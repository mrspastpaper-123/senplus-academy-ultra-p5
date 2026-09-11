import fs from "node:fs";

const sourcePath = new URL("../supabase/science-5sc1-to-5sc7-560.sql", import.meta.url);
const outputPath = new URL("../supabase/science-5sc1-to-5sc7-560-v2-clear.sql", import.meta.url);
const source = fs.readFileSync(sourcePath, "utf8");

const rowPattern = /\('((?:5SC)[1-7])', '概念選擇', '([\s\S]*?)', '(\[[\s\S]*?\])'::jsonb, '"([a-d])"'::jsonb, '([\s\S]*?)', '([\s\S]*?)', (\d)\),/g;
const facts = [];
let match;
while ((match = rowPattern.exec(source))) {
  const [, unit, originalQuestion, optionsJson, correctId, explanation, hint, difficulty] = match;
  const topic = originalQuestion.match(/關於「([^」]+)」/)?.[1];
  if (!topic) throw new Error(`無法讀取知識點：${originalQuestion}`);
  facts.push({ unit, topic, options: JSON.parse(optionsJson), correctId, explanation, hint, difficulty: Number(difficulty) });
}

if (facts.length !== 70) throw new Error(`預期讀取70個核心知識點，實際為${facts.length}個。`);

const names = ["梓軒", "芷晴", "嘉朗", "樂瑤"];
const variants = [
  {
    category: "概念理解",
    stem: (f) => `【概念理解】\n關於「${f.topic}」，下列哪一項說法正確？`,
    optionText: (_f, option) => option.text,
    explanation: (f) => f.explanation,
    hint: (f) => `先回想課本中「${f.topic}」的重點，再逐項判斷。`,
  },
  {
    category: "課堂筆記",
    stem: (f) => `【課堂筆記】\n老師請同學寫下「${f.topic}」的重點。哪一項最適合寫進筆記？`,
    optionText: (_f, option) => option.text,
    explanation: (f) => `正確筆記是「${correctText(f)}」。${f.explanation}`,
    hint: (f) => `答案必須直接而準確地說明「${f.topic}」。`,
  },
  {
    category: "同學討論",
    stem: (f) => `【同學討論】\n四位同學正在討論「${f.topic}」。哪位同學的說法正確？`,
    optionText: (_f, option, index) => `${names[index]}：「${option.text}」`,
    explanation: (f, _option, index) => `${names[index]}的說法「${correctText(f)}」正確。${f.explanation}`,
    hint: (f) => `不要只看同學的名字，應判斷每句話是否符合「${f.topic}」的科學知識。`,
  },
  {
    category: "改正錯誤",
    stem: (f) => `【改正錯誤】\n有同學在「${f.topic}」的筆記中寫了：「${wrongText(f)}」\n應把這句改成哪一項？`,
    optionText: (_f, option) => option.text,
    explanation: (f) => `原句不正確，應改為「${correctText(f)}」。${f.explanation}`,
    hint: (f) => `找出能完整取代錯誤句子，而且符合「${f.topic}」的選項。`,
  },
  {
    category: "生活情境",
    stem: (f) => `【生活情境】\n小組要製作一張介紹「${f.topic}」的生活科學海報。以下哪項內容科學上正確？`,
    optionText: (_f, option) => option.text,
    explanation: (f) => `海報應採用「${correctText(f)}」。${f.explanation}`,
    hint: (f) => `海報內容要符合科學原理，不能只選聽起來順口的句子。`,
  },
  {
    category: "圖卡配對",
    stem: (f) => `【圖卡配對】\n圖卡標題是「${f.topic}」。哪張文字卡應放在這個標題下面？`,
    optionText: (_f, option) => option.text,
    explanation: (f) => `「${correctText(f)}」與圖卡標題的概念相符。${f.explanation}`,
    hint: (f) => `比較標題和四張文字卡的意思，找出正確配對。`,
  },
  {
    category: "概念辨析",
    stem: (f) => `【概念辨析】\n下列四句都看似與「${f.topic}」有關，哪一句沒有混淆其他科學概念？`,
    optionText: (_f, option) => option.text,
    explanation: (f) => `沒有混淆概念的是「${correctText(f)}」。${f.explanation}`,
    hint: (f) => `留意選項是否把其他器官、現象或用途錯配到「${f.topic}」。`,
  },
  {
    category: "重點重溫",
    stem: (f) => `【重點重溫】\n完成「${f.topic}」一課後，哪項總結最準確？`,
    optionText: (_f, option) => option.text,
    explanation: (f) => `最準確的總結是「${correctText(f)}」。${f.explanation}`,
    hint: (f) => `選擇能準確總結課堂重點、沒有誇大或錯配的答案。`,
  },
];

function correctText(fact) {
  return fact.options.find((option) => option.id === fact.correctId).text;
}

function wrongText(fact) {
  return fact.options.find((option) => option.id !== fact.correctId).text;
}

function sqlText(value) {
  return `'${String(value).replaceAll("'", "''")}'`;
}

function rotatedOptions(fact, variantIndex, factIndex) {
  const shift = (variantIndex * 2 + factIndex) % 4;
  return [...fact.options.slice(shift), ...fact.options.slice(0, shift)].map((option, index) => ({
    id: ["a", "b", "c", "d"][index],
    originalId: option.id,
    text: option.text,
  }));
}

