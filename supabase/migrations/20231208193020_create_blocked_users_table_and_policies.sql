create table "public"."blocked_users" (
    "blocker_id" uuid not null,
    "blocked_id" uuid not null,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
);


alter table "public"."blocked_users" enable row level security;

CREATE UNIQUE INDEX blocked_users_pkey ON public.blocked_users USING btree (blocker_id, blocked_id);

alter table "public"."blocked_users" add constraint "blocked_users_pkey" PRIMARY KEY using index "blocked_users_pkey";

alter table "public"."blocked_users" add constraint "blocked_users_blocked_id_fkey" FOREIGN KEY (blocked_id) REFERENCES profiles(id) ON DELETE CASCADE not valid;

alter table "public"."blocked_users" validate constraint "blocked_users_blocked_id_fkey";

alter table "public"."blocked_users" add constraint "blocked_users_blocker_id_fkey" FOREIGN KEY (blocker_id) REFERENCES profiles(id) ON DELETE CASCADE not valid;

alter table "public"."blocked_users" validate constraint "blocked_users_blocker_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_user_id_by_email(email text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE id uuid;
BEGIN
  SELECT au.id INTO id FROM auth.users au WHERE au.email = $1;
  RETURN id;
END;
$function$
;

create policy "auth users can delete their own blocks"
on "public"."blocked_users"
as permissive
for delete
to authenticated
using ((blocker_id = auth.uid()));


create policy "auth users can insert only their own blocks"
on "public"."blocked_users"
as permissive
for insert
to authenticated
with check ((blocker_id = auth.uid()));


create policy "auth users can view their own blocks or people who blocked them"
on "public"."blocked_users"
as permissive
for select
to authenticated
using (((auth.uid() = blocked_id) OR (auth.uid() = blocker_id)));



