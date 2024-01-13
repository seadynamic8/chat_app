drop view if exists "public"."un_read_rooms";

alter table "public"."chat_users" add column "joined" boolean not null default false;

create or replace view "public"."un_read_joined_rooms" as  SELECT mu.room_id,
    max(mu.created_at) AS last_unread_at
   FROM (messages_users mu
     JOIN chat_users cu ON (((mu.room_id = cu.room_id) AND (mu.profile_id = cu.profile_id))))
  WHERE ((mu.read = false) AND (cu.joined = true) AND (mu.profile_id = auth.uid()))
  GROUP BY mu.room_id, cu.joined;


create policy "only auth users who it belongs to can update"
on "public"."chat_users"
as permissive
for update
to authenticated
using ((profile_id = auth.uid()))
with check ((profile_id = auth.uid()));



