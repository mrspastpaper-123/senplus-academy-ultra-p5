-- Secure, admin-only student account deletion.
-- Run once in the shared SENPlus+ Supabase project before using the UI button.

create or replace function public.admin_delete_student(
  p_user_id uuid,
  p_confirmation text
)
returns jsonb
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_requester_role text;
  v_target_role text;
  v_target_email text;
begin
  select role into v_requester_role from public.profiles where id = auth.uid();
  if v_requester_role is distinct from 'admin' then return jsonb_build_object('success', false, 'reason', 'admin_required'); end if;
  if p_user_id = auth.uid() then return jsonb_build_object('success', false, 'reason', 'self_delete_blocked'); end if;
  select p.role, u.email into v_target_role, v_target_email from public.profiles p join auth.users u on u.id = p.id where p.id = p_user_id;
  if not found then return jsonb_build_object('success', false, 'reason', 'student_not_found'); end if;
  if v_target_role is distinct from 'student' then return jsonb_build_object('success', false, 'reason', 'protected_account'); end if;
  if lower(trim(coalesce(p_confirmation, ''))) <> lower(trim(v_target_email)) then return jsonb_build_object('success', false, 'reason', 'invalid_confirmation'); end if;
  delete from auth.users where id = p_user_id;
  if not found then return jsonb_build_object('success', false, 'reason', 'student_not_found'); end if;
  return jsonb_build_object('success', true, 'deleted_user_id', p_user_id);
end;
$$;

revoke all on function public.admin_delete_student(uuid, text) from public;
grant execute on function public.admin_delete_student(uuid, text) to authenticated;
