import fs from "node:fs";

const letters = ["a", "b", "c", "d"];
const optionSet = (correct, wrong, seed) => {
  const values = [correct, ...wrong.filter((v) => v !== correct).slice(0, 3)];
  const shift = seed % 4;
  const choices = [...values.slice(shift), ...values.slice(0, shift)];
  return { choices, answer: letters[choices.indexOf(correct)] };
};
const fill = (sentence, value) => sentence.replace("___", value);

const units = {
  "5EG1": [
    ["Maya waited ___ for her turn at the clinic.","patiently",["patient","impatient","patience"],"An adverb of manner describes how an action is done."],
    ["The librarian spoke ___ so everyone could keep reading.","softly",["soft","loud","softness"],"Use an adverb after the verb to describe how someone speaks."],
    ["Ryan packed the glass model ___ before the journey.","carefully",["careful","carelessly","care"],"Carefully is the adverb formed from careful."],
    ["The choir sang ___ at the school concert.","beautifully",["beautiful","beauty","more beautiful"],"Beautifully describes the way the choir sang."],
    ["The firefighters moved ___ through the smoky corridor.","bravely",["brave","bravery","braver"],"Bravely is an adverb of manner."],
    ["Please write ___ so that I can read your answer.","clearly",["clear","clearness","clearest"],"Clearly describes how the writing should be done."],
    ["The tortoise crossed the path ___.", "slowly",["slow","slowness","slower"],"Slowly is the adverb form of slow."],
    ["Nora completed the puzzle ___ and checked every piece.","methodically",["methodical","method","methods"],"Methodically tells us how Nora completed the puzzle."],
    ["The puppy slept ___ beside the warm fireplace.","peacefully",["peaceful","peace","more peaceful"],"Peacefully describes the way the puppy slept."],
    ["Kai answered the difficult question ___.", "correctly",["correct","correction","correctness"],"Correctly is the adverb needed after answered."],
    ["You ___ wear a helmet when you ride a bicycle.","should",["shouldn't","should to","should wearing"],"Should is used to give sensible advice."],
    ["We ___ leave litter in the country park.","shouldn't",["should","should to","should not to"],"Shouldn't advises someone not to do something."],
    ["Tina has a high fever. She ___ rest at home.","should",["shouldn't","should resting","should to rest"],"Use should plus the base form to give advice."],
    ["You ___ share your password with strangers online.","shouldn't",["should","should sharing","should to share"],"Not sharing a password is safe advice, so use shouldn't."],
    ["The floor is wet. We ___ walk carefully.","should",["shouldn't","should walked","should to walk"],"Should is followed by the base form walk."],
    ["Pupils ___ shout while an examination is in progress.","shouldn't",["should","should shouting","should to shout"],"Shouldn't expresses an action that is not advisable."],
    ["To save water, we ___ turn off the tap while brushing our teeth.","should",["shouldn't","should turning","should to turn"],"Should introduces a recommended action."],
    ["You ___ touch a hot pan with your bare hands.","shouldn't",["should","should touching","should to touch"],"Shouldn't is used because the action is dangerous."],
    ["Leo wants to improve his spelling. He ___ read and practise regularly.","should",["shouldn't","should reads","should to read"],"After should, use the base form of the verb."],
    ["We ___ interrupt people when they are speaking.","shouldn't",["should","should interrupted","should to interrupt"],"Shouldn't gives advice about impolite behaviour."]
  ],
  "5EG2": [
    ["The two pen friends write to ___ every month.","each other",["themselves","their","theirs"],"Each other shows a reciprocal action between two people."],
    ["All five team members encouraged ___ before the final.","one another",["themselves","each","their"],"One another can show a reciprocal action in a group."],
    ["My sister and I helped ___ with our homework.","each other",["ourselves","us","our"],"Each other means that each person helped the other."],
    ["The neighbours greeted ___ at the community picnic.","one another",["themselves","their","theirs"],"One another expresses a shared action."],
    ["This blue umbrella is ___.", "mine",["my","me","I"],"A possessive pronoun stands alone without a following noun."],
    ["Those football boots are ___.", "his",["he","him","he's"],"His can be a possessive pronoun and does not need a noun after it."],
    ["Our classroom is upstairs; ___ is beside the library.","theirs",["their","them","they"],"Theirs replaces their classroom."],
    ["Is this notebook yours or ___?", "hers",["her","she","she's"],"Hers is the possessive pronoun replacing her notebook."],
    ["The nurse ___ treated my ankle was very kind.","who",["which","where","whose"],"Who introduces a relative clause about a person."],
    ["The camera ___ I borrowed belongs to Uncle Ben.","which",["who","where","whose"],"Which introduces a relative clause about a thing."],
    ["This is the hall ___ our graduation ceremony took place.","where",["who","which","whose"],"Where refers to the place in a relative clause."],
    ["I met a girl ___ father is a wildlife photographer.","whose",["who","which","where"],"Whose shows possession in a relative clause."],
    ["The book ___ has a green cover is a dictionary.","that",["who","where","whose"],"That can introduce a defining relative clause about a thing."],
    ["Mr Ho is the coach ___ teaches us basketball.","who",["which","where","whose"],"Use who for a person."],
    ["The village ___ my grandparents live is very peaceful.","where",["who","which","whose"],"Use where to refer to a place."],
    ["The boy ___ bicycle was stolen reported it to the police.","whose",["who","which","where"],"Whose connects the boy with the bicycle he owns."],
    ["The woman ___ the red scarf is our new principal.","in",["with","on","at"],"In can describe a person wearing particular clothing."],
    ["The child ___ curly hair is my cousin.","with",["in","by","to"],"With can describe a physical feature someone has."],
    ["Please write your answers ___ a blue pen.","in",["with","on","at"],"We normally say write in blue pen or in blue ink."],
    ["The man ___ a suitcase is waiting for a taxi.","with",["in","by","to"],"With identifies a person carrying or having something."]
  ],
  "5EG3": [
    ["Ella ___ her science project already.","has finished",["finished yesterday","have finished","has finish"],"Use has plus the past participle for the present perfect."],
    ["We ___ that museum three times.","have visited",["has visited","have visit","visited last Sunday"],"Use have visited for an experience without a finished time."],
    ["Dad ___ home yet.","hasn't arrived",["haven't arrived","didn't arrived","hasn't arrive"],"Yet is commonly used with a negative present perfect verb."],
    ["The pupils ___ their permission slips.","have not returned",["has not returned","did not returned","have not return"],"A plural subject takes have not plus a past participle."],
    ["___ you ever ridden a horse?", "Have",["Has","Did","Are"],"A present perfect question with you begins with Have."],
    ["___ Mia packed her suitcase yet?", "Has",["Have","Did","Is"],"A present perfect question with Mia begins with Has."],
    ["How many times ___ they watched this film?", "have",["has","did","are"],"Use have with the plural subject they."],
    ["Where ___ Tom put the library books?", "has",["have","did","is"],"Use has plus the past participle with Tom."],
    ["I have ___ watered the plants, so the soil is still wet.","just",["yet","ever","last night"],"Just means a short time ago and is used before the past participle."],
    ["The train has ___ left the station.","already",["yet","ago","tomorrow"],"Already shows that something happened sooner than expected."],
    ["Have you completed your art homework ___?", "yet",["already yesterday","ago","last week"],"Yet is normally placed at the end of a present perfect question."],
    ["Sam hasn't read the message ___.", "yet",["already","ever yesterday","ago"],"Yet is suitable in a negative present perfect sentence."],
    ["Have you ___ seen snow?", "ever",["never","yet yesterday","ago"],"Ever asks whether something has happened at any time."],
    ["I have ___ eaten octopus because I am allergic to seafood.","never",["ever","yet","once yesterday"],"Never means not at any time."],
    ["Lily has entered the speech festival ___.", "twice",["two time","twice times","second"],"Twice means two times."],
    ["We have stayed at this campsite ___.", "once",["one time ago","first","once yesterday"],"Once means one time when no finished time is stated."],
    ["Ben ___ never flown in a helicopter.","has",["have","did","is"],"Use has with the singular subject Ben."],
    ["My cousins ___ just arrived from Canada.","have",["has","did","are"],"Use have with the plural subject cousins."],
    ["The chef has ___ the soup, and it is ready to serve.","tasted",["taste","tasting","tastes"],"The present perfect uses has plus the past participle tasted."],
    ["I have ___ my key, so I cannot open the door.","lost",["lose","losing","losed"],"Lost is the past participle of lose."]
  ],
  "5EG4": [
    ["I ___ my homework an hour ago.","finished",["have finished","has finished","finish"],"Use the simple past with ago because the time is finished."],
    ["We ___ to Macau in 2024.","travelled",["have travelled","has travelled","travel"],"Use the simple past with a stated finished year."],
    ["Nina ___ this novel, so she can lend it to you now.","has read",["read last night","have read","has reads"],"Use the present perfect when the result matters now and no finished time is given."],
    ["The bus ___, so we must wait for the next one.","has left",["left at 8 a.m. yesterday","have left","has leave"],"The present result is important, so use has left."],
    ["___ you see the rainbow after school yesterday?", "Did",["Have","Has","Do"],"Yesterday requires the simple past question form Did plus base verb."],
    ["___ you ever seen a shooting star?", "Have",["Did","Has","Do"],"Ever with life experience takes the present perfect."],
    ["Mr Chan ___ at this school since 2018.","has taught",["taught","have taught","has teach"],"Since gives the starting point of an action continuing to now."],
    ["We ___ each other for five years.","have known",["knew","has known","have know"],"For gives the duration of a continuing situation."],
    ["Amy has lived in Tai Po ___ she was born.","since",["for","ago","in"],"Since is followed by a starting point or clause."],
    ["The shop has been closed ___ two weeks.","for",["since","ago","in"],"For is followed by a length of time."],
    ["I joined the chess club three months ___.", "ago",["since","for","already"],"Ago is used with the simple past to count back from now."],
    ["My family moved here ___ 2021.","in",["since","for","ago"],"Use in with a finished year in a simple past sentence."],
    ["Cara ___ her ankle last Saturday.","hurt",["has hurt","have hurt","hurts"],"Last Saturday is a finished time, so use the simple past."],
    ["Cara ___ her ankle, so she cannot play today.","has hurt",["hurt last Saturday","have hurt","has hurting"],"Use the present perfect when explaining a present result."],
    ["I ___ my breakfast yet.","haven't eaten",["didn't eat yet","hasn't eaten","haven't ate"],"Yet in a negative sentence normally takes the present perfect."],
    ["I ___ breakfast at seven o'clock this morning.","ate",["have eaten","has eaten","eaten"],"A stated finished time takes the simple past."],
    ["How long ___ you had this bicycle?", "have",["did","has","are"],"How long asks about a duration continuing to now, so use have."],
    ["When ___ you buy this bicycle?", "did",["have","has","are"],"When asks for a finished time, so use did."],
    ["The children ___ in the playground since lunchtime.","have been",["were","has been","have be"],"Since lunchtime and a plural subject require have been."],
    ["The children ___ in the playground during recess yesterday.","were",["have been","has been","are"],"Yesterday gives a finished time, so use the simple past were."]
  ]
};

