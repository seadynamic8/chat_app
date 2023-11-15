alter table "public"."profiles" add column "country" text not null default 'US'::text;

alter table "public"."profiles" add column "language" text not null default 'en'::text;


