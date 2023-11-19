create policy "Only authenticated users can upload images"
on "storage"."objects"
as permissive
for insert
to authenticated
with check (true);



