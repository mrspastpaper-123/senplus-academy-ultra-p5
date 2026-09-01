import fs from "node:fs";

const letters=["a","b","c","d"];
const optionSet=(correct,wrong,seed)=>{const values=[correct,...wrong.filter(v=>v!==correct).slice(0,3)];const shift=seed%4;const choices=[...values.slice(shift),...values.slice(0,shift)];return{choices,answer:letters[choices.indexOf(correct)]};};
const fill=(sentence,value)=>sentence.replace("___",value);

const units={
"5EG5":[
["___ the vegetables before adding them to the soup.","Wash",["Washes","Washing","To wash"],"An affirmative imperative begins with the base form of a verb."],
["___ near the edge of the platform.","Don't stand",["Not stand","Doesn't stand","Don't standing"],"A negative imperative uses don't plus the base form."],
["Please ___ your name at the top of the page.","write",["writes","writing","wrote"],"Use the base form in an imperative, including after please."],
["___ the medicine without an adult's permission.","Do not take",["Not take","Do not taking","Does not take"],"Do not plus the base form makes a negative imperative."],
["___ left at the traffic lights.","Turn",["Turns","Turning","Turned"],"Instructions use the base form of the verb."],
["___ the lid tightly before shaking the bottle.","Close",["Closed","Closes","Closing"],"An instruction begins with the base form close."],
["___ your mobile phone during the performance.","Switch off",["Switches off","Switching off","Switched off"],"Use the base form for an imperative instruction."],
["___ any food to the animals at the zoo.","Don't give",["Not giving","Doesn't give","Don't gave"],"Use don't plus the base form give."],
["___ quietly while other pupils are reading.","Work",["Works","Worked","Working"],"The subject you is understood in an imperative."],
["___ to check both sides before crossing the road.","Remember",["Remembers","Remembering","Remembered"],"Use the base form remember to give a reminder."],
["___, preheat the oven to 180 degrees.","First",["Finally","Yesterday","Because"],"First introduces the opening step in a sequence."],
["First, fold the paper in half. ___, draw a line along the fold.","Next",["Finally before","Because","Although"],"Next introduces the following step."],
["Mix the flour and sugar. ___, add two eggs.","Then",["First yesterday","Although","Because"],"Then shows what happens after the previous step."],
["Wash the strawberries. ___, remove their leaves.","After that",["Before first","Although","So because"],"After that links a later step in a process."],
["___, place the finished model somewhere safe to dry.","Finally",["First before","Because","While first"],"Finally introduces the last step."],
["First, open the document. Next, type your message. ___, press Send.","Finally",["First","Before","Although"],"The final action in a sequence is introduced by finally."],
["Put the seed into the soil. ___, cover it gently with soil.","Then",["Finally before","Because","Until"],"Then introduces the action that follows."],
["___ washing your hands, dry them with a clean towel.","After",["Before","Until","Although"],"After plus a gerund shows that one action is completed first."],
["Check that the road is clear ___ you cross.","before",["after","finally","so"],"Before shows that checking happens earlier than crossing."],
["Wait here ___ the teacher returns.","until",["after that","first","although"],"Until means up to the time when something happens."]
],
"5EG6":[
["I want ___ the new science exhibition.","to visit",["visiting","visit to","visited"],"Want is followed by a to-infinitive."],
["We need ___ enough water for the hike.","to bring",["bringing","bring to","brought"],"Need is followed by a to-infinitive in this sentence."],
["Mia decided ___ the lost wallet to the office.","to take",["taking","take to","took"],"Decide is followed by a to-infinitive."],
["The class hopes ___ the recycling competition.","to win",["winning","win to","won"],"Hope is followed by a to-infinitive."],
["Dad plans ___ dinner before six o'clock.","to cook",["cooking","cook to","cooked"],"Plan is followed by a to-infinitive."],
["The guide reminded us ___ on the marked path.","to stay",["staying","stay to","stayed"],"Remind someone is followed by a to-infinitive."],
["I would like ___ this book for another week.","to keep",["keeping","keep to","kept"],"Would like is followed by a to-infinitive."],
["They agreed ___ the work fairly.","to share",["sharing","share to","shared"],"Agree is followed by a to-infinitive."],
["The doctor advised Ken ___ more water.","to drink",["drinking","drink to","drank"],"Advise someone is followed by a to-infinitive."],
["We use a thermometer ___ temperature.","to measure",["measuring","measure to","measured"],"A to-infinitive can explain the purpose of an object."],
["Ruby enjoys ___ mystery stories.","reading",["to reading","read","reads"],"Enjoy is followed by a gerund."],
["Please finish ___ your desk before recess.","tidying",["to tidying","tidy","tidied"],"Finish is followed by a gerund."],
["You should avoid ___ on the wet floor.","running",["to running","run","ran"],"Avoid is followed by a gerund."],
["The baby kept ___ during the journey.","sleeping",["to sleeping","sleep","slept"],"Keep is followed by a gerund to show a continuing action."],
["Noah practises ___ the violin every evening.","playing",["to playing","play","played"],"Practise is followed by a gerund."],
["My grandparents love ___ in the park.","walking",["to walking","walked","walks"],"Love can be followed by a gerund when talking about an activity."],
["Sally is interested in ___ wildlife photographs.","taking",["take","to taking","took"],"A preposition is followed by a noun or gerund."],
["Thank you for ___ me with the project.","helping",["help","to helping","helped"],"For is a preposition, so it is followed by a gerund."],
["Leo is good at ___ difficult puzzles.","solving",["solve","to solving","solved"],"At is followed by the gerund solving."],
["The children left without ___ goodbye.","saying",["say","to saying","said"],"Without is a preposition and is followed by a gerund."]
],
"5EG7":[
["At eight o'clock last night, I ___ my homework.","was doing",["were doing","did at eight","am doing"],"Use was plus an -ing form for an action in progress at a past time."],
["The children ___ football when it began to rain.","were playing",["was playing","played when","are playing"],"A plural subject takes were in the past continuous."],
["Mum ___ dinner while Dad was setting the table.","was cooking",["were cooking","cooked while","is cooking"],"A singular subject takes was in the past continuous."],
["We ___ when the alarm rang.","were sleeping",["was sleeping","slept when","are sleeping"],"The longer background action uses the past continuous."],
["What ___ you doing at five yesterday?", "were",["was","did","are"],"A past continuous question with you uses were."],
["___ Tina waiting for the bus when you saw her?", "Was",["Were","Did","Is"],"A past continuous question with Tina begins with Was."],
["The dog ___ under the table while we were eating.","was hiding",["were hiding","hid while","is hiding"],"Use was hiding for an action continuing at that past time."],
["They ___ attention when the teacher asked the question.","were not paying",["was not paying","did not paying","are not paying"],"A negative past continuous verb for they uses were not plus -ing."],
["While I ___ to school, I found a key.","was walking",["were walking","walked while","am walking"],"The action after while is an ongoing past action."],
["The lights went out while we ___ a film.","were watching",["was watching","watched while","are watching"],"Were watching describes the longer action interrupted by a shorter event."],
["I was reading ___ my brother was drawing.","while",["when suddenly after","because of","until first"],"While can link two actions happening at the same time."],
["The pupils were lining up ___ the bell rang.","when",["while the same","until first","although of"],"When introduces a shorter action interrupting a longer one."],
["___ the coach was speaking, everyone was listening carefully.","While",["When suddenly after","Ago","Since"],"While links simultaneous ongoing actions."],
["The glass broke ___ Ava was washing it.","while",["ago","since","for"],"While introduces the action that was in progress."],
["I cut ___ while I was slicing an apple.","myself",["me","my","mine"],"Myself is used when I is both the subject and object."],
["Tom taught ___ how to make a simple website.","himself",["him","his","he"],"Himself refers back to the male subject Tom."],
["We made the costumes ___.", "ourselves",["us","our","ours"],"Ourselves emphasises that we made them without help."],
["The cat cleaned ___ after eating.","itself",["it","its","it's"],"Itself refers back to an animal or thing used as the subject."],
["Children, please help ___ to some fruit.","yourselves",["yourself","you","your"],"Yourselves agrees with the plural person being addressed."],
["Nina and Zoe organised the whole event ___.", "themselves",["them","their","theirs"],"Themselves refers back to the plural subject Nina and Zoe."]
],
"5EG8":[
["Which sentence uses direct speech correctly? ___","Mum said, “Dinner is ready.”",["Mum said “Dinner is ready”.","Mum said, Dinner is ready.","Mum said that, “Dinner is ready.”"],"Direct speech uses quotation marks around the speaker's exact words."],
["Which sentence punctuates the reporting clause correctly? ___","“Please sit down,” said Mr Lee.",["“Please sit down” said Mr Lee.","Please sit down, said Mr Lee.","“Please sit down.” said Mr Lee."],"A comma normally separates the quoted words from a following reporting clause."],
["Change to direct speech: Ben said that he was tired. ___","Ben said, “I am tired.”",["Ben said that, “he was tired.”","Ben said “I was tired”.","Ben said, I am tired."],"Direct speech gives the speaker's original words inside quotation marks."],
["Change to direct speech: Amy said that she liked the painting. ___","Amy said, “I like the painting.”",["Amy said that “she likes the painting.”","Amy said, “She liked painting”.","Amy said I like the painting."],"Change the pronoun to I and place the exact words in quotation marks."],
["The teacher said, “The Earth moves around the Sun.” This becomes: ___","The teacher said that the Earth moves around the Sun.",["The teacher said that the Earth moved yesterday around the Sun.","The teacher told that Earth move around Sun.","The teacher said the Earth moving around the Sun."],"A scientific fact can remain in the present tense in reported speech."],
["Lily said, “I am reading a new book.” This becomes: ___","Lily said that she was reading a new book.",["Lily said that I am reading a new book.","Lily told that she reading a new book.","Lily said she were read a new book."],"In reported speech, I changes to she and am reading normally changes to was reading."],
["Jack said, “I finished the model.” This becomes: ___","Jack said that he had finished the model.",["Jack said that I finish the model.","Jack told that he has finish the model.","Jack said he finishing the model."],"The pronoun changes and the earlier completed action can be reported with had finished."],
["Mia said, “We will arrive early.” This becomes: ___","Mia said that they would arrive early.",["Mia said that we will arrived early.","Mia told that they would arrived early.","Mia said they will arriving early."],"In reported speech, will normally changes to would and we changes to they."],
["Dad said to me, “Close the window.” This becomes: ___","Dad told me to close the window.",["Dad said me close the window.","Dad told to me closing the window.","Dad told me closed the window."],"Report a positive command with told plus object plus to-infinitive."],
["The guard said to us, “Do not enter.” This becomes: ___","The guard told us not to enter.",["The guard said us do not enter.","The guard told us to not entered.","The guard told not us entering."],"Report a negative command with told plus object plus not to-infinitive."],
["Mum said to Eva, “Please tidy your room.” This becomes: ___","Mum told Eva to tidy her room.",["Mum said Eva tidying your room.","Mum told Eva tidy his room.","Mum told to Eva tidied her room."],"Use told plus Eva plus to tidy, and change your to her."],
["The coach said to the players, “Run faster.” This becomes: ___","The coach told the players to run faster.",["The coach said the players ran faster.","The coach told the players running faster.","The coach told to run the players faster."],"A reported instruction uses told plus object plus to-infinitive."],
["Sara said, “I can swim.” This becomes: ___","Sara said that she could swim.",["Sara told that I can swam.","Sara said she can swimming.","Sara said that her could swim."],"Can normally changes to could in reported speech, and I changes to she."],
["Tom said, “My bag is here.” This becomes: ___","Tom said that his bag was there.",["Tom said that my bag is here.","Tom told his bag were there.","Tom said his bag be here."],"My changes to his, is to was, and here to there."],
["Which reporting verb is correct? The nurse ___ me to rest.","told",["said","said to that","told to"],"Tell is followed by an object; say is not used directly before an object."],
["Which reporting verb is correct? Kelly ___ that she was busy.","said",["told","told to","said me"],"Say can be followed by a that-clause without an object."],
["Yesterday, Ben said that he ___ the film the week before.","had watched",["has watch","watches tomorrow","is watching now"],"Had watched shows an action completed before the past reporting time."],
["The guide told us that the museum ___ at ten every day.","opens",["opened yesterday only","opening","open to"],"A regular timetable or continuing fact can stay in the present tense."],
["Ella told me that she ___ me the next day.","would call",["will called","calls yesterday","would called"],"Will changes to would, and tomorrow can change to the next day."],
["Which sentence is correct reported speech? ___","Noah said that he had lost his key.",["Noah told that he has lose my key.","Noah said me he losted his key.","Noah said that I had losing his key."],"Reported statements use said that, suitable pronouns and a correct verb form."]
]};

