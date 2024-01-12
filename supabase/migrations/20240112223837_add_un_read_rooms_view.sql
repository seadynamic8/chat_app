create or replace view "public"."un_read_rooms" as  SELECT messages_users.room_id,
    max(messages_users.created_at) AS last_unread_at
   FROM messages_users
  WHERE ((messages_users.read = false) AND (messages_users.profile_id = auth.uid()))
  GROUP BY messages_users.room_id;



