create table "public"."fcm_tokens" (
    "id" uuid not null default gen_random_uuid(),
    "profile_id" uuid not null,
    "fcm_id" uuid,
    "apns_id" uuid
);


alter table "public"."fcm_tokens" enable row level security;

alter table "public"."profiles" add column "fcm_tokens" jsonb;

CREATE UNIQUE INDEX fcm_tokens_apns_id_key ON public.fcm_tokens USING btree (apns_id);

CREATE UNIQUE INDEX fcm_tokens_fcm_id_key ON public.fcm_tokens USING btree (fcm_id);

CREATE UNIQUE INDEX fcm_tokens_pkey ON public.fcm_tokens USING btree (id);

alter table "public"."fcm_tokens" add constraint "fcm_tokens_pkey" PRIMARY KEY using index "fcm_tokens_pkey";

alter table "public"."fcm_tokens" add constraint "fcm_tokens_apns_id_key" UNIQUE using index "fcm_tokens_apns_id_key";

alter table "public"."fcm_tokens" add constraint "fcm_tokens_fcm_id_key" UNIQUE using index "fcm_tokens_fcm_id_key";

alter table "public"."fcm_tokens" add constraint "fcm_tokens_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE not valid;

alter table "public"."fcm_tokens" validate constraint "fcm_tokens_profile_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_vault_secret(secret text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE 
  secret_id uuid;
BEGIN
  INSERT INTO vault.secrets (secret)
  VALUES ($1)
  RETURNING id into secret_id;

  RETURN secret_id;
END;$function$
;

CREATE OR REPLACE FUNCTION public.fcm_token_count(profile_id uuid, fcm text, apns text)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
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
AS $function$
BEGIN
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
END
$function$
;

grant delete on table "public"."fcm_tokens" to "anon";

grant insert on table "public"."fcm_tokens" to "anon";

grant references on table "public"."fcm_tokens" to "anon";

grant select on table "public"."fcm_tokens" to "anon";

grant trigger on table "public"."fcm_tokens" to "anon";

grant truncate on table "public"."fcm_tokens" to "anon";

grant update on table "public"."fcm_tokens" to "anon";

grant delete on table "public"."fcm_tokens" to "authenticated";

grant insert on table "public"."fcm_tokens" to "authenticated";

grant references on table "public"."fcm_tokens" to "authenticated";

grant select on table "public"."fcm_tokens" to "authenticated";

grant trigger on table "public"."fcm_tokens" to "authenticated";

grant truncate on table "public"."fcm_tokens" to "authenticated";

grant update on table "public"."fcm_tokens" to "authenticated";

grant delete on table "public"."fcm_tokens" to "service_role";

grant insert on table "public"."fcm_tokens" to "service_role";

grant references on table "public"."fcm_tokens" to "service_role";

grant select on table "public"."fcm_tokens" to "service_role";

grant trigger on table "public"."fcm_tokens" to "service_role";

grant truncate on table "public"."fcm_tokens" to "service_role";

grant update on table "public"."fcm_tokens" to "service_role";

create policy "Only users who the token belongs to can delete"
on "public"."fcm_tokens"
as permissive
for delete
to authenticated
using ((profile_id = auth.uid()));


create policy "Only users who the token belongs to can select"
on "public"."fcm_tokens"
as permissive
for select
to authenticated
using ((profile_id = auth.uid()));


create policy "Only users who the token belongs to can update"
on "public"."fcm_tokens"
as permissive
for update
to authenticated
using ((profile_id = auth.uid()))
with check ((profile_id = auth.uid()));


create policy "Only users who the tokens belong to can insert"
on "public"."fcm_tokens"
as permissive
for insert
to authenticated
with check ((profile_id = auth.uid()));