const genericRules=["Use an adjective after every action verb.","A modal verb must always be followed by to.","Use has with all plural subjects.","Use the simple present for every past action.","A preposition is followed only by a base verb.","Direct speech never needs quotation marks.","Use said directly before a person without to.","Use while only with a finished point in time."];
const rows=[];
for(const[code,records]of Object.entries(units))records.forEach(([sentence,correct,wrong,rule],index)=>{const base=index*4;const q1=optionSet(correct,wrong,base);rows.push([code,"Gap filling",`Complete the sentence: ${sentence}`,q1,rule,2+index%3]);const correctSentence=fill(sentence,correct);const wrongSentences=wrong.map(word=>fill(sentence,word));const q2=optionSet(correctSentence,wrongSentences,base+1);rows.push([code,"Sentence use",`Which sentence is grammatically correct? (Set ${index+1})`,q2,rule,2+(index+1)%3]);const q3=optionSet(rule,genericRules.filter(r=>r!==rule),base+2);rows.push([code,"Grammar rule",`Which rule best explains the answer in this example: “${correctSentence}”?`,q3,rule,3+index%2]);const q4=optionSet(correct,wrong,base+3);rows.push([code,"Proofreading",`A pupil wrote: “${fill(sentence,wrong[0])}” Which word or phrase should replace “${wrong[0]}”?`,q4,`The correct version is: ${correctSentence}`,3+index%2]);});

