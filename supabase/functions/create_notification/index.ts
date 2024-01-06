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
  
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_ANON_KEY') ?? '',
    { 
      global: { 
        headers: { Authorization: authHeader } 
      },
    },
  )

  const { otherProfileId, notification, data: params } = await req.json()

  console.log('Getting other profile data...')
  
  const { data: profileData, error } = await supabase
          .from('profiles')
          .select('fcm_tokens')
          .eq('id', otherProfileId)
          .single()
  if (error != null) {
    throw error
  }

  console.log('Able to retrieve other profile fcmTokens')

  const fcmTokens = profileData!.fcm_tokens as Array<string>

  const accessToken = await getAccessToken({
    clientEmail: serviceAccount.client_email,
    privateKey: serviceAccount.private_key
  })

  console.log('Got google access token')

  console.log('Sending message to other user....')

  const data = {
    'otherProfileId': otherProfileId,
    ...params
  };

  fcmTokens.forEach(async (fcmToken, _idx, _tokens) => {

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