const genericRules = [
  "Use an adjective before every verb.",
  "Use the simple past whenever the sentence has no time expression.",
  "Use a possessive adjective without a noun after it.",
  "A modal verb must always be followed by 'to'.",
  "Use 'has' with every plural subject.",
  "Use 'for' before a starting date or year.",
  "Use 'since' before a length of time.",
  "Use 'who' to refer to an object.",
];

const rows = [];
for (const [code, records] of Object.entries(units)) {
  records.forEach(([sentence, correct, wrong, rule], index) => {
    const base = index * 4;
    const q1 = optionSet(correct, wrong, base);
    rows.push([code,"Gap filling",`Complete the sentence: ${sentence}`,q1,rule,2 + index % 3]);

    const correctSentence = fill(sentence, correct);
    const wrongSentences = wrong.map((word) => fill(sentence, word));
    const q2 = optionSet(correctSentence, wrongSentences, base + 1);
    rows.push([code,"Sentence use",`Which sentence is grammatically correct? (Set ${index + 1})`,q2,rule,2 + (index + 1) % 3]);

    const q3 = optionSet(rule, genericRules.filter((r) => r !== rule), base + 2);
    rows.push([code,"Grammar rule",`Which rule best explains the answer in this sentence: “${correctSentence}”?`,q3,rule,3 + index % 2]);

    const q4 = optionSet(correct, wrong, base + 3);
    rows.push([code,"Proofreading",`A pupil wrote: “${fill(sentence, wrong[0])}” Which word or phrase should replace “${wrong[0]}”?`,q4,`The correct sentence is: ${correctSentence}`,3 + index % 2]);
  });
}

