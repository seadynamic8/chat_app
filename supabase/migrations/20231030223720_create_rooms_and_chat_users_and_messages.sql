create table if not exists "public"."chat_users" (
    "profile_id" uuid not null,
    "room_id" uuid not null,
    "created_at" timestamp with time zone not null default now()
);


alter table "public"."chat_users" enable row level security;

create table if not exists "public"."messages" (
    "id" uuid not null default gen_random_uuid(),
    "profile_id" uuid not null,
    "room_id" uuid not null,
    "content" text not null,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
);


alter table "public"."messages" enable row level security;

create table if not exists "public"."rooms" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now()
);


alter table "public"."rooms" enable row level security;

alter table "public"."profiles" alter column "birthdate" drop not null;

CREATE UNIQUE INDEX chat_users_pkey ON public.chat_users USING btree (profile_id, room_id);

CREATE UNIQUE INDEX chat_users_profile_id_room_id_idx ON public.chat_users USING btree (profile_id, room_id);

CREATE UNIQUE INDEX messages_pkey ON public.messages USING btree (id);

CREATE UNIQUE INDEX messages_profile_id_idx ON public.messages USING btree (profile_id);

CREATE UNIQUE INDEX messages_profile_id_room_id_idx ON public.messages USING btree (profile_id, room_id);

CREATE UNIQUE INDEX messages_room_id_idx ON public.messages USING btree (room_id);

CREATE UNIQUE INDEX rooms_id_key ON public.rooms USING btree (id);

CREATE UNIQUE INDEX rooms_pkey ON public.rooms USING btree (id);

alter table "public"."chat_users" add constraint "chat_users_pkey" PRIMARY KEY using index "chat_users_pkey";

alter table "public"."messages" add constraint "messages_pkey" PRIMARY KEY using index "messages_pkey";

alter table "public"."rooms" add constraint "rooms_pkey" PRIMARY KEY using index "rooms_pkey";

alter table "public"."chat_users" add constraint "chat_users_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE not valid;

alter table "public"."chat_users" validate constraint "chat_users_profile_id_fkey";

alter table "public"."chat_users" add constraint "chat_users_room_id_fkey" FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE not valid;

alter table "public"."chat_users" validate constraint "chat_users_room_id_fkey";

alter table "public"."messages" add constraint "messages_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE not valid;

alter table "public"."messages" validate constraint "messages_profile_id_fkey";

alter table "public"."messages" add constraint "messages_room_id_fkey" FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE not valid;

alter table "public"."messages" validate constraint "messages_room_id_fkey";

alter table "public"."rooms" add constraint "rooms_id_key" UNIQUE using index "rooms_id_key";

create policy "Authenticated users can insert their own profile"
on "public"."profiles"
as permissive
for insert
to authenticated
with check ((auth.uid() = id));


create policy "Authenticated users can update their own profiles"
on "public"."profiles"
as permissive
for update
to authenticated
using ((auth.uid() = id));


create policy "Authenticated users can view anyone's profile"
on "public"."profiles"
as permissive
for select
to authenticated
using (true);



