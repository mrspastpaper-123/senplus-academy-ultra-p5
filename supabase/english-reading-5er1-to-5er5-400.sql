-- P5 English Reading 5ER1-5ER5: 40 original passages, 400 questions (80 per unit).
-- Safe to run repeatedly; existing matching questions are preserved.

begin;

do $$
begin
  if not exists (select 1 from public.curriculum_subjects where grade='P5' and code='english') then
    raise exception 'P5 English subject was not found in curriculum_subjects.';
  end if;
end $$;

insert into public.curriculum_domains(subject_id,code,name_zh,name_en,sort_order)
select s.id,'reading','閱讀理解','Reading Comprehension',2
from public.curriculum_subjects s
where s.grade='P5' and s.code='english'
  and not exists (select 1 from public.curriculum_domains d where d.subject_id=s.id and d.code='reading');

insert into public.curriculum_nodes (domain_id, code, title_zh, title_en, difficulty, sort_order, is_active)
select d.id,v.code,v.title_zh,v.title_en,v.difficulty,v.sort_order,true
from public.curriculum_domains d
join public.curriculum_subjects s on s.id=d.subject_id
cross join (values
  ('5ER1','英文記敘文閱讀','Narrative Reading',3,20),
  ('5ER2','英文說明文閱讀','Informational Reading',3,21),
  ('5ER3','英文實用文閱讀','Practical Reading',3,22),
  ('5ER4','英文詩歌及文學閱讀','Poetry and Literary Reading',3,23),
  ('5ER5','英文推論及作者觀點','Inference and Author’s Viewpoint Reading',3,24)
) v(code,title_zh,title_en,difficulty,sort_order)
where s.grade='P5' and s.code='english' and d.code='reading'
  and not exists (select 1 from public.curriculum_nodes n where n.code=v.code);

