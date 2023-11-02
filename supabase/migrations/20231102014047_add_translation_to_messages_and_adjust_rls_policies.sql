drop policy "auth users able to create new messages for room they are in" on "public"."messages";

drop policy "auth users able to update the messages in the room they are in" on "public"."messages";

drop policy "auth users should be able to view messages in the same room" on "public"."messages";

alter table "public"."messages" add column "translation" text;

create policy "auth users able to create new messages for room they are in"
on "public"."messages"
as permissive
for insert
to authenticated
with check ((auth.uid() IN ( SELECT chat_users.profile_id
   FROM chat_users
  WHERE (chat_users.room_id = messages.room_id))));


create policy "auth users able to update the messages in the room they are in"
on "public"."messages"
as permissive
for update
to public
using ((auth.uid() IN ( SELECT chat_users.profile_id
   FROM chat_users
  WHERE (chat_users.room_id = messages.room_id))))
with check ((auth.uid() IN ( SELECT chat_users.profile_id
   FROM chat_users
  WHERE (chat_users.room_id = messages.room_id))));


create policy "auth users should be able to view messages in the same room"
on "public"."messages"
as permissive
for select
to authenticated
using ((auth.uid() IN ( SELECT chat_users.profile_id
   FROM chat_users
  WHERE (chat_users.room_id = messages.room_id))));



