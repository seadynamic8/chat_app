-- Remove old online_at and offline_at columns from profiles

alter table "public"."profiles" drop constraint "profiles_offline_at_key";

alter table "public"."profiles" drop constraint "profiles_online_at_key";

drop index if exists "public"."online_at_idx";

drop index if exists "public"."profiles_offline_at_key";

drop index if exists "public"."profiles_online_at_key";

alter table "public"."profiles" drop column "offline_at";

alter table "public"."profiles" drop column "online_at";

-- Create new online_status table with same online/offline timestamps

create table "public"."online_status" (
    "id" uuid not null,
    "online_at" timestamp with time zone,
    "offline_at" timestamp with time zone,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
);

alter table "public"."online_status" enable row level security;

CREATE UNIQUE INDEX online_status_offline_at_key ON public.online_status USING btree (offline_at);

CREATE UNIQUE INDEX online_status_online_at_key ON public.online_status USING btree (online_at);

CREATE UNIQUE INDEX online_status_pkey ON public.online_status USING btree (id);

alter table "public"."online_status" add constraint "online_status_pkey" PRIMARY KEY using index "online_status_pkey";

alter table "public"."online_status" add constraint "online_status_id_fkey" FOREIGN KEY (id) REFERENCES profiles(id) ON DELETE CASCADE not valid;

alter table "public"."online_status" validate constraint "online_status_id_fkey";

alter table "public"."online_status" add constraint "online_status_offline_at_key" UNIQUE using index "online_status_offline_at_key";

alter table "public"."online_status" add constraint "online_status_online_at_key" UNIQUE using index "online_status_online_at_key";

grant delete on table "public"."online_status" to "anon";

grant insert on table "public"."online_status" to "anon";

grant references on table "public"."online_status" to "anon";

grant select on table "public"."online_status" to "anon";

grant trigger on table "public"."online_status" to "anon";

grant truncate on table "public"."online_status" to "anon";

grant update on table "public"."online_status" to "anon";

grant delete on table "public"."online_status" to "authenticated";

grant insert on table "public"."online_status" to "authenticated";

grant references on table "public"."online_status" to "authenticated";

grant select on table "public"."online_status" to "authenticated";

grant trigger on table "public"."online_status" to "authenticated";

grant truncate on table "public"."online_status" to "authenticated";

grant update on table "public"."online_status" to "authenticated";

grant delete on table "public"."online_status" to "service_role";

grant insert on table "public"."online_status" to "service_role";

grant references on table "public"."online_status" to "service_role";

grant select on table "public"."online_status" to "service_role";

grant trigger on table "public"."online_status" to "service_role";

grant truncate on table "public"."online_status" to "service_role";

grant update on table "public"."online_status" to "service_role";

create policy "auth users can view all"
on "public"."online_status"
as permissive
for select
to authenticated
using (true);


create policy "only user who it belongs to can insert"
on "public"."online_status"
as permissive
for insert
to authenticated
with check ((id = auth.uid()));


create policy "only user who it belongs to can update"
on "public"."online_status"
as permissive
for update
to authenticated
using ((id = auth.uid()));


CREATE TRIGGER handle_update_at BEFORE UPDATE ON public.online_status FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at');


