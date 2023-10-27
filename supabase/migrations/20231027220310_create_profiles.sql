create table "public"."profiles" (
    "id" uuid not null default auth.uid(),
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "username" text,
    "birthdate" date not null,
    "bio" text,
    "avatar_url" text
);


alter table "public"."profiles" enable row level security;

CREATE UNIQUE INDEX profiles_avatar_url_key ON public.profiles USING btree (avatar_url);

CREATE UNIQUE INDEX profiles_pkey ON public.profiles USING btree (id);

CREATE UNIQUE INDEX profiles_username_key ON public.profiles USING btree (username);

alter table "public"."profiles" add constraint "profiles_pkey" PRIMARY KEY using index "profiles_pkey";

alter table "public"."profiles" add constraint "profiles_avatar_url_key" UNIQUE using index "profiles_avatar_url_key";

alter table "public"."profiles" add constraint "profiles_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."profiles" validate constraint "profiles_id_fkey";

alter table "public"."profiles" add constraint "profiles_username_key" UNIQUE using index "profiles_username_key";


