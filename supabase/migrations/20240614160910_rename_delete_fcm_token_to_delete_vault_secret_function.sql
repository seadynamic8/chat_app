drop function if exists "public"."delete_fcm_token"(token text);

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.delete_vault_secret(secret text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  delete from vault.decrypted_secrets
  where decrypted_secret = $1;
END;$function$
;
