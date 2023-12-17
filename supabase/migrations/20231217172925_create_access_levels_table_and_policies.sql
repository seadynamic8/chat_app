create table "public"."access_levels" (
    "id" uuid not null,
    "level" text not null default 'trial'::text,
    "trial_duration" bigint,
    "credits" bigint not null default '0'::bigint
);


alter table "public"."access_levels" enable row level security;

CREATE UNIQUE INDEX access_levels_pkey ON public.access_levels USING btree (id);

alter table "public"."access_levels" add constraint "access_levels_pkey" PRIMARY KEY using index "access_levels_pkey";

alter table "public"."access_levels" add constraint "access_levels_id_fkey" FOREIGN KEY (id) REFERENCES profiles(id) ON DELETE CASCADE not valid;

alter table "public"."access_levels" validate constraint "access_levels_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_new_profile()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
  insert into public.access_levels (id)
  values (new.id);
  return new;
end;
$function$
;

grant delete on table "public"."access_levels" to "anon";

grant insert on table "public"."access_levels" to "anon";

grant references on table "public"."access_levels" to "anon";

grant select on table "public"."access_levels" to "anon";

grant trigger on table "public"."access_levels" to "anon";

grant truncate on table "public"."access_levels" to "anon";

grant update on table "public"."access_levels" to "anon";

grant delete on table "public"."access_levels" to "authenticated";

grant insert on table "public"."access_levels" to "authenticated";

grant references on table "public"."access_levels" to "authenticated";

grant select on table "public"."access_levels" to "authenticated";

grant trigger on table "public"."access_levels" to "authenticated";

grant truncate on table "public"."access_levels" to "authenticated";

grant update on table "public"."access_levels" to "authenticated";

grant delete on table "public"."access_levels" to "service_role";

grant insert on table "public"."access_levels" to "service_role";

grant references on table "public"."access_levels" to "service_role";

grant select on table "public"."access_levels" to "service_role";

grant trigger on table "public"."access_levels" to "service_role";

grant truncate on table "public"."access_levels" to "service_role";

grant update on table "public"."access_levels" to "service_role";

create policy "auth users can view all"
on "public"."access_levels"
as permissive
for select
to authenticated
using (true);


create policy "only auth users who it belongs to can update"
on "public"."access_levels"
as permissive
for update
to authenticated
using ((id = auth.uid()))
with check ((id = auth.uid()));


CREATE TRIGGER on_profile_user_created AFTER INSERT ON public.profiles FOR EACH ROW EXECUTE FUNCTION handle_new_profile();


