-- SENPlus+ Academy Ultra P5：把題庫內所有英鎊符號 £ 改為香港使用的 $。
-- 可安全重複執行；第二次執行時不會再修改已更新的內容。

begin;

drop table if exists tmp_currency_update_counts;
create temporary table tmp_currency_update_counts (
  content_area text primary key,
  updated_rows integer not null
) on commit preserve rows;

do $$
declare
  affected integer;
begin
  update public.questions
  set question_text = replace(question_text, '£', '$')
  where question_text like '%£%';
  get diagnostics affected = row_count;
  insert into tmp_currency_update_counts values ('題目文字', affected);

  update public.questions
  set options = replace(options::text, '£', '$')::jsonb
  where options::text like '%£%';
  get diagnostics affected = row_count;
  insert into tmp_currency_update_counts values ('選項', affected);

  update public.question_answer_keys
  set explanation = replace(explanation, '£', '$')
  where explanation like '%£%';
  get diagnostics affected = row_count;
  insert into tmp_currency_update_counts values ('答案解析', affected);

  update public.question_answer_keys
  set hint = replace(hint, '£', '$')
  where hint like '%£%';
  get diagnostics affected = row_count;
  insert into tmp_currency_update_counts values ('提示', affected);
end $$;

commit;

select content_area, updated_rows
from tmp_currency_update_counts
order by content_area;
