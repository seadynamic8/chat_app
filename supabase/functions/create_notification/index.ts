import { corsHeaders } from "../_shared/cors.ts";
import { supabaseAdmin } from "../_shared/supabaseAdmin.ts";
import serviceAccount from "../service-account.json" with { type: "json" };
import { JWT } from "npm:google-auth-library@9";
// import { apnsPrivateKey } from '../AuthKey.ts'
// import { create, getNumericDate } from 'https://deno.land/x/djwt@v3.0.1/mod.ts'

console.log("Running create notification function");

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  const { otherProfileId, notification, data: params } = await req.json();

  const fcmTokens = await getFCMTokens(otherProfileId);

  const googleAccessToken = await getAccessToken({
    clientEmail: serviceAccount.client_email,
    privateKey: serviceAccount.private_key,
  });
  // const apnsJWT = await getAPNSJWT();

  console.log("Sending fcm message to other user....");

  const msgSendPromises = fcmTokens.map(async (token) => {
    let apnsSettings;
    if (token.apns != null) {
      apnsSettings = {
        // Seems like the apns auth is not needed now, (the certificate uploaded to FCM will work)
        // 'headers': {
        //   ':method': 'GET',
        //   ':path': `/3/device/${token.apns}`,
        //   'authorization': `bearer ${apnsJWT}`,
        //   'apns-push-type': 'alert',
        //   'apns-id': token.apns, // a unique id to reference notification for errors
        // },
        "payload": {
          "aps": {
            "sound": "default",
          },
        },
      };
    }

    try {
      const url =
        `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`;

      const options = {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${googleAccessToken}`,
        },
        body: JSON.stringify({
          message: {
            token: token.fcm,
            android: {
              priority: "high",
            },
            apns: apnsSettings,
            notification: notification,
            data: {
              "otherProfileId": otherProfileId,
              ...params,
            },
          },
        }),
      };
      const response = await fetch(url, options);

      return { token: token.fcm, response: response };
    } catch (error) {
      // Token either was refreshed or uninstalled or etc, anyways invalid now
      if (
        error.error.status == "UNREGISTERED" ||
        (error.error.details instanceof Array &&
          error.error.details.length > 0 &&
          error.error.details[0].errorCode == "UNREGISTERED")
      ) {
        console.log("[NOTICE] Found token unregistered, deleting token");
        // Delete token
        await deleteFCMToken(token.fcm);
        return;
      }
      throw error;
    }
  });

  const responses = await Promise.all(msgSendPromises);

  for (const res of responses) {
    const resData = await res?.response.json();

    console.log(
      `Successfully sent message to token: ${res?.token}, data:`,
      resData,
    );
  }

  console.log("Finished sending message, returning....");

  return new Response(
    JSON.stringify("ok"),
    { headers: { "Content-Type": "application/json" } },
  );
});

interface Token {
  fcm: string;
  apns: null | string;
}

const getFCMTokens = async (otherProfileId: string): Promise<Token[]> => {
  const { data: fcmTokens, error: fcmError } = await supabaseAdmin
    .rpc("fcm_tokens_for_user", { "profile_id": otherProfileId });

  if (fcmError != null) {
    console.log("fcmError");
    throw fcmError;
  }
  return fcmTokens;
};

// Don't need to delete from FCM as it's already unregistered
const deleteFCMToken = async (token: string) => {
  console.log("Deleting token: ", token);

  const { error } = await supabaseAdmin
    .rpc("delete_vault_secret", { "secret": token });

  if (error != null) {
    console.log("deleteFCMToken error: ${error}");
    throw error;
  }
};

const getAccessToken = ({
  clientEmail,
  privateKey,
}: {
  clientEmail: string;
  privateKey: string;
}): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
    });

    jwtClient.authorize((err, tokens) => {
      if (err) {
        reject(err);
        return;
      }
      resolve(tokens!.access_token!);
    });
  });
};

// function parsePem(pem: string) {
//   const pemHeader = "-----BEGIN PRIVATE KEY-----";
//   const pemFooter = "-----END PRIVATE KEY-----";
//   const pemContents = pem.substring(
//     pemHeader.length,
//     pem.length - pemFooter.length,
//   );
//   return pemContents;
// }

// function str2ab(str: string) {
//   const buf = new ArrayBuffer(str.length);
//   const bufView = new Uint8Array(buf);
//   for (let i = 0, strLen = str.length; i < strLen; i++) {
//     bufView[i] = str.charCodeAt(i);
//   }
//   return buf;
// }

// async function getAPNSJWT() {
//   const apnsJWTPayload = {
//     iss: "Y9BPBCB945", // Team ID
//     iat: getNumericDate(0)
//   }
//   const privateKeyString = parsePem(apnsPrivateKey)
//   const binaryKey = atob(privateKeyString)
//   const key = await crypto.subtle.importKey(
//     "pkcs8",
//     str2ab(binaryKey),
//     {
//       name: "ECDSA",
//       namedCurve: "P-256"
//     },
//     true,
//     ["sign"],
//   )

//   const apnsJWT = await create({
//     alg: "ES256",
//     kid: "8YHDZRGWN5" // Key ID
//   }, apnsJWTPayload, key)

//   return apnsJWT;
// }
