-- SENPlus+ Academy Ultra P5：學生及家長自助註冊
-- 可重複執行。只接受 student / parent；不能透過註冊資料取得管理員權限。

begin;

do $$
declare
  constraint_name text;
begin
  for constraint_name in
    select c.conname
    from pg_constraint c
    join pg_class t on t.oid = c.conrelid
    join pg_namespace n on n.oid = t.relnamespace
    where n.nspname = 'public'
      and t.relname = 'profiles'
      and c.contype = 'c'
      and pg_get_constraintdef(c.oid) ilike '%role%'
  loop
    execute format('alter table public.profiles drop constraint %I', constraint_name);
  end loop;
end $$;

alter table public.profiles
  add constraint profiles_role_check
  check (role in ('student', 'parent', 'teacher', 'admin')) not valid;

alter table public.profiles validate constraint profiles_role_check;

create or replace function public.handle_self_service_signup()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  requested_role text;
  display_name_value text;
begin
  if coalesce(new.raw_user_meta_data ->> 'signup_source', '') <> 'self_service' then
    return new;
  end if;

  requested_role := case
    when new.raw_user_meta_data ->> 'requested_role' = 'parent' then 'parent'
    else 'student'
  end;
  display_name_value := left(trim(coalesce(new.raw_user_meta_data ->> 'display_name', '')), 60);

  if char_length(display_name_value) < 2 then
    raise exception 'Display name must contain at least 2 characters.';
  end if;

  insert into public.profiles (id, display_name, role, grade, login_allowed)
  values (
    new.id,
    display_name_value,
    requested_role,
    'P5',
    true
  )
  on conflict (id) do update
  set display_name = excluded.display_name,
      role = excluded.role,
      grade = excluded.grade,
      login_allowed = true;

  return new;
end;
$$;

drop trigger if exists on_auth_user_self_service_signup on auth.users;
create trigger on_auth_user_self_service_signup
after insert on auth.users
for each row execute function public.handle_self_service_signup();

revoke all on function public.handle_self_service_signup() from public;

commit;

select 'self_service_signup_ready' as status,
       exists (
         select 1
         from pg_trigger
         where tgname = 'on_auth_user_self_service_signup'
           and not tgisinternal
       ) as trigger_installed;
