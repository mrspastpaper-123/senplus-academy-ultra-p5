-- SENPlus+ Academy Ultra P5：家長專用儀表板及安全子女連結
-- 可重複執行。家長必須使用學生本人產生的一次性連結碼。

begin;

create table if not exists public.parent_student_links (
  parent_id uuid not null references auth.users(id) on delete cascade,
  student_id uuid not null references auth.users(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending', 'approved')),
  requested_at timestamptz not null default now(),
  approved_at timestamptz,
  created_at timestamptz not null default now(),
  primary key (parent_id, student_id),
  check (parent_id <> student_id)
);

alter table public.parent_student_links add column if not exists status text not null default 'pending';
alter table public.parent_student_links add column if not exists requested_at timestamptz not null default now();
alter table public.parent_student_links add column if not exists approved_at timestamptz;

create table if not exists public.parent_link_codes (
  student_id uuid primary key references auth.users(id) on delete cascade,
  code text not null unique,
  expires_at timestamptz not null,
  created_at timestamptz not null default now(),
  check (code ~ '^[A-Z0-9]{6}$')
);

create index if not exists parent_student_links_student_idx
  on public.parent_student_links (student_id, status);

alter table public.parent_student_links enable row level security;
alter table public.parent_link_codes enable row level security;

revoke all on public.parent_student_links from anon, authenticated;
revoke all on public.parent_link_codes from anon, authenticated;

create or replace function public.create_parent_link_code()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_role text;
  v_code text;
  v_chars constant text := '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
  v_attempt integer := 0;
begin
  select role into v_role from public.profiles where id = auth.uid();
  if v_role <> 'student' then
    raise exception 'Only student accounts can create a parent link code.';
  end if;

  loop
    v_attempt := v_attempt + 1;
    v_code := '';
    for i in 1..6 loop
      v_code := v_code || substr(v_chars, 1 + floor(random() * length(v_chars))::integer, 1);
    end loop;
    exit when not exists (select 1 from public.parent_link_codes where code = v_code);
    if v_attempt >= 20 then raise exception 'Unable to create a unique code.'; end if;
  end loop;

  insert into public.parent_link_codes (student_id, code, expires_at, created_at)
  values (auth.uid(), v_code, now() + interval '30 minutes', now())
  on conflict (student_id) do update
  set code = excluded.code, expires_at = excluded.expires_at, created_at = excluded.created_at;

  return jsonb_build_object('success', true, 'code', v_code, 'expires_at', now() + interval '30 minutes');
end;
$$;

create or replace function public.parent_link_student(p_code text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_role text;
  v_student_id uuid;
  v_student_name text;
begin
  select role into v_role from public.profiles where id = auth.uid();
  if v_role <> 'parent' then raise exception 'Only parent accounts can link students.'; end if;

  select c.student_id, p.display_name
  into v_student_id, v_student_name
  from public.parent_link_codes c
  join public.profiles p on p.id = c.student_id and p.role = 'student'
  where c.code = upper(trim(p_code)) and c.expires_at > now();

  if v_student_id is null then
    return jsonb_build_object('success', false, 'message', '連結碼無效或已過期，請學生重新產生。');
  end if;

  insert into public.parent_student_links (parent_id, student_id, status, requested_at, approved_at)
  values (auth.uid(), v_student_id, 'pending', now(), null)
  on conflict (parent_id, student_id) do update
  set status = 'pending', requested_at = now(), approved_at = null;
  delete from public.parent_link_codes where student_id = v_student_id;

  return jsonb_build_object('success', true, 'pending', true, 'student_id', v_student_id, 'display_name', v_student_name);
end;
$$;

create or replace function public.student_get_parent_requests()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare v_result jsonb;
begin
  if not exists (select 1 from public.profiles where id = auth.uid() and role = 'student') then
    raise exception 'Only student accounts can view parent requests.';
  end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'parent_id', l.parent_id,
    'display_name', coalesce(p.display_name, '未命名家長'),
    'status', l.status,
    'requested_at', l.requested_at,
    'approved_at', l.approved_at
  ) order by l.requested_at desc), '[]'::jsonb)
  into v_result
  from public.parent_student_links l
  join public.profiles p on p.id = l.parent_id and p.role = 'parent'
  where l.student_id = auth.uid();
  return jsonb_build_object('success', true, 'requests', v_result);
end;
$$;

create or replace function public.student_respond_parent_request(p_parent_id uuid, p_approve boolean)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not exists (select 1 from public.profiles where id = auth.uid() and role = 'student') then
    raise exception 'Only student accounts can respond to parent requests.';
  end if;
  if p_approve then
    update public.parent_student_links
    set status = 'approved', approved_at = now()
    where student_id = auth.uid() and parent_id = p_parent_id and status = 'pending';
  else
    delete from public.parent_student_links
    where student_id = auth.uid() and parent_id = p_parent_id;
  end if;
  return jsonb_build_object('success', true, 'approved', p_approve);
end;
$$;

