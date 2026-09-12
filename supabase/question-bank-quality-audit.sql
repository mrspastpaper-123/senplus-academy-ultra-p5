-- SENPlus+ Academy Ultra P5：題庫品質自動檢查
-- 可重複執行；只供管理員使用，不會修改或刪除題目。

begin;

create or replace function public.admin_question_quality_report()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  result jsonb;
begin
  if not exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  ) then
    raise exception 'Administrator access required.';
  end if;

  with base as (
    select
      q.id as question_id,
      q.node_id,
      n.code as node_code,
      coalesce(n.title_zh, n.title_en, '') as node_title,
      q.question_text,
      q.options,
      k.correct_answer,
      k.explanation,
      k.hint,
      lower(regexp_replace(trim(coalesce(q.question_text, '')), '\s+', ' ', 'g')) as normalised_question
    from public.questions q
    join public.curriculum_nodes n on n.id = q.node_id
    left join public.question_answer_keys k on k.question_id = q.id
    where q.status = 'published'
  ), duplicate_groups as (
    select node_id, normalised_question, count(*) as copies
    from base
    where normalised_question <> ''
    group by node_id, normalised_question
    having count(*) > 1
  ), issues as (
    select b.question_id, b.node_code, b.node_title,
           'duplicate_question'::text as issue_type,
           '重複題目'::text as issue_label,
           format('同一單元內共有 %s 題相同題幹', d.copies) as detail,
           b.question_text
    from base b
    join duplicate_groups d using (node_id, normalised_question)

    union all

    select b.question_id, b.node_code, b.node_title,
           'missing_answer', '答案缺失',
           case
             when b.correct_answer is null then '沒有答案記錄'
             else '正確答案未能對應任何選項'
           end,
           b.question_text
    from base b
    where b.correct_answer is null
       or nullif(trim(both '"' from b.correct_answer::text), '') is null
       or (
         jsonb_typeof(b.options) = 'array'
         and not exists (
           select 1
           from jsonb_array_elements(b.options) option_row
           where lower(trim(option_row ->> 'id')) = lower(trim(both '"' from b.correct_answer::text))
         )
       )

    union all

    select b.question_id, b.node_code, b.node_title,
           'option_count', '選項數量不正確',
           case when jsonb_typeof(b.options) <> 'array' then '選項不是陣列格式'
                else format('目前只有 %s 個選項，應有4個', jsonb_array_length(b.options)) end,
           b.question_text
    from base b
    where b.options is null
       or jsonb_typeof(b.options) <> 'array'
       or (jsonb_typeof(b.options) = 'array' and jsonb_array_length(b.options) <> 4)

    union all

    select b.question_id, b.node_code, b.node_title,
           'duplicate_options', '四個選項有重複',
           '兩個或以上選項的文字完全相同',
           b.question_text
    from base b
    where jsonb_typeof(b.options) = 'array'
      and (
        select count(distinct lower(trim(option_row ->> 'text')))
        from jsonb_array_elements(b.options) option_row
      ) < jsonb_array_length(b.options)

    union all

    select b.question_id, b.node_code, b.node_title,
           'currency_symbol', '貨幣符號未本地化',
           '發現 £，香港題目應使用 $',
           b.question_text
    from base b
    where coalesce(b.question_text, '') like '%£%'
       or coalesce(b.options::text, '') like '%£%'
       or coalesce(b.explanation, '') like '%£%'
       or coalesce(b.hint, '') like '%£%'
  ), summary as (
    select issue_type, issue_label, count(*) as issue_count
    from issues
    group by issue_type, issue_label
  )
  select jsonb_build_object(
    'success', true,
    'checked_at', now(),
    'published_questions', (select count(*) from base),
    'questions_with_issues', (select count(distinct question_id) from issues),
    'total_issues', (select count(*) from issues),
    'summary', coalesce((
      select jsonb_agg(jsonb_build_object(
        'issue_type', issue_type,
        'issue_label', issue_label,
        'issue_count', issue_count
      ) order by issue_type)
      from summary
    ), '[]'::jsonb),
    'issues', coalesce((
      select jsonb_agg(jsonb_build_object(
        'question_id', question_id,
        'node_code', node_code,
        'node_title', node_title,
        'issue_type', issue_type,
        'issue_label', issue_label,
        'detail', detail,
        'question_text', question_text
      ) order by node_code, question_id, issue_type)
      from (select * from issues limit 1000) limited_issues
    ), '[]'::jsonb)
  ) into result;

  return result;
end;
$$;

revoke all on function public.admin_question_quality_report() from public;
grant execute on function public.admin_question_quality_report() to authenticated;

commit;

select
  'question_quality_audit_ready' as status,
  to_regprocedure('public.admin_question_quality_report()') is not null as audit_function_ready;
