import { corsHeaders } from '../_shared/cors.ts'
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.24.0";

console.log("Running get_user_id_by_email funciton...")

Deno.serve(async (req) => {
  try {
    if (req.method === 'OPTIONS') {
      return new Response('ok', { headers: corsHeaders })
    }

    const authHeader = req.headers.get('Authorization')!
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { 
        global: { 
          headers: { Authorization: authHeader } 
        },
      },
    );

    const { email } = await req.json();

    console.log(`Looking for user email: ${email}`)

    const { data: userId, error } = await supabase.rpc(
      "get_user_id_by_email", { email: email }
    )
    if (error) {
      throw error
    }

    if (userId != null || userId != '') {
      console.log(`Found user id: ${userId}, returning.`)
    } else {
      console.log('Did not find user id, returning.');
    }

    return new Response(
      JSON.stringify({ 'id': userId }),
      { headers: { "Content-Type": "application/json" } },
    )
  } catch (err) {
    return new Response(String(err?.message ?? err), { status: 500 })
  }
})
