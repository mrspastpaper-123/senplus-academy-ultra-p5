begin;

-- Keep the original one-argument function available for older deployed clients,
-- and add an optional prompt to exclude for the "抽選另一題" action.
create or replace function public.start_writing_task(
  p_node_id bigint,
  p_exclude_prompt_id bigint default null
)
returns jsonb
language plpgsql
security definer
set search_path=public
as $$
declare
  p public.writing_prompts;
begin
  if auth.uid() is null then
    raise exception 'not_authenticated';
  end if;

  select * into p
  from public.writing_prompts
  where node_id=p_node_id
    and status='published'
    and (p_exclude_prompt_id is null or id<>p_exclude_prompt_id)
  order by random()
  limit 1;

  -- A unit containing only one published prompt still remains usable.
  if p.id is null and p_exclude_prompt_id is not null then
    select * into p
    from public.writing_prompts
    where node_id=p_node_id and status='published'
    order by random()
    limit 1;
  end if;

  if p.id is null then
    return jsonb_build_object('success',false,'reason','no_prompt');
  end if;

  return jsonb_build_object(
    'success',true,
    'prompt_id',p.id,
    'genre',p.genre,
    'title',p.title,
    'instruction',p.instruction,
    'min_chars',p.min_chars,
    'max_chars',p.max_chars,
    'guidance',p.guidance
  );
end $$;

grant execute on function public.start_writing_task(bigint,bigint) to authenticated;

commit;

select n.code,n.title_zh,count(wp.id) filter(where wp.status='published') as published_prompts
from public.curriculum_nodes n
left join public.writing_prompts wp on wp.node_id=n.id
where n.code in('5CW1','5CW2','5CW3','5CW4')
group by n.code,n.title_zh
order by n.code;
