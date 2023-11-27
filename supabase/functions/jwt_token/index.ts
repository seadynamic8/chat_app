import { corsHeaders } from '../_shared/cors.ts'
import { create, getNumericDate } from 'https://deno.land/x/djwt@v3.0.1/mod.ts'

console.log("Running JWT Token Function...");

Deno.serve(async (req) => {
  try {
    if (req.method === 'OPTIONS') {
      return new Response('ok', { headers: corsHeaders })
    }

    const API_KEY = Deno.env.get('VIDEOSDK_API_KEY')
    const SECRET_KEY = Deno.env.get('VIDEOSDK_SECRET_KEY')

    const payload = {
      apikey: API_KEY,
      permissions: ["allow_join"], // also accepts "ask_join" || "allow_mod"
      version: 2,
      roles: ['CRAWLER'],
      exp: getNumericDate(10 * 60) // 10 * (60 seconds) = 10 minutes
    }

    const enc = new TextEncoder()

    const key = await crypto.subtle.importKey(
      "raw",
      enc.encode(SECRET_KEY),
      {
        name: "HMAC",
        hash: {name: "SHA-256"},
      },
      false,
      ["sign", "verify"],
    )

    const token = await create({ alg: "HS256", typ: "JWT" }, payload, key)

    return new Response(
      JSON.stringify(token),
      { headers: { "Content-Type": "application/json" } },
    )
  } catch (err) {
    return new Response(String(err?.message ?? err), { status: 500 })
  }
})

