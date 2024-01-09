set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.delete_read_messages_except_last(profile_id uuid, room_id uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$BEGIN
  delete from messages_users m1
  where read = true
  and m1.profile_id = $1
  and m1.room_id = $2
  and 
    created_at < 
      (select max(created_at) 
       from messages_users m2
       group by m2.profile_id, m2.room_id);
END;$function$
;