if (rows.length !== 320) throw new Error(`Expected 320 questions, found ${rows.length}.`);
for (const code of Object.keys(units)) {
  if (rows.filter((row) => row[0] === code).length !== 80) throw new Error(`${code} does not contain 80 questions.`);
}
const questionKeys = rows.map((row) => `${row[0]}\u0000${row[2]}`);
if (new Set(questionKeys).size !== questionKeys.length) throw new Error("Duplicate question text found.");
rows.forEach((row, index) => {
  const { choices, answer } = row[3];
  if (choices.length !== 4 || new Set(choices).size !== 4) throw new Error(`Question ${index + 1} does not have four unique options.`);
  if (!letters.includes(answer)) throw new Error(`Question ${index + 1} has an invalid answer key.`);
});

const esc = (value) => String(value).replaceAll("'", "''");
const json = (value) => esc(JSON.stringify(value));
const values = rows.map(([code,category,question,{choices,answer},explanation,difficulty]) => {
  const options = choices.map((text, i) => ({ id: letters[i], text }));
  return `  ('${code}','${esc(category)}','${esc(question)}','${json(options)}'::jsonb,'"${answer}"'::jsonb,'${esc(explanation)}','Review the grammar clue and read the whole sentence before choosing.',${difficulty})`;
}).join(",\n");

