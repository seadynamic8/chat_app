create policy "auth users can insert themselves into new rooms"
on "public"."chat_users"
as permissive
for insert
to authenticated
with check (true);


create policy "auth users can remove themselves from a room"
on "public"."chat_users"
as permissive
for delete
to authenticated
using ((auth.uid() = profile_id));


create policy "auth users can view any rooms"
on "public"."chat_users"
as permissive
for select
to authenticated
using (true);


create policy "authenticated users can create rooms"
on "public"."rooms"
as permissive
for insert
to authenticated
with check (true);


create policy "authenticated users can update rooms they belong to"
on "public"."rooms"
as permissive
for update
to authenticated
using (true)
with check ((auth.uid() IN ( SELECT chat_users.profile_id
   FROM chat_users
  WHERE (rooms.id = chat_users.room_id))));


create policy "authenticated users view rooms they belong to"
on "public"."rooms"
as permissive
for select
to authenticated
using (true);



