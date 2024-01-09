set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.delete_fcm_token(token text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$BEGIN
  delete from vault.decrypted_secrets
  where decrypted_secret = $1;
END;$function$
;


