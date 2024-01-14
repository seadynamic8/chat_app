alter table "public"."access_levels" add column "created_at" timestamp with time zone not null default now();

alter table "public"."access_levels" add column "updated_at" timestamp with time zone not null default now();

alter table "public"."blocked_users" alter column "updated_at" set not null;

alter table "public"."chat_users" add column "updated_at" timestamp with time zone not null default now();

alter table "public"."fcm_tokens" add column "created_at" timestamp with time zone not null default now();

alter table "public"."fcm_tokens" add column "updated_at" timestamp with time zone not null default now();

alter table "public"."messages_users" add column "updated_at" timestamp with time zone not null default now();

CREATE TRIGGER handle_update_at BEFORE UPDATE ON public.access_levels FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at');

CREATE TRIGGER handle_update_at BEFORE UPDATE ON public.blocked_users FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at');

CREATE TRIGGER handle_update_at BEFORE UPDATE ON public.chat_users FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at');

CREATE TRIGGER handle_update_at BEFORE UPDATE ON public.fcm_tokens FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at');

CREATE TRIGGER handle_update_at BEFORE UPDATE ON public.messages FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at');

CREATE TRIGGER handle_update_at BEFORE UPDATE ON public.messages_users FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at');

CREATE TRIGGER handle_update_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION moddatetime('updated_at');


