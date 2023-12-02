import { corsHeaders } from '../_shared/cors.ts'
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.24.0"

console.log("Running Create User Function...");

Deno.serve(async (req) => {
  try {
    if (req.method === 'OPTIONS') {
      return new Response('ok', { headers: corsHeaders })
    }

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
    const { email, password, autoConfirmEmail, username } = await req.json();

    console.log(`Creating user: ${email.toLowerCase()}, auto confirm email: ${autoConfirmEmail}`)

    const { data, error } = await supabaseAdmin.auth.admin.createUser({
      email: email.toLowerCase(), 
      password: password, 
      email_confirm: autoConfirmEmail,
    })
    if (error) throw error;

    if (data != null) {
      console.log(`Create profile for user, with username: ${username}`);

      await supabaseAdmin.from('profiles').insert({
        'id': data.user.id,
        'username': username,
      });
    }

    console.log('Created user.')

    return new Response(
      JSON.stringify(data),
      { headers: { "Content-Type": "application/json" } },
    )
  } catch (err) {
    return new Response(String(err?.message ?? err), { status: 500 })
  }
})