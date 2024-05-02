alter table access_levels rename to user_access;

-- Update function to use new table name user_access
CREATE OR REPLACE FUNCTION public.handle_new_profile()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
  insert into public.user_access (id)
  values (new.id);
  return new;
end;
$function$
;