create or replace function public.parent_unlink_student(p_student_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not exists (select 1 from public.profiles where id = auth.uid() and role = 'parent') then
    raise exception 'Only parent accounts can unlink students.';
  end if;
  delete from public.parent_student_links where parent_id = auth.uid() and student_id = p_student_id;
  return jsonb_build_object('success', true);
end;
$$;

create or replace function public.parent_get_dashboard()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_result jsonb;
  v_pending jsonb;
begin
  if not exists (select 1 from public.profiles where id = auth.uid() and role = 'parent') then
    raise exception 'Only parent accounts can view this dashboard.';
  end if;

  select coalesce(jsonb_agg(child_row order by child_row->>'display_name'), '[]'::jsonb)
  into v_result
  from (
    select jsonb_build_object(
      'student_id', p.id,
      'display_name', coalesce(p.display_name, '未命名學生'),
      'grade', coalesce(p.grade, 'P5'),
      'attempt_count', (select count(*) from public.practice_attempts a where a.student_id = p.id),
      'completed_count', (select count(*) from public.practice_attempts a where a.student_id = p.id and a.status = 'completed'),
      'average_score', coalesce((select round(avg(a.score)) from public.practice_attempts a where a.student_id = p.id and a.status = 'completed'), 0),
      'wrong_count', (select count(*) from public.question_responses r join public.practice_attempts a on a.id = r.attempt_id where a.student_id = p.id and r.is_correct = false),
      'last_active', (select max(a.started_at) from public.practice_attempts a where a.student_id = p.id),
      'subject_performance', coalesce((
        select jsonb_agg(jsonb_build_object(
          'subject', z.subject_name, 'attempts', z.attempt_count,
          'completed', z.completed_count, 'average', z.average_score
        ) order by z.subject_order)
        from (
          select s.name_zh subject_name, s.sort_order subject_order,
                 count(*) attempt_count,
                 count(*) filter (where a.status = 'completed') completed_count,
                 coalesce(round(avg(a.score) filter (where a.status = 'completed')), 0) average_score
          from public.practice_attempts a
          join public.curriculum_nodes n on n.id = a.node_id
          join public.curriculum_domains d on d.id = n.domain_id
          join public.curriculum_subjects s on s.id = d.subject_id
          where a.student_id = p.id
          group by s.id, s.name_zh, s.sort_order
        ) z
      ), '[]'::jsonb),
      'attempts', coalesce((
        select jsonb_agg(jsonb_build_object(
          'id', x.id, 'node_code', x.code, 'title_zh', x.title_zh,
          'status', x.status, 'total_questions', x.total_questions,
          'answered_count', x.answered_count, 'correct_count', x.correct_count,
          'score', x.score, 'started_at', x.started_at, 'completed_at', x.completed_at
        ) order by x.started_at desc)
        from (
          select a.id, n.code, n.title_zh, a.status, a.total_questions,
                 a.answered_count, a.correct_count, a.score, a.started_at, a.completed_at
          from public.practice_attempts a
          join public.curriculum_nodes n on n.id = a.node_id
          where a.student_id = p.id
          order by a.started_at desc limit 50
        ) x
      ), '[]'::jsonb)
    ) child_row
    from public.parent_student_links l
    join public.profiles p on p.id = l.student_id and p.role = 'student'
    where l.parent_id = auth.uid() and l.status = 'approved'
  ) linked;

  select coalesce(jsonb_agg(jsonb_build_object(
    'student_id', p.id, 'display_name', coalesce(p.display_name, '未命名學生'),
    'requested_at', l.requested_at
  ) order by l.requested_at desc), '[]'::jsonb)
  into v_pending
  from public.parent_student_links l
  join public.profiles p on p.id = l.student_id
  where l.parent_id = auth.uid() and l.status = 'pending';

  return jsonb_build_object('success', true, 'children', v_result, 'pending_requests', v_pending);
end;
$$;

create or replace function public.parent_get_child_errors(p_student_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare v_errors jsonb;
begin
  if not exists (
    select 1 from public.parent_student_links
    where parent_id = auth.uid() and student_id = p_student_id and status = 'approved'
  ) then raise exception 'You are not allowed to view this student.'; end if;

  select coalesce(jsonb_agg(error_row order by (error_row->>'answered_at')::timestamptz desc), '[]'::jsonb)
  into v_errors
  from (
    select jsonb_build_object(
      'response_id', r.id, 'attempt_id', r.attempt_id, 'question_id', r.question_id,
      'selected_answer', r.selected_answer, 'answered_at', r.answered_at,
      'node_code', n.code, 'title_zh', n.title_zh,
      'question_text', q.question_text, 'options', q.options,
      'correct_answer', k.correct_answer, 'explanation', k.explanation, 'hint', k.hint
    ) error_row
    from public.question_responses r
    join public.practice_attempts a on a.id = r.attempt_id and a.student_id = p_student_id
    join public.questions q on q.id = r.question_id
    join public.curriculum_nodes n on n.id = q.node_id
    left join public.question_answer_keys k on k.question_id = q.id
    where r.is_correct = false
    order by r.answered_at desc limit 100
  ) recent_errors;
  return jsonb_build_object('success', true, 'errors', v_errors);
end;
$$;

revoke all on function public.create_parent_link_code() from public;
revoke all on function public.parent_link_student(text) from public;
revoke all on function public.student_get_parent_requests() from public;
revoke all on function public.student_respond_parent_request(uuid, boolean) from public;
revoke all on function public.parent_unlink_student(uuid) from public;
revoke all on function public.parent_get_dashboard() from public;
revoke all on function public.parent_get_child_errors(uuid) from public;
grant execute on function public.create_parent_link_code() to authenticated;
grant execute on function public.parent_link_student(text) to authenticated;
grant execute on function public.student_get_parent_requests() to authenticated;
grant execute on function public.student_respond_parent_request(uuid, boolean) to authenticated;
grant execute on function public.parent_unlink_student(uuid) to authenticated;
grant execute on function public.parent_get_dashboard() to authenticated;
grant execute on function public.parent_get_child_errors(uuid) to authenticated;

commit;

select 'parent_dashboard_ready' as status,
       to_regclass('public.parent_student_links') is not null as links_table_ready,
       to_regprocedure('public.parent_get_dashboard()') is not null as dashboard_function_ready;
