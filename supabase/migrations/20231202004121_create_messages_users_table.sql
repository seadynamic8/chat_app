create table "public"."messages_users" (
    "message_id" uuid not null,
    "profile_id" uuid not null,
    "room_id" uuid not null,
    "read" boolean not null default false,
    "read_at" timestamp with time zone,
    "created_at" timestamp with time zone not null default now()
);


alter table "public"."messages_users" enable row level security;

CREATE UNIQUE INDEX messages_users_pkey ON public.messages_users USING btree (message_id, profile_id);

alter table "public"."messages_users" add constraint "messages_users_pkey" PRIMARY KEY using index "messages_users_pkey";

alter table "public"."messages_users" add constraint "messages_users_message_id_fkey" FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE not valid;

alter table "public"."messages_users" validate constraint "messages_users_message_id_fkey";

alter table "public"."messages_users" add constraint "messages_users_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE not valid;

alter table "public"."messages_users" validate constraint "messages_users_profile_id_fkey";

alter table "public"."messages_users" add constraint "messages_users_room_id_fkey" FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE not valid;

alter table "public"."messages_users" validate constraint "messages_users_room_id_fkey";

create policy "Enable insert for authenticated users only"
on "public"."messages_users"
as permissive
for insert
to authenticated
with check (true);


create policy "only auth users who the message is for can update it"
on "public"."messages_users"
as permissive
for update
to authenticated
using ((profile_id = auth.uid()))
with check ((profile_id = auth.uid()));


create policy "only auth users who the message is for can view it"
on "public"."messages_users"
as permissive
for select
to authenticated
using ((profile_id = auth.uid()));



