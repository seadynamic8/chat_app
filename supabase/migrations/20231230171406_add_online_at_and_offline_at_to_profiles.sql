alter table "public"."blocked_users" alter column "created_at" set not null;

alter table "public"."profiles" add column "offline_at" timestamp with time zone;

alter table "public"."profiles" add column "online_at" timestamp with time zone;

