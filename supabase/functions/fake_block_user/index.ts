import { corsHeaders } from '../_shared/cors.ts'
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.24.0"

console.log("Running Block User Function...");

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
    const { blockerId, blockedId } = await req.json();

    console.log(`${blockerId} blocking user: ${blockedId}`)

    const { error } = await supabaseAdmin.from('blocked_users')
    .insert({
      'blocker_id': blockerId,
      'blocked_id': blockedId,
    })
    if (error) throw error;

    console.log(`Blocked user, returning....`);

    return new Response(
      JSON.stringify("ok"),
      { headers: { "Content-Type": "application/json" } },
    )
  } catch (err) {
    return new Response(String(err?.message ?? err), { status: 500 })
  }
})