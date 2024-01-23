drop policy "only auth users who the message is for can view it" on "public"."messages_users";

alter table "public"."messages" add column "parent_message_id" uuid;

alter table "public"."messages" add constraint "messages_parent_message_id_fkey" FOREIGN KEY (parent_message_id) REFERENCES messages(id) ON DELETE CASCADE not valid;

alter table "public"."messages" validate constraint "messages_parent_message_id_fkey";

create policy "auth users  can view it"
on "public"."messages_users"
as permissive
for select
to authenticated
using (true);