create temporary table tmp_english_reading (node_code text,passage_title text,question_text text,options jsonb,correct_answer jsonb,explanation text,hint text,difficulty integer) on commit drop;
insert into tmp_english_reading values
  ('5ER1','The Seedling on the Stairs','The Seedling on the Stairs

At the school stairwell, Maya noticed a seedling growing through a crack. Other people were busy, and the easiest choice was to walk away. Instead, Maya paused, looked for useful details and decided to protect it while keeping the stairs safe. The situation mattered because a hurried response could make it worse.

First, Maya placed a bright marker beside it and asked the caretaker for advice. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Maya explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the class moved it carefully into the garden. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Maya realised that care can be practical as well as kind. The experience would be remembered not only for its result, but also for the thoughtful way the problem had been handled.

Question: Where does the story mainly take place?','[{"id":"a","text":"the school stairwell"},{"id":"b","text":"at a distant airport"},{"id":"c","text":"inside a television studio"},{"id":"d","text":"on an unknown island"}]'::jsonb,'"a"'::jsonb,'The passage supports “the school stairwell”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Seedling on the Stairs','The Seedling on the Stairs

At the school stairwell, Maya noticed a seedling growing through a crack. Other people were busy, and the easiest choice was to walk away. Instead, Maya paused, looked for useful details and decided to protect it while keeping the stairs safe. The situation mattered because a hurried response could make it worse.

First, Maya placed a bright marker beside it and asked the caretaker for advice. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Maya explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the class moved it carefully into the garden. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Maya realised that care can be practical as well as kind. The experience would be remembered not only for its result, but also for the thoughtful way the problem had been handled.

Question: What problem does the main character notice?','[{"id":"a","text":"a prize arriving early"},{"id":"b","text":"a lesson being cancelled"},{"id":"c","text":"a journey with no difficulty"},{"id":"d","text":"a seedling growing through a crack"}]'::jsonb,'"d"'::jsonb,'The passage supports “a seedling growing through a crack”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Seedling on the Stairs','The Seedling on the Stairs

At the school stairwell, Maya noticed a seedling growing through a crack. Other people were busy, and the easiest choice was to walk away. Instead, Maya paused, looked for useful details and decided to protect it while keeping the stairs safe. The situation mattered because a hurried response could make it worse.

First, Maya placed a bright marker beside it and asked the caretaker for advice. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Maya explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the class moved it carefully into the garden. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Maya realised that care can be practical as well as kind. The experience would be remembered not only for its result, but also for the thoughtful way the problem had been handled.

Question: What does the main character decide to do?','[{"id":"a","text":"pretend nothing happened"},{"id":"b","text":"leave without telling anyone"},{"id":"c","text":"protect it while keeping the stairs safe"},{"id":"d","text":"wait for somebody else to act"}]'::jsonb,'"c"'::jsonb,'The passage supports “protect it while keeping the stairs safe”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Seedling on the Stairs','The Seedling on the Stairs

At the school stairwell, Maya noticed a seedling growing through a crack. Other people were busy, and the easiest choice was to walk away. Instead, Maya paused, looked for useful details and decided to protect it while keeping the stairs safe. The situation mattered because a hurried response could make it worse.

First, Maya placed a bright marker beside it and asked the caretaker for advice. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Maya explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the class moved it carefully into the garden. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Maya realised that care can be practical as well as kind. The experience would be remembered not only for its result, but also for the thoughtful way the problem had been handled.

Question: Which action helps to solve the problem?','[{"id":"a","text":"blaming the nearest person"},{"id":"b","text":"placed a bright marker beside it and asked the caretaker for advice"},{"id":"c","text":"hiding all the evidence"},{"id":"d","text":"repeating the same failed step"}]'::jsonb,'"b"'::jsonb,'The passage supports “placed a bright marker beside it and asked the caretaker for advice”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Seedling on the Stairs','The Seedling on the Stairs

At the school stairwell, Maya noticed a seedling growing through a crack. Other people were busy, and the easiest choice was to walk away. Instead, Maya paused, looked for useful details and decided to protect it while keeping the stairs safe. The situation mattered because a hurried response could make it worse.

First, Maya placed a bright marker beside it and asked the caretaker for advice. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Maya explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the class moved it carefully into the garden. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Maya realised that care can be practical as well as kind. The experience would be remembered not only for its result, but also for the thoughtful way the problem had been handled.

Question: What is the final result?','[{"id":"a","text":"the class moved it carefully into the garden"},{"id":"b","text":"the problem becomes impossible"},{"id":"c","text":"nobody learns what happened"},{"id":"d","text":"the group gives up immediately"}]'::jsonb,'"a"'::jsonb,'The passage supports “the class moved it carefully into the garden”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Seedling on the Stairs','The Seedling on the Stairs

At the school stairwell, Maya noticed a seedling growing through a crack. Other people were busy, and the easiest choice was to walk away. Instead, Maya paused, looked for useful details and decided to protect it while keeping the stairs safe. The situation mattered because a hurried response could make it worse.

First, Maya placed a bright marker beside it and asked the caretaker for advice. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Maya explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the class moved it carefully into the garden. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Maya realised that care can be practical as well as kind. The experience would be remembered not only for its result, but also for the thoughtful way the problem had been handled.

Question: Which word best describes the main character?','[{"id":"a","text":"careless"},{"id":"b","text":"selfish"},{"id":"c","text":"impatient"},{"id":"d","text":"thoughtful"}]'::jsonb,'"d"'::jsonb,'The passage supports “thoughtful”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Seedling on the Stairs','The Seedling on the Stairs

At the school stairwell, Maya noticed a seedling growing through a crack. Other people were busy, and the easiest choice was to walk away. Instead, Maya paused, looked for useful details and decided to protect it while keeping the stairs safe. The situation mattered because a hurried response could make it worse.

First, Maya placed a bright marker beside it and asked the caretaker for advice. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Maya explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the class moved it carefully into the garden. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Maya realised that care can be practical as well as kind. The experience would be remembered not only for its result, but also for the thoughtful way the problem had been handled.

Question: Why is the first attempt mentioned?','[{"id":"a","text":"It introduces a completely different story."},{"id":"b","text":"It shows that the result depended on luck."},{"id":"c","text":"It shows how the character learns and adjusts."},{"id":"d","text":"It proves that planning is useless."}]'::jsonb,'"c"'::jsonb,'The passage supports “It shows how the character learns and adjusts.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Seedling on the Stairs','The Seedling on the Stairs

At the school stairwell, Maya noticed a seedling growing through a crack. Other people were busy, and the easiest choice was to walk away. Instead, Maya paused, looked for useful details and decided to protect it while keeping the stairs safe. The situation mattered because a hurried response could make it worse.

First, Maya placed a bright marker beside it and asked the caretaker for advice. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Maya explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the class moved it carefully into the garden. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Maya realised that care can be practical as well as kind. The experience would be remembered not only for its result, but also for the thoughtful way the problem had been handled.

Question: What does “walk away” suggest in the first paragraph?','[{"id":"a","text":"move to a new home"},{"id":"b","text":"ignore the problem"},{"id":"c","text":"take a healthy walk"},{"id":"d","text":"search for a map"}]'::jsonb,'"b"'::jsonb,'The passage supports “ignore the problem”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Seedling on the Stairs','The Seedling on the Stairs

At the school stairwell, Maya noticed a seedling growing through a crack. Other people were busy, and the easiest choice was to walk away. Instead, Maya paused, looked for useful details and decided to protect it while keeping the stairs safe. The situation mattered because a hurried response could make it worse.

First, Maya placed a bright marker beside it and asked the caretaker for advice. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Maya explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the class moved it carefully into the garden. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Maya realised that care can be practical as well as kind. The experience would be remembered not only for its result, but also for the thoughtful way the problem had been handled.

Question: What lesson does the character learn?','[{"id":"a","text":"care can be practical as well as kind"},{"id":"b","text":"speed matters more than safety"},{"id":"c","text":"people should avoid all difficult tasks"},{"id":"d","text":"only adults can solve problems"}]'::jsonb,'"a"'::jsonb,'The passage supports “care can be practical as well as kind”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Seedling on the Stairs','The Seedling on the Stairs

At the school stairwell, Maya noticed a seedling growing through a crack. Other people were busy, and the easiest choice was to walk away. Instead, Maya paused, looked for useful details and decided to protect it while keeping the stairs safe. The situation mattered because a hurried response could make it worse.

First, Maya placed a bright marker beside it and asked the caretaker for advice. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Maya explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the class moved it carefully into the garden. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Maya realised that care can be practical as well as kind. The experience would be remembered not only for its result, but also for the thoughtful way the problem had been handled.

Question: Which is the best summary?','[{"id":"a","text":"A pupil wins a competition without preparing."},{"id":"b","text":"A group argues and never reaches a decision."},{"id":"c","text":"A family travels to an unfamiliar country."},{"id":"d","text":"A pupil handles a problem through observation, cooperation and adjustment."}]'::jsonb,'"d"'::jsonb,'The passage supports “A pupil handles a problem through observation, cooperation and adjustment.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','A Map in the Library','A Map in the Library

At the school library, Ethan noticed an old hand-drawn map inside a returned book. Other people were busy, and the easiest choice was to walk away. Instead, Ethan paused, looked for useful details and decided to discover who had made it. The situation mattered because a hurried response could make it worse.

First, Ethan compared the drawing with photographs in the school archive. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ethan explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, he found that a former pupil had mapped the original campus. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ethan realised that patient research can connect people across time. The experience would be remembered not only for its result, but also for the curious way the problem had been handled.

Question: Where does the story mainly take place?','[{"id":"a","text":"at a distant airport"},{"id":"b","text":"inside a television studio"},{"id":"c","text":"on an unknown island"},{"id":"d","text":"the school library"}]'::jsonb,'"d"'::jsonb,'The passage supports “the school library”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','A Map in the Library','A Map in the Library

At the school library, Ethan noticed an old hand-drawn map inside a returned book. Other people were busy, and the easiest choice was to walk away. Instead, Ethan paused, looked for useful details and decided to discover who had made it. The situation mattered because a hurried response could make it worse.

First, Ethan compared the drawing with photographs in the school archive. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ethan explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, he found that a former pupil had mapped the original campus. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ethan realised that patient research can connect people across time. The experience would be remembered not only for its result, but also for the curious way the problem had been handled.

Question: What problem does the main character notice?','[{"id":"a","text":"a lesson being cancelled"},{"id":"b","text":"a journey with no difficulty"},{"id":"c","text":"an old hand-drawn map inside a returned book"},{"id":"d","text":"a prize arriving early"}]'::jsonb,'"c"'::jsonb,'The passage supports “an old hand-drawn map inside a returned book”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','A Map in the Library','A Map in the Library

At the school library, Ethan noticed an old hand-drawn map inside a returned book. Other people were busy, and the easiest choice was to walk away. Instead, Ethan paused, looked for useful details and decided to discover who had made it. The situation mattered because a hurried response could make it worse.

First, Ethan compared the drawing with photographs in the school archive. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ethan explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, he found that a former pupil had mapped the original campus. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ethan realised that patient research can connect people across time. The experience would be remembered not only for its result, but also for the curious way the problem had been handled.

Question: What does the main character decide to do?','[{"id":"a","text":"leave without telling anyone"},{"id":"b","text":"discover who had made it"},{"id":"c","text":"wait for somebody else to act"},{"id":"d","text":"pretend nothing happened"}]'::jsonb,'"b"'::jsonb,'The passage supports “discover who had made it”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','A Map in the Library','A Map in the Library

At the school library, Ethan noticed an old hand-drawn map inside a returned book. Other people were busy, and the easiest choice was to walk away. Instead, Ethan paused, looked for useful details and decided to discover who had made it. The situation mattered because a hurried response could make it worse.

First, Ethan compared the drawing with photographs in the school archive. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ethan explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, he found that a former pupil had mapped the original campus. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ethan realised that patient research can connect people across time. The experience would be remembered not only for its result, but also for the curious way the problem had been handled.

Question: Which action helps to solve the problem?','[{"id":"a","text":"compared the drawing with photographs in the school archive"},{"id":"b","text":"hiding all the evidence"},{"id":"c","text":"repeating the same failed step"},{"id":"d","text":"blaming the nearest person"}]'::jsonb,'"a"'::jsonb,'The passage supports “compared the drawing with photographs in the school archive”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','A Map in the Library','A Map in the Library

At the school library, Ethan noticed an old hand-drawn map inside a returned book. Other people were busy, and the easiest choice was to walk away. Instead, Ethan paused, looked for useful details and decided to discover who had made it. The situation mattered because a hurried response could make it worse.

First, Ethan compared the drawing with photographs in the school archive. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ethan explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, he found that a former pupil had mapped the original campus. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ethan realised that patient research can connect people across time. The experience would be remembered not only for its result, but also for the curious way the problem had been handled.

Question: What is the final result?','[{"id":"a","text":"the problem becomes impossible"},{"id":"b","text":"nobody learns what happened"},{"id":"c","text":"the group gives up immediately"},{"id":"d","text":"he found that a former pupil had mapped the original campus"}]'::jsonb,'"d"'::jsonb,'The passage supports “he found that a former pupil had mapped the original campus”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','A Map in the Library','A Map in the Library

At the school library, Ethan noticed an old hand-drawn map inside a returned book. Other people were busy, and the easiest choice was to walk away. Instead, Ethan paused, looked for useful details and decided to discover who had made it. The situation mattered because a hurried response could make it worse.

First, Ethan compared the drawing with photographs in the school archive. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ethan explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, he found that a former pupil had mapped the original campus. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ethan realised that patient research can connect people across time. The experience would be remembered not only for its result, but also for the curious way the problem had been handled.

Question: Which word best describes the main character?','[{"id":"a","text":"selfish"},{"id":"b","text":"impatient"},{"id":"c","text":"curious"},{"id":"d","text":"careless"}]'::jsonb,'"c"'::jsonb,'The passage supports “curious”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','A Map in the Library','A Map in the Library

At the school library, Ethan noticed an old hand-drawn map inside a returned book. Other people were busy, and the easiest choice was to walk away. Instead, Ethan paused, looked for useful details and decided to discover who had made it. The situation mattered because a hurried response could make it worse.

First, Ethan compared the drawing with photographs in the school archive. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ethan explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, he found that a former pupil had mapped the original campus. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ethan realised that patient research can connect people across time. The experience would be remembered not only for its result, but also for the curious way the problem had been handled.

Question: Why is the first attempt mentioned?','[{"id":"a","text":"It shows that the result depended on luck."},{"id":"b","text":"It shows how the character learns and adjusts."},{"id":"c","text":"It proves that planning is useless."},{"id":"d","text":"It introduces a completely different story."}]'::jsonb,'"b"'::jsonb,'The passage supports “It shows how the character learns and adjusts.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','A Map in the Library','A Map in the Library

At the school library, Ethan noticed an old hand-drawn map inside a returned book. Other people were busy, and the easiest choice was to walk away. Instead, Ethan paused, looked for useful details and decided to discover who had made it. The situation mattered because a hurried response could make it worse.

First, Ethan compared the drawing with photographs in the school archive. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ethan explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, he found that a former pupil had mapped the original campus. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ethan realised that patient research can connect people across time. The experience would be remembered not only for its result, but also for the curious way the problem had been handled.

Question: What does “walk away” suggest in the first paragraph?','[{"id":"a","text":"ignore the problem"},{"id":"b","text":"take a healthy walk"},{"id":"c","text":"search for a map"},{"id":"d","text":"move to a new home"}]'::jsonb,'"a"'::jsonb,'The passage supports “ignore the problem”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','A Map in the Library','A Map in the Library

At the school library, Ethan noticed an old hand-drawn map inside a returned book. Other people were busy, and the easiest choice was to walk away. Instead, Ethan paused, looked for useful details and decided to discover who had made it. The situation mattered because a hurried response could make it worse.

First, Ethan compared the drawing with photographs in the school archive. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ethan explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, he found that a former pupil had mapped the original campus. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ethan realised that patient research can connect people across time. The experience would be remembered not only for its result, but also for the curious way the problem had been handled.

Question: What lesson does the character learn?','[{"id":"a","text":"speed matters more than safety"},{"id":"b","text":"people should avoid all difficult tasks"},{"id":"c","text":"only adults can solve problems"},{"id":"d","text":"patient research can connect people across time"}]'::jsonb,'"d"'::jsonb,'The passage supports “patient research can connect people across time”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','A Map in the Library','A Map in the Library

At the school library, Ethan noticed an old hand-drawn map inside a returned book. Other people were busy, and the easiest choice was to walk away. Instead, Ethan paused, looked for useful details and decided to discover who had made it. The situation mattered because a hurried response could make it worse.

First, Ethan compared the drawing with photographs in the school archive. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ethan explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, he found that a former pupil had mapped the original campus. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ethan realised that patient research can connect people across time. The experience would be remembered not only for its result, but also for the curious way the problem had been handled.

Question: Which is the best summary?','[{"id":"a","text":"A group argues and never reaches a decision."},{"id":"b","text":"A family travels to an unfamiliar country."},{"id":"c","text":"A pupil handles a problem through observation, cooperation and adjustment."},{"id":"d","text":"A pupil wins a competition without preparing."}]'::jsonb,'"c"'::jsonb,'The passage supports “A pupil handles a problem through observation, cooperation and adjustment.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Silent Team Captain','The Silent Team Captain

At the sports ground, Aisha noticed her team arguing before a relay. Other people were busy, and the easiest choice was to walk away. Instead, Aisha paused, looked for useful details and decided to help everyone work together. The situation mattered because a hurried response could make it worse.

First, Aisha listened to each runner before changing the order. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Aisha explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the team finished smoothly even though it did not win. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Aisha realised that good leadership begins with listening. The experience would be remembered not only for its result, but also for the calm way the problem had been handled.

Question: Where does the story mainly take place?','[{"id":"a","text":"inside a television studio"},{"id":"b","text":"on an unknown island"},{"id":"c","text":"the sports ground"},{"id":"d","text":"at a distant airport"}]'::jsonb,'"c"'::jsonb,'The passage supports “the sports ground”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Silent Team Captain','The Silent Team Captain

At the sports ground, Aisha noticed her team arguing before a relay. Other people were busy, and the easiest choice was to walk away. Instead, Aisha paused, looked for useful details and decided to help everyone work together. The situation mattered because a hurried response could make it worse.

First, Aisha listened to each runner before changing the order. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Aisha explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the team finished smoothly even though it did not win. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Aisha realised that good leadership begins with listening. The experience would be remembered not only for its result, but also for the calm way the problem had been handled.

Question: What problem does the main character notice?','[{"id":"a","text":"a journey with no difficulty"},{"id":"b","text":"her team arguing before a relay"},{"id":"c","text":"a prize arriving early"},{"id":"d","text":"a lesson being cancelled"}]'::jsonb,'"b"'::jsonb,'The passage supports “her team arguing before a relay”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Silent Team Captain','The Silent Team Captain

At the sports ground, Aisha noticed her team arguing before a relay. Other people were busy, and the easiest choice was to walk away. Instead, Aisha paused, looked for useful details and decided to help everyone work together. The situation mattered because a hurried response could make it worse.

First, Aisha listened to each runner before changing the order. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Aisha explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the team finished smoothly even though it did not win. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Aisha realised that good leadership begins with listening. The experience would be remembered not only for its result, but also for the calm way the problem had been handled.

Question: What does the main character decide to do?','[{"id":"a","text":"help everyone work together"},{"id":"b","text":"wait for somebody else to act"},{"id":"c","text":"pretend nothing happened"},{"id":"d","text":"leave without telling anyone"}]'::jsonb,'"a"'::jsonb,'The passage supports “help everyone work together”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Silent Team Captain','The Silent Team Captain

At the sports ground, Aisha noticed her team arguing before a relay. Other people were busy, and the easiest choice was to walk away. Instead, Aisha paused, looked for useful details and decided to help everyone work together. The situation mattered because a hurried response could make it worse.

First, Aisha listened to each runner before changing the order. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Aisha explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the team finished smoothly even though it did not win. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Aisha realised that good leadership begins with listening. The experience would be remembered not only for its result, but also for the calm way the problem had been handled.

Question: Which action helps to solve the problem?','[{"id":"a","text":"hiding all the evidence"},{"id":"b","text":"repeating the same failed step"},{"id":"c","text":"blaming the nearest person"},{"id":"d","text":"listened to each runner before changing the order"}]'::jsonb,'"d"'::jsonb,'The passage supports “listened to each runner before changing the order”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Silent Team Captain','The Silent Team Captain

At the sports ground, Aisha noticed her team arguing before a relay. Other people were busy, and the easiest choice was to walk away. Instead, Aisha paused, looked for useful details and decided to help everyone work together. The situation mattered because a hurried response could make it worse.

First, Aisha listened to each runner before changing the order. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Aisha explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the team finished smoothly even though it did not win. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Aisha realised that good leadership begins with listening. The experience would be remembered not only for its result, but also for the calm way the problem had been handled.

Question: What is the final result?','[{"id":"a","text":"nobody learns what happened"},{"id":"b","text":"the group gives up immediately"},{"id":"c","text":"the team finished smoothly even though it did not win"},{"id":"d","text":"the problem becomes impossible"}]'::jsonb,'"c"'::jsonb,'The passage supports “the team finished smoothly even though it did not win”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Silent Team Captain','The Silent Team Captain

At the sports ground, Aisha noticed her team arguing before a relay. Other people were busy, and the easiest choice was to walk away. Instead, Aisha paused, looked for useful details and decided to help everyone work together. The situation mattered because a hurried response could make it worse.

First, Aisha listened to each runner before changing the order. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Aisha explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the team finished smoothly even though it did not win. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Aisha realised that good leadership begins with listening. The experience would be remembered not only for its result, but also for the calm way the problem had been handled.

Question: Which word best describes the main character?','[{"id":"a","text":"impatient"},{"id":"b","text":"calm"},{"id":"c","text":"careless"},{"id":"d","text":"selfish"}]'::jsonb,'"b"'::jsonb,'The passage supports “calm”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Silent Team Captain','The Silent Team Captain

At the sports ground, Aisha noticed her team arguing before a relay. Other people were busy, and the easiest choice was to walk away. Instead, Aisha paused, looked for useful details and decided to help everyone work together. The situation mattered because a hurried response could make it worse.

First, Aisha listened to each runner before changing the order. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Aisha explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the team finished smoothly even though it did not win. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Aisha realised that good leadership begins with listening. The experience would be remembered not only for its result, but also for the calm way the problem had been handled.

Question: Why is the first attempt mentioned?','[{"id":"a","text":"It shows how the character learns and adjusts."},{"id":"b","text":"It proves that planning is useless."},{"id":"c","text":"It introduces a completely different story."},{"id":"d","text":"It shows that the result depended on luck."}]'::jsonb,'"a"'::jsonb,'The passage supports “It shows how the character learns and adjusts.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Silent Team Captain','The Silent Team Captain

At the sports ground, Aisha noticed her team arguing before a relay. Other people were busy, and the easiest choice was to walk away. Instead, Aisha paused, looked for useful details and decided to help everyone work together. The situation mattered because a hurried response could make it worse.

First, Aisha listened to each runner before changing the order. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Aisha explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the team finished smoothly even though it did not win. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Aisha realised that good leadership begins with listening. The experience would be remembered not only for its result, but also for the calm way the problem had been handled.

Question: What does “walk away” suggest in the first paragraph?','[{"id":"a","text":"take a healthy walk"},{"id":"b","text":"search for a map"},{"id":"c","text":"move to a new home"},{"id":"d","text":"ignore the problem"}]'::jsonb,'"d"'::jsonb,'The passage supports “ignore the problem”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Silent Team Captain','The Silent Team Captain

At the sports ground, Aisha noticed her team arguing before a relay. Other people were busy, and the easiest choice was to walk away. Instead, Aisha paused, looked for useful details and decided to help everyone work together. The situation mattered because a hurried response could make it worse.

First, Aisha listened to each runner before changing the order. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Aisha explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the team finished smoothly even though it did not win. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Aisha realised that good leadership begins with listening. The experience would be remembered not only for its result, but also for the calm way the problem had been handled.

Question: What lesson does the character learn?','[{"id":"a","text":"people should avoid all difficult tasks"},{"id":"b","text":"only adults can solve problems"},{"id":"c","text":"good leadership begins with listening"},{"id":"d","text":"speed matters more than safety"}]'::jsonb,'"c"'::jsonb,'The passage supports “good leadership begins with listening”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Silent Team Captain','The Silent Team Captain

At the sports ground, Aisha noticed her team arguing before a relay. Other people were busy, and the easiest choice was to walk away. Instead, Aisha paused, looked for useful details and decided to help everyone work together. The situation mattered because a hurried response could make it worse.

First, Aisha listened to each runner before changing the order. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Aisha explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the team finished smoothly even though it did not win. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Aisha realised that good leadership begins with listening. The experience would be remembered not only for its result, but also for the calm way the problem had been handled.

Question: Which is the best summary?','[{"id":"a","text":"A family travels to an unfamiliar country."},{"id":"b","text":"A pupil handles a problem through observation, cooperation and adjustment."},{"id":"c","text":"A pupil wins a competition without preparing."},{"id":"d","text":"A group argues and never reaches a decision."}]'::jsonb,'"b"'::jsonb,'The passage supports “A pupil handles a problem through observation, cooperation and adjustment.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Last Bus Home','The Last Bus Home

At a rainy bus stop, Leo noticed an elderly passenger dropping a shopping bag. Other people were busy, and the easiest choice was to walk away. Instead, Leo paused, looked for useful details and decided to help without missing the final bus. The situation mattered because a hurried response could make it worse.

First, Leo collected the rolling tins and signalled to the driver. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Leo explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the driver waited and everyone boarded safely. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Leo realised that a small delay can make a large difference. The experience would be remembered not only for its result, but also for the responsible way the problem had been handled.

Question: Where does the story mainly take place?','[{"id":"a","text":"on an unknown island"},{"id":"b","text":"a rainy bus stop"},{"id":"c","text":"at a distant airport"},{"id":"d","text":"inside a television studio"}]'::jsonb,'"b"'::jsonb,'The passage supports “a rainy bus stop”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Last Bus Home','The Last Bus Home

At a rainy bus stop, Leo noticed an elderly passenger dropping a shopping bag. Other people were busy, and the easiest choice was to walk away. Instead, Leo paused, looked for useful details and decided to help without missing the final bus. The situation mattered because a hurried response could make it worse.

First, Leo collected the rolling tins and signalled to the driver. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Leo explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the driver waited and everyone boarded safely. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Leo realised that a small delay can make a large difference. The experience would be remembered not only for its result, but also for the responsible way the problem had been handled.

Question: What problem does the main character notice?','[{"id":"a","text":"an elderly passenger dropping a shopping bag"},{"id":"b","text":"a prize arriving early"},{"id":"c","text":"a lesson being cancelled"},{"id":"d","text":"a journey with no difficulty"}]'::jsonb,'"a"'::jsonb,'The passage supports “an elderly passenger dropping a shopping bag”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Last Bus Home','The Last Bus Home

At a rainy bus stop, Leo noticed an elderly passenger dropping a shopping bag. Other people were busy, and the easiest choice was to walk away. Instead, Leo paused, looked for useful details and decided to help without missing the final bus. The situation mattered because a hurried response could make it worse.

First, Leo collected the rolling tins and signalled to the driver. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Leo explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the driver waited and everyone boarded safely. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Leo realised that a small delay can make a large difference. The experience would be remembered not only for its result, but also for the responsible way the problem had been handled.

Question: What does the main character decide to do?','[{"id":"a","text":"wait for somebody else to act"},{"id":"b","text":"pretend nothing happened"},{"id":"c","text":"leave without telling anyone"},{"id":"d","text":"help without missing the final bus"}]'::jsonb,'"d"'::jsonb,'The passage supports “help without missing the final bus”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Last Bus Home','The Last Bus Home

At a rainy bus stop, Leo noticed an elderly passenger dropping a shopping bag. Other people were busy, and the easiest choice was to walk away. Instead, Leo paused, looked for useful details and decided to help without missing the final bus. The situation mattered because a hurried response could make it worse.

First, Leo collected the rolling tins and signalled to the driver. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Leo explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the driver waited and everyone boarded safely. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Leo realised that a small delay can make a large difference. The experience would be remembered not only for its result, but also for the responsible way the problem had been handled.

Question: Which action helps to solve the problem?','[{"id":"a","text":"repeating the same failed step"},{"id":"b","text":"blaming the nearest person"},{"id":"c","text":"collected the rolling tins and signalled to the driver"},{"id":"d","text":"hiding all the evidence"}]'::jsonb,'"c"'::jsonb,'The passage supports “collected the rolling tins and signalled to the driver”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Last Bus Home','The Last Bus Home

At a rainy bus stop, Leo noticed an elderly passenger dropping a shopping bag. Other people were busy, and the easiest choice was to walk away. Instead, Leo paused, looked for useful details and decided to help without missing the final bus. The situation mattered because a hurried response could make it worse.

First, Leo collected the rolling tins and signalled to the driver. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Leo explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the driver waited and everyone boarded safely. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Leo realised that a small delay can make a large difference. The experience would be remembered not only for its result, but also for the responsible way the problem had been handled.

Question: What is the final result?','[{"id":"a","text":"the group gives up immediately"},{"id":"b","text":"the driver waited and everyone boarded safely"},{"id":"c","text":"the problem becomes impossible"},{"id":"d","text":"nobody learns what happened"}]'::jsonb,'"b"'::jsonb,'The passage supports “the driver waited and everyone boarded safely”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Last Bus Home','The Last Bus Home

At a rainy bus stop, Leo noticed an elderly passenger dropping a shopping bag. Other people were busy, and the easiest choice was to walk away. Instead, Leo paused, looked for useful details and decided to help without missing the final bus. The situation mattered because a hurried response could make it worse.

First, Leo collected the rolling tins and signalled to the driver. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Leo explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the driver waited and everyone boarded safely. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Leo realised that a small delay can make a large difference. The experience would be remembered not only for its result, but also for the responsible way the problem had been handled.

Question: Which word best describes the main character?','[{"id":"a","text":"responsible"},{"id":"b","text":"careless"},{"id":"c","text":"selfish"},{"id":"d","text":"impatient"}]'::jsonb,'"a"'::jsonb,'The passage supports “responsible”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Last Bus Home','The Last Bus Home

At a rainy bus stop, Leo noticed an elderly passenger dropping a shopping bag. Other people were busy, and the easiest choice was to walk away. Instead, Leo paused, looked for useful details and decided to help without missing the final bus. The situation mattered because a hurried response could make it worse.

First, Leo collected the rolling tins and signalled to the driver. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Leo explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the driver waited and everyone boarded safely. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Leo realised that a small delay can make a large difference. The experience would be remembered not only for its result, but also for the responsible way the problem had been handled.

Question: Why is the first attempt mentioned?','[{"id":"a","text":"It proves that planning is useless."},{"id":"b","text":"It introduces a completely different story."},{"id":"c","text":"It shows that the result depended on luck."},{"id":"d","text":"It shows how the character learns and adjusts."}]'::jsonb,'"d"'::jsonb,'The passage supports “It shows how the character learns and adjusts.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Last Bus Home','The Last Bus Home

At a rainy bus stop, Leo noticed an elderly passenger dropping a shopping bag. Other people were busy, and the easiest choice was to walk away. Instead, Leo paused, looked for useful details and decided to help without missing the final bus. The situation mattered because a hurried response could make it worse.

First, Leo collected the rolling tins and signalled to the driver. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Leo explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the driver waited and everyone boarded safely. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Leo realised that a small delay can make a large difference. The experience would be remembered not only for its result, but also for the responsible way the problem had been handled.

Question: What does “walk away” suggest in the first paragraph?','[{"id":"a","text":"search for a map"},{"id":"b","text":"move to a new home"},{"id":"c","text":"ignore the problem"},{"id":"d","text":"take a healthy walk"}]'::jsonb,'"c"'::jsonb,'The passage supports “ignore the problem”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Last Bus Home','The Last Bus Home

At a rainy bus stop, Leo noticed an elderly passenger dropping a shopping bag. Other people were busy, and the easiest choice was to walk away. Instead, Leo paused, looked for useful details and decided to help without missing the final bus. The situation mattered because a hurried response could make it worse.

First, Leo collected the rolling tins and signalled to the driver. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Leo explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the driver waited and everyone boarded safely. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Leo realised that a small delay can make a large difference. The experience would be remembered not only for its result, but also for the responsible way the problem had been handled.

Question: What lesson does the character learn?','[{"id":"a","text":"only adults can solve problems"},{"id":"b","text":"a small delay can make a large difference"},{"id":"c","text":"speed matters more than safety"},{"id":"d","text":"people should avoid all difficult tasks"}]'::jsonb,'"b"'::jsonb,'The passage supports “a small delay can make a large difference”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Last Bus Home','The Last Bus Home

At a rainy bus stop, Leo noticed an elderly passenger dropping a shopping bag. Other people were busy, and the easiest choice was to walk away. Instead, Leo paused, looked for useful details and decided to help without missing the final bus. The situation mattered because a hurried response could make it worse.

First, Leo collected the rolling tins and signalled to the driver. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Leo explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the driver waited and everyone boarded safely. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Leo realised that a small delay can make a large difference. The experience would be remembered not only for its result, but also for the responsible way the problem had been handled.

Question: Which is the best summary?','[{"id":"a","text":"A pupil handles a problem through observation, cooperation and adjustment."},{"id":"b","text":"A pupil wins a competition without preparing."},{"id":"c","text":"A group argues and never reaches a decision."},{"id":"d","text":"A family travels to an unfamiliar country."}]'::jsonb,'"a"'::jsonb,'The passage supports “A pupil handles a problem through observation, cooperation and adjustment.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Broken Model Bridge','The Broken Model Bridge

At the science room, Sofia noticed the class bridge collapsing before judging. Other people were busy, and the easiest choice was to walk away. Instead, Sofia paused, looked for useful details and decided to repair it with very little time left. The situation mattered because a hurried response could make it worse.

First, Sofia studied the weak joint instead of rebuilding everything. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Sofia explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the repaired bridge held twice the expected weight. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Sofia realised that mistakes provide useful evidence. The experience would be remembered not only for its result, but also for the determined way the problem had been handled.

Question: Where does the story mainly take place?','[{"id":"a","text":"the science room"},{"id":"b","text":"at a distant airport"},{"id":"c","text":"inside a television studio"},{"id":"d","text":"on an unknown island"}]'::jsonb,'"a"'::jsonb,'The passage supports “the science room”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Broken Model Bridge','The Broken Model Bridge

At the science room, Sofia noticed the class bridge collapsing before judging. Other people were busy, and the easiest choice was to walk away. Instead, Sofia paused, looked for useful details and decided to repair it with very little time left. The situation mattered because a hurried response could make it worse.

First, Sofia studied the weak joint instead of rebuilding everything. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Sofia explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the repaired bridge held twice the expected weight. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Sofia realised that mistakes provide useful evidence. The experience would be remembered not only for its result, but also for the determined way the problem had been handled.

Question: What problem does the main character notice?','[{"id":"a","text":"a prize arriving early"},{"id":"b","text":"a lesson being cancelled"},{"id":"c","text":"a journey with no difficulty"},{"id":"d","text":"the class bridge collapsing before judging"}]'::jsonb,'"d"'::jsonb,'The passage supports “the class bridge collapsing before judging”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Broken Model Bridge','The Broken Model Bridge

At the science room, Sofia noticed the class bridge collapsing before judging. Other people were busy, and the easiest choice was to walk away. Instead, Sofia paused, looked for useful details and decided to repair it with very little time left. The situation mattered because a hurried response could make it worse.

First, Sofia studied the weak joint instead of rebuilding everything. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Sofia explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the repaired bridge held twice the expected weight. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Sofia realised that mistakes provide useful evidence. The experience would be remembered not only for its result, but also for the determined way the problem had been handled.

Question: What does the main character decide to do?','[{"id":"a","text":"pretend nothing happened"},{"id":"b","text":"leave without telling anyone"},{"id":"c","text":"repair it with very little time left"},{"id":"d","text":"wait for somebody else to act"}]'::jsonb,'"c"'::jsonb,'The passage supports “repair it with very little time left”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Broken Model Bridge','The Broken Model Bridge

At the science room, Sofia noticed the class bridge collapsing before judging. Other people were busy, and the easiest choice was to walk away. Instead, Sofia paused, looked for useful details and decided to repair it with very little time left. The situation mattered because a hurried response could make it worse.

First, Sofia studied the weak joint instead of rebuilding everything. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Sofia explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the repaired bridge held twice the expected weight. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Sofia realised that mistakes provide useful evidence. The experience would be remembered not only for its result, but also for the determined way the problem had been handled.

Question: Which action helps to solve the problem?','[{"id":"a","text":"blaming the nearest person"},{"id":"b","text":"studied the weak joint instead of rebuilding everything"},{"id":"c","text":"hiding all the evidence"},{"id":"d","text":"repeating the same failed step"}]'::jsonb,'"b"'::jsonb,'The passage supports “studied the weak joint instead of rebuilding everything”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Broken Model Bridge','The Broken Model Bridge

At the science room, Sofia noticed the class bridge collapsing before judging. Other people were busy, and the easiest choice was to walk away. Instead, Sofia paused, looked for useful details and decided to repair it with very little time left. The situation mattered because a hurried response could make it worse.

First, Sofia studied the weak joint instead of rebuilding everything. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Sofia explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the repaired bridge held twice the expected weight. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Sofia realised that mistakes provide useful evidence. The experience would be remembered not only for its result, but also for the determined way the problem had been handled.

Question: What is the final result?','[{"id":"a","text":"the repaired bridge held twice the expected weight"},{"id":"b","text":"the problem becomes impossible"},{"id":"c","text":"nobody learns what happened"},{"id":"d","text":"the group gives up immediately"}]'::jsonb,'"a"'::jsonb,'The passage supports “the repaired bridge held twice the expected weight”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Broken Model Bridge','The Broken Model Bridge

At the science room, Sofia noticed the class bridge collapsing before judging. Other people were busy, and the easiest choice was to walk away. Instead, Sofia paused, looked for useful details and decided to repair it with very little time left. The situation mattered because a hurried response could make it worse.

First, Sofia studied the weak joint instead of rebuilding everything. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Sofia explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the repaired bridge held twice the expected weight. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Sofia realised that mistakes provide useful evidence. The experience would be remembered not only for its result, but also for the determined way the problem had been handled.

Question: Which word best describes the main character?','[{"id":"a","text":"careless"},{"id":"b","text":"selfish"},{"id":"c","text":"impatient"},{"id":"d","text":"determined"}]'::jsonb,'"d"'::jsonb,'The passage supports “determined”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Broken Model Bridge','The Broken Model Bridge

At the science room, Sofia noticed the class bridge collapsing before judging. Other people were busy, and the easiest choice was to walk away. Instead, Sofia paused, looked for useful details and decided to repair it with very little time left. The situation mattered because a hurried response could make it worse.

First, Sofia studied the weak joint instead of rebuilding everything. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Sofia explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the repaired bridge held twice the expected weight. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Sofia realised that mistakes provide useful evidence. The experience would be remembered not only for its result, but also for the determined way the problem had been handled.

Question: Why is the first attempt mentioned?','[{"id":"a","text":"It introduces a completely different story."},{"id":"b","text":"It shows that the result depended on luck."},{"id":"c","text":"It shows how the character learns and adjusts."},{"id":"d","text":"It proves that planning is useless."}]'::jsonb,'"c"'::jsonb,'The passage supports “It shows how the character learns and adjusts.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Broken Model Bridge','The Broken Model Bridge

At the science room, Sofia noticed the class bridge collapsing before judging. Other people were busy, and the easiest choice was to walk away. Instead, Sofia paused, looked for useful details and decided to repair it with very little time left. The situation mattered because a hurried response could make it worse.

First, Sofia studied the weak joint instead of rebuilding everything. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Sofia explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the repaired bridge held twice the expected weight. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Sofia realised that mistakes provide useful evidence. The experience would be remembered not only for its result, but also for the determined way the problem had been handled.

Question: What does “walk away” suggest in the first paragraph?','[{"id":"a","text":"move to a new home"},{"id":"b","text":"ignore the problem"},{"id":"c","text":"take a healthy walk"},{"id":"d","text":"search for a map"}]'::jsonb,'"b"'::jsonb,'The passage supports “ignore the problem”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Broken Model Bridge','The Broken Model Bridge

At the science room, Sofia noticed the class bridge collapsing before judging. Other people were busy, and the easiest choice was to walk away. Instead, Sofia paused, looked for useful details and decided to repair it with very little time left. The situation mattered because a hurried response could make it worse.

First, Sofia studied the weak joint instead of rebuilding everything. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Sofia explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the repaired bridge held twice the expected weight. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Sofia realised that mistakes provide useful evidence. The experience would be remembered not only for its result, but also for the determined way the problem had been handled.

Question: What lesson does the character learn?','[{"id":"a","text":"mistakes provide useful evidence"},{"id":"b","text":"speed matters more than safety"},{"id":"c","text":"people should avoid all difficult tasks"},{"id":"d","text":"only adults can solve problems"}]'::jsonb,'"a"'::jsonb,'The passage supports “mistakes provide useful evidence”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Broken Model Bridge','The Broken Model Bridge

At the science room, Sofia noticed the class bridge collapsing before judging. Other people were busy, and the easiest choice was to walk away. Instead, Sofia paused, looked for useful details and decided to repair it with very little time left. The situation mattered because a hurried response could make it worse.

First, Sofia studied the weak joint instead of rebuilding everything. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Sofia explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the repaired bridge held twice the expected weight. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Sofia realised that mistakes provide useful evidence. The experience would be remembered not only for its result, but also for the determined way the problem had been handled.

Question: Which is the best summary?','[{"id":"a","text":"A pupil wins a competition without preparing."},{"id":"b","text":"A group argues and never reaches a decision."},{"id":"c","text":"A family travels to an unfamiliar country."},{"id":"d","text":"A pupil handles a problem through observation, cooperation and adjustment."}]'::jsonb,'"d"'::jsonb,'The passage supports “A pupil handles a problem through observation, cooperation and adjustment.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','Music from the Courtyard','Music from the Courtyard

At the community centre, Noah noticed a nervous child practising violin alone. Other people were busy, and the easiest choice was to walk away. Instead, Noah paused, looked for useful details and decided to encourage the child without causing embarrassment. The situation mattered because a hurried response could make it worse.

First, Noah sat nearby and quietly tapped the rhythm. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Noah explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the child completed the tune and joined the concert. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Noah realised that support does not always require many words. The experience would be remembered not only for its result, but also for the gentle way the problem had been handled.

Question: Where does the story mainly take place?','[{"id":"a","text":"at a distant airport"},{"id":"b","text":"inside a television studio"},{"id":"c","text":"on an unknown island"},{"id":"d","text":"the community centre"}]'::jsonb,'"d"'::jsonb,'The passage supports “the community centre”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','Music from the Courtyard','Music from the Courtyard

At the community centre, Noah noticed a nervous child practising violin alone. Other people were busy, and the easiest choice was to walk away. Instead, Noah paused, looked for useful details and decided to encourage the child without causing embarrassment. The situation mattered because a hurried response could make it worse.

First, Noah sat nearby and quietly tapped the rhythm. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Noah explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the child completed the tune and joined the concert. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Noah realised that support does not always require many words. The experience would be remembered not only for its result, but also for the gentle way the problem had been handled.

Question: What problem does the main character notice?','[{"id":"a","text":"a lesson being cancelled"},{"id":"b","text":"a journey with no difficulty"},{"id":"c","text":"a nervous child practising violin alone"},{"id":"d","text":"a prize arriving early"}]'::jsonb,'"c"'::jsonb,'The passage supports “a nervous child practising violin alone”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','Music from the Courtyard','Music from the Courtyard

At the community centre, Noah noticed a nervous child practising violin alone. Other people were busy, and the easiest choice was to walk away. Instead, Noah paused, looked for useful details and decided to encourage the child without causing embarrassment. The situation mattered because a hurried response could make it worse.

First, Noah sat nearby and quietly tapped the rhythm. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Noah explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the child completed the tune and joined the concert. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Noah realised that support does not always require many words. The experience would be remembered not only for its result, but also for the gentle way the problem had been handled.

Question: What does the main character decide to do?','[{"id":"a","text":"leave without telling anyone"},{"id":"b","text":"encourage the child without causing embarrassment"},{"id":"c","text":"wait for somebody else to act"},{"id":"d","text":"pretend nothing happened"}]'::jsonb,'"b"'::jsonb,'The passage supports “encourage the child without causing embarrassment”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','Music from the Courtyard','Music from the Courtyard

At the community centre, Noah noticed a nervous child practising violin alone. Other people were busy, and the easiest choice was to walk away. Instead, Noah paused, looked for useful details and decided to encourage the child without causing embarrassment. The situation mattered because a hurried response could make it worse.

First, Noah sat nearby and quietly tapped the rhythm. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Noah explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the child completed the tune and joined the concert. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Noah realised that support does not always require many words. The experience would be remembered not only for its result, but also for the gentle way the problem had been handled.

Question: Which action helps to solve the problem?','[{"id":"a","text":"sat nearby and quietly tapped the rhythm"},{"id":"b","text":"hiding all the evidence"},{"id":"c","text":"repeating the same failed step"},{"id":"d","text":"blaming the nearest person"}]'::jsonb,'"a"'::jsonb,'The passage supports “sat nearby and quietly tapped the rhythm”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','Music from the Courtyard','Music from the Courtyard

At the community centre, Noah noticed a nervous child practising violin alone. Other people were busy, and the easiest choice was to walk away. Instead, Noah paused, looked for useful details and decided to encourage the child without causing embarrassment. The situation mattered because a hurried response could make it worse.

First, Noah sat nearby and quietly tapped the rhythm. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Noah explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the child completed the tune and joined the concert. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Noah realised that support does not always require many words. The experience would be remembered not only for its result, but also for the gentle way the problem had been handled.

Question: What is the final result?','[{"id":"a","text":"the problem becomes impossible"},{"id":"b","text":"nobody learns what happened"},{"id":"c","text":"the group gives up immediately"},{"id":"d","text":"the child completed the tune and joined the concert"}]'::jsonb,'"d"'::jsonb,'The passage supports “the child completed the tune and joined the concert”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','Music from the Courtyard','Music from the Courtyard

At the community centre, Noah noticed a nervous child practising violin alone. Other people were busy, and the easiest choice was to walk away. Instead, Noah paused, looked for useful details and decided to encourage the child without causing embarrassment. The situation mattered because a hurried response could make it worse.

First, Noah sat nearby and quietly tapped the rhythm. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Noah explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the child completed the tune and joined the concert. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Noah realised that support does not always require many words. The experience would be remembered not only for its result, but also for the gentle way the problem had been handled.

Question: Which word best describes the main character?','[{"id":"a","text":"selfish"},{"id":"b","text":"impatient"},{"id":"c","text":"gentle"},{"id":"d","text":"careless"}]'::jsonb,'"c"'::jsonb,'The passage supports “gentle”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','Music from the Courtyard','Music from the Courtyard

At the community centre, Noah noticed a nervous child practising violin alone. Other people were busy, and the easiest choice was to walk away. Instead, Noah paused, looked for useful details and decided to encourage the child without causing embarrassment. The situation mattered because a hurried response could make it worse.

First, Noah sat nearby and quietly tapped the rhythm. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Noah explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the child completed the tune and joined the concert. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Noah realised that support does not always require many words. The experience would be remembered not only for its result, but also for the gentle way the problem had been handled.

Question: Why is the first attempt mentioned?','[{"id":"a","text":"It shows that the result depended on luck."},{"id":"b","text":"It shows how the character learns and adjusts."},{"id":"c","text":"It proves that planning is useless."},{"id":"d","text":"It introduces a completely different story."}]'::jsonb,'"b"'::jsonb,'The passage supports “It shows how the character learns and adjusts.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','Music from the Courtyard','Music from the Courtyard

At the community centre, Noah noticed a nervous child practising violin alone. Other people were busy, and the easiest choice was to walk away. Instead, Noah paused, looked for useful details and decided to encourage the child without causing embarrassment. The situation mattered because a hurried response could make it worse.

First, Noah sat nearby and quietly tapped the rhythm. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Noah explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the child completed the tune and joined the concert. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Noah realised that support does not always require many words. The experience would be remembered not only for its result, but also for the gentle way the problem had been handled.

Question: What does “walk away” suggest in the first paragraph?','[{"id":"a","text":"ignore the problem"},{"id":"b","text":"take a healthy walk"},{"id":"c","text":"search for a map"},{"id":"d","text":"move to a new home"}]'::jsonb,'"a"'::jsonb,'The passage supports “ignore the problem”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','Music from the Courtyard','Music from the Courtyard

At the community centre, Noah noticed a nervous child practising violin alone. Other people were busy, and the easiest choice was to walk away. Instead, Noah paused, looked for useful details and decided to encourage the child without causing embarrassment. The situation mattered because a hurried response could make it worse.

First, Noah sat nearby and quietly tapped the rhythm. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Noah explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the child completed the tune and joined the concert. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Noah realised that support does not always require many words. The experience would be remembered not only for its result, but also for the gentle way the problem had been handled.

Question: What lesson does the character learn?','[{"id":"a","text":"speed matters more than safety"},{"id":"b","text":"people should avoid all difficult tasks"},{"id":"c","text":"only adults can solve problems"},{"id":"d","text":"support does not always require many words"}]'::jsonb,'"d"'::jsonb,'The passage supports “support does not always require many words”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','Music from the Courtyard','Music from the Courtyard

At the community centre, Noah noticed a nervous child practising violin alone. Other people were busy, and the easiest choice was to walk away. Instead, Noah paused, looked for useful details and decided to encourage the child without causing embarrassment. The situation mattered because a hurried response could make it worse.

First, Noah sat nearby and quietly tapped the rhythm. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Noah explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the child completed the tune and joined the concert. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Noah realised that support does not always require many words. The experience would be remembered not only for its result, but also for the gentle way the problem had been handled.

Question: Which is the best summary?','[{"id":"a","text":"A group argues and never reaches a decision."},{"id":"b","text":"A family travels to an unfamiliar country."},{"id":"c","text":"A pupil handles a problem through observation, cooperation and adjustment."},{"id":"d","text":"A pupil wins a competition without preparing."}]'::jsonb,'"c"'::jsonb,'The passage supports “A pupil handles a problem through observation, cooperation and adjustment.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Missing Recipe Page','The Missing Recipe Page

At her grandmother’s kitchen, Ruby noticed a favourite recipe with one page missing. Other people were busy, and the easiest choice was to walk away. Instead, Ruby paused, looked for useful details and decided to prepare the dish for a family gathering. The situation mattered because a hurried response could make it worse.

First, Ruby used smell, texture and her grandmother’s clues to test small batches. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ruby explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the family recognised the dish although it was slightly different. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ruby realised that traditions can survive through understanding, not exact copying. The experience would be remembered not only for its result, but also for the resourceful way the problem had been handled.

Question: Where does the story mainly take place?','[{"id":"a","text":"inside a television studio"},{"id":"b","text":"on an unknown island"},{"id":"c","text":"her grandmother’s kitchen"},{"id":"d","text":"at a distant airport"}]'::jsonb,'"c"'::jsonb,'The passage supports “her grandmother’s kitchen”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Missing Recipe Page','The Missing Recipe Page

At her grandmother’s kitchen, Ruby noticed a favourite recipe with one page missing. Other people were busy, and the easiest choice was to walk away. Instead, Ruby paused, looked for useful details and decided to prepare the dish for a family gathering. The situation mattered because a hurried response could make it worse.

First, Ruby used smell, texture and her grandmother’s clues to test small batches. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ruby explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the family recognised the dish although it was slightly different. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ruby realised that traditions can survive through understanding, not exact copying. The experience would be remembered not only for its result, but also for the resourceful way the problem had been handled.

Question: What problem does the main character notice?','[{"id":"a","text":"a journey with no difficulty"},{"id":"b","text":"a favourite recipe with one page missing"},{"id":"c","text":"a prize arriving early"},{"id":"d","text":"a lesson being cancelled"}]'::jsonb,'"b"'::jsonb,'The passage supports “a favourite recipe with one page missing”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Missing Recipe Page','The Missing Recipe Page

At her grandmother’s kitchen, Ruby noticed a favourite recipe with one page missing. Other people were busy, and the easiest choice was to walk away. Instead, Ruby paused, looked for useful details and decided to prepare the dish for a family gathering. The situation mattered because a hurried response could make it worse.

First, Ruby used smell, texture and her grandmother’s clues to test small batches. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ruby explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the family recognised the dish although it was slightly different. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ruby realised that traditions can survive through understanding, not exact copying. The experience would be remembered not only for its result, but also for the resourceful way the problem had been handled.

Question: What does the main character decide to do?','[{"id":"a","text":"prepare the dish for a family gathering"},{"id":"b","text":"wait for somebody else to act"},{"id":"c","text":"pretend nothing happened"},{"id":"d","text":"leave without telling anyone"}]'::jsonb,'"a"'::jsonb,'The passage supports “prepare the dish for a family gathering”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Missing Recipe Page','The Missing Recipe Page

At her grandmother’s kitchen, Ruby noticed a favourite recipe with one page missing. Other people were busy, and the easiest choice was to walk away. Instead, Ruby paused, looked for useful details and decided to prepare the dish for a family gathering. The situation mattered because a hurried response could make it worse.

First, Ruby used smell, texture and her grandmother’s clues to test small batches. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ruby explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the family recognised the dish although it was slightly different. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ruby realised that traditions can survive through understanding, not exact copying. The experience would be remembered not only for its result, but also for the resourceful way the problem had been handled.

Question: Which action helps to solve the problem?','[{"id":"a","text":"hiding all the evidence"},{"id":"b","text":"repeating the same failed step"},{"id":"c","text":"blaming the nearest person"},{"id":"d","text":"used smell, texture and her grandmother’s clues to test small batches"}]'::jsonb,'"d"'::jsonb,'The passage supports “used smell, texture and her grandmother’s clues to test small batches”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Missing Recipe Page','The Missing Recipe Page

At her grandmother’s kitchen, Ruby noticed a favourite recipe with one page missing. Other people were busy, and the easiest choice was to walk away. Instead, Ruby paused, looked for useful details and decided to prepare the dish for a family gathering. The situation mattered because a hurried response could make it worse.

First, Ruby used smell, texture and her grandmother’s clues to test small batches. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ruby explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the family recognised the dish although it was slightly different. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ruby realised that traditions can survive through understanding, not exact copying. The experience would be remembered not only for its result, but also for the resourceful way the problem had been handled.

Question: What is the final result?','[{"id":"a","text":"nobody learns what happened"},{"id":"b","text":"the group gives up immediately"},{"id":"c","text":"the family recognised the dish although it was slightly different"},{"id":"d","text":"the problem becomes impossible"}]'::jsonb,'"c"'::jsonb,'The passage supports “the family recognised the dish although it was slightly different”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Missing Recipe Page','The Missing Recipe Page

At her grandmother’s kitchen, Ruby noticed a favourite recipe with one page missing. Other people were busy, and the easiest choice was to walk away. Instead, Ruby paused, looked for useful details and decided to prepare the dish for a family gathering. The situation mattered because a hurried response could make it worse.

First, Ruby used smell, texture and her grandmother’s clues to test small batches. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ruby explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the family recognised the dish although it was slightly different. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ruby realised that traditions can survive through understanding, not exact copying. The experience would be remembered not only for its result, but also for the resourceful way the problem had been handled.

Question: Which word best describes the main character?','[{"id":"a","text":"impatient"},{"id":"b","text":"resourceful"},{"id":"c","text":"careless"},{"id":"d","text":"selfish"}]'::jsonb,'"b"'::jsonb,'The passage supports “resourceful”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Missing Recipe Page','The Missing Recipe Page

At her grandmother’s kitchen, Ruby noticed a favourite recipe with one page missing. Other people were busy, and the easiest choice was to walk away. Instead, Ruby paused, looked for useful details and decided to prepare the dish for a family gathering. The situation mattered because a hurried response could make it worse.

First, Ruby used smell, texture and her grandmother’s clues to test small batches. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ruby explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the family recognised the dish although it was slightly different. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ruby realised that traditions can survive through understanding, not exact copying. The experience would be remembered not only for its result, but also for the resourceful way the problem had been handled.

Question: Why is the first attempt mentioned?','[{"id":"a","text":"It shows how the character learns and adjusts."},{"id":"b","text":"It proves that planning is useless."},{"id":"c","text":"It introduces a completely different story."},{"id":"d","text":"It shows that the result depended on luck."}]'::jsonb,'"a"'::jsonb,'The passage supports “It shows how the character learns and adjusts.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','The Missing Recipe Page','The Missing Recipe Page

At her grandmother’s kitchen, Ruby noticed a favourite recipe with one page missing. Other people were busy, and the easiest choice was to walk away. Instead, Ruby paused, looked for useful details and decided to prepare the dish for a family gathering. The situation mattered because a hurried response could make it worse.

First, Ruby used smell, texture and her grandmother’s clues to test small batches. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ruby explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the family recognised the dish although it was slightly different. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ruby realised that traditions can survive through understanding, not exact copying. The experience would be remembered not only for its result, but also for the resourceful way the problem had been handled.

Question: What does “walk away” suggest in the first paragraph?','[{"id":"a","text":"take a healthy walk"},{"id":"b","text":"search for a map"},{"id":"c","text":"move to a new home"},{"id":"d","text":"ignore the problem"}]'::jsonb,'"d"'::jsonb,'The passage supports “ignore the problem”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','The Missing Recipe Page','The Missing Recipe Page

At her grandmother’s kitchen, Ruby noticed a favourite recipe with one page missing. Other people were busy, and the easiest choice was to walk away. Instead, Ruby paused, looked for useful details and decided to prepare the dish for a family gathering. The situation mattered because a hurried response could make it worse.

First, Ruby used smell, texture and her grandmother’s clues to test small batches. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ruby explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the family recognised the dish although it was slightly different. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ruby realised that traditions can survive through understanding, not exact copying. The experience would be remembered not only for its result, but also for the resourceful way the problem had been handled.

Question: What lesson does the character learn?','[{"id":"a","text":"people should avoid all difficult tasks"},{"id":"b","text":"only adults can solve problems"},{"id":"c","text":"traditions can survive through understanding, not exact copying"},{"id":"d","text":"speed matters more than safety"}]'::jsonb,'"c"'::jsonb,'The passage supports “traditions can survive through understanding, not exact copying”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','The Missing Recipe Page','The Missing Recipe Page

At her grandmother’s kitchen, Ruby noticed a favourite recipe with one page missing. Other people were busy, and the easiest choice was to walk away. Instead, Ruby paused, looked for useful details and decided to prepare the dish for a family gathering. The situation mattered because a hurried response could make it worse.

First, Ruby used smell, texture and her grandmother’s clues to test small batches. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Ruby explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the family recognised the dish although it was slightly different. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Ruby realised that traditions can survive through understanding, not exact copying. The experience would be remembered not only for its result, but also for the resourceful way the problem had been handled.

Question: Which is the best summary?','[{"id":"a","text":"A family travels to an unfamiliar country."},{"id":"b","text":"A pupil handles a problem through observation, cooperation and adjustment."},{"id":"c","text":"A pupil wins a competition without preparing."},{"id":"d","text":"A group argues and never reaches a decision."}]'::jsonb,'"b"'::jsonb,'The passage supports “A pupil handles a problem through observation, cooperation and adjustment.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','Lights across the Harbour','Lights across the Harbour

At the waterfront, Daniel noticed a sudden power cut during a class visit. Other people were busy, and the easiest choice was to walk away. Instead, Daniel paused, looked for useful details and decided to keep younger pupils calm. The situation mattered because a hurried response could make it worse.

First, Daniel turned the wait into a game of identifying safe harbour lights. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Daniel explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the group returned safely when power was restored. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Daniel realised that knowledge can turn fear into confidence. The experience would be remembered not only for its result, but also for the reassuring way the problem had been handled.

Question: Where does the story mainly take place?','[{"id":"a","text":"on an unknown island"},{"id":"b","text":"the waterfront"},{"id":"c","text":"at a distant airport"},{"id":"d","text":"inside a television studio"}]'::jsonb,'"b"'::jsonb,'The passage supports “the waterfront”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','Lights across the Harbour','Lights across the Harbour

At the waterfront, Daniel noticed a sudden power cut during a class visit. Other people were busy, and the easiest choice was to walk away. Instead, Daniel paused, looked for useful details and decided to keep younger pupils calm. The situation mattered because a hurried response could make it worse.

First, Daniel turned the wait into a game of identifying safe harbour lights. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Daniel explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the group returned safely when power was restored. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Daniel realised that knowledge can turn fear into confidence. The experience would be remembered not only for its result, but also for the reassuring way the problem had been handled.

Question: What problem does the main character notice?','[{"id":"a","text":"a sudden power cut during a class visit"},{"id":"b","text":"a prize arriving early"},{"id":"c","text":"a lesson being cancelled"},{"id":"d","text":"a journey with no difficulty"}]'::jsonb,'"a"'::jsonb,'The passage supports “a sudden power cut during a class visit”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','Lights across the Harbour','Lights across the Harbour

At the waterfront, Daniel noticed a sudden power cut during a class visit. Other people were busy, and the easiest choice was to walk away. Instead, Daniel paused, looked for useful details and decided to keep younger pupils calm. The situation mattered because a hurried response could make it worse.

First, Daniel turned the wait into a game of identifying safe harbour lights. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Daniel explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the group returned safely when power was restored. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Daniel realised that knowledge can turn fear into confidence. The experience would be remembered not only for its result, but also for the reassuring way the problem had been handled.

Question: What does the main character decide to do?','[{"id":"a","text":"wait for somebody else to act"},{"id":"b","text":"pretend nothing happened"},{"id":"c","text":"leave without telling anyone"},{"id":"d","text":"keep younger pupils calm"}]'::jsonb,'"d"'::jsonb,'The passage supports “keep younger pupils calm”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','Lights across the Harbour','Lights across the Harbour

At the waterfront, Daniel noticed a sudden power cut during a class visit. Other people were busy, and the easiest choice was to walk away. Instead, Daniel paused, looked for useful details and decided to keep younger pupils calm. The situation mattered because a hurried response could make it worse.

First, Daniel turned the wait into a game of identifying safe harbour lights. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Daniel explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the group returned safely when power was restored. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Daniel realised that knowledge can turn fear into confidence. The experience would be remembered not only for its result, but also for the reassuring way the problem had been handled.

Question: Which action helps to solve the problem?','[{"id":"a","text":"repeating the same failed step"},{"id":"b","text":"blaming the nearest person"},{"id":"c","text":"turned the wait into a game of identifying safe harbour lights"},{"id":"d","text":"hiding all the evidence"}]'::jsonb,'"c"'::jsonb,'The passage supports “turned the wait into a game of identifying safe harbour lights”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','Lights across the Harbour','Lights across the Harbour

At the waterfront, Daniel noticed a sudden power cut during a class visit. Other people were busy, and the easiest choice was to walk away. Instead, Daniel paused, looked for useful details and decided to keep younger pupils calm. The situation mattered because a hurried response could make it worse.

First, Daniel turned the wait into a game of identifying safe harbour lights. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Daniel explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the group returned safely when power was restored. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Daniel realised that knowledge can turn fear into confidence. The experience would be remembered not only for its result, but also for the reassuring way the problem had been handled.

Question: What is the final result?','[{"id":"a","text":"the group gives up immediately"},{"id":"b","text":"the group returned safely when power was restored"},{"id":"c","text":"the problem becomes impossible"},{"id":"d","text":"nobody learns what happened"}]'::jsonb,'"b"'::jsonb,'The passage supports “the group returned safely when power was restored”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','Lights across the Harbour','Lights across the Harbour

At the waterfront, Daniel noticed a sudden power cut during a class visit. Other people were busy, and the easiest choice was to walk away. Instead, Daniel paused, looked for useful details and decided to keep younger pupils calm. The situation mattered because a hurried response could make it worse.

First, Daniel turned the wait into a game of identifying safe harbour lights. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Daniel explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the group returned safely when power was restored. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Daniel realised that knowledge can turn fear into confidence. The experience would be remembered not only for its result, but also for the reassuring way the problem had been handled.

Question: Which word best describes the main character?','[{"id":"a","text":"reassuring"},{"id":"b","text":"careless"},{"id":"c","text":"selfish"},{"id":"d","text":"impatient"}]'::jsonb,'"a"'::jsonb,'The passage supports “reassuring”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','Lights across the Harbour','Lights across the Harbour

At the waterfront, Daniel noticed a sudden power cut during a class visit. Other people were busy, and the easiest choice was to walk away. Instead, Daniel paused, looked for useful details and decided to keep younger pupils calm. The situation mattered because a hurried response could make it worse.

First, Daniel turned the wait into a game of identifying safe harbour lights. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Daniel explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the group returned safely when power was restored. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Daniel realised that knowledge can turn fear into confidence. The experience would be remembered not only for its result, but also for the reassuring way the problem had been handled.

Question: Why is the first attempt mentioned?','[{"id":"a","text":"It proves that planning is useless."},{"id":"b","text":"It introduces a completely different story."},{"id":"c","text":"It shows that the result depended on luck."},{"id":"d","text":"It shows how the character learns and adjusts."}]'::jsonb,'"d"'::jsonb,'The passage supports “It shows how the character learns and adjusts.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER1','Lights across the Harbour','Lights across the Harbour

At the waterfront, Daniel noticed a sudden power cut during a class visit. Other people were busy, and the easiest choice was to walk away. Instead, Daniel paused, looked for useful details and decided to keep younger pupils calm. The situation mattered because a hurried response could make it worse.

First, Daniel turned the wait into a game of identifying safe harbour lights. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Daniel explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the group returned safely when power was restored. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Daniel realised that knowledge can turn fear into confidence. The experience would be remembered not only for its result, but also for the reassuring way the problem had been handled.

Question: What does “walk away” suggest in the first paragraph?','[{"id":"a","text":"search for a map"},{"id":"b","text":"move to a new home"},{"id":"c","text":"ignore the problem"},{"id":"d","text":"take a healthy walk"}]'::jsonb,'"c"'::jsonb,'The passage supports “ignore the problem”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER1','Lights across the Harbour','Lights across the Harbour

At the waterfront, Daniel noticed a sudden power cut during a class visit. Other people were busy, and the easiest choice was to walk away. Instead, Daniel paused, looked for useful details and decided to keep younger pupils calm. The situation mattered because a hurried response could make it worse.

First, Daniel turned the wait into a game of identifying safe harbour lights. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Daniel explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the group returned safely when power was restored. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Daniel realised that knowledge can turn fear into confidence. The experience would be remembered not only for its result, but also for the reassuring way the problem had been handled.

Question: What lesson does the character learn?','[{"id":"a","text":"only adults can solve problems"},{"id":"b","text":"knowledge can turn fear into confidence"},{"id":"c","text":"speed matters more than safety"},{"id":"d","text":"people should avoid all difficult tasks"}]'::jsonb,'"b"'::jsonb,'The passage supports “knowledge can turn fear into confidence”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER1','Lights across the Harbour','Lights across the Harbour

At the waterfront, Daniel noticed a sudden power cut during a class visit. Other people were busy, and the easiest choice was to walk away. Instead, Daniel paused, looked for useful details and decided to keep younger pupils calm. The situation mattered because a hurried response could make it worse.

First, Daniel turned the wait into a game of identifying safe harbour lights. The first attempt was not perfect, but it revealed what needed to change. Rather than hiding the difficulty, Daniel explained it clearly and invited others to help. Each person took one manageable task, and they checked one another’s work.

In the end, the group returned safely when power was restored. The success did not come from luck or from one dramatic action. It grew from careful observation, cooperation and a willingness to adjust the plan. People who had first watched from a distance began to take part.

On the way home, Daniel realised that knowledge can turn fear into confidence. The experience would be remembered not only for its result, but also for the reassuring way the problem had been handled.

Question: Which is the best summary?','[{"id":"a","text":"A pupil handles a problem through observation, cooperation and adjustment."},{"id":"b","text":"A pupil wins a competition without preparing."},{"id":"c","text":"A group argues and never reaches a decision."},{"id":"d","text":"A family travels to an unfamiliar country."}]'::jsonb,'"a"'::jsonb,'The passage supports “A pupil handles a problem through observation, cooperation and adjustment.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','Why City Trees Matter','Why City Trees Matter

City trees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

They cool streets by providing shade and releasing water vapour. Their roots slow rainwater and their leaves trap some dust. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Young trees need suitable soil, water and protection. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Planting the right tree in the right place brings lasting benefits. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the passage mainly about?','[{"id":"a","text":"city trees"},{"id":"b","text":"a fictional treasure hunt"},{"id":"c","text":"a famous person’s childhood"},{"id":"d","text":"instructions for a board game"}]'::jsonb,'"a"'::jsonb,'The passage supports “city trees”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','Why City Trees Matter','Why City Trees Matter

City trees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

They cool streets by providing shade and releasing water vapour. Their roots slow rainwater and their leaves trap some dust. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Young trees need suitable soil, water and protection. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Planting the right tree in the right place brings lasting benefits. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which benefit or process is stated first?','[{"id":"a","text":"It works without any conditions."},{"id":"b","text":"It has no effect on people or nature."},{"id":"c","text":"It was invented only last year."},{"id":"d","text":"They cool streets by providing shade and releasing water vapour."}]'::jsonb,'"d"'::jsonb,'The passage supports “They cool streets by providing shade and releasing water vapour.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','Why City Trees Matter','Why City Trees Matter

City trees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

They cool streets by providing shade and releasing water vapour. Their roots slow rainwater and their leaves trap some dust. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Young trees need suitable soil, water and protection. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Planting the right tree in the right place brings lasting benefits. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What additional detail does the passage give?','[{"id":"a","text":"No observations are ever needed."},{"id":"b","text":"The process stops after one day."},{"id":"c","text":"Their roots slow rainwater and their leaves trap some dust."},{"id":"d","text":"All examples produce identical results."}]'::jsonb,'"c"'::jsonb,'The passage supports “Their roots slow rainwater and their leaves trap some dust.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','Why City Trees Matter','Why City Trees Matter

City trees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

They cool streets by providing shade and releasing water vapour. Their roots slow rainwater and their leaves trap some dust. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Young trees need suitable soil, water and protection. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Planting the right tree in the right place brings lasting benefits. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What challenge is mentioned?','[{"id":"a","text":"Every place has exactly the same conditions."},{"id":"b","text":"Young trees need suitable soil, water and protection."},{"id":"c","text":"There are no limits at all."},{"id":"d","text":"The subject cannot be studied."}]'::jsonb,'"b"'::jsonb,'The passage supports “Young trees need suitable soil, water and protection.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','Why City Trees Matter','Why City Trees Matter

City trees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

They cool streets by providing shade and releasing water vapour. Their roots slow rainwater and their leaves trap some dust. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Young trees need suitable soil, water and protection. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Planting the right tree in the right place brings lasting benefits. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What conclusion does the writer reach?','[{"id":"a","text":"Planting the right tree in the right place brings lasting benefits."},{"id":"b","text":"The topic should be ignored."},{"id":"c","text":"One quick action solves every problem."},{"id":"d","text":"Maintenance is never necessary."}]'::jsonb,'"a"'::jsonb,'The passage supports “Planting the right tree in the right place brings lasting benefits.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','Why City Trees Matter','Why City Trees Matter

City trees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

They cool streets by providing shade and releasing water vapour. Their roots slow rainwater and their leaves trap some dust. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Young trees need suitable soil, water and protection. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Planting the right tree in the right place brings lasting benefits. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Why do people collect observations over time?','[{"id":"a","text":"They want to avoid using evidence."},{"id":"b","text":"The topic exists only at night."},{"id":"c","text":"Older observations are always wrong."},{"id":"d","text":"Conditions can change."}]'::jsonb,'"d"'::jsonb,'The passage supports “Conditions can change.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','Why City Trees Matter','Why City Trees Matter

City trees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

They cool streets by providing shade and releasing water vapour. Their roots slow rainwater and their leaves trap some dust. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Young trees need suitable soil, water and protection. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Planting the right tree in the right place brings lasting benefits. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What does “incomplete picture” mean?','[{"id":"a","text":"a drawing that uses pale colours"},{"id":"b","text":"a picture stored on a computer"},{"id":"c","text":"an understanding that is missing important information"},{"id":"d","text":"a photograph with a torn corner"}]'::jsonb,'"c"'::jsonb,'The passage supports “an understanding that is missing important information”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','Why City Trees Matter','Why City Trees Matter

City trees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

They cool streets by providing shade and releasing water vapour. Their roots slow rainwater and their leaves trap some dust. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Young trees need suitable soil, water and protection. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Planting the right tree in the right place brings lasting benefits. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which text feature would best support this passage?','[{"id":"a","text":"a list of unrelated jokes"},{"id":"b","text":"a labelled diagram showing the connected process"},{"id":"c","text":"a menu of imaginary meals"},{"id":"d","text":"a map of fictional kingdoms"}]'::jsonb,'"b"'::jsonb,'The passage supports “a labelled diagram showing the connected process”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','Why City Trees Matter','Why City Trees Matter

City trees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

They cool streets by providing shade and releasing water vapour. Their roots slow rainwater and their leaves trap some dust. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Young trees need suitable soil, water and protection. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Planting the right tree in the right place brings lasting benefits. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the author’s main purpose?','[{"id":"a","text":"to explain how the topic works and why it matters"},{"id":"b","text":"to entertain with a mystery story"},{"id":"c","text":"to advertise an expensive product"},{"id":"d","text":"to argue that evidence is unnecessary"}]'::jsonb,'"a"'::jsonb,'The passage supports “to explain how the topic works and why it matters”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','Why City Trees Matter','Why City Trees Matter

City trees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

They cool streets by providing shade and releasing water vapour. Their roots slow rainwater and their leaves trap some dust. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Young trees need suitable soil, water and protection. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Planting the right tree in the right place brings lasting benefits. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which statement can be inferred?','[{"id":"a","text":"Every solution works everywhere."},{"id":"b","text":"Challenges mean people should never try."},{"id":"c","text":"Only scientists can make responsible choices."},{"id":"d","text":"Good results require planning and continued care."}]'::jsonb,'"d"'::jsonb,'The passage supports “Good results require planning and continued care.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','How Bees Share Directions','How Bees Share Directions

Honeybees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

A worker bee uses movement to show where food can be found. The angle of its dance relates to the Sun, while the duration suggests distance. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Clouds and changing light make the task more difficult. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

The dance helps many bees use one scout’s discovery. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the passage mainly about?','[{"id":"a","text":"a fictional treasure hunt"},{"id":"b","text":"a famous person’s childhood"},{"id":"c","text":"instructions for a board game"},{"id":"d","text":"honeybees"}]'::jsonb,'"d"'::jsonb,'The passage supports “honeybees”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','How Bees Share Directions','How Bees Share Directions

Honeybees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

A worker bee uses movement to show where food can be found. The angle of its dance relates to the Sun, while the duration suggests distance. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Clouds and changing light make the task more difficult. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

The dance helps many bees use one scout’s discovery. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which benefit or process is stated first?','[{"id":"a","text":"It has no effect on people or nature."},{"id":"b","text":"It was invented only last year."},{"id":"c","text":"A worker bee uses movement to show where food can be found."},{"id":"d","text":"It works without any conditions."}]'::jsonb,'"c"'::jsonb,'The passage supports “A worker bee uses movement to show where food can be found.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','How Bees Share Directions','How Bees Share Directions

Honeybees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

A worker bee uses movement to show where food can be found. The angle of its dance relates to the Sun, while the duration suggests distance. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Clouds and changing light make the task more difficult. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

The dance helps many bees use one scout’s discovery. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What additional detail does the passage give?','[{"id":"a","text":"The process stops after one day."},{"id":"b","text":"The angle of its dance relates to the Sun, while the duration suggests distance."},{"id":"c","text":"All examples produce identical results."},{"id":"d","text":"No observations are ever needed."}]'::jsonb,'"b"'::jsonb,'The passage supports “The angle of its dance relates to the Sun, while the duration suggests distance.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','How Bees Share Directions','How Bees Share Directions

Honeybees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

A worker bee uses movement to show where food can be found. The angle of its dance relates to the Sun, while the duration suggests distance. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Clouds and changing light make the task more difficult. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

The dance helps many bees use one scout’s discovery. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What challenge is mentioned?','[{"id":"a","text":"Clouds and changing light make the task more difficult."},{"id":"b","text":"There are no limits at all."},{"id":"c","text":"The subject cannot be studied."},{"id":"d","text":"Every place has exactly the same conditions."}]'::jsonb,'"a"'::jsonb,'The passage supports “Clouds and changing light make the task more difficult.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','How Bees Share Directions','How Bees Share Directions

Honeybees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

A worker bee uses movement to show where food can be found. The angle of its dance relates to the Sun, while the duration suggests distance. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Clouds and changing light make the task more difficult. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

The dance helps many bees use one scout’s discovery. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What conclusion does the writer reach?','[{"id":"a","text":"The topic should be ignored."},{"id":"b","text":"One quick action solves every problem."},{"id":"c","text":"Maintenance is never necessary."},{"id":"d","text":"The dance helps many bees use one scout’s discovery."}]'::jsonb,'"d"'::jsonb,'The passage supports “The dance helps many bees use one scout’s discovery.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','How Bees Share Directions','How Bees Share Directions

Honeybees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

A worker bee uses movement to show where food can be found. The angle of its dance relates to the Sun, while the duration suggests distance. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Clouds and changing light make the task more difficult. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

The dance helps many bees use one scout’s discovery. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Why do people collect observations over time?','[{"id":"a","text":"The topic exists only at night."},{"id":"b","text":"Older observations are always wrong."},{"id":"c","text":"Conditions can change."},{"id":"d","text":"They want to avoid using evidence."}]'::jsonb,'"c"'::jsonb,'The passage supports “Conditions can change.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','How Bees Share Directions','How Bees Share Directions

Honeybees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

A worker bee uses movement to show where food can be found. The angle of its dance relates to the Sun, while the duration suggests distance. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Clouds and changing light make the task more difficult. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

The dance helps many bees use one scout’s discovery. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What does “incomplete picture” mean?','[{"id":"a","text":"a picture stored on a computer"},{"id":"b","text":"an understanding that is missing important information"},{"id":"c","text":"a photograph with a torn corner"},{"id":"d","text":"a drawing that uses pale colours"}]'::jsonb,'"b"'::jsonb,'The passage supports “an understanding that is missing important information”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','How Bees Share Directions','How Bees Share Directions

Honeybees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

A worker bee uses movement to show where food can be found. The angle of its dance relates to the Sun, while the duration suggests distance. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Clouds and changing light make the task more difficult. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

The dance helps many bees use one scout’s discovery. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which text feature would best support this passage?','[{"id":"a","text":"a labelled diagram showing the connected process"},{"id":"b","text":"a menu of imaginary meals"},{"id":"c","text":"a map of fictional kingdoms"},{"id":"d","text":"a list of unrelated jokes"}]'::jsonb,'"a"'::jsonb,'The passage supports “a labelled diagram showing the connected process”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','How Bees Share Directions','How Bees Share Directions

Honeybees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

A worker bee uses movement to show where food can be found. The angle of its dance relates to the Sun, while the duration suggests distance. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Clouds and changing light make the task more difficult. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

The dance helps many bees use one scout’s discovery. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the author’s main purpose?','[{"id":"a","text":"to entertain with a mystery story"},{"id":"b","text":"to advertise an expensive product"},{"id":"c","text":"to argue that evidence is unnecessary"},{"id":"d","text":"to explain how the topic works and why it matters"}]'::jsonb,'"d"'::jsonb,'The passage supports “to explain how the topic works and why it matters”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','How Bees Share Directions','How Bees Share Directions

Honeybees may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

A worker bee uses movement to show where food can be found. The angle of its dance relates to the Sun, while the duration suggests distance. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Clouds and changing light make the task more difficult. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

The dance helps many bees use one scout’s discovery. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which statement can be inferred?','[{"id":"a","text":"Challenges mean people should never try."},{"id":"b","text":"Only scientists can make responsible choices."},{"id":"c","text":"Good results require planning and continued care."},{"id":"d","text":"Every solution works everywhere."}]'::jsonb,'"c"'::jsonb,'The passage supports “Good results require planning and continued care.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','The Journey of Recycled Glass','The Journey of Recycled Glass

Recycled glass may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Used glass is sorted by colour and cleaned. It is crushed into small pieces called cullet and melted. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Food and mixed materials can spoil a batch. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Recycling glass saves raw materials and can be repeated many times. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the passage mainly about?','[{"id":"a","text":"a famous person’s childhood"},{"id":"b","text":"instructions for a board game"},{"id":"c","text":"recycled glass"},{"id":"d","text":"a fictional treasure hunt"}]'::jsonb,'"c"'::jsonb,'The passage supports “recycled glass”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','The Journey of Recycled Glass','The Journey of Recycled Glass

Recycled glass may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Used glass is sorted by colour and cleaned. It is crushed into small pieces called cullet and melted. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Food and mixed materials can spoil a batch. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Recycling glass saves raw materials and can be repeated many times. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which benefit or process is stated first?','[{"id":"a","text":"It was invented only last year."},{"id":"b","text":"Used glass is sorted by colour and cleaned."},{"id":"c","text":"It works without any conditions."},{"id":"d","text":"It has no effect on people or nature."}]'::jsonb,'"b"'::jsonb,'The passage supports “Used glass is sorted by colour and cleaned.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','The Journey of Recycled Glass','The Journey of Recycled Glass

Recycled glass may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Used glass is sorted by colour and cleaned. It is crushed into small pieces called cullet and melted. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Food and mixed materials can spoil a batch. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Recycling glass saves raw materials and can be repeated many times. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What additional detail does the passage give?','[{"id":"a","text":"It is crushed into small pieces called cullet and melted."},{"id":"b","text":"All examples produce identical results."},{"id":"c","text":"No observations are ever needed."},{"id":"d","text":"The process stops after one day."}]'::jsonb,'"a"'::jsonb,'The passage supports “It is crushed into small pieces called cullet and melted.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','The Journey of Recycled Glass','The Journey of Recycled Glass

Recycled glass may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Used glass is sorted by colour and cleaned. It is crushed into small pieces called cullet and melted. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Food and mixed materials can spoil a batch. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Recycling glass saves raw materials and can be repeated many times. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What challenge is mentioned?','[{"id":"a","text":"There are no limits at all."},{"id":"b","text":"The subject cannot be studied."},{"id":"c","text":"Every place has exactly the same conditions."},{"id":"d","text":"Food and mixed materials can spoil a batch."}]'::jsonb,'"d"'::jsonb,'The passage supports “Food and mixed materials can spoil a batch.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','The Journey of Recycled Glass','The Journey of Recycled Glass

Recycled glass may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Used glass is sorted by colour and cleaned. It is crushed into small pieces called cullet and melted. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Food and mixed materials can spoil a batch. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Recycling glass saves raw materials and can be repeated many times. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What conclusion does the writer reach?','[{"id":"a","text":"One quick action solves every problem."},{"id":"b","text":"Maintenance is never necessary."},{"id":"c","text":"Recycling glass saves raw materials and can be repeated many times."},{"id":"d","text":"The topic should be ignored."}]'::jsonb,'"c"'::jsonb,'The passage supports “Recycling glass saves raw materials and can be repeated many times.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','The Journey of Recycled Glass','The Journey of Recycled Glass

Recycled glass may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Used glass is sorted by colour and cleaned. It is crushed into small pieces called cullet and melted. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Food and mixed materials can spoil a batch. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Recycling glass saves raw materials and can be repeated many times. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Why do people collect observations over time?','[{"id":"a","text":"Older observations are always wrong."},{"id":"b","text":"Conditions can change."},{"id":"c","text":"They want to avoid using evidence."},{"id":"d","text":"The topic exists only at night."}]'::jsonb,'"b"'::jsonb,'The passage supports “Conditions can change.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','The Journey of Recycled Glass','The Journey of Recycled Glass

Recycled glass may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Used glass is sorted by colour and cleaned. It is crushed into small pieces called cullet and melted. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Food and mixed materials can spoil a batch. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Recycling glass saves raw materials and can be repeated many times. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What does “incomplete picture” mean?','[{"id":"a","text":"an understanding that is missing important information"},{"id":"b","text":"a photograph with a torn corner"},{"id":"c","text":"a drawing that uses pale colours"},{"id":"d","text":"a picture stored on a computer"}]'::jsonb,'"a"'::jsonb,'The passage supports “an understanding that is missing important information”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','The Journey of Recycled Glass','The Journey of Recycled Glass

Recycled glass may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Used glass is sorted by colour and cleaned. It is crushed into small pieces called cullet and melted. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Food and mixed materials can spoil a batch. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Recycling glass saves raw materials and can be repeated many times. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which text feature would best support this passage?','[{"id":"a","text":"a menu of imaginary meals"},{"id":"b","text":"a map of fictional kingdoms"},{"id":"c","text":"a list of unrelated jokes"},{"id":"d","text":"a labelled diagram showing the connected process"}]'::jsonb,'"d"'::jsonb,'The passage supports “a labelled diagram showing the connected process”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','The Journey of Recycled Glass','The Journey of Recycled Glass

Recycled glass may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Used glass is sorted by colour and cleaned. It is crushed into small pieces called cullet and melted. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Food and mixed materials can spoil a batch. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Recycling glass saves raw materials and can be repeated many times. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the author’s main purpose?','[{"id":"a","text":"to advertise an expensive product"},{"id":"b","text":"to argue that evidence is unnecessary"},{"id":"c","text":"to explain how the topic works and why it matters"},{"id":"d","text":"to entertain with a mystery story"}]'::jsonb,'"c"'::jsonb,'The passage supports “to explain how the topic works and why it matters”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','The Journey of Recycled Glass','The Journey of Recycled Glass

Recycled glass may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Used glass is sorted by colour and cleaned. It is crushed into small pieces called cullet and melted. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Food and mixed materials can spoil a batch. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Recycling glass saves raw materials and can be repeated many times. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which statement can be inferred?','[{"id":"a","text":"Only scientists can make responsible choices."},{"id":"b","text":"Good results require planning and continued care."},{"id":"c","text":"Every solution works everywhere."},{"id":"d","text":"Challenges mean people should never try."}]'::jsonb,'"b"'::jsonb,'The passage supports “Good results require planning and continued care.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','Why We Need Sleep','Why We Need Sleep

Sleep may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Sleep supports memory, growth and emotional control. The brain organises learning while the body repairs itself. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Bright screens and irregular routines can delay sleep. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

A calm, regular bedtime routine improves rest. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the passage mainly about?','[{"id":"a","text":"instructions for a board game"},{"id":"b","text":"sleep"},{"id":"c","text":"a fictional treasure hunt"},{"id":"d","text":"a famous person’s childhood"}]'::jsonb,'"b"'::jsonb,'The passage supports “sleep”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','Why We Need Sleep','Why We Need Sleep

Sleep may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Sleep supports memory, growth and emotional control. The brain organises learning while the body repairs itself. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Bright screens and irregular routines can delay sleep. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

A calm, regular bedtime routine improves rest. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which benefit or process is stated first?','[{"id":"a","text":"Sleep supports memory, growth and emotional control."},{"id":"b","text":"It works without any conditions."},{"id":"c","text":"It has no effect on people or nature."},{"id":"d","text":"It was invented only last year."}]'::jsonb,'"a"'::jsonb,'The passage supports “Sleep supports memory, growth and emotional control.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','Why We Need Sleep','Why We Need Sleep

Sleep may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Sleep supports memory, growth and emotional control. The brain organises learning while the body repairs itself. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Bright screens and irregular routines can delay sleep. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

A calm, regular bedtime routine improves rest. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What additional detail does the passage give?','[{"id":"a","text":"All examples produce identical results."},{"id":"b","text":"No observations are ever needed."},{"id":"c","text":"The process stops after one day."},{"id":"d","text":"The brain organises learning while the body repairs itself."}]'::jsonb,'"d"'::jsonb,'The passage supports “The brain organises learning while the body repairs itself.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','Why We Need Sleep','Why We Need Sleep

Sleep may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Sleep supports memory, growth and emotional control. The brain organises learning while the body repairs itself. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Bright screens and irregular routines can delay sleep. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

A calm, regular bedtime routine improves rest. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What challenge is mentioned?','[{"id":"a","text":"The subject cannot be studied."},{"id":"b","text":"Every place has exactly the same conditions."},{"id":"c","text":"Bright screens and irregular routines can delay sleep."},{"id":"d","text":"There are no limits at all."}]'::jsonb,'"c"'::jsonb,'The passage supports “Bright screens and irregular routines can delay sleep.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','Why We Need Sleep','Why We Need Sleep

Sleep may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Sleep supports memory, growth and emotional control. The brain organises learning while the body repairs itself. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Bright screens and irregular routines can delay sleep. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

A calm, regular bedtime routine improves rest. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What conclusion does the writer reach?','[{"id":"a","text":"Maintenance is never necessary."},{"id":"b","text":"A calm, regular bedtime routine improves rest."},{"id":"c","text":"The topic should be ignored."},{"id":"d","text":"One quick action solves every problem."}]'::jsonb,'"b"'::jsonb,'The passage supports “A calm, regular bedtime routine improves rest.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','Why We Need Sleep','Why We Need Sleep

Sleep may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Sleep supports memory, growth and emotional control. The brain organises learning while the body repairs itself. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Bright screens and irregular routines can delay sleep. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

A calm, regular bedtime routine improves rest. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Why do people collect observations over time?','[{"id":"a","text":"Conditions can change."},{"id":"b","text":"They want to avoid using evidence."},{"id":"c","text":"The topic exists only at night."},{"id":"d","text":"Older observations are always wrong."}]'::jsonb,'"a"'::jsonb,'The passage supports “Conditions can change.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','Why We Need Sleep','Why We Need Sleep

Sleep may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Sleep supports memory, growth and emotional control. The brain organises learning while the body repairs itself. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Bright screens and irregular routines can delay sleep. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

A calm, regular bedtime routine improves rest. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What does “incomplete picture” mean?','[{"id":"a","text":"a photograph with a torn corner"},{"id":"b","text":"a drawing that uses pale colours"},{"id":"c","text":"a picture stored on a computer"},{"id":"d","text":"an understanding that is missing important information"}]'::jsonb,'"d"'::jsonb,'The passage supports “an understanding that is missing important information”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','Why We Need Sleep','Why We Need Sleep

Sleep may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Sleep supports memory, growth and emotional control. The brain organises learning while the body repairs itself. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Bright screens and irregular routines can delay sleep. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

A calm, regular bedtime routine improves rest. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which text feature would best support this passage?','[{"id":"a","text":"a map of fictional kingdoms"},{"id":"b","text":"a list of unrelated jokes"},{"id":"c","text":"a labelled diagram showing the connected process"},{"id":"d","text":"a menu of imaginary meals"}]'::jsonb,'"c"'::jsonb,'The passage supports “a labelled diagram showing the connected process”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','Why We Need Sleep','Why We Need Sleep

Sleep may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Sleep supports memory, growth and emotional control. The brain organises learning while the body repairs itself. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Bright screens and irregular routines can delay sleep. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

A calm, regular bedtime routine improves rest. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the author’s main purpose?','[{"id":"a","text":"to argue that evidence is unnecessary"},{"id":"b","text":"to explain how the topic works and why it matters"},{"id":"c","text":"to entertain with a mystery story"},{"id":"d","text":"to advertise an expensive product"}]'::jsonb,'"b"'::jsonb,'The passage supports “to explain how the topic works and why it matters”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','Why We Need Sleep','Why We Need Sleep

Sleep may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Sleep supports memory, growth and emotional control. The brain organises learning while the body repairs itself. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Bright screens and irregular routines can delay sleep. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

A calm, regular bedtime routine improves rest. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which statement can be inferred?','[{"id":"a","text":"Good results require planning and continued care."},{"id":"b","text":"Every solution works everywhere."},{"id":"c","text":"Challenges mean people should never try."},{"id":"d","text":"Only scientists can make responsible choices."}]'::jsonb,'"a"'::jsonb,'The passage supports “Good results require planning and continued care.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','Living Walls in Busy Cities','Living Walls in Busy Cities

Living walls may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Plants are grown vertically on specially supported surfaces. They may reduce heat, absorb some sound and create habitats. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. They require water, safe supports and regular maintenance. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Good design matters more than simply adding many plants. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the passage mainly about?','[{"id":"a","text":"living walls"},{"id":"b","text":"a fictional treasure hunt"},{"id":"c","text":"a famous person’s childhood"},{"id":"d","text":"instructions for a board game"}]'::jsonb,'"a"'::jsonb,'The passage supports “living walls”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','Living Walls in Busy Cities','Living Walls in Busy Cities

Living walls may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Plants are grown vertically on specially supported surfaces. They may reduce heat, absorb some sound and create habitats. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. They require water, safe supports and regular maintenance. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Good design matters more than simply adding many plants. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which benefit or process is stated first?','[{"id":"a","text":"It works without any conditions."},{"id":"b","text":"It has no effect on people or nature."},{"id":"c","text":"It was invented only last year."},{"id":"d","text":"Plants are grown vertically on specially supported surfaces."}]'::jsonb,'"d"'::jsonb,'The passage supports “Plants are grown vertically on specially supported surfaces.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','Living Walls in Busy Cities','Living Walls in Busy Cities

Living walls may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Plants are grown vertically on specially supported surfaces. They may reduce heat, absorb some sound and create habitats. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. They require water, safe supports and regular maintenance. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Good design matters more than simply adding many plants. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What additional detail does the passage give?','[{"id":"a","text":"No observations are ever needed."},{"id":"b","text":"The process stops after one day."},{"id":"c","text":"They may reduce heat, absorb some sound and create habitats."},{"id":"d","text":"All examples produce identical results."}]'::jsonb,'"c"'::jsonb,'The passage supports “They may reduce heat, absorb some sound and create habitats.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','Living Walls in Busy Cities','Living Walls in Busy Cities

Living walls may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Plants are grown vertically on specially supported surfaces. They may reduce heat, absorb some sound and create habitats. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. They require water, safe supports and regular maintenance. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Good design matters more than simply adding many plants. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What challenge is mentioned?','[{"id":"a","text":"Every place has exactly the same conditions."},{"id":"b","text":"They require water, safe supports and regular maintenance."},{"id":"c","text":"There are no limits at all."},{"id":"d","text":"The subject cannot be studied."}]'::jsonb,'"b"'::jsonb,'The passage supports “They require water, safe supports and regular maintenance.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','Living Walls in Busy Cities','Living Walls in Busy Cities

Living walls may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Plants are grown vertically on specially supported surfaces. They may reduce heat, absorb some sound and create habitats. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. They require water, safe supports and regular maintenance. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Good design matters more than simply adding many plants. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What conclusion does the writer reach?','[{"id":"a","text":"Good design matters more than simply adding many plants."},{"id":"b","text":"The topic should be ignored."},{"id":"c","text":"One quick action solves every problem."},{"id":"d","text":"Maintenance is never necessary."}]'::jsonb,'"a"'::jsonb,'The passage supports “Good design matters more than simply adding many plants.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','Living Walls in Busy Cities','Living Walls in Busy Cities

Living walls may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Plants are grown vertically on specially supported surfaces. They may reduce heat, absorb some sound and create habitats. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. They require water, safe supports and regular maintenance. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Good design matters more than simply adding many plants. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Why do people collect observations over time?','[{"id":"a","text":"They want to avoid using evidence."},{"id":"b","text":"The topic exists only at night."},{"id":"c","text":"Older observations are always wrong."},{"id":"d","text":"Conditions can change."}]'::jsonb,'"d"'::jsonb,'The passage supports “Conditions can change.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','Living Walls in Busy Cities','Living Walls in Busy Cities

Living walls may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Plants are grown vertically on specially supported surfaces. They may reduce heat, absorb some sound and create habitats. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. They require water, safe supports and regular maintenance. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Good design matters more than simply adding many plants. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What does “incomplete picture” mean?','[{"id":"a","text":"a drawing that uses pale colours"},{"id":"b","text":"a picture stored on a computer"},{"id":"c","text":"an understanding that is missing important information"},{"id":"d","text":"a photograph with a torn corner"}]'::jsonb,'"c"'::jsonb,'The passage supports “an understanding that is missing important information”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','Living Walls in Busy Cities','Living Walls in Busy Cities

Living walls may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Plants are grown vertically on specially supported surfaces. They may reduce heat, absorb some sound and create habitats. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. They require water, safe supports and regular maintenance. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Good design matters more than simply adding many plants. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which text feature would best support this passage?','[{"id":"a","text":"a list of unrelated jokes"},{"id":"b","text":"a labelled diagram showing the connected process"},{"id":"c","text":"a menu of imaginary meals"},{"id":"d","text":"a map of fictional kingdoms"}]'::jsonb,'"b"'::jsonb,'The passage supports “a labelled diagram showing the connected process”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','Living Walls in Busy Cities','Living Walls in Busy Cities

Living walls may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Plants are grown vertically on specially supported surfaces. They may reduce heat, absorb some sound and create habitats. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. They require water, safe supports and regular maintenance. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Good design matters more than simply adding many plants. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the author’s main purpose?','[{"id":"a","text":"to explain how the topic works and why it matters"},{"id":"b","text":"to entertain with a mystery story"},{"id":"c","text":"to advertise an expensive product"},{"id":"d","text":"to argue that evidence is unnecessary"}]'::jsonb,'"a"'::jsonb,'The passage supports “to explain how the topic works and why it matters”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','Living Walls in Busy Cities','Living Walls in Busy Cities

Living walls may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Plants are grown vertically on specially supported surfaces. They may reduce heat, absorb some sound and create habitats. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. They require water, safe supports and regular maintenance. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Good design matters more than simply adding many plants. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which statement can be inferred?','[{"id":"a","text":"Every solution works everywhere."},{"id":"b","text":"Challenges mean people should never try."},{"id":"c","text":"Only scientists can make responsible choices."},{"id":"d","text":"Good results require planning and continued care."}]'::jsonb,'"d"'::jsonb,'The passage supports “Good results require planning and continued care.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','How Weather Forecasts Are Made','How Weather Forecasts Are Made

Weather forecasts may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Scientists collect readings from satellites, stations, ships and balloons. Computers compare the data with mathematical models. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Small changes can make long-range forecasts less certain. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Forecasts express the most likely outcome, not a promise. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the passage mainly about?','[{"id":"a","text":"a fictional treasure hunt"},{"id":"b","text":"a famous person’s childhood"},{"id":"c","text":"instructions for a board game"},{"id":"d","text":"weather forecasts"}]'::jsonb,'"d"'::jsonb,'The passage supports “weather forecasts”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','How Weather Forecasts Are Made','How Weather Forecasts Are Made

Weather forecasts may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Scientists collect readings from satellites, stations, ships and balloons. Computers compare the data with mathematical models. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Small changes can make long-range forecasts less certain. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Forecasts express the most likely outcome, not a promise. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which benefit or process is stated first?','[{"id":"a","text":"It has no effect on people or nature."},{"id":"b","text":"It was invented only last year."},{"id":"c","text":"Scientists collect readings from satellites, stations, ships and balloons."},{"id":"d","text":"It works without any conditions."}]'::jsonb,'"c"'::jsonb,'The passage supports “Scientists collect readings from satellites, stations, ships and balloons.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','How Weather Forecasts Are Made','How Weather Forecasts Are Made

Weather forecasts may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Scientists collect readings from satellites, stations, ships and balloons. Computers compare the data with mathematical models. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Small changes can make long-range forecasts less certain. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Forecasts express the most likely outcome, not a promise. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What additional detail does the passage give?','[{"id":"a","text":"The process stops after one day."},{"id":"b","text":"Computers compare the data with mathematical models."},{"id":"c","text":"All examples produce identical results."},{"id":"d","text":"No observations are ever needed."}]'::jsonb,'"b"'::jsonb,'The passage supports “Computers compare the data with mathematical models.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','How Weather Forecasts Are Made','How Weather Forecasts Are Made

Weather forecasts may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Scientists collect readings from satellites, stations, ships and balloons. Computers compare the data with mathematical models. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Small changes can make long-range forecasts less certain. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Forecasts express the most likely outcome, not a promise. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What challenge is mentioned?','[{"id":"a","text":"Small changes can make long-range forecasts less certain."},{"id":"b","text":"There are no limits at all."},{"id":"c","text":"The subject cannot be studied."},{"id":"d","text":"Every place has exactly the same conditions."}]'::jsonb,'"a"'::jsonb,'The passage supports “Small changes can make long-range forecasts less certain.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','How Weather Forecasts Are Made','How Weather Forecasts Are Made

Weather forecasts may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Scientists collect readings from satellites, stations, ships and balloons. Computers compare the data with mathematical models. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Small changes can make long-range forecasts less certain. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Forecasts express the most likely outcome, not a promise. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What conclusion does the writer reach?','[{"id":"a","text":"The topic should be ignored."},{"id":"b","text":"One quick action solves every problem."},{"id":"c","text":"Maintenance is never necessary."},{"id":"d","text":"Forecasts express the most likely outcome, not a promise."}]'::jsonb,'"d"'::jsonb,'The passage supports “Forecasts express the most likely outcome, not a promise.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','How Weather Forecasts Are Made','How Weather Forecasts Are Made

Weather forecasts may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Scientists collect readings from satellites, stations, ships and balloons. Computers compare the data with mathematical models. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Small changes can make long-range forecasts less certain. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Forecasts express the most likely outcome, not a promise. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Why do people collect observations over time?','[{"id":"a","text":"The topic exists only at night."},{"id":"b","text":"Older observations are always wrong."},{"id":"c","text":"Conditions can change."},{"id":"d","text":"They want to avoid using evidence."}]'::jsonb,'"c"'::jsonb,'The passage supports “Conditions can change.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','How Weather Forecasts Are Made','How Weather Forecasts Are Made

Weather forecasts may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Scientists collect readings from satellites, stations, ships and balloons. Computers compare the data with mathematical models. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Small changes can make long-range forecasts less certain. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Forecasts express the most likely outcome, not a promise. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What does “incomplete picture” mean?','[{"id":"a","text":"a picture stored on a computer"},{"id":"b","text":"an understanding that is missing important information"},{"id":"c","text":"a photograph with a torn corner"},{"id":"d","text":"a drawing that uses pale colours"}]'::jsonb,'"b"'::jsonb,'The passage supports “an understanding that is missing important information”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','How Weather Forecasts Are Made','How Weather Forecasts Are Made

Weather forecasts may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Scientists collect readings from satellites, stations, ships and balloons. Computers compare the data with mathematical models. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Small changes can make long-range forecasts less certain. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Forecasts express the most likely outcome, not a promise. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which text feature would best support this passage?','[{"id":"a","text":"a labelled diagram showing the connected process"},{"id":"b","text":"a menu of imaginary meals"},{"id":"c","text":"a map of fictional kingdoms"},{"id":"d","text":"a list of unrelated jokes"}]'::jsonb,'"a"'::jsonb,'The passage supports “a labelled diagram showing the connected process”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','How Weather Forecasts Are Made','How Weather Forecasts Are Made

Weather forecasts may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Scientists collect readings from satellites, stations, ships and balloons. Computers compare the data with mathematical models. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Small changes can make long-range forecasts less certain. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Forecasts express the most likely outcome, not a promise. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the author’s main purpose?','[{"id":"a","text":"to entertain with a mystery story"},{"id":"b","text":"to advertise an expensive product"},{"id":"c","text":"to argue that evidence is unnecessary"},{"id":"d","text":"to explain how the topic works and why it matters"}]'::jsonb,'"d"'::jsonb,'The passage supports “to explain how the topic works and why it matters”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','How Weather Forecasts Are Made','How Weather Forecasts Are Made

Weather forecasts may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Scientists collect readings from satellites, stations, ships and balloons. Computers compare the data with mathematical models. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Small changes can make long-range forecasts less certain. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Forecasts express the most likely outcome, not a promise. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which statement can be inferred?','[{"id":"a","text":"Challenges mean people should never try."},{"id":"b","text":"Only scientists can make responsible choices."},{"id":"c","text":"Good results require planning and continued care."},{"id":"d","text":"Every solution works everywhere."}]'::jsonb,'"c"'::jsonb,'The passage supports “Good results require planning and continued care.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','The Secret Work of Mangroves','The Secret Work of Mangroves

Mangroves may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Mangrove roots grow in salty, muddy coastal water. They shelter young animals and reduce the force of waves. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Pollution and coastal building can damage them. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Protecting connected habitats benefits wildlife and people. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the passage mainly about?','[{"id":"a","text":"a famous person’s childhood"},{"id":"b","text":"instructions for a board game"},{"id":"c","text":"mangroves"},{"id":"d","text":"a fictional treasure hunt"}]'::jsonb,'"c"'::jsonb,'The passage supports “mangroves”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','The Secret Work of Mangroves','The Secret Work of Mangroves

Mangroves may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Mangrove roots grow in salty, muddy coastal water. They shelter young animals and reduce the force of waves. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Pollution and coastal building can damage them. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Protecting connected habitats benefits wildlife and people. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which benefit or process is stated first?','[{"id":"a","text":"It was invented only last year."},{"id":"b","text":"Mangrove roots grow in salty, muddy coastal water."},{"id":"c","text":"It works without any conditions."},{"id":"d","text":"It has no effect on people or nature."}]'::jsonb,'"b"'::jsonb,'The passage supports “Mangrove roots grow in salty, muddy coastal water.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','The Secret Work of Mangroves','The Secret Work of Mangroves

Mangroves may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Mangrove roots grow in salty, muddy coastal water. They shelter young animals and reduce the force of waves. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Pollution and coastal building can damage them. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Protecting connected habitats benefits wildlife and people. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What additional detail does the passage give?','[{"id":"a","text":"They shelter young animals and reduce the force of waves."},{"id":"b","text":"All examples produce identical results."},{"id":"c","text":"No observations are ever needed."},{"id":"d","text":"The process stops after one day."}]'::jsonb,'"a"'::jsonb,'The passage supports “They shelter young animals and reduce the force of waves.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','The Secret Work of Mangroves','The Secret Work of Mangroves

Mangroves may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Mangrove roots grow in salty, muddy coastal water. They shelter young animals and reduce the force of waves. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Pollution and coastal building can damage them. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Protecting connected habitats benefits wildlife and people. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What challenge is mentioned?','[{"id":"a","text":"There are no limits at all."},{"id":"b","text":"The subject cannot be studied."},{"id":"c","text":"Every place has exactly the same conditions."},{"id":"d","text":"Pollution and coastal building can damage them."}]'::jsonb,'"d"'::jsonb,'The passage supports “Pollution and coastal building can damage them.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','The Secret Work of Mangroves','The Secret Work of Mangroves

Mangroves may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Mangrove roots grow in salty, muddy coastal water. They shelter young animals and reduce the force of waves. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Pollution and coastal building can damage them. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Protecting connected habitats benefits wildlife and people. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What conclusion does the writer reach?','[{"id":"a","text":"One quick action solves every problem."},{"id":"b","text":"Maintenance is never necessary."},{"id":"c","text":"Protecting connected habitats benefits wildlife and people."},{"id":"d","text":"The topic should be ignored."}]'::jsonb,'"c"'::jsonb,'The passage supports “Protecting connected habitats benefits wildlife and people.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','The Secret Work of Mangroves','The Secret Work of Mangroves

Mangroves may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Mangrove roots grow in salty, muddy coastal water. They shelter young animals and reduce the force of waves. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Pollution and coastal building can damage them. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Protecting connected habitats benefits wildlife and people. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Why do people collect observations over time?','[{"id":"a","text":"Older observations are always wrong."},{"id":"b","text":"Conditions can change."},{"id":"c","text":"They want to avoid using evidence."},{"id":"d","text":"The topic exists only at night."}]'::jsonb,'"b"'::jsonb,'The passage supports “Conditions can change.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','The Secret Work of Mangroves','The Secret Work of Mangroves

Mangroves may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Mangrove roots grow in salty, muddy coastal water. They shelter young animals and reduce the force of waves. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Pollution and coastal building can damage them. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Protecting connected habitats benefits wildlife and people. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What does “incomplete picture” mean?','[{"id":"a","text":"an understanding that is missing important information"},{"id":"b","text":"a photograph with a torn corner"},{"id":"c","text":"a drawing that uses pale colours"},{"id":"d","text":"a picture stored on a computer"}]'::jsonb,'"a"'::jsonb,'The passage supports “an understanding that is missing important information”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','The Secret Work of Mangroves','The Secret Work of Mangroves

Mangroves may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Mangrove roots grow in salty, muddy coastal water. They shelter young animals and reduce the force of waves. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Pollution and coastal building can damage them. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Protecting connected habitats benefits wildlife and people. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which text feature would best support this passage?','[{"id":"a","text":"a menu of imaginary meals"},{"id":"b","text":"a map of fictional kingdoms"},{"id":"c","text":"a list of unrelated jokes"},{"id":"d","text":"a labelled diagram showing the connected process"}]'::jsonb,'"d"'::jsonb,'The passage supports “a labelled diagram showing the connected process”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','The Secret Work of Mangroves','The Secret Work of Mangroves

Mangroves may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Mangrove roots grow in salty, muddy coastal water. They shelter young animals and reduce the force of waves. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Pollution and coastal building can damage them. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Protecting connected habitats benefits wildlife and people. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the author’s main purpose?','[{"id":"a","text":"to advertise an expensive product"},{"id":"b","text":"to argue that evidence is unnecessary"},{"id":"c","text":"to explain how the topic works and why it matters"},{"id":"d","text":"to entertain with a mystery story"}]'::jsonb,'"c"'::jsonb,'The passage supports “to explain how the topic works and why it matters”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','The Secret Work of Mangroves','The Secret Work of Mangroves

Mangroves may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Mangrove roots grow in salty, muddy coastal water. They shelter young animals and reduce the force of waves. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Pollution and coastal building can damage them. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Protecting connected habitats benefits wildlife and people. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which statement can be inferred?','[{"id":"a","text":"Only scientists can make responsible choices."},{"id":"b","text":"Good results require planning and continued care."},{"id":"c","text":"Every solution works everywhere."},{"id":"d","text":"Challenges mean people should never try."}]'::jsonb,'"b"'::jsonb,'The passage supports “Good results require planning and continued care.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','What Makes a Good Password?','What Makes a Good Password?

Secure passwords may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Long, unique passwords are harder to guess. A password manager can store different passwords safely. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Names, birthdays and reused passwords create risks. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Security improves when strong passwords are combined with extra verification. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the passage mainly about?','[{"id":"a","text":"instructions for a board game"},{"id":"b","text":"secure passwords"},{"id":"c","text":"a fictional treasure hunt"},{"id":"d","text":"a famous person’s childhood"}]'::jsonb,'"b"'::jsonb,'The passage supports “secure passwords”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','What Makes a Good Password?','What Makes a Good Password?

Secure passwords may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Long, unique passwords are harder to guess. A password manager can store different passwords safely. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Names, birthdays and reused passwords create risks. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Security improves when strong passwords are combined with extra verification. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which benefit or process is stated first?','[{"id":"a","text":"Long, unique passwords are harder to guess."},{"id":"b","text":"It works without any conditions."},{"id":"c","text":"It has no effect on people or nature."},{"id":"d","text":"It was invented only last year."}]'::jsonb,'"a"'::jsonb,'The passage supports “Long, unique passwords are harder to guess.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','What Makes a Good Password?','What Makes a Good Password?

Secure passwords may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Long, unique passwords are harder to guess. A password manager can store different passwords safely. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Names, birthdays and reused passwords create risks. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Security improves when strong passwords are combined with extra verification. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What additional detail does the passage give?','[{"id":"a","text":"All examples produce identical results."},{"id":"b","text":"No observations are ever needed."},{"id":"c","text":"The process stops after one day."},{"id":"d","text":"A password manager can store different passwords safely."}]'::jsonb,'"d"'::jsonb,'The passage supports “A password manager can store different passwords safely.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','What Makes a Good Password?','What Makes a Good Password?

Secure passwords may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Long, unique passwords are harder to guess. A password manager can store different passwords safely. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Names, birthdays and reused passwords create risks. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Security improves when strong passwords are combined with extra verification. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What challenge is mentioned?','[{"id":"a","text":"The subject cannot be studied."},{"id":"b","text":"Every place has exactly the same conditions."},{"id":"c","text":"Names, birthdays and reused passwords create risks."},{"id":"d","text":"There are no limits at all."}]'::jsonb,'"c"'::jsonb,'The passage supports “Names, birthdays and reused passwords create risks.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','What Makes a Good Password?','What Makes a Good Password?

Secure passwords may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Long, unique passwords are harder to guess. A password manager can store different passwords safely. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Names, birthdays and reused passwords create risks. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Security improves when strong passwords are combined with extra verification. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What conclusion does the writer reach?','[{"id":"a","text":"Maintenance is never necessary."},{"id":"b","text":"Security improves when strong passwords are combined with extra verification."},{"id":"c","text":"The topic should be ignored."},{"id":"d","text":"One quick action solves every problem."}]'::jsonb,'"b"'::jsonb,'The passage supports “Security improves when strong passwords are combined with extra verification.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','What Makes a Good Password?','What Makes a Good Password?

Secure passwords may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Long, unique passwords are harder to guess. A password manager can store different passwords safely. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Names, birthdays and reused passwords create risks. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Security improves when strong passwords are combined with extra verification. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Why do people collect observations over time?','[{"id":"a","text":"Conditions can change."},{"id":"b","text":"They want to avoid using evidence."},{"id":"c","text":"The topic exists only at night."},{"id":"d","text":"Older observations are always wrong."}]'::jsonb,'"a"'::jsonb,'The passage supports “Conditions can change.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','What Makes a Good Password?','What Makes a Good Password?

Secure passwords may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Long, unique passwords are harder to guess. A password manager can store different passwords safely. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Names, birthdays and reused passwords create risks. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Security improves when strong passwords are combined with extra verification. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What does “incomplete picture” mean?','[{"id":"a","text":"a photograph with a torn corner"},{"id":"b","text":"a drawing that uses pale colours"},{"id":"c","text":"a picture stored on a computer"},{"id":"d","text":"an understanding that is missing important information"}]'::jsonb,'"d"'::jsonb,'The passage supports “an understanding that is missing important information”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER2','What Makes a Good Password?','What Makes a Good Password?

Secure passwords may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Long, unique passwords are harder to guess. A password manager can store different passwords safely. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Names, birthdays and reused passwords create risks. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Security improves when strong passwords are combined with extra verification. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which text feature would best support this passage?','[{"id":"a","text":"a map of fictional kingdoms"},{"id":"b","text":"a list of unrelated jokes"},{"id":"c","text":"a labelled diagram showing the connected process"},{"id":"d","text":"a menu of imaginary meals"}]'::jsonb,'"c"'::jsonb,'The passage supports “a labelled diagram showing the connected process”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER2','What Makes a Good Password?','What Makes a Good Password?

Secure passwords may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Long, unique passwords are harder to guess. A password manager can store different passwords safely. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Names, birthdays and reused passwords create risks. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Security improves when strong passwords are combined with extra verification. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: What is the author’s main purpose?','[{"id":"a","text":"to argue that evidence is unnecessary"},{"id":"b","text":"to explain how the topic works and why it matters"},{"id":"c","text":"to entertain with a mystery story"},{"id":"d","text":"to advertise an expensive product"}]'::jsonb,'"b"'::jsonb,'The passage supports “to explain how the topic works and why it matters”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER2','What Makes a Good Password?','What Makes a Good Password?

Secure passwords may seem ordinary, but it plays an important role in daily life and the environment. Understanding how it works helps people make better decisions instead of relying on guesses.

Long, unique passwords are harder to guess. A password manager can store different passwords safely. These processes work together, so looking at only one part gives an incomplete picture. Scientists and communities collect observations over time because conditions can change.

However, there are limits and challenges. Names, birthdays and reused passwords create risks. A solution that works in one place may need to be adjusted elsewhere. Careful planning, suitable materials and regular checks are therefore important.

Security improves when strong passwords are combined with extra verification. The main lesson is that useful systems depend on connected parts. Evidence, maintenance and responsible choices allow the benefits to continue.

Question: Which statement can be inferred?','[{"id":"a","text":"Good results require planning and continued care."},{"id":"b","text":"Every solution works everywhere."},{"id":"c","text":"Challenges mean people should never try."},{"id":"d","text":"Only scientists can make responsible choices."}]'::jsonb,'"a"'::jsonb,'The passage supports “Good results require planning and continued care.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Green Saturday Community Fair','Green Saturday Community Fair
EVENT NOTICE

Date/Time: Saturday 12 October, 10:00 a.m.–3:00 p.m.
Place: Riverside Community Hall

What to know
• Bring a reusable cup; children under twelve must attend with an adult.
• Activities include repair workshop, book swap and seed planting.
• Please register for workshops by 9 October.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What type of text is this?','[{"id":"a","text":"event notice"},{"id":"b","text":"a mystery story"},{"id":"c","text":"a personal diary"},{"id":"d","text":"a poem"}]'::jsonb,'"a"'::jsonb,'The passage supports “event notice”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Green Saturday Community Fair','Green Saturday Community Fair
EVENT NOTICE

Date/Time: Saturday 12 October, 10:00 a.m.–3:00 p.m.
Place: Riverside Community Hall

What to know
• Bring a reusable cup; children under twelve must attend with an adult.
• Activities include repair workshop, book swap and seed planting.
• Please register for workshops by 9 October.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: When does the arrangement take place?','[{"id":"a","text":"every day of the year"},{"id":"b","text":"at an unstated time"},{"id":"c","text":"after the event has finished"},{"id":"d","text":"Saturday 12 October, 10:00 a.m.–3:00 p.m."}]'::jsonb,'"d"'::jsonb,'The passage supports “Saturday 12 October, 10:00 a.m.–3:00 p.m.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Green Saturday Community Fair','Green Saturday Community Fair
EVENT NOTICE

Date/Time: Saturday 12 October, 10:00 a.m.–3:00 p.m.
Place: Riverside Community Hall

What to know
• Bring a reusable cup; children under twelve must attend with an adult.
• Activities include repair workshop, book swap and seed planting.
• Please register for workshops by 9 October.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Where should participants go?','[{"id":"a","text":"to a different city"},{"id":"b","text":"to an unnamed office"},{"id":"c","text":"Riverside Community Hall"},{"id":"d","text":"to any place they choose"}]'::jsonb,'"c"'::jsonb,'The passage supports “Riverside Community Hall”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Green Saturday Community Fair','Green Saturday Community Fair
EVENT NOTICE

Date/Time: Saturday 12 October, 10:00 a.m.–3:00 p.m.
Place: Riverside Community Hall

What to know
• Bring a reusable cup; children under twelve must attend with an adult.
• Activities include repair workshop, book swap and seed planting.
• Please register for workshops by 9 October.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Which rule must readers follow?','[{"id":"a","text":"Arrive only after closing time."},{"id":"b","text":"Bring a reusable cup; children under twelve must attend with an adult."},{"id":"c","text":"Ignore all staff instructions."},{"id":"d","text":"Bring every item from home."}]'::jsonb,'"b"'::jsonb,'The passage supports “Bring a reusable cup; children under twelve must attend with an adult.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Green Saturday Community Fair','Green Saturday Community Fair
EVENT NOTICE

Date/Time: Saturday 12 October, 10:00 a.m.–3:00 p.m.
Place: Riverside Community Hall

What to know
• Bring a reusable cup; children under twelve must attend with an adult.
• Activities include repair workshop, book swap and seed planting.
• Please register for workshops by 9 October.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What will be available?','[{"id":"a","text":"repair workshop, book swap and seed planting"},{"id":"b","text":"an overnight flight"},{"id":"c","text":"a private examination"},{"id":"d","text":"an unrelated television show"}]'::jsonb,'"a"'::jsonb,'The passage supports “repair workshop, book swap and seed planting”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Green Saturday Community Fair','Green Saturday Community Fair
EVENT NOTICE

Date/Time: Saturday 12 October, 10:00 a.m.–3:00 p.m.
Place: Riverside Community Hall

What to know
• Bring a reusable cup; children under twelve must attend with an adult.
• Activities include repair workshop, book swap and seed planting.
• Please register for workshops by 9 October.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What action should the reader take?','[{"id":"a","text":"delete the notice immediately"},{"id":"b","text":"wait until next year"},{"id":"c","text":"contact an unofficial account"},{"id":"d","text":"register for workshops by 9 October"}]'::jsonb,'"d"'::jsonb,'The passage supports “register for workshops by 9 October”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Green Saturday Community Fair','Green Saturday Community Fair
EVENT NOTICE

Date/Time: Saturday 12 October, 10:00 a.m.–3:00 p.m.
Place: Riverside Community Hall

What to know
• Bring a reusable cup; children under twelve must attend with an adult.
• Activities include repair workshop, book swap and seed planting.
• Please register for workshops by 9 October.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Why should readers keep the notice?','[{"id":"a","text":"to replace personal identification"},{"id":"b","text":"to avoid reading later updates"},{"id":"c","text":"to check the arrangements before travelling"},{"id":"d","text":"to use it as an entry prize"}]'::jsonb,'"c"'::jsonb,'The passage supports “to check the arrangements before travelling”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Green Saturday Community Fair','Green Saturday Community Fair
EVENT NOTICE

Date/Time: Saturday 12 October, 10:00 a.m.–3:00 p.m.
Place: Riverside Community Hall

What to know
• Bring a reusable cup; children under twelve must attend with an adult.
• Activities include repair workshop, book swap and seed planting.
• Please register for workshops by 9 October.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What may happen if conditions change?','[{"id":"a","text":"Readers should invent their own plan."},{"id":"b","text":"Official messages may update the arrangements."},{"id":"c","text":"The date will never be discussed."},{"id":"d","text":"All safety rules will disappear."}]'::jsonb,'"b"'::jsonb,'The passage supports “Official messages may update the arrangements.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Green Saturday Community Fair','Green Saturday Community Fair
EVENT NOTICE

Date/Time: Saturday 12 October, 10:00 a.m.–3:00 p.m.
Place: Riverside Community Hall

What to know
• Bring a reusable cup; children under twelve must attend with an adult.
• Activities include repair workshop, book swap and seed planting.
• Please register for workshops by 9 October.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Who is the most likely intended reader?','[{"id":"a","text":"someone planning to take part or affected by the arrangement"},{"id":"b","text":"a historian studying ancient objects"},{"id":"c","text":"a novelist creating fantasy characters"},{"id":"d","text":"a scientist measuring distant stars"}]'::jsonb,'"a"'::jsonb,'The passage supports “someone planning to take part or affected by the arrangement”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Green Saturday Community Fair','Green Saturday Community Fair
EVENT NOTICE

Date/Time: Saturday 12 October, 10:00 a.m.–3:00 p.m.
Place: Riverside Community Hall

What to know
• Bring a reusable cup; children under twelve must attend with an adult.
• Activities include repair workshop, book swap and seed planting.
• Please register for workshops by 9 October.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What is the purpose of the text?','[{"id":"a","text":"to describe a dream in detail"},{"id":"b","text":"to persuade readers to buy a toy"},{"id":"c","text":"to retell a traditional tale"},{"id":"d","text":"to give clear practical information and required actions"}]'::jsonb,'"d"'::jsonb,'The passage supports “to give clear practical information and required actions”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','School Library Reading Challenge','School Library Reading Challenge
SCHOOL ANNOUNCEMENT

Date/Time: 4–29 November
Place: school library

What to know
• Borrow up to two challenge books at a time.
• Activities include weekly recommendations and a final sharing session.
• Please return the reading record every Friday.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What type of text is this?','[{"id":"a","text":"a mystery story"},{"id":"b","text":"a personal diary"},{"id":"c","text":"a poem"},{"id":"d","text":"school announcement"}]'::jsonb,'"d"'::jsonb,'The passage supports “school announcement”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','School Library Reading Challenge','School Library Reading Challenge
SCHOOL ANNOUNCEMENT

Date/Time: 4–29 November
Place: school library

What to know
• Borrow up to two challenge books at a time.
• Activities include weekly recommendations and a final sharing session.
• Please return the reading record every Friday.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: When does the arrangement take place?','[{"id":"a","text":"at an unstated time"},{"id":"b","text":"after the event has finished"},{"id":"c","text":"4–29 November"},{"id":"d","text":"every day of the year"}]'::jsonb,'"c"'::jsonb,'The passage supports “4–29 November”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','School Library Reading Challenge','School Library Reading Challenge
SCHOOL ANNOUNCEMENT

Date/Time: 4–29 November
Place: school library

What to know
• Borrow up to two challenge books at a time.
• Activities include weekly recommendations and a final sharing session.
• Please return the reading record every Friday.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Where should participants go?','[{"id":"a","text":"to an unnamed office"},{"id":"b","text":"school library"},{"id":"c","text":"to any place they choose"},{"id":"d","text":"to a different city"}]'::jsonb,'"b"'::jsonb,'The passage supports “school library”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','School Library Reading Challenge','School Library Reading Challenge
SCHOOL ANNOUNCEMENT

Date/Time: 4–29 November
Place: school library

What to know
• Borrow up to two challenge books at a time.
• Activities include weekly recommendations and a final sharing session.
• Please return the reading record every Friday.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Which rule must readers follow?','[{"id":"a","text":"Borrow up to two challenge books at a time."},{"id":"b","text":"Ignore all staff instructions."},{"id":"c","text":"Bring every item from home."},{"id":"d","text":"Arrive only after closing time."}]'::jsonb,'"a"'::jsonb,'The passage supports “Borrow up to two challenge books at a time.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','School Library Reading Challenge','School Library Reading Challenge
SCHOOL ANNOUNCEMENT

Date/Time: 4–29 November
Place: school library

What to know
• Borrow up to two challenge books at a time.
• Activities include weekly recommendations and a final sharing session.
• Please return the reading record every Friday.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What will be available?','[{"id":"a","text":"an overnight flight"},{"id":"b","text":"a private examination"},{"id":"c","text":"an unrelated television show"},{"id":"d","text":"weekly recommendations and a final sharing session"}]'::jsonb,'"d"'::jsonb,'The passage supports “weekly recommendations and a final sharing session”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','School Library Reading Challenge','School Library Reading Challenge
SCHOOL ANNOUNCEMENT

Date/Time: 4–29 November
Place: school library

What to know
• Borrow up to two challenge books at a time.
• Activities include weekly recommendations and a final sharing session.
• Please return the reading record every Friday.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What action should the reader take?','[{"id":"a","text":"wait until next year"},{"id":"b","text":"contact an unofficial account"},{"id":"c","text":"return the reading record every Friday"},{"id":"d","text":"delete the notice immediately"}]'::jsonb,'"c"'::jsonb,'The passage supports “return the reading record every Friday”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','School Library Reading Challenge','School Library Reading Challenge
SCHOOL ANNOUNCEMENT

Date/Time: 4–29 November
Place: school library

What to know
• Borrow up to two challenge books at a time.
• Activities include weekly recommendations and a final sharing session.
• Please return the reading record every Friday.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Why should readers keep the notice?','[{"id":"a","text":"to avoid reading later updates"},{"id":"b","text":"to check the arrangements before travelling"},{"id":"c","text":"to use it as an entry prize"},{"id":"d","text":"to replace personal identification"}]'::jsonb,'"b"'::jsonb,'The passage supports “to check the arrangements before travelling”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','School Library Reading Challenge','School Library Reading Challenge
SCHOOL ANNOUNCEMENT

Date/Time: 4–29 November
Place: school library

What to know
• Borrow up to two challenge books at a time.
• Activities include weekly recommendations and a final sharing session.
• Please return the reading record every Friday.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What may happen if conditions change?','[{"id":"a","text":"Official messages may update the arrangements."},{"id":"b","text":"The date will never be discussed."},{"id":"c","text":"All safety rules will disappear."},{"id":"d","text":"Readers should invent their own plan."}]'::jsonb,'"a"'::jsonb,'The passage supports “Official messages may update the arrangements.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','School Library Reading Challenge','School Library Reading Challenge
SCHOOL ANNOUNCEMENT

Date/Time: 4–29 November
Place: school library

What to know
• Borrow up to two challenge books at a time.
• Activities include weekly recommendations and a final sharing session.
• Please return the reading record every Friday.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Who is the most likely intended reader?','[{"id":"a","text":"a historian studying ancient objects"},{"id":"b","text":"a novelist creating fantasy characters"},{"id":"c","text":"a scientist measuring distant stars"},{"id":"d","text":"someone planning to take part or affected by the arrangement"}]'::jsonb,'"d"'::jsonb,'The passage supports “someone planning to take part or affected by the arrangement”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','School Library Reading Challenge','School Library Reading Challenge
SCHOOL ANNOUNCEMENT

Date/Time: 4–29 November
Place: school library

What to know
• Borrow up to two challenge books at a time.
• Activities include weekly recommendations and a final sharing session.
• Please return the reading record every Friday.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What is the purpose of the text?','[{"id":"a","text":"to persuade readers to buy a toy"},{"id":"b","text":"to retell a traditional tale"},{"id":"c","text":"to give clear practical information and required actions"},{"id":"d","text":"to describe a dream in detail"}]'::jsonb,'"c"'::jsonb,'The passage supports “to give clear practical information and required actions”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Harbour Museum Family Visit','Harbour Museum Family Visit
VISITOR GUIDE

Date/Time: Sunday 18 May, 11:00 a.m.–1:30 p.m.
Place: Harbour Museum entrance

What to know
• Large bags must be left in the free lockers.
• Activities include guided gallery tour and model-boat activity.
• Please arrive fifteen minutes early.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What type of text is this?','[{"id":"a","text":"a personal diary"},{"id":"b","text":"a poem"},{"id":"c","text":"visitor guide"},{"id":"d","text":"a mystery story"}]'::jsonb,'"c"'::jsonb,'The passage supports “visitor guide”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Harbour Museum Family Visit','Harbour Museum Family Visit
VISITOR GUIDE

Date/Time: Sunday 18 May, 11:00 a.m.–1:30 p.m.
Place: Harbour Museum entrance

What to know
• Large bags must be left in the free lockers.
• Activities include guided gallery tour and model-boat activity.
• Please arrive fifteen minutes early.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: When does the arrangement take place?','[{"id":"a","text":"after the event has finished"},{"id":"b","text":"Sunday 18 May, 11:00 a.m.–1:30 p.m."},{"id":"c","text":"every day of the year"},{"id":"d","text":"at an unstated time"}]'::jsonb,'"b"'::jsonb,'The passage supports “Sunday 18 May, 11:00 a.m.–1:30 p.m.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Harbour Museum Family Visit','Harbour Museum Family Visit
VISITOR GUIDE

Date/Time: Sunday 18 May, 11:00 a.m.–1:30 p.m.
Place: Harbour Museum entrance

What to know
• Large bags must be left in the free lockers.
• Activities include guided gallery tour and model-boat activity.
• Please arrive fifteen minutes early.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Where should participants go?','[{"id":"a","text":"Harbour Museum entrance"},{"id":"b","text":"to any place they choose"},{"id":"c","text":"to a different city"},{"id":"d","text":"to an unnamed office"}]'::jsonb,'"a"'::jsonb,'The passage supports “Harbour Museum entrance”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Harbour Museum Family Visit','Harbour Museum Family Visit
VISITOR GUIDE

Date/Time: Sunday 18 May, 11:00 a.m.–1:30 p.m.
Place: Harbour Museum entrance

What to know
• Large bags must be left in the free lockers.
• Activities include guided gallery tour and model-boat activity.
• Please arrive fifteen minutes early.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Which rule must readers follow?','[{"id":"a","text":"Ignore all staff instructions."},{"id":"b","text":"Bring every item from home."},{"id":"c","text":"Arrive only after closing time."},{"id":"d","text":"Large bags must be left in the free lockers."}]'::jsonb,'"d"'::jsonb,'The passage supports “Large bags must be left in the free lockers.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Harbour Museum Family Visit','Harbour Museum Family Visit
VISITOR GUIDE

Date/Time: Sunday 18 May, 11:00 a.m.–1:30 p.m.
Place: Harbour Museum entrance

What to know
• Large bags must be left in the free lockers.
• Activities include guided gallery tour and model-boat activity.
• Please arrive fifteen minutes early.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What will be available?','[{"id":"a","text":"a private examination"},{"id":"b","text":"an unrelated television show"},{"id":"c","text":"guided gallery tour and model-boat activity"},{"id":"d","text":"an overnight flight"}]'::jsonb,'"c"'::jsonb,'The passage supports “guided gallery tour and model-boat activity”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Harbour Museum Family Visit','Harbour Museum Family Visit
VISITOR GUIDE

Date/Time: Sunday 18 May, 11:00 a.m.–1:30 p.m.
Place: Harbour Museum entrance

What to know
• Large bags must be left in the free lockers.
• Activities include guided gallery tour and model-boat activity.
• Please arrive fifteen minutes early.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What action should the reader take?','[{"id":"a","text":"contact an unofficial account"},{"id":"b","text":"arrive fifteen minutes early"},{"id":"c","text":"delete the notice immediately"},{"id":"d","text":"wait until next year"}]'::jsonb,'"b"'::jsonb,'The passage supports “arrive fifteen minutes early”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Harbour Museum Family Visit','Harbour Museum Family Visit
VISITOR GUIDE

Date/Time: Sunday 18 May, 11:00 a.m.–1:30 p.m.
Place: Harbour Museum entrance

What to know
• Large bags must be left in the free lockers.
• Activities include guided gallery tour and model-boat activity.
• Please arrive fifteen minutes early.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Why should readers keep the notice?','[{"id":"a","text":"to check the arrangements before travelling"},{"id":"b","text":"to use it as an entry prize"},{"id":"c","text":"to replace personal identification"},{"id":"d","text":"to avoid reading later updates"}]'::jsonb,'"a"'::jsonb,'The passage supports “to check the arrangements before travelling”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Harbour Museum Family Visit','Harbour Museum Family Visit
VISITOR GUIDE

Date/Time: Sunday 18 May, 11:00 a.m.–1:30 p.m.
Place: Harbour Museum entrance

What to know
• Large bags must be left in the free lockers.
• Activities include guided gallery tour and model-boat activity.
• Please arrive fifteen minutes early.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What may happen if conditions change?','[{"id":"a","text":"The date will never be discussed."},{"id":"b","text":"All safety rules will disappear."},{"id":"c","text":"Readers should invent their own plan."},{"id":"d","text":"Official messages may update the arrangements."}]'::jsonb,'"d"'::jsonb,'The passage supports “Official messages may update the arrangements.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Harbour Museum Family Visit','Harbour Museum Family Visit
VISITOR GUIDE

Date/Time: Sunday 18 May, 11:00 a.m.–1:30 p.m.
Place: Harbour Museum entrance

What to know
• Large bags must be left in the free lockers.
• Activities include guided gallery tour and model-boat activity.
• Please arrive fifteen minutes early.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Who is the most likely intended reader?','[{"id":"a","text":"a novelist creating fantasy characters"},{"id":"b","text":"a scientist measuring distant stars"},{"id":"c","text":"someone planning to take part or affected by the arrangement"},{"id":"d","text":"a historian studying ancient objects"}]'::jsonb,'"c"'::jsonb,'The passage supports “someone planning to take part or affected by the arrangement”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Harbour Museum Family Visit','Harbour Museum Family Visit
VISITOR GUIDE

Date/Time: Sunday 18 May, 11:00 a.m.–1:30 p.m.
Place: Harbour Museum entrance

What to know
• Large bags must be left in the free lockers.
• Activities include guided gallery tour and model-boat activity.
• Please arrive fifteen minutes early.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What is the purpose of the text?','[{"id":"a","text":"to retell a traditional tale"},{"id":"b","text":"to give clear practical information and required actions"},{"id":"c","text":"to describe a dream in detail"},{"id":"d","text":"to persuade readers to buy a toy"}]'::jsonb,'"b"'::jsonb,'The passage supports “to give clear practical information and required actions”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Lost Property: Blue Sports Bag','Lost Property: Blue Sports Bag
LOST-PROPERTY NOTICE

Date/Time: Tuesday 7 January, after lunch
Place: outside the covered playground

What to know
• The owner should describe the name tag and contents.
• Activities include collection from the general office.
• Please collect it before Friday at 4:00 p.m..

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What type of text is this?','[{"id":"a","text":"a poem"},{"id":"b","text":"lost-property notice"},{"id":"c","text":"a mystery story"},{"id":"d","text":"a personal diary"}]'::jsonb,'"b"'::jsonb,'The passage supports “lost-property notice”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Lost Property: Blue Sports Bag','Lost Property: Blue Sports Bag
LOST-PROPERTY NOTICE

Date/Time: Tuesday 7 January, after lunch
Place: outside the covered playground

What to know
• The owner should describe the name tag and contents.
• Activities include collection from the general office.
• Please collect it before Friday at 4:00 p.m..

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: When does the arrangement take place?','[{"id":"a","text":"Tuesday 7 January, after lunch"},{"id":"b","text":"every day of the year"},{"id":"c","text":"at an unstated time"},{"id":"d","text":"after the event has finished"}]'::jsonb,'"a"'::jsonb,'The passage supports “Tuesday 7 January, after lunch”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Lost Property: Blue Sports Bag','Lost Property: Blue Sports Bag
LOST-PROPERTY NOTICE

Date/Time: Tuesday 7 January, after lunch
Place: outside the covered playground

What to know
• The owner should describe the name tag and contents.
• Activities include collection from the general office.
• Please collect it before Friday at 4:00 p.m..

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Where should participants go?','[{"id":"a","text":"to any place they choose"},{"id":"b","text":"to a different city"},{"id":"c","text":"to an unnamed office"},{"id":"d","text":"outside the covered playground"}]'::jsonb,'"d"'::jsonb,'The passage supports “outside the covered playground”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Lost Property: Blue Sports Bag','Lost Property: Blue Sports Bag
LOST-PROPERTY NOTICE

Date/Time: Tuesday 7 January, after lunch
Place: outside the covered playground

What to know
• The owner should describe the name tag and contents.
• Activities include collection from the general office.
• Please collect it before Friday at 4:00 p.m..

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Which rule must readers follow?','[{"id":"a","text":"Bring every item from home."},{"id":"b","text":"Arrive only after closing time."},{"id":"c","text":"The owner should describe the name tag and contents."},{"id":"d","text":"Ignore all staff instructions."}]'::jsonb,'"c"'::jsonb,'The passage supports “The owner should describe the name tag and contents.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Lost Property: Blue Sports Bag','Lost Property: Blue Sports Bag
LOST-PROPERTY NOTICE

Date/Time: Tuesday 7 January, after lunch
Place: outside the covered playground

What to know
• The owner should describe the name tag and contents.
• Activities include collection from the general office.
• Please collect it before Friday at 4:00 p.m..

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What will be available?','[{"id":"a","text":"an unrelated television show"},{"id":"b","text":"collection from the general office"},{"id":"c","text":"an overnight flight"},{"id":"d","text":"a private examination"}]'::jsonb,'"b"'::jsonb,'The passage supports “collection from the general office”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Lost Property: Blue Sports Bag','Lost Property: Blue Sports Bag
LOST-PROPERTY NOTICE

Date/Time: Tuesday 7 January, after lunch
Place: outside the covered playground

What to know
• The owner should describe the name tag and contents.
• Activities include collection from the general office.
• Please collect it before Friday at 4:00 p.m..

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What action should the reader take?','[{"id":"a","text":"collect it before Friday at 4:00 p.m."},{"id":"b","text":"delete the notice immediately"},{"id":"c","text":"wait until next year"},{"id":"d","text":"contact an unofficial account"}]'::jsonb,'"a"'::jsonb,'The passage supports “collect it before Friday at 4:00 p.m.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Lost Property: Blue Sports Bag','Lost Property: Blue Sports Bag
LOST-PROPERTY NOTICE

Date/Time: Tuesday 7 January, after lunch
Place: outside the covered playground

What to know
• The owner should describe the name tag and contents.
• Activities include collection from the general office.
• Please collect it before Friday at 4:00 p.m..

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Why should readers keep the notice?','[{"id":"a","text":"to use it as an entry prize"},{"id":"b","text":"to replace personal identification"},{"id":"c","text":"to avoid reading later updates"},{"id":"d","text":"to check the arrangements before travelling"}]'::jsonb,'"d"'::jsonb,'The passage supports “to check the arrangements before travelling”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Lost Property: Blue Sports Bag','Lost Property: Blue Sports Bag
LOST-PROPERTY NOTICE

Date/Time: Tuesday 7 January, after lunch
Place: outside the covered playground

What to know
• The owner should describe the name tag and contents.
• Activities include collection from the general office.
• Please collect it before Friday at 4:00 p.m..

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What may happen if conditions change?','[{"id":"a","text":"All safety rules will disappear."},{"id":"b","text":"Readers should invent their own plan."},{"id":"c","text":"Official messages may update the arrangements."},{"id":"d","text":"The date will never be discussed."}]'::jsonb,'"c"'::jsonb,'The passage supports “Official messages may update the arrangements.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Lost Property: Blue Sports Bag','Lost Property: Blue Sports Bag
LOST-PROPERTY NOTICE

Date/Time: Tuesday 7 January, after lunch
Place: outside the covered playground

What to know
• The owner should describe the name tag and contents.
• Activities include collection from the general office.
• Please collect it before Friday at 4:00 p.m..

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Who is the most likely intended reader?','[{"id":"a","text":"a scientist measuring distant stars"},{"id":"b","text":"someone planning to take part or affected by the arrangement"},{"id":"c","text":"a historian studying ancient objects"},{"id":"d","text":"a novelist creating fantasy characters"}]'::jsonb,'"b"'::jsonb,'The passage supports “someone planning to take part or affected by the arrangement”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Lost Property: Blue Sports Bag','Lost Property: Blue Sports Bag
LOST-PROPERTY NOTICE

Date/Time: Tuesday 7 January, after lunch
Place: outside the covered playground

What to know
• The owner should describe the name tag and contents.
• Activities include collection from the general office.
• Please collect it before Friday at 4:00 p.m..

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What is the purpose of the text?','[{"id":"a","text":"to give clear practical information and required actions"},{"id":"b","text":"to describe a dream in detail"},{"id":"c","text":"to persuade readers to buy a toy"},{"id":"d","text":"to retell a traditional tale"}]'::jsonb,'"a"'::jsonb,'The passage supports “to give clear practical information and required actions”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Young Gardeners Workshop','Young Gardeners Workshop
REGISTRATION EMAIL

Date/Time: Wednesday 23 April, 3:45–5:00 p.m.
Place: school rooftop garden

What to know
• Wear closed shoes and bring a small towel.
• Activities include compost demonstration and herb planting.
• Please reply with the pupil’s class by 18 April.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What type of text is this?','[{"id":"a","text":"registration email"},{"id":"b","text":"a mystery story"},{"id":"c","text":"a personal diary"},{"id":"d","text":"a poem"}]'::jsonb,'"a"'::jsonb,'The passage supports “registration email”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Young Gardeners Workshop','Young Gardeners Workshop
REGISTRATION EMAIL

Date/Time: Wednesday 23 April, 3:45–5:00 p.m.
Place: school rooftop garden

What to know
• Wear closed shoes and bring a small towel.
• Activities include compost demonstration and herb planting.
• Please reply with the pupil’s class by 18 April.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: When does the arrangement take place?','[{"id":"a","text":"every day of the year"},{"id":"b","text":"at an unstated time"},{"id":"c","text":"after the event has finished"},{"id":"d","text":"Wednesday 23 April, 3:45–5:00 p.m."}]'::jsonb,'"d"'::jsonb,'The passage supports “Wednesday 23 April, 3:45–5:00 p.m.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Young Gardeners Workshop','Young Gardeners Workshop
REGISTRATION EMAIL

Date/Time: Wednesday 23 April, 3:45–5:00 p.m.
Place: school rooftop garden

What to know
• Wear closed shoes and bring a small towel.
• Activities include compost demonstration and herb planting.
• Please reply with the pupil’s class by 18 April.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Where should participants go?','[{"id":"a","text":"to a different city"},{"id":"b","text":"to an unnamed office"},{"id":"c","text":"school rooftop garden"},{"id":"d","text":"to any place they choose"}]'::jsonb,'"c"'::jsonb,'The passage supports “school rooftop garden”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Young Gardeners Workshop','Young Gardeners Workshop
REGISTRATION EMAIL

Date/Time: Wednesday 23 April, 3:45–5:00 p.m.
Place: school rooftop garden

What to know
• Wear closed shoes and bring a small towel.
• Activities include compost demonstration and herb planting.
• Please reply with the pupil’s class by 18 April.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Which rule must readers follow?','[{"id":"a","text":"Arrive only after closing time."},{"id":"b","text":"Wear closed shoes and bring a small towel."},{"id":"c","text":"Ignore all staff instructions."},{"id":"d","text":"Bring every item from home."}]'::jsonb,'"b"'::jsonb,'The passage supports “Wear closed shoes and bring a small towel.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Young Gardeners Workshop','Young Gardeners Workshop
REGISTRATION EMAIL

Date/Time: Wednesday 23 April, 3:45–5:00 p.m.
Place: school rooftop garden

What to know
• Wear closed shoes and bring a small towel.
• Activities include compost demonstration and herb planting.
• Please reply with the pupil’s class by 18 April.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What will be available?','[{"id":"a","text":"compost demonstration and herb planting"},{"id":"b","text":"an overnight flight"},{"id":"c","text":"a private examination"},{"id":"d","text":"an unrelated television show"}]'::jsonb,'"a"'::jsonb,'The passage supports “compost demonstration and herb planting”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Young Gardeners Workshop','Young Gardeners Workshop
REGISTRATION EMAIL

Date/Time: Wednesday 23 April, 3:45–5:00 p.m.
Place: school rooftop garden

What to know
• Wear closed shoes and bring a small towel.
• Activities include compost demonstration and herb planting.
• Please reply with the pupil’s class by 18 April.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What action should the reader take?','[{"id":"a","text":"delete the notice immediately"},{"id":"b","text":"wait until next year"},{"id":"c","text":"contact an unofficial account"},{"id":"d","text":"reply with the pupil’s class by 18 April"}]'::jsonb,'"d"'::jsonb,'The passage supports “reply with the pupil’s class by 18 April”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Young Gardeners Workshop','Young Gardeners Workshop
REGISTRATION EMAIL

Date/Time: Wednesday 23 April, 3:45–5:00 p.m.
Place: school rooftop garden

What to know
• Wear closed shoes and bring a small towel.
• Activities include compost demonstration and herb planting.
• Please reply with the pupil’s class by 18 April.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Why should readers keep the notice?','[{"id":"a","text":"to replace personal identification"},{"id":"b","text":"to avoid reading later updates"},{"id":"c","text":"to check the arrangements before travelling"},{"id":"d","text":"to use it as an entry prize"}]'::jsonb,'"c"'::jsonb,'The passage supports “to check the arrangements before travelling”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Young Gardeners Workshop','Young Gardeners Workshop
REGISTRATION EMAIL

Date/Time: Wednesday 23 April, 3:45–5:00 p.m.
Place: school rooftop garden

What to know
• Wear closed shoes and bring a small towel.
• Activities include compost demonstration and herb planting.
• Please reply with the pupil’s class by 18 April.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What may happen if conditions change?','[{"id":"a","text":"Readers should invent their own plan."},{"id":"b","text":"Official messages may update the arrangements."},{"id":"c","text":"The date will never be discussed."},{"id":"d","text":"All safety rules will disappear."}]'::jsonb,'"b"'::jsonb,'The passage supports “Official messages may update the arrangements.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Young Gardeners Workshop','Young Gardeners Workshop
REGISTRATION EMAIL

Date/Time: Wednesday 23 April, 3:45–5:00 p.m.
Place: school rooftop garden

What to know
• Wear closed shoes and bring a small towel.
• Activities include compost demonstration and herb planting.
• Please reply with the pupil’s class by 18 April.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Who is the most likely intended reader?','[{"id":"a","text":"someone planning to take part or affected by the arrangement"},{"id":"b","text":"a historian studying ancient objects"},{"id":"c","text":"a novelist creating fantasy characters"},{"id":"d","text":"a scientist measuring distant stars"}]'::jsonb,'"a"'::jsonb,'The passage supports “someone planning to take part or affected by the arrangement”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Young Gardeners Workshop','Young Gardeners Workshop
REGISTRATION EMAIL

Date/Time: Wednesday 23 April, 3:45–5:00 p.m.
Place: school rooftop garden

What to know
• Wear closed shoes and bring a small towel.
• Activities include compost demonstration and herb planting.
• Please reply with the pupil’s class by 18 April.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What is the purpose of the text?','[{"id":"a","text":"to describe a dream in detail"},{"id":"b","text":"to persuade readers to buy a toy"},{"id":"c","text":"to retell a traditional tale"},{"id":"d","text":"to give clear practical information and required actions"}]'::jsonb,'"d"'::jsonb,'The passage supports “to give clear practical information and required actions”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Temporary Bus Stop Change','Temporary Bus Stop Change
TRANSPORT NOTICE

Date/Time: 6–10 July
Place: opposite the public library

What to know
• Route 18 will not stop outside Market Street.
• Activities include a temporary stop with staff signs.
• Please allow ten extra minutes for the journey.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What type of text is this?','[{"id":"a","text":"a mystery story"},{"id":"b","text":"a personal diary"},{"id":"c","text":"a poem"},{"id":"d","text":"transport notice"}]'::jsonb,'"d"'::jsonb,'The passage supports “transport notice”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Temporary Bus Stop Change','Temporary Bus Stop Change
TRANSPORT NOTICE

Date/Time: 6–10 July
Place: opposite the public library

What to know
• Route 18 will not stop outside Market Street.
• Activities include a temporary stop with staff signs.
• Please allow ten extra minutes for the journey.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: When does the arrangement take place?','[{"id":"a","text":"at an unstated time"},{"id":"b","text":"after the event has finished"},{"id":"c","text":"6–10 July"},{"id":"d","text":"every day of the year"}]'::jsonb,'"c"'::jsonb,'The passage supports “6–10 July”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Temporary Bus Stop Change','Temporary Bus Stop Change
TRANSPORT NOTICE

Date/Time: 6–10 July
Place: opposite the public library

What to know
• Route 18 will not stop outside Market Street.
• Activities include a temporary stop with staff signs.
• Please allow ten extra minutes for the journey.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Where should participants go?','[{"id":"a","text":"to an unnamed office"},{"id":"b","text":"opposite the public library"},{"id":"c","text":"to any place they choose"},{"id":"d","text":"to a different city"}]'::jsonb,'"b"'::jsonb,'The passage supports “opposite the public library”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Temporary Bus Stop Change','Temporary Bus Stop Change
TRANSPORT NOTICE

Date/Time: 6–10 July
Place: opposite the public library

What to know
• Route 18 will not stop outside Market Street.
• Activities include a temporary stop with staff signs.
• Please allow ten extra minutes for the journey.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Which rule must readers follow?','[{"id":"a","text":"Route 18 will not stop outside Market Street."},{"id":"b","text":"Ignore all staff instructions."},{"id":"c","text":"Bring every item from home."},{"id":"d","text":"Arrive only after closing time."}]'::jsonb,'"a"'::jsonb,'The passage supports “Route 18 will not stop outside Market Street.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Temporary Bus Stop Change','Temporary Bus Stop Change
TRANSPORT NOTICE

Date/Time: 6–10 July
Place: opposite the public library

What to know
• Route 18 will not stop outside Market Street.
• Activities include a temporary stop with staff signs.
• Please allow ten extra minutes for the journey.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What will be available?','[{"id":"a","text":"an overnight flight"},{"id":"b","text":"a private examination"},{"id":"c","text":"an unrelated television show"},{"id":"d","text":"a temporary stop with staff signs"}]'::jsonb,'"d"'::jsonb,'The passage supports “a temporary stop with staff signs”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Temporary Bus Stop Change','Temporary Bus Stop Change
TRANSPORT NOTICE

Date/Time: 6–10 July
Place: opposite the public library

What to know
• Route 18 will not stop outside Market Street.
• Activities include a temporary stop with staff signs.
• Please allow ten extra minutes for the journey.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What action should the reader take?','[{"id":"a","text":"wait until next year"},{"id":"b","text":"contact an unofficial account"},{"id":"c","text":"allow ten extra minutes for the journey"},{"id":"d","text":"delete the notice immediately"}]'::jsonb,'"c"'::jsonb,'The passage supports “allow ten extra minutes for the journey”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Temporary Bus Stop Change','Temporary Bus Stop Change
TRANSPORT NOTICE

Date/Time: 6–10 July
Place: opposite the public library

What to know
• Route 18 will not stop outside Market Street.
• Activities include a temporary stop with staff signs.
• Please allow ten extra minutes for the journey.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Why should readers keep the notice?','[{"id":"a","text":"to avoid reading later updates"},{"id":"b","text":"to check the arrangements before travelling"},{"id":"c","text":"to use it as an entry prize"},{"id":"d","text":"to replace personal identification"}]'::jsonb,'"b"'::jsonb,'The passage supports “to check the arrangements before travelling”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Temporary Bus Stop Change','Temporary Bus Stop Change
TRANSPORT NOTICE

Date/Time: 6–10 July
Place: opposite the public library

What to know
• Route 18 will not stop outside Market Street.
• Activities include a temporary stop with staff signs.
• Please allow ten extra minutes for the journey.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What may happen if conditions change?','[{"id":"a","text":"Official messages may update the arrangements."},{"id":"b","text":"The date will never be discussed."},{"id":"c","text":"All safety rules will disappear."},{"id":"d","text":"Readers should invent their own plan."}]'::jsonb,'"a"'::jsonb,'The passage supports “Official messages may update the arrangements.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Temporary Bus Stop Change','Temporary Bus Stop Change
TRANSPORT NOTICE

Date/Time: 6–10 July
Place: opposite the public library

What to know
• Route 18 will not stop outside Market Street.
• Activities include a temporary stop with staff signs.
• Please allow ten extra minutes for the journey.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Who is the most likely intended reader?','[{"id":"a","text":"a historian studying ancient objects"},{"id":"b","text":"a novelist creating fantasy characters"},{"id":"c","text":"a scientist measuring distant stars"},{"id":"d","text":"someone planning to take part or affected by the arrangement"}]'::jsonb,'"d"'::jsonb,'The passage supports “someone planning to take part or affected by the arrangement”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Temporary Bus Stop Change','Temporary Bus Stop Change
TRANSPORT NOTICE

Date/Time: 6–10 July
Place: opposite the public library

What to know
• Route 18 will not stop outside Market Street.
• Activities include a temporary stop with staff signs.
• Please allow ten extra minutes for the journey.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What is the purpose of the text?','[{"id":"a","text":"to persuade readers to buy a toy"},{"id":"b","text":"to retell a traditional tale"},{"id":"c","text":"to give clear practical information and required actions"},{"id":"d","text":"to describe a dream in detail"}]'::jsonb,'"c"'::jsonb,'The passage supports “to give clear practical information and required actions”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Healthy Lunch Photo Competition','Healthy Lunch Photo Competition
COMPETITION POSTER

Date/Time: 1–20 March
Place: online submission portal

What to know
• Photographs must show a meal prepared by the pupil.
• Activities include nutrition checklist and digital certificate.
• Please submit one photograph with a short caption.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What type of text is this?','[{"id":"a","text":"a personal diary"},{"id":"b","text":"a poem"},{"id":"c","text":"competition poster"},{"id":"d","text":"a mystery story"}]'::jsonb,'"c"'::jsonb,'The passage supports “competition poster”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Healthy Lunch Photo Competition','Healthy Lunch Photo Competition
COMPETITION POSTER

Date/Time: 1–20 March
Place: online submission portal

What to know
• Photographs must show a meal prepared by the pupil.
• Activities include nutrition checklist and digital certificate.
• Please submit one photograph with a short caption.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: When does the arrangement take place?','[{"id":"a","text":"after the event has finished"},{"id":"b","text":"1–20 March"},{"id":"c","text":"every day of the year"},{"id":"d","text":"at an unstated time"}]'::jsonb,'"b"'::jsonb,'The passage supports “1–20 March”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Healthy Lunch Photo Competition','Healthy Lunch Photo Competition
COMPETITION POSTER

Date/Time: 1–20 March
Place: online submission portal

What to know
• Photographs must show a meal prepared by the pupil.
• Activities include nutrition checklist and digital certificate.
• Please submit one photograph with a short caption.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Where should participants go?','[{"id":"a","text":"online submission portal"},{"id":"b","text":"to any place they choose"},{"id":"c","text":"to a different city"},{"id":"d","text":"to an unnamed office"}]'::jsonb,'"a"'::jsonb,'The passage supports “online submission portal”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Healthy Lunch Photo Competition','Healthy Lunch Photo Competition
COMPETITION POSTER

Date/Time: 1–20 March
Place: online submission portal

What to know
• Photographs must show a meal prepared by the pupil.
• Activities include nutrition checklist and digital certificate.
• Please submit one photograph with a short caption.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Which rule must readers follow?','[{"id":"a","text":"Ignore all staff instructions."},{"id":"b","text":"Bring every item from home."},{"id":"c","text":"Arrive only after closing time."},{"id":"d","text":"Photographs must show a meal prepared by the pupil."}]'::jsonb,'"d"'::jsonb,'The passage supports “Photographs must show a meal prepared by the pupil.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Healthy Lunch Photo Competition','Healthy Lunch Photo Competition
COMPETITION POSTER

Date/Time: 1–20 March
Place: online submission portal

What to know
• Photographs must show a meal prepared by the pupil.
• Activities include nutrition checklist and digital certificate.
• Please submit one photograph with a short caption.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What will be available?','[{"id":"a","text":"a private examination"},{"id":"b","text":"an unrelated television show"},{"id":"c","text":"nutrition checklist and digital certificate"},{"id":"d","text":"an overnight flight"}]'::jsonb,'"c"'::jsonb,'The passage supports “nutrition checklist and digital certificate”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Healthy Lunch Photo Competition','Healthy Lunch Photo Competition
COMPETITION POSTER

Date/Time: 1–20 March
Place: online submission portal

What to know
• Photographs must show a meal prepared by the pupil.
• Activities include nutrition checklist and digital certificate.
• Please submit one photograph with a short caption.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What action should the reader take?','[{"id":"a","text":"contact an unofficial account"},{"id":"b","text":"submit one photograph with a short caption"},{"id":"c","text":"delete the notice immediately"},{"id":"d","text":"wait until next year"}]'::jsonb,'"b"'::jsonb,'The passage supports “submit one photograph with a short caption”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Healthy Lunch Photo Competition','Healthy Lunch Photo Competition
COMPETITION POSTER

Date/Time: 1–20 March
Place: online submission portal

What to know
• Photographs must show a meal prepared by the pupil.
• Activities include nutrition checklist and digital certificate.
• Please submit one photograph with a short caption.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Why should readers keep the notice?','[{"id":"a","text":"to check the arrangements before travelling"},{"id":"b","text":"to use it as an entry prize"},{"id":"c","text":"to replace personal identification"},{"id":"d","text":"to avoid reading later updates"}]'::jsonb,'"a"'::jsonb,'The passage supports “to check the arrangements before travelling”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Healthy Lunch Photo Competition','Healthy Lunch Photo Competition
COMPETITION POSTER

Date/Time: 1–20 March
Place: online submission portal

What to know
• Photographs must show a meal prepared by the pupil.
• Activities include nutrition checklist and digital certificate.
• Please submit one photograph with a short caption.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What may happen if conditions change?','[{"id":"a","text":"The date will never be discussed."},{"id":"b","text":"All safety rules will disappear."},{"id":"c","text":"Readers should invent their own plan."},{"id":"d","text":"Official messages may update the arrangements."}]'::jsonb,'"d"'::jsonb,'The passage supports “Official messages may update the arrangements.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Healthy Lunch Photo Competition','Healthy Lunch Photo Competition
COMPETITION POSTER

Date/Time: 1–20 March
Place: online submission portal

What to know
• Photographs must show a meal prepared by the pupil.
• Activities include nutrition checklist and digital certificate.
• Please submit one photograph with a short caption.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Who is the most likely intended reader?','[{"id":"a","text":"a novelist creating fantasy characters"},{"id":"b","text":"a scientist measuring distant stars"},{"id":"c","text":"someone planning to take part or affected by the arrangement"},{"id":"d","text":"a historian studying ancient objects"}]'::jsonb,'"c"'::jsonb,'The passage supports “someone planning to take part or affected by the arrangement”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Healthy Lunch Photo Competition','Healthy Lunch Photo Competition
COMPETITION POSTER

Date/Time: 1–20 March
Place: online submission portal

What to know
• Photographs must show a meal prepared by the pupil.
• Activities include nutrition checklist and digital certificate.
• Please submit one photograph with a short caption.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What is the purpose of the text?','[{"id":"a","text":"to retell a traditional tale"},{"id":"b","text":"to give clear practical information and required actions"},{"id":"c","text":"to describe a dream in detail"},{"id":"d","text":"to persuade readers to buy a toy"}]'::jsonb,'"b"'::jsonb,'The passage supports “to give clear practical information and required actions”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Weather Warning for Sports Day','Weather Warning for Sports Day
SCHOOL MESSAGE

Date/Time: Friday 27 June, decision at 7:00 a.m.
Place: school website and parent app

What to know
• Do not travel until the final notice is posted.
• Activities include indoor lessons if the event is postponed.
• Please check the official update before leaving home.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What type of text is this?','[{"id":"a","text":"a poem"},{"id":"b","text":"school message"},{"id":"c","text":"a mystery story"},{"id":"d","text":"a personal diary"}]'::jsonb,'"b"'::jsonb,'The passage supports “school message”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Weather Warning for Sports Day','Weather Warning for Sports Day
SCHOOL MESSAGE

Date/Time: Friday 27 June, decision at 7:00 a.m.
Place: school website and parent app

What to know
• Do not travel until the final notice is posted.
• Activities include indoor lessons if the event is postponed.
• Please check the official update before leaving home.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: When does the arrangement take place?','[{"id":"a","text":"Friday 27 June, decision at 7:00 a.m."},{"id":"b","text":"every day of the year"},{"id":"c","text":"at an unstated time"},{"id":"d","text":"after the event has finished"}]'::jsonb,'"a"'::jsonb,'The passage supports “Friday 27 June, decision at 7:00 a.m.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Weather Warning for Sports Day','Weather Warning for Sports Day
SCHOOL MESSAGE

Date/Time: Friday 27 June, decision at 7:00 a.m.
Place: school website and parent app

What to know
• Do not travel until the final notice is posted.
• Activities include indoor lessons if the event is postponed.
• Please check the official update before leaving home.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Where should participants go?','[{"id":"a","text":"to any place they choose"},{"id":"b","text":"to a different city"},{"id":"c","text":"to an unnamed office"},{"id":"d","text":"school website and parent app"}]'::jsonb,'"d"'::jsonb,'The passage supports “school website and parent app”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Weather Warning for Sports Day','Weather Warning for Sports Day
SCHOOL MESSAGE

Date/Time: Friday 27 June, decision at 7:00 a.m.
Place: school website and parent app

What to know
• Do not travel until the final notice is posted.
• Activities include indoor lessons if the event is postponed.
• Please check the official update before leaving home.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Which rule must readers follow?','[{"id":"a","text":"Bring every item from home."},{"id":"b","text":"Arrive only after closing time."},{"id":"c","text":"Do not travel until the final notice is posted."},{"id":"d","text":"Ignore all staff instructions."}]'::jsonb,'"c"'::jsonb,'The passage supports “Do not travel until the final notice is posted.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Weather Warning for Sports Day','Weather Warning for Sports Day
SCHOOL MESSAGE

Date/Time: Friday 27 June, decision at 7:00 a.m.
Place: school website and parent app

What to know
• Do not travel until the final notice is posted.
• Activities include indoor lessons if the event is postponed.
• Please check the official update before leaving home.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What will be available?','[{"id":"a","text":"an unrelated television show"},{"id":"b","text":"indoor lessons if the event is postponed"},{"id":"c","text":"an overnight flight"},{"id":"d","text":"a private examination"}]'::jsonb,'"b"'::jsonb,'The passage supports “indoor lessons if the event is postponed”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Weather Warning for Sports Day','Weather Warning for Sports Day
SCHOOL MESSAGE

Date/Time: Friday 27 June, decision at 7:00 a.m.
Place: school website and parent app

What to know
• Do not travel until the final notice is posted.
• Activities include indoor lessons if the event is postponed.
• Please check the official update before leaving home.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What action should the reader take?','[{"id":"a","text":"check the official update before leaving home"},{"id":"b","text":"delete the notice immediately"},{"id":"c","text":"wait until next year"},{"id":"d","text":"contact an unofficial account"}]'::jsonb,'"a"'::jsonb,'The passage supports “check the official update before leaving home”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Weather Warning for Sports Day','Weather Warning for Sports Day
SCHOOL MESSAGE

Date/Time: Friday 27 June, decision at 7:00 a.m.
Place: school website and parent app

What to know
• Do not travel until the final notice is posted.
• Activities include indoor lessons if the event is postponed.
• Please check the official update before leaving home.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Why should readers keep the notice?','[{"id":"a","text":"to use it as an entry prize"},{"id":"b","text":"to replace personal identification"},{"id":"c","text":"to avoid reading later updates"},{"id":"d","text":"to check the arrangements before travelling"}]'::jsonb,'"d"'::jsonb,'The passage supports “to check the arrangements before travelling”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER3','Weather Warning for Sports Day','Weather Warning for Sports Day
SCHOOL MESSAGE

Date/Time: Friday 27 June, decision at 7:00 a.m.
Place: school website and parent app

What to know
• Do not travel until the final notice is posted.
• Activities include indoor lessons if the event is postponed.
• Please check the official update before leaving home.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What may happen if conditions change?','[{"id":"a","text":"All safety rules will disappear."},{"id":"b","text":"Readers should invent their own plan."},{"id":"c","text":"Official messages may update the arrangements."},{"id":"d","text":"The date will never be discussed."}]'::jsonb,'"c"'::jsonb,'The passage supports “Official messages may update the arrangements.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER3','Weather Warning for Sports Day','Weather Warning for Sports Day
SCHOOL MESSAGE

Date/Time: Friday 27 June, decision at 7:00 a.m.
Place: school website and parent app

What to know
• Do not travel until the final notice is posted.
• Activities include indoor lessons if the event is postponed.
• Please check the official update before leaving home.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: Who is the most likely intended reader?','[{"id":"a","text":"a scientist measuring distant stars"},{"id":"b","text":"someone planning to take part or affected by the arrangement"},{"id":"c","text":"a historian studying ancient objects"},{"id":"d","text":"a novelist creating fantasy characters"}]'::jsonb,'"b"'::jsonb,'The passage supports “someone planning to take part or affected by the arrangement”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER3','Weather Warning for Sports Day','Weather Warning for Sports Day
SCHOOL MESSAGE

Date/Time: Friday 27 June, decision at 7:00 a.m.
Place: school website and parent app

What to know
• Do not travel until the final notice is posted.
• Activities include indoor lessons if the event is postponed.
• Please check the official update before leaving home.

Important
Places for organised activities may be limited. Follow staff instructions and check official messages if conditions change. Keep this notice so that you can confirm the arrangements before travelling.

Question: What is the purpose of the text?','[{"id":"a","text":"to give clear practical information and required actions"},{"id":"b","text":"to describe a dream in detail"},{"id":"c","text":"to persuade readers to buy a toy"},{"id":"d","text":"to retell a traditional tale"}]'::jsonb,'"a"'::jsonb,'The passage supports “to give clear practical information and required actions”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','The Pocket of Morning','The Pocket of Morning

A silver line slips under my door,
then climbs the chair and crosses the floor.
I keep no key, yet day comes in,
a quiet guest with a golden grin.

Question: What is the poem mainly about?','[{"id":"a","text":"morning"},{"id":"b","text":"a set of school rules"},{"id":"c","text":"a scientific experiment"},{"id":"d","text":"a newspaper report"}]'::jsonb,'"a"'::jsonb,'The passage supports “morning”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','The Pocket of Morning','The Pocket of Morning

A silver line slips under my door,
then climbs the chair and crosses the floor.
I keep no key, yet day comes in,
a quiet guest with a golden grin.

Question: Which description best matches the central image?','[{"id":"a","text":"a formal list of facts"},{"id":"b","text":"a warning with no imagery"},{"id":"c","text":"a set of travel directions"},{"id":"d","text":"light entering a room"}]'::jsonb,'"d"'::jsonb,'The passage supports “light entering a room”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','The Pocket of Morning','The Pocket of Morning

A silver line slips under my door,
then climbs the chair and crosses the floor.
I keep no key, yet day comes in,
a quiet guest with a golden grin.

Question: What is the mood of the poem?','[{"id":"a","text":"confusing"},{"id":"b","text":"official"},{"id":"c","text":"hopeful"},{"id":"d","text":"angry"}]'::jsonb,'"c"'::jsonb,'The passage supports “hopeful”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','The Pocket of Morning','The Pocket of Morning

A silver line slips under my door,
then climbs the chair and crosses the floor.
I keep no key, yet day comes in,
a quiet guest with a golden grin.

Question: Which poetic device is especially important?','[{"id":"a","text":"a legal definition"},{"id":"b","text":"personification"},{"id":"c","text":"a table of results"},{"id":"d","text":"a numbered procedure"}]'::jsonb,'"b"'::jsonb,'The passage supports “personification”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','The Pocket of Morning','The Pocket of Morning

A silver line slips under my door,
then climbs the chair and crosses the floor.
I keep no key, yet day comes in,
a quiet guest with a golden grin.

Question: What theme is suggested?','[{"id":"a","text":"a new beginning"},{"id":"b","text":"Rules matter more than feelings."},{"id":"c","text":"Every journey should be avoided."},{"id":"d","text":"Only expensive things have value."}]'::jsonb,'"a"'::jsonb,'The passage supports “a new beginning”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','The Pocket of Morning','The Pocket of Morning

A silver line slips under my door,
then climbs the chair and crosses the floor.
I keep no key, yet day comes in,
a quiet guest with a golden grin.

Question: Why does the poet use short lines?','[{"id":"a","text":"to hide the title"},{"id":"b","text":"to turn the poem into a timetable"},{"id":"c","text":"to remove all sound patterns"},{"id":"d","text":"to create rhythm and focus attention on each image"}]'::jsonb,'"d"'::jsonb,'The passage supports “to create rhythm and focus attention on each image”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','The Pocket of Morning','The Pocket of Morning

A silver line slips under my door,
then climbs the chair and crosses the floor.
I keep no key, yet day comes in,
a quiet guest with a golden grin.

Question: What does the poem invite the reader to do?','[{"id":"a","text":"compare prices in a shop"},{"id":"b","text":"follow a cooking recipe"},{"id":"c","text":"notice meaning in an ordinary experience"},{"id":"d","text":"memorise a safety code"}]'::jsonb,'"c"'::jsonb,'The passage supports “notice meaning in an ordinary experience”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','The Pocket of Morning','The Pocket of Morning

A silver line slips under my door,
then climbs the chair and crosses the floor.
I keep no key, yet day comes in,
a quiet guest with a golden grin.

Question: Which sense is most strongly used?','[{"id":"a","text":"no senses at all"},{"id":"b","text":"sight or sound, depending on the image"},{"id":"c","text":"taste only"},{"id":"d","text":"balance only"}]'::jsonb,'"b"'::jsonb,'The passage supports “sight or sound, depending on the image”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','The Pocket of Morning','The Pocket of Morning

A silver line slips under my door,
then climbs the chair and crosses the floor.
I keep no key, yet day comes in,
a quiet guest with a golden grin.

Question: How does the title help the reader?','[{"id":"a","text":"It introduces the poem’s central subject or image."},{"id":"b","text":"It gives the poet’s address."},{"id":"c","text":"It explains every line literally."},{"id":"d","text":"It lists all possible answers."}]'::jsonb,'"a"'::jsonb,'The passage supports “It introduces the poem’s central subject or image.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','The Pocket of Morning','The Pocket of Morning

A silver line slips under my door,
then climbs the chair and crosses the floor.
I keep no key, yet day comes in,
a quiet guest with a golden grin.

Question: Which statement best describes the speaker?','[{"id":"a","text":"The speaker reports only measurements."},{"id":"b","text":"The speaker gives orders to a large team."},{"id":"c","text":"The speaker refuses to notice the surroundings."},{"id":"d","text":"The speaker observes the subject closely and responds with feeling."}]'::jsonb,'"d"'::jsonb,'The passage supports “The speaker observes the subject closely and responds with feeling.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Rain on the Roof','Rain on the Roof

Tap on the tiles, then hurry, then slow,
a thousand small footsteps come and go.
The windows listen; the old house hums,
and waits for the patch of blue that comes.

Question: What is the poem mainly about?','[{"id":"a","text":"a set of school rules"},{"id":"b","text":"a scientific experiment"},{"id":"c","text":"a newspaper report"},{"id":"d","text":"rain"}]'::jsonb,'"d"'::jsonb,'The passage supports “rain”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Rain on the Roof','Rain on the Roof

Tap on the tiles, then hurry, then slow,
a thousand small footsteps come and go.
The windows listen; the old house hums,
and waits for the patch of blue that comes.

Question: Which description best matches the central image?','[{"id":"a","text":"a warning with no imagery"},{"id":"b","text":"a set of travel directions"},{"id":"c","text":"changing rainfall"},{"id":"d","text":"a formal list of facts"}]'::jsonb,'"c"'::jsonb,'The passage supports “changing rainfall”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Rain on the Roof','Rain on the Roof

Tap on the tiles, then hurry, then slow,
a thousand small footsteps come and go.
The windows listen; the old house hums,
and waits for the patch of blue that comes.

Question: What is the mood of the poem?','[{"id":"a","text":"official"},{"id":"b","text":"peaceful"},{"id":"c","text":"angry"},{"id":"d","text":"confusing"}]'::jsonb,'"b"'::jsonb,'The passage supports “peaceful”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Rain on the Roof','Rain on the Roof

Tap on the tiles, then hurry, then slow,
a thousand small footsteps come and go.
The windows listen; the old house hums,
and waits for the patch of blue that comes.

Question: Which poetic device is especially important?','[{"id":"a","text":"sound imagery"},{"id":"b","text":"a table of results"},{"id":"c","text":"a numbered procedure"},{"id":"d","text":"a legal definition"}]'::jsonb,'"a"'::jsonb,'The passage supports “sound imagery”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Rain on the Roof','Rain on the Roof

Tap on the tiles, then hurry, then slow,
a thousand small footsteps come and go.
The windows listen; the old house hums,
and waits for the patch of blue that comes.

Question: What theme is suggested?','[{"id":"a","text":"Rules matter more than feelings."},{"id":"b","text":"Every journey should be avoided."},{"id":"c","text":"Only expensive things have value."},{"id":"d","text":"waiting patiently"}]'::jsonb,'"d"'::jsonb,'The passage supports “waiting patiently”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Rain on the Roof','Rain on the Roof

Tap on the tiles, then hurry, then slow,
a thousand small footsteps come and go.
The windows listen; the old house hums,
and waits for the patch of blue that comes.

Question: Why does the poet use short lines?','[{"id":"a","text":"to turn the poem into a timetable"},{"id":"b","text":"to remove all sound patterns"},{"id":"c","text":"to create rhythm and focus attention on each image"},{"id":"d","text":"to hide the title"}]'::jsonb,'"c"'::jsonb,'The passage supports “to create rhythm and focus attention on each image”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Rain on the Roof','Rain on the Roof

Tap on the tiles, then hurry, then slow,
a thousand small footsteps come and go.
The windows listen; the old house hums,
and waits for the patch of blue that comes.

Question: What does the poem invite the reader to do?','[{"id":"a","text":"follow a cooking recipe"},{"id":"b","text":"notice meaning in an ordinary experience"},{"id":"c","text":"memorise a safety code"},{"id":"d","text":"compare prices in a shop"}]'::jsonb,'"b"'::jsonb,'The passage supports “notice meaning in an ordinary experience”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Rain on the Roof','Rain on the Roof

Tap on the tiles, then hurry, then slow,
a thousand small footsteps come and go.
The windows listen; the old house hums,
and waits for the patch of blue that comes.

Question: Which sense is most strongly used?','[{"id":"a","text":"sight or sound, depending on the image"},{"id":"b","text":"taste only"},{"id":"c","text":"balance only"},{"id":"d","text":"no senses at all"}]'::jsonb,'"a"'::jsonb,'The passage supports “sight or sound, depending on the image”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Rain on the Roof','Rain on the Roof

Tap on the tiles, then hurry, then slow,
a thousand small footsteps come and go.
The windows listen; the old house hums,
and waits for the patch of blue that comes.

Question: How does the title help the reader?','[{"id":"a","text":"It gives the poet’s address."},{"id":"b","text":"It explains every line literally."},{"id":"c","text":"It lists all possible answers."},{"id":"d","text":"It introduces the poem’s central subject or image."}]'::jsonb,'"d"'::jsonb,'The passage supports “It introduces the poem’s central subject or image.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Rain on the Roof','Rain on the Roof

Tap on the tiles, then hurry, then slow,
a thousand small footsteps come and go.
The windows listen; the old house hums,
and waits for the patch of blue that comes.

Question: Which statement best describes the speaker?','[{"id":"a","text":"The speaker gives orders to a large team."},{"id":"b","text":"The speaker refuses to notice the surroundings."},{"id":"c","text":"The speaker observes the subject closely and responds with feeling."},{"id":"d","text":"The speaker reports only measurements."}]'::jsonb,'"c"'::jsonb,'The passage supports “The speaker observes the subject closely and responds with feeling.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','The Paper Boat','The Paper Boat

I set my small white traveller free
where gutter streams run to the sea.
It turns at stones but carries on,
a folded dream before the dawn.

Question: What is the poem mainly about?','[{"id":"a","text":"a scientific experiment"},{"id":"b","text":"a newspaper report"},{"id":"c","text":"a paper boat"},{"id":"d","text":"a set of school rules"}]'::jsonb,'"c"'::jsonb,'The passage supports “a paper boat”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','The Paper Boat','The Paper Boat

I set my small white traveller free
where gutter streams run to the sea.
It turns at stones but carries on,
a folded dream before the dawn.

Question: Which description best matches the central image?','[{"id":"a","text":"a set of travel directions"},{"id":"b","text":"a fragile boat continuing its journey"},{"id":"c","text":"a formal list of facts"},{"id":"d","text":"a warning with no imagery"}]'::jsonb,'"b"'::jsonb,'The passage supports “a fragile boat continuing its journey”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','The Paper Boat','The Paper Boat

I set my small white traveller free
where gutter streams run to the sea.
It turns at stones but carries on,
a folded dream before the dawn.

Question: What is the mood of the poem?','[{"id":"a","text":"adventurous"},{"id":"b","text":"angry"},{"id":"c","text":"confusing"},{"id":"d","text":"official"}]'::jsonb,'"a"'::jsonb,'The passage supports “adventurous”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','The Paper Boat','The Paper Boat

I set my small white traveller free
where gutter streams run to the sea.
It turns at stones but carries on,
a folded dream before the dawn.

Question: Which poetic device is especially important?','[{"id":"a","text":"a table of results"},{"id":"b","text":"a numbered procedure"},{"id":"c","text":"a legal definition"},{"id":"d","text":"metaphor"}]'::jsonb,'"d"'::jsonb,'The passage supports “metaphor”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','The Paper Boat','The Paper Boat

I set my small white traveller free
where gutter streams run to the sea.
It turns at stones but carries on,
a folded dream before the dawn.

Question: What theme is suggested?','[{"id":"a","text":"Every journey should be avoided."},{"id":"b","text":"Only expensive things have value."},{"id":"c","text":"courage despite difficulty"},{"id":"d","text":"Rules matter more than feelings."}]'::jsonb,'"c"'::jsonb,'The passage supports “courage despite difficulty”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','The Paper Boat','The Paper Boat

I set my small white traveller free
where gutter streams run to the sea.
It turns at stones but carries on,
a folded dream before the dawn.

Question: Why does the poet use short lines?','[{"id":"a","text":"to remove all sound patterns"},{"id":"b","text":"to create rhythm and focus attention on each image"},{"id":"c","text":"to hide the title"},{"id":"d","text":"to turn the poem into a timetable"}]'::jsonb,'"b"'::jsonb,'The passage supports “to create rhythm and focus attention on each image”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','The Paper Boat','The Paper Boat

I set my small white traveller free
where gutter streams run to the sea.
It turns at stones but carries on,
a folded dream before the dawn.

Question: What does the poem invite the reader to do?','[{"id":"a","text":"notice meaning in an ordinary experience"},{"id":"b","text":"memorise a safety code"},{"id":"c","text":"compare prices in a shop"},{"id":"d","text":"follow a cooking recipe"}]'::jsonb,'"a"'::jsonb,'The passage supports “notice meaning in an ordinary experience”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','The Paper Boat','The Paper Boat

I set my small white traveller free
where gutter streams run to the sea.
It turns at stones but carries on,
a folded dream before the dawn.

Question: Which sense is most strongly used?','[{"id":"a","text":"taste only"},{"id":"b","text":"balance only"},{"id":"c","text":"no senses at all"},{"id":"d","text":"sight or sound, depending on the image"}]'::jsonb,'"d"'::jsonb,'The passage supports “sight or sound, depending on the image”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','The Paper Boat','The Paper Boat

I set my small white traveller free
where gutter streams run to the sea.
It turns at stones but carries on,
a folded dream before the dawn.

Question: How does the title help the reader?','[{"id":"a","text":"It explains every line literally."},{"id":"b","text":"It lists all possible answers."},{"id":"c","text":"It introduces the poem’s central subject or image."},{"id":"d","text":"It gives the poet’s address."}]'::jsonb,'"c"'::jsonb,'The passage supports “It introduces the poem’s central subject or image.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','The Paper Boat','The Paper Boat

I set my small white traveller free
where gutter streams run to the sea.
It turns at stones but carries on,
a folded dream before the dawn.

Question: Which statement best describes the speaker?','[{"id":"a","text":"The speaker refuses to notice the surroundings."},{"id":"b","text":"The speaker observes the subject closely and responds with feeling."},{"id":"c","text":"The speaker reports only measurements."},{"id":"d","text":"The speaker gives orders to a large team."}]'::jsonb,'"b"'::jsonb,'The passage supports “The speaker observes the subject closely and responds with feeling.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Grandfather’s Clock','Grandfather’s Clock

It clears its throat at half past four,
and counts the shadows by the door.
Though Grandad’s chair is empty now,
the clock remembers when and how.

Question: What is the poem mainly about?','[{"id":"a","text":"a newspaper report"},{"id":"b","text":"an old clock"},{"id":"c","text":"a set of school rules"},{"id":"d","text":"a scientific experiment"}]'::jsonb,'"b"'::jsonb,'The passage supports “an old clock”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Grandfather’s Clock','Grandfather’s Clock

It clears its throat at half past four,
and counts the shadows by the door.
Though Grandad’s chair is empty now,
the clock remembers when and how.

Question: Which description best matches the central image?','[{"id":"a","text":"memory and an old clock"},{"id":"b","text":"a formal list of facts"},{"id":"c","text":"a warning with no imagery"},{"id":"d","text":"a set of travel directions"}]'::jsonb,'"a"'::jsonb,'The passage supports “memory and an old clock”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Grandfather’s Clock','Grandfather’s Clock

It clears its throat at half past four,
and counts the shadows by the door.
Though Grandad’s chair is empty now,
the clock remembers when and how.

Question: What is the mood of the poem?','[{"id":"a","text":"angry"},{"id":"b","text":"confusing"},{"id":"c","text":"official"},{"id":"d","text":"reflective"}]'::jsonb,'"d"'::jsonb,'The passage supports “reflective”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Grandfather’s Clock','Grandfather’s Clock

It clears its throat at half past four,
and counts the shadows by the door.
Though Grandad’s chair is empty now,
the clock remembers when and how.

Question: Which poetic device is especially important?','[{"id":"a","text":"a numbered procedure"},{"id":"b","text":"a legal definition"},{"id":"c","text":"personification"},{"id":"d","text":"a table of results"}]'::jsonb,'"c"'::jsonb,'The passage supports “personification”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Grandfather’s Clock','Grandfather’s Clock

It clears its throat at half past four,
and counts the shadows by the door.
Though Grandad’s chair is empty now,
the clock remembers when and how.

Question: What theme is suggested?','[{"id":"a","text":"Only expensive things have value."},{"id":"b","text":"remembering someone loved"},{"id":"c","text":"Rules matter more than feelings."},{"id":"d","text":"Every journey should be avoided."}]'::jsonb,'"b"'::jsonb,'The passage supports “remembering someone loved”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Grandfather’s Clock','Grandfather’s Clock

It clears its throat at half past four,
and counts the shadows by the door.
Though Grandad’s chair is empty now,
the clock remembers when and how.

Question: Why does the poet use short lines?','[{"id":"a","text":"to create rhythm and focus attention on each image"},{"id":"b","text":"to hide the title"},{"id":"c","text":"to turn the poem into a timetable"},{"id":"d","text":"to remove all sound patterns"}]'::jsonb,'"a"'::jsonb,'The passage supports “to create rhythm and focus attention on each image”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Grandfather’s Clock','Grandfather’s Clock

It clears its throat at half past four,
and counts the shadows by the door.
Though Grandad’s chair is empty now,
the clock remembers when and how.

Question: What does the poem invite the reader to do?','[{"id":"a","text":"memorise a safety code"},{"id":"b","text":"compare prices in a shop"},{"id":"c","text":"follow a cooking recipe"},{"id":"d","text":"notice meaning in an ordinary experience"}]'::jsonb,'"d"'::jsonb,'The passage supports “notice meaning in an ordinary experience”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Grandfather’s Clock','Grandfather’s Clock

It clears its throat at half past four,
and counts the shadows by the door.
Though Grandad’s chair is empty now,
the clock remembers when and how.

Question: Which sense is most strongly used?','[{"id":"a","text":"balance only"},{"id":"b","text":"no senses at all"},{"id":"c","text":"sight or sound, depending on the image"},{"id":"d","text":"taste only"}]'::jsonb,'"c"'::jsonb,'The passage supports “sight or sound, depending on the image”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Grandfather’s Clock','Grandfather’s Clock

It clears its throat at half past four,
and counts the shadows by the door.
Though Grandad’s chair is empty now,
the clock remembers when and how.

Question: How does the title help the reader?','[{"id":"a","text":"It lists all possible answers."},{"id":"b","text":"It introduces the poem’s central subject or image."},{"id":"c","text":"It gives the poet’s address."},{"id":"d","text":"It explains every line literally."}]'::jsonb,'"b"'::jsonb,'The passage supports “It introduces the poem’s central subject or image.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Grandfather’s Clock','Grandfather’s Clock

It clears its throat at half past four,
and counts the shadows by the door.
Though Grandad’s chair is empty now,
the clock remembers when and how.

Question: Which statement best describes the speaker?','[{"id":"a","text":"The speaker observes the subject closely and responds with feeling."},{"id":"b","text":"The speaker reports only measurements."},{"id":"c","text":"The speaker gives orders to a large team."},{"id":"d","text":"The speaker refuses to notice the surroundings."}]'::jsonb,'"a"'::jsonb,'The passage supports “The speaker observes the subject closely and responds with feeling.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Library at Lunchtime','Library at Lunchtime

Outside, the playground leaps and calls;
inside, ships sail between the walls.
I turn one page—the room grows wide,
and carry distant worlds outside.

Question: What is the poem mainly about?','[{"id":"a","text":"a library"},{"id":"b","text":"a set of school rules"},{"id":"c","text":"a scientific experiment"},{"id":"d","text":"a newspaper report"}]'::jsonb,'"a"'::jsonb,'The passage supports “a library”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Library at Lunchtime','Library at Lunchtime

Outside, the playground leaps and calls;
inside, ships sail between the walls.
I turn one page—the room grows wide,
and carry distant worlds outside.

Question: Which description best matches the central image?','[{"id":"a","text":"a formal list of facts"},{"id":"b","text":"a warning with no imagery"},{"id":"c","text":"a set of travel directions"},{"id":"d","text":"reading as a journey"}]'::jsonb,'"d"'::jsonb,'The passage supports “reading as a journey”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Library at Lunchtime','Library at Lunchtime

Outside, the playground leaps and calls;
inside, ships sail between the walls.
I turn one page—the room grows wide,
and carry distant worlds outside.

Question: What is the mood of the poem?','[{"id":"a","text":"confusing"},{"id":"b","text":"official"},{"id":"c","text":"delighted"},{"id":"d","text":"angry"}]'::jsonb,'"c"'::jsonb,'The passage supports “delighted”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Library at Lunchtime','Library at Lunchtime

Outside, the playground leaps and calls;
inside, ships sail between the walls.
I turn one page—the room grows wide,
and carry distant worlds outside.

Question: Which poetic device is especially important?','[{"id":"a","text":"a legal definition"},{"id":"b","text":"metaphor"},{"id":"c","text":"a table of results"},{"id":"d","text":"a numbered procedure"}]'::jsonb,'"b"'::jsonb,'The passage supports “metaphor”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Library at Lunchtime','Library at Lunchtime

Outside, the playground leaps and calls;
inside, ships sail between the walls.
I turn one page—the room grows wide,
and carry distant worlds outside.

Question: What theme is suggested?','[{"id":"a","text":"books open new worlds"},{"id":"b","text":"Rules matter more than feelings."},{"id":"c","text":"Every journey should be avoided."},{"id":"d","text":"Only expensive things have value."}]'::jsonb,'"a"'::jsonb,'The passage supports “books open new worlds”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Library at Lunchtime','Library at Lunchtime

Outside, the playground leaps and calls;
inside, ships sail between the walls.
I turn one page—the room grows wide,
and carry distant worlds outside.

Question: Why does the poet use short lines?','[{"id":"a","text":"to hide the title"},{"id":"b","text":"to turn the poem into a timetable"},{"id":"c","text":"to remove all sound patterns"},{"id":"d","text":"to create rhythm and focus attention on each image"}]'::jsonb,'"d"'::jsonb,'The passage supports “to create rhythm and focus attention on each image”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Library at Lunchtime','Library at Lunchtime

Outside, the playground leaps and calls;
inside, ships sail between the walls.
I turn one page—the room grows wide,
and carry distant worlds outside.

Question: What does the poem invite the reader to do?','[{"id":"a","text":"compare prices in a shop"},{"id":"b","text":"follow a cooking recipe"},{"id":"c","text":"notice meaning in an ordinary experience"},{"id":"d","text":"memorise a safety code"}]'::jsonb,'"c"'::jsonb,'The passage supports “notice meaning in an ordinary experience”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Library at Lunchtime','Library at Lunchtime

Outside, the playground leaps and calls;
inside, ships sail between the walls.
I turn one page—the room grows wide,
and carry distant worlds outside.

Question: Which sense is most strongly used?','[{"id":"a","text":"no senses at all"},{"id":"b","text":"sight or sound, depending on the image"},{"id":"c","text":"taste only"},{"id":"d","text":"balance only"}]'::jsonb,'"b"'::jsonb,'The passage supports “sight or sound, depending on the image”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Library at Lunchtime','Library at Lunchtime

Outside, the playground leaps and calls;
inside, ships sail between the walls.
I turn one page—the room grows wide,
and carry distant worlds outside.

Question: How does the title help the reader?','[{"id":"a","text":"It introduces the poem’s central subject or image."},{"id":"b","text":"It gives the poet’s address."},{"id":"c","text":"It explains every line literally."},{"id":"d","text":"It lists all possible answers."}]'::jsonb,'"a"'::jsonb,'The passage supports “It introduces the poem’s central subject or image.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Library at Lunchtime','Library at Lunchtime

Outside, the playground leaps and calls;
inside, ships sail between the walls.
I turn one page—the room grows wide,
and carry distant worlds outside.

Question: Which statement best describes the speaker?','[{"id":"a","text":"The speaker reports only measurements."},{"id":"b","text":"The speaker gives orders to a large team."},{"id":"c","text":"The speaker refuses to notice the surroundings."},{"id":"d","text":"The speaker observes the subject closely and responds with feeling."}]'::jsonb,'"d"'::jsonb,'The passage supports “The speaker observes the subject closely and responds with feeling.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Winter Tree','Winter Tree

No coat of green, no bird-built crown,
its patient branches settle down.
Beneath the frost, the roots still know
the secret time to wake and grow.

Question: What is the poem mainly about?','[{"id":"a","text":"a set of school rules"},{"id":"b","text":"a scientific experiment"},{"id":"c","text":"a newspaper report"},{"id":"d","text":"a bare tree"}]'::jsonb,'"d"'::jsonb,'The passage supports “a bare tree”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Winter Tree','Winter Tree

No coat of green, no bird-built crown,
its patient branches settle down.
Beneath the frost, the roots still know
the secret time to wake and grow.

Question: Which description best matches the central image?','[{"id":"a","text":"a warning with no imagery"},{"id":"b","text":"a set of travel directions"},{"id":"c","text":"life continuing beneath winter"},{"id":"d","text":"a formal list of facts"}]'::jsonb,'"c"'::jsonb,'The passage supports “life continuing beneath winter”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Winter Tree','Winter Tree

No coat of green, no bird-built crown,
its patient branches settle down.
Beneath the frost, the roots still know
the secret time to wake and grow.

Question: What is the mood of the poem?','[{"id":"a","text":"official"},{"id":"b","text":"hopeful"},{"id":"c","text":"angry"},{"id":"d","text":"confusing"}]'::jsonb,'"b"'::jsonb,'The passage supports “hopeful”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Winter Tree','Winter Tree

No coat of green, no bird-built crown,
its patient branches settle down.
Beneath the frost, the roots still know
the secret time to wake and grow.

Question: Which poetic device is especially important?','[{"id":"a","text":"contrast"},{"id":"b","text":"a table of results"},{"id":"c","text":"a numbered procedure"},{"id":"d","text":"a legal definition"}]'::jsonb,'"a"'::jsonb,'The passage supports “contrast”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Winter Tree','Winter Tree

No coat of green, no bird-built crown,
its patient branches settle down.
Beneath the frost, the roots still know
the secret time to wake and grow.

Question: What theme is suggested?','[{"id":"a","text":"Rules matter more than feelings."},{"id":"b","text":"Every journey should be avoided."},{"id":"c","text":"Only expensive things have value."},{"id":"d","text":"change can be hidden"}]'::jsonb,'"d"'::jsonb,'The passage supports “change can be hidden”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Winter Tree','Winter Tree

No coat of green, no bird-built crown,
its patient branches settle down.
Beneath the frost, the roots still know
the secret time to wake and grow.

Question: Why does the poet use short lines?','[{"id":"a","text":"to turn the poem into a timetable"},{"id":"b","text":"to remove all sound patterns"},{"id":"c","text":"to create rhythm and focus attention on each image"},{"id":"d","text":"to hide the title"}]'::jsonb,'"c"'::jsonb,'The passage supports “to create rhythm and focus attention on each image”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Winter Tree','Winter Tree

No coat of green, no bird-built crown,
its patient branches settle down.
Beneath the frost, the roots still know
the secret time to wake and grow.

Question: What does the poem invite the reader to do?','[{"id":"a","text":"follow a cooking recipe"},{"id":"b","text":"notice meaning in an ordinary experience"},{"id":"c","text":"memorise a safety code"},{"id":"d","text":"compare prices in a shop"}]'::jsonb,'"b"'::jsonb,'The passage supports “notice meaning in an ordinary experience”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Winter Tree','Winter Tree

No coat of green, no bird-built crown,
its patient branches settle down.
Beneath the frost, the roots still know
the secret time to wake and grow.

Question: Which sense is most strongly used?','[{"id":"a","text":"sight or sound, depending on the image"},{"id":"b","text":"taste only"},{"id":"c","text":"balance only"},{"id":"d","text":"no senses at all"}]'::jsonb,'"a"'::jsonb,'The passage supports “sight or sound, depending on the image”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Winter Tree','Winter Tree

No coat of green, no bird-built crown,
its patient branches settle down.
Beneath the frost, the roots still know
the secret time to wake and grow.

Question: How does the title help the reader?','[{"id":"a","text":"It gives the poet’s address."},{"id":"b","text":"It explains every line literally."},{"id":"c","text":"It lists all possible answers."},{"id":"d","text":"It introduces the poem’s central subject or image."}]'::jsonb,'"d"'::jsonb,'The passage supports “It introduces the poem’s central subject or image.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Winter Tree','Winter Tree

No coat of green, no bird-built crown,
its patient branches settle down.
Beneath the frost, the roots still know
the secret time to wake and grow.

Question: Which statement best describes the speaker?','[{"id":"a","text":"The speaker gives orders to a large team."},{"id":"b","text":"The speaker refuses to notice the surroundings."},{"id":"c","text":"The speaker observes the subject closely and responds with feeling."},{"id":"d","text":"The speaker reports only measurements."}]'::jsonb,'"c"'::jsonb,'The passage supports “The speaker observes the subject closely and responds with feeling.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Market Sounds','Market Sounds

Coins ring bright and baskets slide,
voices meet like a turning tide.
Spices wake in the warming air;
the morning builds a city there.

Question: What is the poem mainly about?','[{"id":"a","text":"a scientific experiment"},{"id":"b","text":"a newspaper report"},{"id":"c","text":"a street market"},{"id":"d","text":"a set of school rules"}]'::jsonb,'"c"'::jsonb,'The passage supports “a street market”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Market Sounds','Market Sounds

Coins ring bright and baskets slide,
voices meet like a turning tide.
Spices wake in the warming air;
the morning builds a city there.

Question: Which description best matches the central image?','[{"id":"a","text":"a set of travel directions"},{"id":"b","text":"the energy of a market"},{"id":"c","text":"a formal list of facts"},{"id":"d","text":"a warning with no imagery"}]'::jsonb,'"b"'::jsonb,'The passage supports “the energy of a market”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Market Sounds','Market Sounds

Coins ring bright and baskets slide,
voices meet like a turning tide.
Spices wake in the warming air;
the morning builds a city there.

Question: What is the mood of the poem?','[{"id":"a","text":"lively"},{"id":"b","text":"angry"},{"id":"c","text":"confusing"},{"id":"d","text":"official"}]'::jsonb,'"a"'::jsonb,'The passage supports “lively”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Market Sounds','Market Sounds

Coins ring bright and baskets slide,
voices meet like a turning tide.
Spices wake in the warming air;
the morning builds a city there.

Question: Which poetic device is especially important?','[{"id":"a","text":"a table of results"},{"id":"b","text":"a numbered procedure"},{"id":"c","text":"a legal definition"},{"id":"d","text":"simile"}]'::jsonb,'"d"'::jsonb,'The passage supports “simile”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Market Sounds','Market Sounds

Coins ring bright and baskets slide,
voices meet like a turning tide.
Spices wake in the warming air;
the morning builds a city there.

Question: What theme is suggested?','[{"id":"a","text":"Every journey should be avoided."},{"id":"b","text":"Only expensive things have value."},{"id":"c","text":"ordinary places can feel vibrant"},{"id":"d","text":"Rules matter more than feelings."}]'::jsonb,'"c"'::jsonb,'The passage supports “ordinary places can feel vibrant”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Market Sounds','Market Sounds

Coins ring bright and baskets slide,
voices meet like a turning tide.
Spices wake in the warming air;
the morning builds a city there.

Question: Why does the poet use short lines?','[{"id":"a","text":"to remove all sound patterns"},{"id":"b","text":"to create rhythm and focus attention on each image"},{"id":"c","text":"to hide the title"},{"id":"d","text":"to turn the poem into a timetable"}]'::jsonb,'"b"'::jsonb,'The passage supports “to create rhythm and focus attention on each image”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Market Sounds','Market Sounds

Coins ring bright and baskets slide,
voices meet like a turning tide.
Spices wake in the warming air;
the morning builds a city there.

Question: What does the poem invite the reader to do?','[{"id":"a","text":"notice meaning in an ordinary experience"},{"id":"b","text":"memorise a safety code"},{"id":"c","text":"compare prices in a shop"},{"id":"d","text":"follow a cooking recipe"}]'::jsonb,'"a"'::jsonb,'The passage supports “notice meaning in an ordinary experience”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Market Sounds','Market Sounds

Coins ring bright and baskets slide,
voices meet like a turning tide.
Spices wake in the warming air;
the morning builds a city there.

Question: Which sense is most strongly used?','[{"id":"a","text":"taste only"},{"id":"b","text":"balance only"},{"id":"c","text":"no senses at all"},{"id":"d","text":"sight or sound, depending on the image"}]'::jsonb,'"d"'::jsonb,'The passage supports “sight or sound, depending on the image”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Market Sounds','Market Sounds

Coins ring bright and baskets slide,
voices meet like a turning tide.
Spices wake in the warming air;
the morning builds a city there.

Question: How does the title help the reader?','[{"id":"a","text":"It explains every line literally."},{"id":"b","text":"It lists all possible answers."},{"id":"c","text":"It introduces the poem’s central subject or image."},{"id":"d","text":"It gives the poet’s address."}]'::jsonb,'"c"'::jsonb,'The passage supports “It introduces the poem’s central subject or image.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Market Sounds','Market Sounds

Coins ring bright and baskets slide,
voices meet like a turning tide.
Spices wake in the warming air;
the morning builds a city there.

Question: Which statement best describes the speaker?','[{"id":"a","text":"The speaker refuses to notice the surroundings."},{"id":"b","text":"The speaker observes the subject closely and responds with feeling."},{"id":"c","text":"The speaker reports only measurements."},{"id":"d","text":"The speaker gives orders to a large team."}]'::jsonb,'"b"'::jsonb,'The passage supports “The speaker observes the subject closely and responds with feeling.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Shadow Friend','Shadow Friend

You stretch when afternoon is low,
you shrink at noon, then home we go.
You never speak or choose the way,
yet copy every game I play.

Question: What is the poem mainly about?','[{"id":"a","text":"a newspaper report"},{"id":"b","text":"a shadow"},{"id":"c","text":"a set of school rules"},{"id":"d","text":"a scientific experiment"}]'::jsonb,'"b"'::jsonb,'The passage supports “a shadow”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Shadow Friend','Shadow Friend

You stretch when afternoon is low,
you shrink at noon, then home we go.
You never speak or choose the way,
yet copy every game I play.

Question: Which description best matches the central image?','[{"id":"a","text":"a child’s shadow"},{"id":"b","text":"a formal list of facts"},{"id":"c","text":"a warning with no imagery"},{"id":"d","text":"a set of travel directions"}]'::jsonb,'"a"'::jsonb,'The passage supports “a child’s shadow”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Shadow Friend','Shadow Friend

You stretch when afternoon is low,
you shrink at noon, then home we go.
You never speak or choose the way,
yet copy every game I play.

Question: What is the mood of the poem?','[{"id":"a","text":"angry"},{"id":"b","text":"confusing"},{"id":"c","text":"official"},{"id":"d","text":"playful"}]'::jsonb,'"d"'::jsonb,'The passage supports “playful”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Shadow Friend','Shadow Friend

You stretch when afternoon is low,
you shrink at noon, then home we go.
You never speak or choose the way,
yet copy every game I play.

Question: Which poetic device is especially important?','[{"id":"a","text":"a numbered procedure"},{"id":"b","text":"a legal definition"},{"id":"c","text":"direct address"},{"id":"d","text":"a table of results"}]'::jsonb,'"c"'::jsonb,'The passage supports “direct address”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Shadow Friend','Shadow Friend

You stretch when afternoon is low,
you shrink at noon, then home we go.
You never speak or choose the way,
yet copy every game I play.

Question: What theme is suggested?','[{"id":"a","text":"Only expensive things have value."},{"id":"b","text":"noticing everyday wonders"},{"id":"c","text":"Rules matter more than feelings."},{"id":"d","text":"Every journey should be avoided."}]'::jsonb,'"b"'::jsonb,'The passage supports “noticing everyday wonders”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Shadow Friend','Shadow Friend

You stretch when afternoon is low,
you shrink at noon, then home we go.
You never speak or choose the way,
yet copy every game I play.

Question: Why does the poet use short lines?','[{"id":"a","text":"to create rhythm and focus attention on each image"},{"id":"b","text":"to hide the title"},{"id":"c","text":"to turn the poem into a timetable"},{"id":"d","text":"to remove all sound patterns"}]'::jsonb,'"a"'::jsonb,'The passage supports “to create rhythm and focus attention on each image”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Shadow Friend','Shadow Friend

You stretch when afternoon is low,
you shrink at noon, then home we go.
You never speak or choose the way,
yet copy every game I play.

Question: What does the poem invite the reader to do?','[{"id":"a","text":"memorise a safety code"},{"id":"b","text":"compare prices in a shop"},{"id":"c","text":"follow a cooking recipe"},{"id":"d","text":"notice meaning in an ordinary experience"}]'::jsonb,'"d"'::jsonb,'The passage supports “notice meaning in an ordinary experience”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER4','Shadow Friend','Shadow Friend

You stretch when afternoon is low,
you shrink at noon, then home we go.
You never speak or choose the way,
yet copy every game I play.

Question: Which sense is most strongly used?','[{"id":"a","text":"balance only"},{"id":"b","text":"no senses at all"},{"id":"c","text":"sight or sound, depending on the image"},{"id":"d","text":"taste only"}]'::jsonb,'"c"'::jsonb,'The passage supports “sight or sound, depending on the image”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER4','Shadow Friend','Shadow Friend

You stretch when afternoon is low,
you shrink at noon, then home we go.
You never speak or choose the way,
yet copy every game I play.

Question: How does the title help the reader?','[{"id":"a","text":"It lists all possible answers."},{"id":"b","text":"It introduces the poem’s central subject or image."},{"id":"c","text":"It gives the poet’s address."},{"id":"d","text":"It explains every line literally."}]'::jsonb,'"b"'::jsonb,'The passage supports “It introduces the poem’s central subject or image.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER4','Shadow Friend','Shadow Friend

You stretch when afternoon is low,
you shrink at noon, then home we go.
You never speak or choose the way,
yet copy every game I play.

Question: Which statement best describes the speaker?','[{"id":"a","text":"The speaker observes the subject closely and responds with feeling."},{"id":"b","text":"The speaker reports only measurements."},{"id":"c","text":"The speaker gives orders to a large team."},{"id":"d","text":"The speaker refuses to notice the surroundings."}]'::jsonb,'"a"'::jsonb,'The passage supports “The speaker observes the subject closely and responds with feeling.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','A Car-Free Street near School','A Car-Free Street near School

People often disagree about streets near schools. I believe we should consider closing one short street to cars at arrival and dismissal times. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it would reduce danger and make the air cleaner. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that some families need cars because of distance or disability. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to trial the plan for one month while keeping an access route. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What issue does the writer discuss?','[{"id":"a","text":"streets near schools"},{"id":"b","text":"how to train for a professional sport"},{"id":"c","text":"the plot of a fantasy film"},{"id":"d","text":"a recipe for a celebration cake"}]'::jsonb,'"a"'::jsonb,'The passage supports “streets near schools”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','A Car-Free Street near School','A Car-Free Street near School

People often disagree about streets near schools. I believe we should consider closing one short street to cars at arrival and dismissal times. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it would reduce danger and make the air cleaner. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that some families need cars because of distance or disability. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to trial the plan for one month while keeping an access route. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer propose?','[{"id":"a","text":"making an immediate permanent change without evidence"},{"id":"b","text":"ignoring the issue completely"},{"id":"c","text":"allowing only one person to decide"},{"id":"d","text":"closing one short street to cars at arrival and dismissal times"}]'::jsonb,'"d"'::jsonb,'The passage supports “closing one short street to cars at arrival and dismissal times”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','A Car-Free Street near School','A Car-Free Street near School

People often disagree about streets near schools. I believe we should consider closing one short street to cars at arrival and dismissal times. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it would reduce danger and make the air cleaner. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that some families need cars because of distance or disability. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to trial the plan for one month while keeping an access route. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the strongest supporting reason?','[{"id":"a","text":"the issue affects nobody"},{"id":"b","text":"evidence should never be collected"},{"id":"c","text":"it would reduce danger and make the air cleaner"},{"id":"d","text":"the idea has no possible benefit"}]'::jsonb,'"c"'::jsonb,'The passage supports “it would reduce danger and make the air cleaner”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','A Car-Free Street near School','A Car-Free Street near School

People often disagree about streets near schools. I believe we should consider closing one short street to cars at arrival and dismissal times. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it would reduce danger and make the air cleaner. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that some families need cars because of distance or disability. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to trial the plan for one month while keeping an access route. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which opposing concern is acknowledged?','[{"id":"a","text":"the proposal requires no planning"},{"id":"b","text":"some families need cars because of distance or disability"},{"id":"c","text":"there are no disadvantages"},{"id":"d","text":"all readers already agree"}]'::jsonb,'"b"'::jsonb,'The passage supports “some families need cars because of distance or disability”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','A Car-Free Street near School','A Car-Free Street near School

People often disagree about streets near schools. I believe we should consider closing one short street to cars at arrival and dismissal times. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it would reduce danger and make the air cleaner. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that some families need cars because of distance or disability. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to trial the plan for one month while keeping an access route. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What compromise or next step is suggested?','[{"id":"a","text":"trial the plan for one month while keeping an access route"},{"id":"b","text":"ban further discussion"},{"id":"c","text":"spend all resources immediately"},{"id":"d","text":"hide any negative results"}]'::jsonb,'"a"'::jsonb,'The passage supports “trial the plan for one month while keeping an access route”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','A Car-Free Street near School','A Car-Free Street near School

People often disagree about streets near schools. I believe we should consider closing one short street to cars at arrival and dismissal times. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it would reduce danger and make the air cleaner. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that some families need cars because of distance or disability. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to trial the plan for one month while keeping an access route. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which phrase best describes the writer’s tone?','[{"id":"a","text":"mocking and rude"},{"id":"b","text":"careless and uncertain"},{"id":"c","text":"angry and threatening"},{"id":"d","text":"cautiously supportive"}]'::jsonb,'"d"'::jsonb,'The passage supports “cautiously supportive”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','A Car-Free Street near School','A Car-Free Street near School

People often disagree about streets near schools. I believe we should consider closing one short street to cars at arrival and dismissal times. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it would reduce danger and make the air cleaner. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that some families need cars because of distance or disability. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to trial the plan for one month while keeping an access route. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Why does the writer include the opposing view?','[{"id":"a","text":"to change the topic completely"},{"id":"b","text":"to make the passage longer without purpose"},{"id":"c","text":"to show fairness and respond to a genuine concern"},{"id":"d","text":"to prove the writer has no opinion"}]'::jsonb,'"c"'::jsonb,'The passage supports “to show fairness and respond to a genuine concern”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','A Car-Free Street near School','A Car-Free Street near School

People often disagree about streets near schools. I believe we should consider closing one short street to cars at arrival and dismissal times. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it would reduce danger and make the air cleaner. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that some families need cars because of distance or disability. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to trial the plan for one month while keeping an access route. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer believe evidence should do?','[{"id":"a","text":"be collected only after a permanent decision"},{"id":"b","text":"guide whether the proposal is changed, expanded or stopped"},{"id":"c","text":"be ignored when it is inconvenient"},{"id":"d","text":"replace all discussion and judgement"}]'::jsonb,'"b"'::jsonb,'The passage supports “guide whether the proposal is changed, expanded or stopped”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','A Car-Free Street near School','A Car-Free Street near School

People often disagree about streets near schools. I believe we should consider closing one short street to cars at arrival and dismissal times. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it would reduce danger and make the air cleaner. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that some families need cars because of distance or disability. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to trial the plan for one month while keeping an access route. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which assumption supports the argument?','[{"id":"a","text":"A small trial can reveal benefits and problems before a larger decision."},{"id":"b","text":"Every new idea is automatically successful."},{"id":"c","text":"People never change their opinions."},{"id":"d","text":"Costs and safety do not matter."}]'::jsonb,'"a"'::jsonb,'The passage supports “A small trial can reveal benefits and problems before a larger decision.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','A Car-Free Street near School','A Car-Free Street near School

People often disagree about streets near schools. I believe we should consider closing one short street to cars at arrival and dismissal times. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it would reduce danger and make the air cleaner. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that some families need cars because of distance or disability. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to trial the plan for one month while keeping an access route. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the main message?','[{"id":"a","text":"The boldest idea is always the best."},{"id":"b","text":"Opposing opinions should be silenced."},{"id":"c","text":"Schools should never change existing arrangements."},{"id":"d","text":"Useful change should be tested fairly and improved through evidence."}]'::jsonb,'"d"'::jsonb,'The passage supports “Useful change should be tested fairly and improved through evidence.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Homework-Free Weekends?','Homework-Free Weekends?

People often disagree about weekend homework. I believe we should consider limiting routine homework at weekends. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils need rest, family time and independent interests. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that short practice may help pupils remember difficult skills. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to set optional practice and use weekdays for essential tasks. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What issue does the writer discuss?','[{"id":"a","text":"how to train for a professional sport"},{"id":"b","text":"the plot of a fantasy film"},{"id":"c","text":"a recipe for a celebration cake"},{"id":"d","text":"weekend homework"}]'::jsonb,'"d"'::jsonb,'The passage supports “weekend homework”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Homework-Free Weekends?','Homework-Free Weekends?

People often disagree about weekend homework. I believe we should consider limiting routine homework at weekends. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils need rest, family time and independent interests. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that short practice may help pupils remember difficult skills. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to set optional practice and use weekdays for essential tasks. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer propose?','[{"id":"a","text":"ignoring the issue completely"},{"id":"b","text":"allowing only one person to decide"},{"id":"c","text":"limiting routine homework at weekends"},{"id":"d","text":"making an immediate permanent change without evidence"}]'::jsonb,'"c"'::jsonb,'The passage supports “limiting routine homework at weekends”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Homework-Free Weekends?','Homework-Free Weekends?

People often disagree about weekend homework. I believe we should consider limiting routine homework at weekends. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils need rest, family time and independent interests. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that short practice may help pupils remember difficult skills. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to set optional practice and use weekdays for essential tasks. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the strongest supporting reason?','[{"id":"a","text":"evidence should never be collected"},{"id":"b","text":"pupils need rest, family time and independent interests"},{"id":"c","text":"the idea has no possible benefit"},{"id":"d","text":"the issue affects nobody"}]'::jsonb,'"b"'::jsonb,'The passage supports “pupils need rest, family time and independent interests”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Homework-Free Weekends?','Homework-Free Weekends?

People often disagree about weekend homework. I believe we should consider limiting routine homework at weekends. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils need rest, family time and independent interests. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that short practice may help pupils remember difficult skills. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to set optional practice and use weekdays for essential tasks. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which opposing concern is acknowledged?','[{"id":"a","text":"short practice may help pupils remember difficult skills"},{"id":"b","text":"there are no disadvantages"},{"id":"c","text":"all readers already agree"},{"id":"d","text":"the proposal requires no planning"}]'::jsonb,'"a"'::jsonb,'The passage supports “short practice may help pupils remember difficult skills”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Homework-Free Weekends?','Homework-Free Weekends?

People often disagree about weekend homework. I believe we should consider limiting routine homework at weekends. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils need rest, family time and independent interests. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that short practice may help pupils remember difficult skills. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to set optional practice and use weekdays for essential tasks. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What compromise or next step is suggested?','[{"id":"a","text":"ban further discussion"},{"id":"b","text":"spend all resources immediately"},{"id":"c","text":"hide any negative results"},{"id":"d","text":"set optional practice and use weekdays for essential tasks"}]'::jsonb,'"d"'::jsonb,'The passage supports “set optional practice and use weekdays for essential tasks”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Homework-Free Weekends?','Homework-Free Weekends?

People often disagree about weekend homework. I believe we should consider limiting routine homework at weekends. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils need rest, family time and independent interests. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that short practice may help pupils remember difficult skills. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to set optional practice and use weekdays for essential tasks. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which phrase best describes the writer’s tone?','[{"id":"a","text":"careless and uncertain"},{"id":"b","text":"angry and threatening"},{"id":"c","text":"balanced"},{"id":"d","text":"mocking and rude"}]'::jsonb,'"c"'::jsonb,'The passage supports “balanced”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Homework-Free Weekends?','Homework-Free Weekends?

People often disagree about weekend homework. I believe we should consider limiting routine homework at weekends. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils need rest, family time and independent interests. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that short practice may help pupils remember difficult skills. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to set optional practice and use weekdays for essential tasks. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Why does the writer include the opposing view?','[{"id":"a","text":"to make the passage longer without purpose"},{"id":"b","text":"to show fairness and respond to a genuine concern"},{"id":"c","text":"to prove the writer has no opinion"},{"id":"d","text":"to change the topic completely"}]'::jsonb,'"b"'::jsonb,'The passage supports “to show fairness and respond to a genuine concern”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Homework-Free Weekends?','Homework-Free Weekends?

People often disagree about weekend homework. I believe we should consider limiting routine homework at weekends. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils need rest, family time and independent interests. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that short practice may help pupils remember difficult skills. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to set optional practice and use weekdays for essential tasks. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer believe evidence should do?','[{"id":"a","text":"guide whether the proposal is changed, expanded or stopped"},{"id":"b","text":"be ignored when it is inconvenient"},{"id":"c","text":"replace all discussion and judgement"},{"id":"d","text":"be collected only after a permanent decision"}]'::jsonb,'"a"'::jsonb,'The passage supports “guide whether the proposal is changed, expanded or stopped”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Homework-Free Weekends?','Homework-Free Weekends?

People often disagree about weekend homework. I believe we should consider limiting routine homework at weekends. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils need rest, family time and independent interests. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that short practice may help pupils remember difficult skills. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to set optional practice and use weekdays for essential tasks. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which assumption supports the argument?','[{"id":"a","text":"Every new idea is automatically successful."},{"id":"b","text":"People never change their opinions."},{"id":"c","text":"Costs and safety do not matter."},{"id":"d","text":"A small trial can reveal benefits and problems before a larger decision."}]'::jsonb,'"d"'::jsonb,'The passage supports “A small trial can reveal benefits and problems before a larger decision.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Homework-Free Weekends?','Homework-Free Weekends?

People often disagree about weekend homework. I believe we should consider limiting routine homework at weekends. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils need rest, family time and independent interests. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that short practice may help pupils remember difficult skills. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to set optional practice and use weekdays for essential tasks. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the main message?','[{"id":"a","text":"Opposing opinions should be silenced."},{"id":"b","text":"Schools should never change existing arrangements."},{"id":"c","text":"Useful change should be tested fairly and improved through evidence."},{"id":"d","text":"The boldest idea is always the best."}]'::jsonb,'"c"'::jsonb,'The passage supports “Useful change should be tested fairly and improved through evidence.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Repair before Replacing','Repair before Replacing

People often disagree about damaged school equipment. I believe we should consider checking whether items can be repaired safely. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that repairing saves materials and teaches practical thinking. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that repairs may cost time and unsafe items must be replaced. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use a safety and cost checklist before deciding. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What issue does the writer discuss?','[{"id":"a","text":"the plot of a fantasy film"},{"id":"b","text":"a recipe for a celebration cake"},{"id":"c","text":"damaged school equipment"},{"id":"d","text":"how to train for a professional sport"}]'::jsonb,'"c"'::jsonb,'The passage supports “damaged school equipment”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Repair before Replacing','Repair before Replacing

People often disagree about damaged school equipment. I believe we should consider checking whether items can be repaired safely. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that repairing saves materials and teaches practical thinking. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that repairs may cost time and unsafe items must be replaced. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use a safety and cost checklist before deciding. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer propose?','[{"id":"a","text":"allowing only one person to decide"},{"id":"b","text":"checking whether items can be repaired safely"},{"id":"c","text":"making an immediate permanent change without evidence"},{"id":"d","text":"ignoring the issue completely"}]'::jsonb,'"b"'::jsonb,'The passage supports “checking whether items can be repaired safely”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Repair before Replacing','Repair before Replacing

People often disagree about damaged school equipment. I believe we should consider checking whether items can be repaired safely. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that repairing saves materials and teaches practical thinking. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that repairs may cost time and unsafe items must be replaced. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use a safety and cost checklist before deciding. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the strongest supporting reason?','[{"id":"a","text":"repairing saves materials and teaches practical thinking"},{"id":"b","text":"the idea has no possible benefit"},{"id":"c","text":"the issue affects nobody"},{"id":"d","text":"evidence should never be collected"}]'::jsonb,'"a"'::jsonb,'The passage supports “repairing saves materials and teaches practical thinking”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Repair before Replacing','Repair before Replacing

People often disagree about damaged school equipment. I believe we should consider checking whether items can be repaired safely. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that repairing saves materials and teaches practical thinking. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that repairs may cost time and unsafe items must be replaced. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use a safety and cost checklist before deciding. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which opposing concern is acknowledged?','[{"id":"a","text":"there are no disadvantages"},{"id":"b","text":"all readers already agree"},{"id":"c","text":"the proposal requires no planning"},{"id":"d","text":"repairs may cost time and unsafe items must be replaced"}]'::jsonb,'"d"'::jsonb,'The passage supports “repairs may cost time and unsafe items must be replaced”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Repair before Replacing','Repair before Replacing

People often disagree about damaged school equipment. I believe we should consider checking whether items can be repaired safely. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that repairing saves materials and teaches practical thinking. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that repairs may cost time and unsafe items must be replaced. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use a safety and cost checklist before deciding. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What compromise or next step is suggested?','[{"id":"a","text":"spend all resources immediately"},{"id":"b","text":"hide any negative results"},{"id":"c","text":"use a safety and cost checklist before deciding"},{"id":"d","text":"ban further discussion"}]'::jsonb,'"c"'::jsonb,'The passage supports “use a safety and cost checklist before deciding”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Repair before Replacing','Repair before Replacing

People often disagree about damaged school equipment. I believe we should consider checking whether items can be repaired safely. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that repairing saves materials and teaches practical thinking. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that repairs may cost time and unsafe items must be replaced. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use a safety and cost checklist before deciding. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which phrase best describes the writer’s tone?','[{"id":"a","text":"angry and threatening"},{"id":"b","text":"strongly supportive"},{"id":"c","text":"mocking and rude"},{"id":"d","text":"careless and uncertain"}]'::jsonb,'"b"'::jsonb,'The passage supports “strongly supportive”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Repair before Replacing','Repair before Replacing

People often disagree about damaged school equipment. I believe we should consider checking whether items can be repaired safely. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that repairing saves materials and teaches practical thinking. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that repairs may cost time and unsafe items must be replaced. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use a safety and cost checklist before deciding. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Why does the writer include the opposing view?','[{"id":"a","text":"to show fairness and respond to a genuine concern"},{"id":"b","text":"to prove the writer has no opinion"},{"id":"c","text":"to change the topic completely"},{"id":"d","text":"to make the passage longer without purpose"}]'::jsonb,'"a"'::jsonb,'The passage supports “to show fairness and respond to a genuine concern”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Repair before Replacing','Repair before Replacing

People often disagree about damaged school equipment. I believe we should consider checking whether items can be repaired safely. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that repairing saves materials and teaches practical thinking. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that repairs may cost time and unsafe items must be replaced. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use a safety and cost checklist before deciding. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer believe evidence should do?','[{"id":"a","text":"be ignored when it is inconvenient"},{"id":"b","text":"replace all discussion and judgement"},{"id":"c","text":"be collected only after a permanent decision"},{"id":"d","text":"guide whether the proposal is changed, expanded or stopped"}]'::jsonb,'"d"'::jsonb,'The passage supports “guide whether the proposal is changed, expanded or stopped”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Repair before Replacing','Repair before Replacing

People often disagree about damaged school equipment. I believe we should consider checking whether items can be repaired safely. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that repairing saves materials and teaches practical thinking. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that repairs may cost time and unsafe items must be replaced. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use a safety and cost checklist before deciding. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which assumption supports the argument?','[{"id":"a","text":"People never change their opinions."},{"id":"b","text":"Costs and safety do not matter."},{"id":"c","text":"A small trial can reveal benefits and problems before a larger decision."},{"id":"d","text":"Every new idea is automatically successful."}]'::jsonb,'"c"'::jsonb,'The passage supports “A small trial can reveal benefits and problems before a larger decision.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Repair before Replacing','Repair before Replacing

People often disagree about damaged school equipment. I believe we should consider checking whether items can be repaired safely. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that repairing saves materials and teaches practical thinking. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that repairs may cost time and unsafe items must be replaced. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use a safety and cost checklist before deciding. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the main message?','[{"id":"a","text":"Schools should never change existing arrangements."},{"id":"b","text":"Useful change should be tested fairly and improved through evidence."},{"id":"c","text":"The boldest idea is always the best."},{"id":"d","text":"Opposing opinions should be silenced."}]'::jsonb,'"b"'::jsonb,'The passage supports “Useful change should be tested fairly and improved through evidence.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Should Every Class Keep Plants?','Should Every Class Keep Plants?

People often disagree about classroom plants. I believe we should consider giving each class responsibility for a few suitable plants. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that plants can support observation and shared responsibility. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that allergies, spills and holiday care require planning. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to choose safe plants and use a clear care rota. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What issue does the writer discuss?','[{"id":"a","text":"a recipe for a celebration cake"},{"id":"b","text":"classroom plants"},{"id":"c","text":"how to train for a professional sport"},{"id":"d","text":"the plot of a fantasy film"}]'::jsonb,'"b"'::jsonb,'The passage supports “classroom plants”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Should Every Class Keep Plants?','Should Every Class Keep Plants?

People often disagree about classroom plants. I believe we should consider giving each class responsibility for a few suitable plants. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that plants can support observation and shared responsibility. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that allergies, spills and holiday care require planning. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to choose safe plants and use a clear care rota. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer propose?','[{"id":"a","text":"giving each class responsibility for a few suitable plants"},{"id":"b","text":"making an immediate permanent change without evidence"},{"id":"c","text":"ignoring the issue completely"},{"id":"d","text":"allowing only one person to decide"}]'::jsonb,'"a"'::jsonb,'The passage supports “giving each class responsibility for a few suitable plants”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Should Every Class Keep Plants?','Should Every Class Keep Plants?

People often disagree about classroom plants. I believe we should consider giving each class responsibility for a few suitable plants. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that plants can support observation and shared responsibility. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that allergies, spills and holiday care require planning. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to choose safe plants and use a clear care rota. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the strongest supporting reason?','[{"id":"a","text":"the idea has no possible benefit"},{"id":"b","text":"the issue affects nobody"},{"id":"c","text":"evidence should never be collected"},{"id":"d","text":"plants can support observation and shared responsibility"}]'::jsonb,'"d"'::jsonb,'The passage supports “plants can support observation and shared responsibility”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Should Every Class Keep Plants?','Should Every Class Keep Plants?

People often disagree about classroom plants. I believe we should consider giving each class responsibility for a few suitable plants. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that plants can support observation and shared responsibility. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that allergies, spills and holiday care require planning. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to choose safe plants and use a clear care rota. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which opposing concern is acknowledged?','[{"id":"a","text":"all readers already agree"},{"id":"b","text":"the proposal requires no planning"},{"id":"c","text":"allergies, spills and holiday care require planning"},{"id":"d","text":"there are no disadvantages"}]'::jsonb,'"c"'::jsonb,'The passage supports “allergies, spills and holiday care require planning”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Should Every Class Keep Plants?','Should Every Class Keep Plants?

People often disagree about classroom plants. I believe we should consider giving each class responsibility for a few suitable plants. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that plants can support observation and shared responsibility. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that allergies, spills and holiday care require planning. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to choose safe plants and use a clear care rota. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What compromise or next step is suggested?','[{"id":"a","text":"hide any negative results"},{"id":"b","text":"choose safe plants and use a clear care rota"},{"id":"c","text":"ban further discussion"},{"id":"d","text":"spend all resources immediately"}]'::jsonb,'"b"'::jsonb,'The passage supports “choose safe plants and use a clear care rota”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Should Every Class Keep Plants?','Should Every Class Keep Plants?

People often disagree about classroom plants. I believe we should consider giving each class responsibility for a few suitable plants. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that plants can support observation and shared responsibility. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that allergies, spills and holiday care require planning. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to choose safe plants and use a clear care rota. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which phrase best describes the writer’s tone?','[{"id":"a","text":"supportive with conditions"},{"id":"b","text":"mocking and rude"},{"id":"c","text":"careless and uncertain"},{"id":"d","text":"angry and threatening"}]'::jsonb,'"a"'::jsonb,'The passage supports “supportive with conditions”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Should Every Class Keep Plants?','Should Every Class Keep Plants?

People often disagree about classroom plants. I believe we should consider giving each class responsibility for a few suitable plants. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that plants can support observation and shared responsibility. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that allergies, spills and holiday care require planning. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to choose safe plants and use a clear care rota. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Why does the writer include the opposing view?','[{"id":"a","text":"to prove the writer has no opinion"},{"id":"b","text":"to change the topic completely"},{"id":"c","text":"to make the passage longer without purpose"},{"id":"d","text":"to show fairness and respond to a genuine concern"}]'::jsonb,'"d"'::jsonb,'The passage supports “to show fairness and respond to a genuine concern”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Should Every Class Keep Plants?','Should Every Class Keep Plants?

People often disagree about classroom plants. I believe we should consider giving each class responsibility for a few suitable plants. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that plants can support observation and shared responsibility. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that allergies, spills and holiday care require planning. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to choose safe plants and use a clear care rota. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer believe evidence should do?','[{"id":"a","text":"replace all discussion and judgement"},{"id":"b","text":"be collected only after a permanent decision"},{"id":"c","text":"guide whether the proposal is changed, expanded or stopped"},{"id":"d","text":"be ignored when it is inconvenient"}]'::jsonb,'"c"'::jsonb,'The passage supports “guide whether the proposal is changed, expanded or stopped”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Should Every Class Keep Plants?','Should Every Class Keep Plants?

People often disagree about classroom plants. I believe we should consider giving each class responsibility for a few suitable plants. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that plants can support observation and shared responsibility. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that allergies, spills and holiday care require planning. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to choose safe plants and use a clear care rota. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which assumption supports the argument?','[{"id":"a","text":"Costs and safety do not matter."},{"id":"b","text":"A small trial can reveal benefits and problems before a larger decision."},{"id":"c","text":"Every new idea is automatically successful."},{"id":"d","text":"People never change their opinions."}]'::jsonb,'"b"'::jsonb,'The passage supports “A small trial can reveal benefits and problems before a larger decision.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Should Every Class Keep Plants?','Should Every Class Keep Plants?

People often disagree about classroom plants. I believe we should consider giving each class responsibility for a few suitable plants. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that plants can support observation and shared responsibility. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that allergies, spills and holiday care require planning. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to choose safe plants and use a clear care rota. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the main message?','[{"id":"a","text":"Useful change should be tested fairly and improved through evidence."},{"id":"b","text":"The boldest idea is always the best."},{"id":"c","text":"Opposing opinions should be silenced."},{"id":"d","text":"Schools should never change existing arrangements."}]'::jsonb,'"a"'::jsonb,'The passage supports “Useful change should be tested fairly and improved through evidence.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Longer Lunchtimes','Longer Lunchtimes

People often disagree about the school lunch break. I believe we should consider adding fifteen minutes to lunchtime. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils could eat without rushing and return calmer. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that the school day might finish later. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to run a two-week trial and collect evidence. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What issue does the writer discuss?','[{"id":"a","text":"the school lunch break"},{"id":"b","text":"how to train for a professional sport"},{"id":"c","text":"the plot of a fantasy film"},{"id":"d","text":"a recipe for a celebration cake"}]'::jsonb,'"a"'::jsonb,'The passage supports “the school lunch break”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Longer Lunchtimes','Longer Lunchtimes

People often disagree about the school lunch break. I believe we should consider adding fifteen minutes to lunchtime. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils could eat without rushing and return calmer. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that the school day might finish later. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to run a two-week trial and collect evidence. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer propose?','[{"id":"a","text":"making an immediate permanent change without evidence"},{"id":"b","text":"ignoring the issue completely"},{"id":"c","text":"allowing only one person to decide"},{"id":"d","text":"adding fifteen minutes to lunchtime"}]'::jsonb,'"d"'::jsonb,'The passage supports “adding fifteen minutes to lunchtime”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Longer Lunchtimes','Longer Lunchtimes

People often disagree about the school lunch break. I believe we should consider adding fifteen minutes to lunchtime. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils could eat without rushing and return calmer. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that the school day might finish later. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to run a two-week trial and collect evidence. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the strongest supporting reason?','[{"id":"a","text":"the issue affects nobody"},{"id":"b","text":"evidence should never be collected"},{"id":"c","text":"pupils could eat without rushing and return calmer"},{"id":"d","text":"the idea has no possible benefit"}]'::jsonb,'"c"'::jsonb,'The passage supports “pupils could eat without rushing and return calmer”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Longer Lunchtimes','Longer Lunchtimes

People often disagree about the school lunch break. I believe we should consider adding fifteen minutes to lunchtime. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils could eat without rushing and return calmer. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that the school day might finish later. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to run a two-week trial and collect evidence. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which opposing concern is acknowledged?','[{"id":"a","text":"the proposal requires no planning"},{"id":"b","text":"the school day might finish later"},{"id":"c","text":"there are no disadvantages"},{"id":"d","text":"all readers already agree"}]'::jsonb,'"b"'::jsonb,'The passage supports “the school day might finish later”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Longer Lunchtimes','Longer Lunchtimes

People often disagree about the school lunch break. I believe we should consider adding fifteen minutes to lunchtime. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils could eat without rushing and return calmer. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that the school day might finish later. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to run a two-week trial and collect evidence. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What compromise or next step is suggested?','[{"id":"a","text":"run a two-week trial and collect evidence"},{"id":"b","text":"ban further discussion"},{"id":"c","text":"spend all resources immediately"},{"id":"d","text":"hide any negative results"}]'::jsonb,'"a"'::jsonb,'The passage supports “run a two-week trial and collect evidence”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Longer Lunchtimes','Longer Lunchtimes

People often disagree about the school lunch break. I believe we should consider adding fifteen minutes to lunchtime. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils could eat without rushing and return calmer. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that the school day might finish later. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to run a two-week trial and collect evidence. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which phrase best describes the writer’s tone?','[{"id":"a","text":"mocking and rude"},{"id":"b","text":"careless and uncertain"},{"id":"c","text":"angry and threatening"},{"id":"d","text":"open-minded"}]'::jsonb,'"d"'::jsonb,'The passage supports “open-minded”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Longer Lunchtimes','Longer Lunchtimes

People often disagree about the school lunch break. I believe we should consider adding fifteen minutes to lunchtime. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils could eat without rushing and return calmer. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that the school day might finish later. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to run a two-week trial and collect evidence. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Why does the writer include the opposing view?','[{"id":"a","text":"to change the topic completely"},{"id":"b","text":"to make the passage longer without purpose"},{"id":"c","text":"to show fairness and respond to a genuine concern"},{"id":"d","text":"to prove the writer has no opinion"}]'::jsonb,'"c"'::jsonb,'The passage supports “to show fairness and respond to a genuine concern”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Longer Lunchtimes','Longer Lunchtimes

People often disagree about the school lunch break. I believe we should consider adding fifteen minutes to lunchtime. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils could eat without rushing and return calmer. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that the school day might finish later. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to run a two-week trial and collect evidence. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer believe evidence should do?','[{"id":"a","text":"be collected only after a permanent decision"},{"id":"b","text":"guide whether the proposal is changed, expanded or stopped"},{"id":"c","text":"be ignored when it is inconvenient"},{"id":"d","text":"replace all discussion and judgement"}]'::jsonb,'"b"'::jsonb,'The passage supports “guide whether the proposal is changed, expanded or stopped”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Longer Lunchtimes','Longer Lunchtimes

People often disagree about the school lunch break. I believe we should consider adding fifteen minutes to lunchtime. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils could eat without rushing and return calmer. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that the school day might finish later. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to run a two-week trial and collect evidence. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which assumption supports the argument?','[{"id":"a","text":"A small trial can reveal benefits and problems before a larger decision."},{"id":"b","text":"Every new idea is automatically successful."},{"id":"c","text":"People never change their opinions."},{"id":"d","text":"Costs and safety do not matter."}]'::jsonb,'"a"'::jsonb,'The passage supports “A small trial can reveal benefits and problems before a larger decision.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Longer Lunchtimes','Longer Lunchtimes

People often disagree about the school lunch break. I believe we should consider adding fifteen minutes to lunchtime. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that pupils could eat without rushing and return calmer. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that the school day might finish later. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to run a two-week trial and collect evidence. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the main message?','[{"id":"a","text":"The boldest idea is always the best."},{"id":"b","text":"Opposing opinions should be silenced."},{"id":"c","text":"Schools should never change existing arrangements."},{"id":"d","text":"Useful change should be tested fairly and improved through evidence."}]'::jsonb,'"d"'::jsonb,'The passage supports “Useful change should be tested fairly and improved through evidence.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Digital Books and Printed Books','Digital Books and Printed Books

People often disagree about reading formats. I believe we should consider keeping both digital and printed books available. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that different formats suit different needs and situations. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that buying and maintaining both costs more. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use borrowing data to balance the collection. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What issue does the writer discuss?','[{"id":"a","text":"how to train for a professional sport"},{"id":"b","text":"the plot of a fantasy film"},{"id":"c","text":"a recipe for a celebration cake"},{"id":"d","text":"reading formats"}]'::jsonb,'"d"'::jsonb,'The passage supports “reading formats”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Digital Books and Printed Books','Digital Books and Printed Books

People often disagree about reading formats. I believe we should consider keeping both digital and printed books available. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that different formats suit different needs and situations. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that buying and maintaining both costs more. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use borrowing data to balance the collection. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer propose?','[{"id":"a","text":"ignoring the issue completely"},{"id":"b","text":"allowing only one person to decide"},{"id":"c","text":"keeping both digital and printed books available"},{"id":"d","text":"making an immediate permanent change without evidence"}]'::jsonb,'"c"'::jsonb,'The passage supports “keeping both digital and printed books available”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Digital Books and Printed Books','Digital Books and Printed Books

People often disagree about reading formats. I believe we should consider keeping both digital and printed books available. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that different formats suit different needs and situations. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that buying and maintaining both costs more. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use borrowing data to balance the collection. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the strongest supporting reason?','[{"id":"a","text":"evidence should never be collected"},{"id":"b","text":"different formats suit different needs and situations"},{"id":"c","text":"the idea has no possible benefit"},{"id":"d","text":"the issue affects nobody"}]'::jsonb,'"b"'::jsonb,'The passage supports “different formats suit different needs and situations”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Digital Books and Printed Books','Digital Books and Printed Books

People often disagree about reading formats. I believe we should consider keeping both digital and printed books available. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that different formats suit different needs and situations. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that buying and maintaining both costs more. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use borrowing data to balance the collection. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which opposing concern is acknowledged?','[{"id":"a","text":"buying and maintaining both costs more"},{"id":"b","text":"there are no disadvantages"},{"id":"c","text":"all readers already agree"},{"id":"d","text":"the proposal requires no planning"}]'::jsonb,'"a"'::jsonb,'The passage supports “buying and maintaining both costs more”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Digital Books and Printed Books','Digital Books and Printed Books

People often disagree about reading formats. I believe we should consider keeping both digital and printed books available. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that different formats suit different needs and situations. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that buying and maintaining both costs more. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use borrowing data to balance the collection. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What compromise or next step is suggested?','[{"id":"a","text":"ban further discussion"},{"id":"b","text":"spend all resources immediately"},{"id":"c","text":"hide any negative results"},{"id":"d","text":"use borrowing data to balance the collection"}]'::jsonb,'"d"'::jsonb,'The passage supports “use borrowing data to balance the collection”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Digital Books and Printed Books','Digital Books and Printed Books

People often disagree about reading formats. I believe we should consider keeping both digital and printed books available. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that different formats suit different needs and situations. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that buying and maintaining both costs more. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use borrowing data to balance the collection. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which phrase best describes the writer’s tone?','[{"id":"a","text":"careless and uncertain"},{"id":"b","text":"angry and threatening"},{"id":"c","text":"balanced"},{"id":"d","text":"mocking and rude"}]'::jsonb,'"c"'::jsonb,'The passage supports “balanced”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Digital Books and Printed Books','Digital Books and Printed Books

People often disagree about reading formats. I believe we should consider keeping both digital and printed books available. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that different formats suit different needs and situations. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that buying and maintaining both costs more. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use borrowing data to balance the collection. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Why does the writer include the opposing view?','[{"id":"a","text":"to make the passage longer without purpose"},{"id":"b","text":"to show fairness and respond to a genuine concern"},{"id":"c","text":"to prove the writer has no opinion"},{"id":"d","text":"to change the topic completely"}]'::jsonb,'"b"'::jsonb,'The passage supports “to show fairness and respond to a genuine concern”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Digital Books and Printed Books','Digital Books and Printed Books

People often disagree about reading formats. I believe we should consider keeping both digital and printed books available. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that different formats suit different needs and situations. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that buying and maintaining both costs more. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use borrowing data to balance the collection. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer believe evidence should do?','[{"id":"a","text":"guide whether the proposal is changed, expanded or stopped"},{"id":"b","text":"be ignored when it is inconvenient"},{"id":"c","text":"replace all discussion and judgement"},{"id":"d","text":"be collected only after a permanent decision"}]'::jsonb,'"a"'::jsonb,'The passage supports “guide whether the proposal is changed, expanded or stopped”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Digital Books and Printed Books','Digital Books and Printed Books

People often disagree about reading formats. I believe we should consider keeping both digital and printed books available. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that different formats suit different needs and situations. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that buying and maintaining both costs more. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use borrowing data to balance the collection. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which assumption supports the argument?','[{"id":"a","text":"Every new idea is automatically successful."},{"id":"b","text":"People never change their opinions."},{"id":"c","text":"Costs and safety do not matter."},{"id":"d","text":"A small trial can reveal benefits and problems before a larger decision."}]'::jsonb,'"d"'::jsonb,'The passage supports “A small trial can reveal benefits and problems before a larger decision.”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Digital Books and Printed Books','Digital Books and Printed Books

People often disagree about reading formats. I believe we should consider keeping both digital and printed books available. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that different formats suit different needs and situations. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that buying and maintaining both costs more. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to use borrowing data to balance the collection. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the main message?','[{"id":"a","text":"Opposing opinions should be silenced."},{"id":"b","text":"Schools should never change existing arrangements."},{"id":"c","text":"Useful change should be tested fairly and improved through evidence."},{"id":"d","text":"The boldest idea is always the best."}]'::jsonb,'"c"'::jsonb,'The passage supports “Useful change should be tested fairly and improved through evidence.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','A Weekly Local Food Day','A Weekly Local Food Day

People often disagree about school meals. I believe we should consider offering one meal each week based on local seasonal food. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it may reduce transport and teach pupils about seasons. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that local choices are not always cheaper or available. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to begin with one flexible menu and review waste. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What issue does the writer discuss?','[{"id":"a","text":"the plot of a fantasy film"},{"id":"b","text":"a recipe for a celebration cake"},{"id":"c","text":"school meals"},{"id":"d","text":"how to train for a professional sport"}]'::jsonb,'"c"'::jsonb,'The passage supports “school meals”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','A Weekly Local Food Day','A Weekly Local Food Day

People often disagree about school meals. I believe we should consider offering one meal each week based on local seasonal food. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it may reduce transport and teach pupils about seasons. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that local choices are not always cheaper or available. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to begin with one flexible menu and review waste. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer propose?','[{"id":"a","text":"allowing only one person to decide"},{"id":"b","text":"offering one meal each week based on local seasonal food"},{"id":"c","text":"making an immediate permanent change without evidence"},{"id":"d","text":"ignoring the issue completely"}]'::jsonb,'"b"'::jsonb,'The passage supports “offering one meal each week based on local seasonal food”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','A Weekly Local Food Day','A Weekly Local Food Day

People often disagree about school meals. I believe we should consider offering one meal each week based on local seasonal food. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it may reduce transport and teach pupils about seasons. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that local choices are not always cheaper or available. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to begin with one flexible menu and review waste. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the strongest supporting reason?','[{"id":"a","text":"it may reduce transport and teach pupils about seasons"},{"id":"b","text":"the idea has no possible benefit"},{"id":"c","text":"the issue affects nobody"},{"id":"d","text":"evidence should never be collected"}]'::jsonb,'"a"'::jsonb,'The passage supports “it may reduce transport and teach pupils about seasons”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','A Weekly Local Food Day','A Weekly Local Food Day

People often disagree about school meals. I believe we should consider offering one meal each week based on local seasonal food. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it may reduce transport and teach pupils about seasons. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that local choices are not always cheaper or available. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to begin with one flexible menu and review waste. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which opposing concern is acknowledged?','[{"id":"a","text":"there are no disadvantages"},{"id":"b","text":"all readers already agree"},{"id":"c","text":"the proposal requires no planning"},{"id":"d","text":"local choices are not always cheaper or available"}]'::jsonb,'"d"'::jsonb,'The passage supports “local choices are not always cheaper or available”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','A Weekly Local Food Day','A Weekly Local Food Day

People often disagree about school meals. I believe we should consider offering one meal each week based on local seasonal food. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it may reduce transport and teach pupils about seasons. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that local choices are not always cheaper or available. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to begin with one flexible menu and review waste. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What compromise or next step is suggested?','[{"id":"a","text":"spend all resources immediately"},{"id":"b","text":"hide any negative results"},{"id":"c","text":"begin with one flexible menu and review waste"},{"id":"d","text":"ban further discussion"}]'::jsonb,'"c"'::jsonb,'The passage supports “begin with one flexible menu and review waste”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','A Weekly Local Food Day','A Weekly Local Food Day

People often disagree about school meals. I believe we should consider offering one meal each week based on local seasonal food. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it may reduce transport and teach pupils about seasons. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that local choices are not always cheaper or available. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to begin with one flexible menu and review waste. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which phrase best describes the writer’s tone?','[{"id":"a","text":"angry and threatening"},{"id":"b","text":"cautiously supportive"},{"id":"c","text":"mocking and rude"},{"id":"d","text":"careless and uncertain"}]'::jsonb,'"b"'::jsonb,'The passage supports “cautiously supportive”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','A Weekly Local Food Day','A Weekly Local Food Day

People often disagree about school meals. I believe we should consider offering one meal each week based on local seasonal food. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it may reduce transport and teach pupils about seasons. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that local choices are not always cheaper or available. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to begin with one flexible menu and review waste. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Why does the writer include the opposing view?','[{"id":"a","text":"to show fairness and respond to a genuine concern"},{"id":"b","text":"to prove the writer has no opinion"},{"id":"c","text":"to change the topic completely"},{"id":"d","text":"to make the passage longer without purpose"}]'::jsonb,'"a"'::jsonb,'The passage supports “to show fairness and respond to a genuine concern”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','A Weekly Local Food Day','A Weekly Local Food Day

People often disagree about school meals. I believe we should consider offering one meal each week based on local seasonal food. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it may reduce transport and teach pupils about seasons. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that local choices are not always cheaper or available. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to begin with one flexible menu and review waste. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer believe evidence should do?','[{"id":"a","text":"be ignored when it is inconvenient"},{"id":"b","text":"replace all discussion and judgement"},{"id":"c","text":"be collected only after a permanent decision"},{"id":"d","text":"guide whether the proposal is changed, expanded or stopped"}]'::jsonb,'"d"'::jsonb,'The passage supports “guide whether the proposal is changed, expanded or stopped”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','A Weekly Local Food Day','A Weekly Local Food Day

People often disagree about school meals. I believe we should consider offering one meal each week based on local seasonal food. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it may reduce transport and teach pupils about seasons. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that local choices are not always cheaper or available. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to begin with one flexible menu and review waste. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which assumption supports the argument?','[{"id":"a","text":"People never change their opinions."},{"id":"b","text":"Costs and safety do not matter."},{"id":"c","text":"A small trial can reveal benefits and problems before a larger decision."},{"id":"d","text":"Every new idea is automatically successful."}]'::jsonb,'"c"'::jsonb,'The passage supports “A small trial can reveal benefits and problems before a larger decision.”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','A Weekly Local Food Day','A Weekly Local Food Day

People often disagree about school meals. I believe we should consider offering one meal each week based on local seasonal food. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that it may reduce transport and teach pupils about seasons. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that local choices are not always cheaper or available. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to begin with one flexible menu and review waste. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the main message?','[{"id":"a","text":"Schools should never change existing arrangements."},{"id":"b","text":"Useful change should be tested fairly and improved through evidence."},{"id":"c","text":"The boldest idea is always the best."},{"id":"d","text":"Opposing opinions should be silenced."}]'::jsonb,'"b"'::jsonb,'The passage supports “Useful change should be tested fairly and improved through evidence.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Student Ideas for the Playground','Student Ideas for the Playground

People often disagree about playground planning. I believe we should consider allowing pupils to help design the next playground improvement. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that users notice problems adults may miss. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that popular ideas may be costly or unsafe. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to let pupils propose ideas within a clear budget and safety rules. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What issue does the writer discuss?','[{"id":"a","text":"a recipe for a celebration cake"},{"id":"b","text":"playground planning"},{"id":"c","text":"how to train for a professional sport"},{"id":"d","text":"the plot of a fantasy film"}]'::jsonb,'"b"'::jsonb,'The passage supports “playground planning”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Student Ideas for the Playground','Student Ideas for the Playground

People often disagree about playground planning. I believe we should consider allowing pupils to help design the next playground improvement. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that users notice problems adults may miss. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that popular ideas may be costly or unsafe. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to let pupils propose ideas within a clear budget and safety rules. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer propose?','[{"id":"a","text":"allowing pupils to help design the next playground improvement"},{"id":"b","text":"making an immediate permanent change without evidence"},{"id":"c","text":"ignoring the issue completely"},{"id":"d","text":"allowing only one person to decide"}]'::jsonb,'"a"'::jsonb,'The passage supports “allowing pupils to help design the next playground improvement”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Student Ideas for the Playground','Student Ideas for the Playground

People often disagree about playground planning. I believe we should consider allowing pupils to help design the next playground improvement. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that users notice problems adults may miss. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that popular ideas may be costly or unsafe. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to let pupils propose ideas within a clear budget and safety rules. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the strongest supporting reason?','[{"id":"a","text":"the idea has no possible benefit"},{"id":"b","text":"the issue affects nobody"},{"id":"c","text":"evidence should never be collected"},{"id":"d","text":"users notice problems adults may miss"}]'::jsonb,'"d"'::jsonb,'The passage supports “users notice problems adults may miss”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Student Ideas for the Playground','Student Ideas for the Playground

People often disagree about playground planning. I believe we should consider allowing pupils to help design the next playground improvement. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that users notice problems adults may miss. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that popular ideas may be costly or unsafe. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to let pupils propose ideas within a clear budget and safety rules. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which opposing concern is acknowledged?','[{"id":"a","text":"all readers already agree"},{"id":"b","text":"the proposal requires no planning"},{"id":"c","text":"popular ideas may be costly or unsafe"},{"id":"d","text":"there are no disadvantages"}]'::jsonb,'"c"'::jsonb,'The passage supports “popular ideas may be costly or unsafe”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Student Ideas for the Playground','Student Ideas for the Playground

People often disagree about playground planning. I believe we should consider allowing pupils to help design the next playground improvement. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that users notice problems adults may miss. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that popular ideas may be costly or unsafe. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to let pupils propose ideas within a clear budget and safety rules. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What compromise or next step is suggested?','[{"id":"a","text":"hide any negative results"},{"id":"b","text":"let pupils propose ideas within a clear budget and safety rules"},{"id":"c","text":"ban further discussion"},{"id":"d","text":"spend all resources immediately"}]'::jsonb,'"b"'::jsonb,'The passage supports “let pupils propose ideas within a clear budget and safety rules”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Student Ideas for the Playground','Student Ideas for the Playground

People often disagree about playground planning. I believe we should consider allowing pupils to help design the next playground improvement. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that users notice problems adults may miss. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that popular ideas may be costly or unsafe. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to let pupils propose ideas within a clear budget and safety rules. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which phrase best describes the writer’s tone?','[{"id":"a","text":"supportive"},{"id":"b","text":"mocking and rude"},{"id":"c","text":"careless and uncertain"},{"id":"d","text":"angry and threatening"}]'::jsonb,'"a"'::jsonb,'The passage supports “supportive”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Student Ideas for the Playground','Student Ideas for the Playground

People often disagree about playground planning. I believe we should consider allowing pupils to help design the next playground improvement. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that users notice problems adults may miss. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that popular ideas may be costly or unsafe. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to let pupils propose ideas within a clear budget and safety rules. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Why does the writer include the opposing view?','[{"id":"a","text":"to prove the writer has no opinion"},{"id":"b","text":"to change the topic completely"},{"id":"c","text":"to make the passage longer without purpose"},{"id":"d","text":"to show fairness and respond to a genuine concern"}]'::jsonb,'"d"'::jsonb,'The passage supports “to show fairness and respond to a genuine concern”.','Read the relevant part of the text, then compare all four choices.',3),
  ('5ER5','Student Ideas for the Playground','Student Ideas for the Playground

People often disagree about playground planning. I believe we should consider allowing pupils to help design the next playground improvement. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that users notice problems adults may miss. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that popular ideas may be costly or unsafe. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to let pupils propose ideas within a clear budget and safety rules. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What does the writer believe evidence should do?','[{"id":"a","text":"replace all discussion and judgement"},{"id":"b","text":"be collected only after a permanent decision"},{"id":"c","text":"guide whether the proposal is changed, expanded or stopped"},{"id":"d","text":"be ignored when it is inconvenient"}]'::jsonb,'"c"'::jsonb,'The passage supports “guide whether the proposal is changed, expanded or stopped”.','Read the relevant part of the text, then compare all four choices.',4),
  ('5ER5','Student Ideas for the Playground','Student Ideas for the Playground

People often disagree about playground planning. I believe we should consider allowing pupils to help design the next playground improvement. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that users notice problems adults may miss. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that popular ideas may be costly or unsafe. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to let pupils propose ideas within a clear budget and safety rules. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: Which assumption supports the argument?','[{"id":"a","text":"Costs and safety do not matter."},{"id":"b","text":"A small trial can reveal benefits and problems before a larger decision."},{"id":"c","text":"Every new idea is automatically successful."},{"id":"d","text":"People never change their opinions."}]'::jsonb,'"b"'::jsonb,'The passage supports “A small trial can reveal benefits and problems before a larger decision.”.','Read the relevant part of the text, then compare all four choices.',2),
  ('5ER5','Student Ideas for the Playground','Student Ideas for the Playground

People often disagree about playground planning. I believe we should consider allowing pupils to help design the next playground improvement. This is not a perfect answer, but it could improve a real situation if it is introduced carefully.

The strongest reason is that users notice problems adults may miss. A change is worthwhile only when it produces a clear benefit and people can take part without confusion.

However, opponents point out that popular ideas may be costly or unsafe. This concern should not be dismissed. Ignoring it would make the proposal less fair and could create new difficulties.

A sensible next step is to let pupils propose ideas within a clear budget and safety rules. During this period, organisers should record results and listen to different users. The plan can then be changed, expanded or stopped according to evidence.

Progress does not mean choosing the boldest idea immediately. It means testing a useful idea responsibly and being willing to learn from the result.

Question: What is the main message?','[{"id":"a","text":"Useful change should be tested fairly and improved through evidence."},{"id":"b","text":"The boldest idea is always the best."},{"id":"c","text":"Opposing opinions should be silenced."},{"id":"d","text":"Schools should never change existing arrangements."}]'::jsonb,'"a"'::jsonb,'The passage supports “Useful change should be tested fairly and improved through evidence.”.','Read the relevant part of the text, then compare all four choices.',3);

do $$ begin
 if (select count(*) from tmp_english_reading)<>400 then raise exception 'Expected 400 English reading questions.'; end if;
 if exists(select 1 from tmp_english_reading group by node_code having count(*)<>80) then raise exception 'Each unit must contain 80 questions.'; end if;
 if exists(select 1 from tmp_english_reading group by node_code,passage_title having count(*)<>10) then raise exception 'Each passage must contain 10 questions.'; end if;
 if exists(select 1 from tmp_english_reading group by node_code,question_text having count(*)>1) then raise exception 'Duplicate question text detected.'; end if;
end $$;

insert into public.questions(node_id,question_type,question_text,options,difficulty,source_type,status)
select n.id,'multiple_choice',t.question_text,t.options,t.difficulty,'teacher','published' from tmp_english_reading t join public.curriculum_nodes n on n.code=t.node_code
where not exists(select 1 from public.questions q where q.node_id=n.id and q.question_text=t.question_text);

insert into public.question_answer_keys(question_id,correct_answer,explanation,hint)
select q.id,t.correct_answer,t.explanation,t.hint from tmp_english_reading t join public.curriculum_nodes n on n.code=t.node_code join public.questions q on q.node_id=n.id and q.question_text=t.question_text
on conflict(question_id) do update set correct_answer=excluded.correct_answer,explanation=excluded.explanation,hint=excluded.hint;

commit;

select n.code,n.title_en,count(q.id) filter(where q.status='published') as published_questions from public.curriculum_nodes n left join public.questions q on q.node_id=n.id where n.code between '5ER1' and '5ER5' group by n.code,n.title_en order by n.code;
