-- English reading fix: one complete passage with its full set of 10 questions.
-- Safe to run repeatedly.

begin;

create or replace function public.start_reading_practice(p_node_id bigint)
returns jsonb
language plpgsql
security definer
set search_path=public
as $$
declare
  v_result jsonb;
  v_attempt_id bigint;
  v_node_code text;
  v_passage text;
  v_inserted integer;
begin
  if auth.uid() is null then
    raise exception 'not_authenticated';
  end if;

  select code into v_node_code
  from public.curriculum_nodes
  where id=p_node_id and is_active=true;

  if v_node_code is null or v_node_code !~ '^(5CR|5ER)' then
    return jsonb_build_object('success',false,'reason','not_reading_unit');
  end if;

  if v_node_code ~ '^5ER' then
    select trim(split_part(q.question_text,'Question:',1))
    into v_passage
    from public.questions q
    where q.node_id=p_node_id and q.status='published'
    group by trim(split_part(q.question_text,'Question:',1))
    having count(*) >= 10
    order by random()
    limit 1;
  else
    select trim(split_part(q.question_text,'問題：',1))
    into v_passage
    from public.questions q
    where q.node_id=p_node_id and q.status='published'
    group by trim(split_part(q.question_text,'問題：',1))
    having count(*) >= 10
    order by random()
    limit 1;
  end if;

  if v_passage is null then
    return jsonb_build_object('success',false,'reason','no_complete_passage');
  end if;

  -- Reuse the established attempt creation and scoring setup.
  v_result := public.start_practice(p_node_id,10);
  if not coalesce((v_result->>'success')::boolean,false) then
    return v_result;
  end if;

  v_attempt_id := (v_result->>'attempt_id')::bigint;
  delete from public.attempt_questions where attempt_id=v_attempt_id;

  if v_node_code ~ '^5ER' then
    insert into public.attempt_questions(attempt_id,question_id,position)
    select v_attempt_id,q.id,row_number() over(order by q.id)::integer
    from public.questions q
    where q.node_id=p_node_id
      and q.status='published'
      and trim(split_part(q.question_text,'Question:',1))=v_passage
    order by q.id
    limit 10;
  else
    insert into public.attempt_questions(attempt_id,question_id,position)
    select v_attempt_id,q.id,row_number() over(order by q.id)::integer
    from public.questions q
    where q.node_id=p_node_id
      and q.status='published'
      and trim(split_part(q.question_text,'問題：',1))=v_passage
    order by q.id
    limit 10;
  end if;

  get diagnostics v_inserted = row_count;
  if v_inserted <> 10 then
    delete from public.attempt_questions where attempt_id=v_attempt_id;
    delete from public.practice_attempts where id=v_attempt_id;
    return jsonb_build_object('success',false,'reason','no_complete_passage');
  end if;

  return v_result || jsonb_build_object('passage_question_count',v_inserted);
end $$;

grant execute on function public.start_reading_practice(bigint) to authenticated;

commit;

select n.code,n.title_en,count(distinct trim(split_part(q.question_text,'Question:',1)))
  filter(where q.status='published') as complete_passages
from public.curriculum_nodes n
left join public.questions q on q.node_id=n.id
where n.code between '5ER1' and '5ER5'
group by n.code,n.title_en
order by n.code;
