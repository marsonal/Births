-- بدّل YOUR_ADMIN_EMAIL بالبريد الموجود في supabase-config.js
-- شغّل هذا الملف داخل Supabase SQL Editor
-- هذا المسار يسمح للواجهة العامة برفع الملفات إلى records بدون الحاجة إلى Anonymous Sign-ins

drop policy if exists "birth_records_upload_from_anon" on storage.objects;
drop policy if exists "birth_records_admin_select" on storage.objects;
drop policy if exists "birth_records_admin_delete" on storage.objects;

create policy "birth_records_upload_from_anon"
on storage.objects
for insert
to anon
with check (
  bucket_id = 'birth-records'
  and (storage.foldername(name))[1] = 'records'
);

create policy "birth_records_admin_select"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'birth-records'
  and lower(coalesce(auth.jwt()->>'email', '')) = lower('YOUR_ADMIN_EMAIL')
);

create policy "birth_records_admin_delete"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'birth-records'
  and lower(coalesce(auth.jwt()->>'email', '')) = lower('YOUR_ADMIN_EMAIL')
);
