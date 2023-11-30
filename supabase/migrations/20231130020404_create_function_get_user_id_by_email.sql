set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_user_id_by_email(email text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE id uuid;
BEGIN
  SELECT au.id INTO id FROM auth.users au WHERE au.email = $1;
  RETURN id;
END;
$function$
;


