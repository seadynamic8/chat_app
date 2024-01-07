import { corsHeaders } from '../_shared/cors.ts'
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.24.0"
import serviceAccount from '../service-account.json' with { type: 'json' }
// import { JWT } from 'https://esm.sh/google-auth-library@9.4.1'
import { JWT } from 'npm:google-auth-library@9'


console.log("Running create notification function")
    
Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }
  
  // Need this authorization header if calling edge function directly and not from webhook
  const authHeader = req.headers.get('Authorization')!
  
  const supabaseAdmin = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
    { 
      auth: {
        autoRefreshToken: false,
        persistSession: false
      }
    }
  )

  const { otherProfileId, notification, data: params } = await req.json()

  console.log('Getting other profile data...')

  const { data: fcmData, error: fcmError } = await supabaseAdmin
          .from('fcm_tokens')
          .select('fcm')
          .eq('profile_id', otherProfileId)
          .neq('fcm', null)

  if (fcmError != null) {
    console.log('fcmError');
    throw fcmError
  }
  
  const fcmTokens = fcmData.map((token) => token.fcm)
  console.log(fcmTokens)
          
  const { data: apnsData, error: apnsError } = await supabaseAdmin
          .from('fcm_tokens')
          .select('apns')
          .eq('profile_id', otherProfileId)
          .neq('apns', null)

  if (apnsError != null) {
    console.log('apnsError');
    throw apnsError
  }

  const apnsTokens = apnsData.map((token) => token.apns)
  console.log(apnsTokens)

  console.log('Able to retrieve other profile fcmTokens')

  const accessToken = await getAccessToken({
    clientEmail: serviceAccount.client_email,
    privateKey: serviceAccount.private_key
  })

  console.log('Got google access token')

  // * FCM MESSAGE SEND
  
  const data = {
    'otherProfileId': otherProfileId,
    ...params
  };
  
  fcmTokens.forEach(async (fcmToken, _idx, _tokens) => {
    
    console.log('Sending fcm message to other user....')
    
    const res = await fetch(
      `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          message: {
            token: fcmToken,
            notification: notification,
            data: data
          }
        })
      }
      )
      
      const resData = await res.json()
    if (res.status < 200 || 299 < res.status ) {
      throw resData
    }
  })

  // * APNS MESSAGE SEND
  
  apnsTokens.forEach(async (apnsToken, _idx, _tokens) => {

    console.log('Sending apns message to other user....')

    const res = await fetch(
      `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          message: {
            token: apnsToken,
            apns: {
              'payload': {
                'alert': notification, // can also add a subtitle later
                'sound': 'default'
              },
              
            },
            data: data
          }
        })
      }
    )

    const resData = await res.json()
    if (res.status < 200 || 299 < res.status ) {
      throw resData
    }
  })

  console.log('Finished sending message, returning....')

  return new Response(
    JSON.stringify("ok"),
    { headers: { "Content-Type": "application/json" } },
  )
})

const getAccessToken = ({
  clientEmail,
  privateKey,
}: {
  clientEmail: string
  privateKey: string
}): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
    })

    jwtClient.authorize((err, tokens) => {
      if (err) {
        reject(err)
        return
      }
      resolve(tokens!.access_token!)
    })
  })
}