const sql = `-- P5 English Grammar 5EG1-5EG4: 320 original multiple-choice questions (80 per unit).
-- Based on curriculum coverage identified in the supplied P5 materials; all wording is original.
-- Safe to run more than once: existing nodes and matching question texts are retained.

begin;

do $$
begin
  if not exists (select 1 from public.curriculum_subjects where grade='P5' and code='english') then
    raise exception 'P5 English subject was not found in curriculum_subjects.';
  end if;
end $$;

insert into public.curriculum_domains(subject_id,code,name_zh,name_en,sort_order)
select s.id,'grammar','文法','Grammar',1
from public.curriculum_subjects s
where s.grade='P5' and s.code='english'
  and not exists (select 1 from public.curriculum_domains d where d.subject_id=s.id and d.code='grammar');

insert into public.curriculum_nodes(domain_id,code,title_zh,title_en,difficulty,sort_order,is_active)
select d.id,v.code,v.title_zh,v.title_en,v.difficulty,v.sort_order,true
from public.curriculum_domains d
join public.curriculum_subjects s on s.id=d.subject_id
cross join (values
  ('5EG1','副詞及 should','Adverbs and Modal Should',2,1),
  ('5EG2','代名詞、關係子句及介詞','Pronouns, Relative Clauses and Prepositions',3,2),
  ('5EG3','現在完成式','Present Perfect Tense',3,3),
  ('5EG4','現在完成式及一般過去式','Present Perfect and Simple Past',4,4)
) v(code,title_zh,title_en,difficulty,sort_order)
where s.grade='P5' and s.code='english' and d.code='grammar'
  and not exists (select 1 from public.curriculum_nodes n where n.code=v.code);

create temporary table tmp_english_grammar(
  node_code text not null, category text not null, question_text text not null,
  options jsonb not null, correct_answer jsonb not null, explanation text not null,
  hint text not null, difficulty integer not null
) on commit drop;

insert into tmp_english_grammar(node_code,category,question_text,options,correct_answer,explanation,hint,difficulty)
values
${values};

do $$
declare bad_count integer;
begin
  select count(*) into bad_count
  from (values ('5EG1',80),('5EG2',80),('5EG3',80),('5EG4',80)) expected(code,qty)
  where (select count(*) from tmp_english_grammar t where t.node_code=expected.code)<>expected.qty;
  if bad_count>0 then raise exception 'Per-unit question count validation failed.'; end if;
  if (select count(*) from tmp_english_grammar)<>320 then raise exception 'Total question count is not 320.'; end if;
  if (select count(*) from tmp_english_grammar)<>(select count(*) from (select distinct node_code,question_text from tmp_english_grammar) d) then
    raise exception 'Duplicate question text found in generated batch.';
  end if;
end $$;

insert into public.questions(node_id,question_type,question_text,options,difficulty,source_type,status)
select n.id,'multiple_choice',t.question_text,t.options,t.difficulty,'teacher','published'
from tmp_english_grammar t join public.curriculum_nodes n on n.code=t.node_code
where not exists(select 1 from public.questions q where q.node_id=n.id and q.question_text=t.question_text);

insert into public.question_answer_keys(question_id,correct_answer,explanation,hint)
select q.id,t.correct_answer,t.explanation,t.hint
from tmp_english_grammar t
join public.curriculum_nodes n on n.code=t.node_code
join public.questions q on q.node_id=n.id and q.question_text=t.question_text
on conflict(question_id) do update set correct_answer=excluded.correct_answer,explanation=excluded.explanation,hint=excluded.hint;

commit;

select n.code,n.title_en,count(q.id) filter(where q.status='published') as published_questions
from public.curriculum_nodes n left join public.questions q on q.node_id=n.id
where n.code in('5EG1','5EG2','5EG3','5EG4')
group by n.code,n.title_en order by n.code;
`;

const output = new URL("../supabase/english-grammar-5eg1-to-5eg4-320.sql", import.meta.url);
fs.writeFileSync(output, sql);
console.log(`Generated ${rows.length} questions at ${output.pathname}`);