const generated = [];
for (const [factIndex, fact] of facts.entries()) {
  for (const [variantIndex, variant] of variants.entries()) {
    const rotated = rotatedOptions(fact, variantIndex, factIndex);
    const correctIndex = rotated.findIndex((option) => option.originalId === fact.correctId);
    const options = rotated.map((option, index) => ({ id: option.id, text: variant.optionText(fact, option, index) }));
    generated.push({
      unit: fact.unit,
      category: variant.category,
      question: variant.stem(fact),
      options,
      correctId: options[correctIndex].id,
      explanation: variant.explanation(fact, rotated[correctIndex], correctIndex),
      hint: variant.hint(fact),
      difficulty: Math.min(5, Math.max(1, fact.difficulty + (variantIndex >= 3 ? 1 : 0))),
    });
  }
}

const counts = Object.groupBy(generated, (item) => item.unit);
for (const unit of ["5SC1", "5SC2", "5SC3", "5SC4", "5SC5", "5SC6", "5SC7"]) {
  if ((counts[unit] ?? []).length !== 80) throw new Error(`${unit}題數不等於80。`);
}
if (new Set(generated.map((item) => `${item.unit}\n${item.question}`)).size !== 560) throw new Error("發現重複題目。");

const valueRows = generated.map((item, index) => {
  const suffix = index === generated.length - 1 ? ";" : ",";
  return `  (${sqlText(item.unit)}, ${sqlText(item.category)}, ${sqlText(item.question)}, ${sqlText(JSON.stringify(item.options))}::jsonb, ${sqlText(JSON.stringify(item.correctId))}::jsonb, ${sqlText(item.explanation)}, ${sqlText(item.hint)}, ${item.difficulty})${suffix}`;
}).join("\n");

const sql = `-- P5 科學科上學期清晰重製版 V2：5SC1-5SC7，共560題
-- 根據《科學新領域課本5上》及作業的課題範圍重寫。
-- 執行時把舊科學題目設為 archived，保留既有作答紀錄；新版題目設為 published。
-- 本檔可重複執行，不會重複新增。

begin;

create temporary table tmp_science_v2 (
  node_code text not null,
  category text not null,
  question_text text not null,
  options jsonb not null,
  correct_answer jsonb not null,
  explanation text not null,
  hint text not null,
  difficulty integer not null
) on commit drop;

insert into tmp_science_v2
  (node_code, category, question_text, options, correct_answer, explanation, hint, difficulty)
values
${valueRows}

do $$
declare invalid_units text;
begin
  select string_agg(node_code || '=' || question_count, ', ' order by node_code)
  into invalid_units
  from (
    select node_code, count(*)::text question_count
    from tmp_science_v2 group by node_code having count(*) <> 80
  ) x;
  if invalid_units is not null then raise exception '各單元必須有80題：%', invalid_units; end if;
  if (select count(*) from tmp_science_v2) <> 560 then raise exception '題庫總數必須為560。'; end if;
  if exists (
    select 1 from tmp_science_v2
    where jsonb_typeof(options) <> 'array'
       or jsonb_array_length(options) <> 4
       or correct_answer not in ('"a"'::jsonb, '"b"'::jsonb, '"c"'::jsonb, '"d"'::jsonb)
       or difficulty not between 1 and 5
  ) then raise exception '發現選項、答案或難度格式錯誤。'; end if;
  if exists (
    select 1 from tmp_science_v2 group by node_code, question_text having count(*) > 1
  ) then raise exception '發現重複題目。'; end if;
end $$;

-- 只停用七個科學單元的舊題；不刪除題目或學生作答紀錄。
update public.questions q
set status = 'archived'
from public.curriculum_nodes n
where q.node_id = n.id and n.code between '5SC1' and '5SC7';

insert into public.questions
  (node_id, question_type, question_text, options, difficulty, source_type, status)
select n.id, 'multiple_choice', t.question_text, t.options, t.difficulty, 'teacher', 'published'
from tmp_science_v2 t
join public.curriculum_nodes n on n.code = t.node_code
where not exists (
  select 1 from public.questions q where q.node_id = n.id and q.question_text = t.question_text
);

update public.questions q
set options = t.options,
    difficulty = t.difficulty,
    question_type = 'multiple_choice',
    source_type = 'teacher',
    status = 'published'
from tmp_science_v2 t
join public.curriculum_nodes n on n.code = t.node_code
where q.node_id = n.id and q.question_text = t.question_text;

insert into public.question_answer_keys (question_id, correct_answer, explanation, hint)
select q.id, t.correct_answer, t.explanation, t.hint
from tmp_science_v2 t
join public.curriculum_nodes n on n.code = t.node_code
join public.questions q on q.node_id = n.id and q.question_text = t.question_text
on conflict (question_id) do update
set correct_answer = excluded.correct_answer,
    explanation = excluded.explanation,
    hint = excluded.hint;

commit;

select n.code, n.title_zh,
       count(q.id) filter (where q.status = 'published') as published_questions
from public.curriculum_nodes n
left join public.questions q on q.node_id = n.id
where n.code between '5SC1' and '5SC7'
group by n.code, n.title_zh
order by n.code;
`;

fs.writeFileSync(outputPath, sql);
console.log(`已建立 ${generated.length} 題：${outputPath.pathname}`);
