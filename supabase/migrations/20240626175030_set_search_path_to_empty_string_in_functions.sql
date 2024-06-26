set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_vault_secret(secret text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$DECLARE 
  secret_id uuid;
BEGIN
  INSERT INTO vault.secrets (secret)
  VALUES ($1)
  RETURNING id into secret_id;

  RETURN secret_id;
END;$function$
;

CREATE OR REPLACE FUNCTION public.delete_read_messages_except_last(profile_id uuid, room_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$BEGIN
  delete from messages_users m1
  where read = true
  and m1.profile_id = $1
  and m1.room_id = $2
  and 
    created_at < (
      select max(created_at) 
      from messages_users m2
      where read = true
      and m2.profile_id = $1
      and m2.room_id = $2
      group by m2.profile_id, m2.room_id);
END;$function$
;

CREATE OR REPLACE FUNCTION public.delete_vault_secret(secret text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$BEGIN
  delete from vault.decrypted_secrets
  where decrypted_secret = $1;
END;$function$
;

CREATE OR REPLACE FUNCTION public.fcm_token_count(profile_id uuid, fcm text, apns text)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$DECLARE 
  token_count integer;
BEGIN
  select 
    count (*)::int
    into token_count
  from fcm_tokens tokens
  join vault.decrypted_secrets v1
  on tokens.fcm_id = v1.id
  left join vault.decrypted_secrets v2
  on tokens.apns_id = v2.id
  WHERE tokens.profile_id = $1
  and ((v1.decrypted_secret = $2 and v2.decrypted_secret is null)
  or (v1.decrypted_secret = $2 and v2.decrypted_secret = $3));

  return token_count;
END;$function$
;

CREATE OR REPLACE FUNCTION public.fcm_tokens_for_user(profile_id uuid)
 RETURNS TABLE(fcm text, apns text)
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$BEGIN
  return query
  select 
    v1.decrypted_secret as fcm, 
    v2.decrypted_secret as apns
  from fcm_tokens t1
  join vault.decrypted_secrets v1
  on fcm_id = v1.id
  left join vault.decrypted_secrets v2
  on apns_id = v2.id
  WHERE t1.profile_id = $1;
END$function$
;

CREATE OR REPLACE FUNCTION public.get_user_id_by_email(email text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$DECLARE id uuid;
BEGIN
  SELECT au.id INTO id FROM auth.users au WHERE au.email = $1;
  RETURN id;
END;$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_profile()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$begin
  insert into public.user_access (id)
  values (new.id);
  return new;
end;$function$
;


