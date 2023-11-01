drop index if exists "public"."messages_profile_id_idx";

drop index if exists "public"."messages_profile_id_room_id_idx";

drop index if exists "public"."messages_room_id_idx";

create policy "auth users able to create new messages for room they are in"
on "public"."messages"
as permissive
for insert
to authenticated
with check ((auth.uid() IN ( SELECT chat_users.profile_id
   FROM chat_users
  WHERE (chat_users.room_id = chat_users.room_id))));


create policy "auth users able to update the messages in the room they are in"
on "public"."messages"
as permissive
for update
to public
with check ((auth.uid() IN ( SELECT chat_users.profile_id
   FROM chat_users
  WHERE (chat_users.room_id = chat_users.room_id))));


create policy "auth users should be able to view messages in the same room"
on "public"."messages"
as permissive
for select
to authenticated
using ((auth.uid() IN ( SELECT chat_users.profile_id
   FROM chat_users
  WHERE (chat_users.room_id = chat_users.room_id))));



