CREATE INDEX online_at_idx ON public.profiles USING btree (online_at);

CREATE UNIQUE INDEX profiles_created_at_key ON public.profiles USING btree (created_at);

CREATE UNIQUE INDEX profiles_offline_at_key ON public.profiles USING btree (offline_at);

CREATE UNIQUE INDEX profiles_online_at_key ON public.profiles USING btree (online_at);

alter table "public"."profiles" add constraint "profiles_created_at_key" UNIQUE using index "profiles_created_at_key";

alter table "public"."profiles" add constraint "profiles_offline_at_key" UNIQUE using index "profiles_offline_at_key";

alter table "public"."profiles" add constraint "profiles_online_at_key" UNIQUE using index "profiles_online_at_key";