if(rows.length!==320)throw new Error(`Expected 320 questions, found ${rows.length}.`);
for(const code of Object.keys(units))if(rows.filter(row=>row[0]===code).length!==80)throw new Error(`${code} does not contain 80 questions.`);
const keys=rows.map(row=>`${row[0]}\u0000${row[2]}`);if(new Set(keys).size!==keys.length)throw new Error("Duplicate question text found.");
rows.forEach((row,index)=>{const{choices,answer}=row[3];if(choices.length!==4||new Set(choices).size!==4)throw new Error(`Question ${index+1} does not have four unique options.`);if(!letters.includes(answer))throw new Error(`Question ${index+1} has an invalid answer key.`);});

const esc=value=>String(value).replaceAll("'","''");const json=value=>esc(JSON.stringify(value));
const values=rows.map(([code,category,question,{choices,answer},explanation,difficulty])=>{const options=choices.map((text,i)=>({id:letters[i],text}));return`  ('${code}','${esc(category)}','${esc(question)}','${json(options)}'::jsonb,'"${answer}"'::jsonb,'${esc(explanation)}','Read the whole sentence, identify the grammar pattern and then compare all four options.',${difficulty})`;}).join(",\n");

const sql=`-- P5 English Grammar 5EG5-5EG8: 320 original multiple-choice questions (80 per unit).
-- Safe to run repeatedly: existing nodes and matching question texts are retained.
begin;

do $$ begin
  if not exists(select 1 from public.curriculum_subjects where grade='P5' and code='english') then raise exception 'P5 English subject was not found.'; end if;
  if not exists(select 1 from public.curriculum_domains d join public.curriculum_subjects s on s.id=d.subject_id where s.grade='P5' and s.code='english' and d.code='grammar') then raise exception 'P5 English grammar domain was not found. Run the 5EG1-5EG4 SQL first.'; end if;
end $$;

insert into public.curriculum_nodes(domain_id,code,title_zh,title_en,difficulty,sort_order,is_active)
select d.id,v.code,v.title_zh,v.title_en,v.difficulty,v.sort_order,true
from public.curriculum_domains d join public.curriculum_subjects s on s.id=d.subject_id
cross join(values
('5EG5','祈使句及次序連接詞','Imperatives and Sequence Connectives',3,5),
('5EG6','不定詞及動名詞','Infinitives and Gerunds',3,6),
('5EG7','過去進行式及反身代名詞','Past Continuous and Reflexive Pronouns',4,7),
('5EG8','直接引語及間接引語','Direct and Indirect Speech',4,8)
)v(code,title_zh,title_en,difficulty,sort_order)
where s.grade='P5' and s.code='english' and d.code='grammar' and not exists(select 1 from public.curriculum_nodes n where n.code=v.code);

create temporary table tmp_english_grammar(node_code text not null,category text not null,question_text text not null,options jsonb not null,correct_answer jsonb not null,explanation text not null,hint text not null,difficulty integer not null)on commit drop;
insert into tmp_english_grammar(node_code,category,question_text,options,correct_answer,explanation,hint,difficulty)values
${values};

do $$ declare bad_count integer; begin
select count(*) into bad_count from(values('5EG5',80),('5EG6',80),('5EG7',80),('5EG8',80))expected(code,qty) where(select count(*) from tmp_english_grammar t where t.node_code=expected.code)<>expected.qty;
if bad_count>0 then raise exception 'Per-unit question count validation failed.';end if;
if(select count(*) from tmp_english_grammar)<>320 then raise exception 'Total question count is not 320.';end if;
if(select count(*) from tmp_english_grammar)<>(select count(*) from(select distinct node_code,question_text from tmp_english_grammar)d)then raise exception 'Duplicate question text found.';end if;
end $$;

insert into public.questions(node_id,question_type,question_text,options,difficulty,source_type,status)
select n.id,'multiple_choice',t.question_text,t.options,t.difficulty,'teacher','published' from tmp_english_grammar t join public.curriculum_nodes n on n.code=t.node_code where not exists(select 1 from public.questions q where q.node_id=n.id and q.question_text=t.question_text);
insert into public.question_answer_keys(question_id,correct_answer,explanation,hint)
select q.id,t.correct_answer,t.explanation,t.hint from tmp_english_grammar t join public.curriculum_nodes n on n.code=t.node_code join public.questions q on q.node_id=n.id and q.question_text=t.question_text
on conflict(question_id)do update set correct_answer=excluded.correct_answer,explanation=excluded.explanation,hint=excluded.hint;
commit;

select n.code,n.title_en,count(q.id)filter(where q.status='published')as published_questions from public.curriculum_nodes n left join public.questions q on q.node_id=n.id where n.code in('5EG5','5EG6','5EG7','5EG8') group by n.code,n.title_en order by n.code;
`;
const output=new URL("../supabase/english-grammar-5eg5-to-5eg8-320.sql",import.meta.url);fs.writeFileSync(output,sql);console.log(`Generated ${rows.length} questions at ${output.pathname}`);
