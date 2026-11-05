-- Four original P5 science practice topics aligned to the textbook split reference.
-- Uses the existing practice schema and leaves historical attempts intact.
begin;

-- Serialize concurrent runs of this seed.
select pg_advisory_xact_lock(hashtext('p5-science-textbook-practice-starter'));

insert into public.curriculum_domains (subject_id, code, name_zh, name_en, sort_order)
select s.id, 'textbook_reference', '教材參照專題', 'Textbook Reference Topics', 2
from public.curriculum_subjects s
where s.grade = 'P5' and s.code = 'science'
  and not exists (
    select 1 from public.curriculum_domains d
    where d.subject_id = s.id and d.code = 'textbook_reference'
  );

insert into public.curriculum_nodes (domain_id, code, title_zh, title_en, difficulty, sort_order, is_active)
select d.id, u.code, u.title_zh, u.title_en, 3, u.sort_order, true
from public.curriculum_domains d
join public.curriculum_subjects s on s.id = d.subject_id
cross join (values
  ('5SC12', '光與聲音', 'Light and Sound', 12),
  ('5SC13', '電的探究與生活應用', 'Exploring Electricity', 13),
  ('5SC14', '泌尿系統', 'The Urinary System', 14),
  ('5SC15', '宇宙窺探', 'Exploring Space', 15)
) u(code, title_zh, title_en, sort_order)
where s.grade = 'P5' and s.code = 'science' and d.code = 'textbook_reference'
  and not exists (select 1 from public.curriculum_nodes n where n.code = u.code);

create temporary table p5_textbook_practice_seed (
  unit_code text not null,
  question_text text not null,
  options jsonb not null,
  correct_answer jsonb not null,
  explanation text not null,
  primary key (unit_code, question_text)
) on commit drop;

insert into p5_textbook_practice_seed values
  ('5SC12', '在暗房裏，手電筒照向一本書。我們為甚麼能看見書的封面？', '[{"id": "a", "text": "封面把部分光反射到眼睛"}, {"id": "b", "text": "封面把聲音傳到眼睛"}, {"id": "c", "text": "眼睛自行發光照亮封面"}, {"id": "d", "text": "封面只能吸收光"}]', '"a"', '書本受光後把部分光反射到眼睛，所以我們能看見它。'),
  ('5SC12', '一張不透光的卡紙放在燈和白牆之間。卡紙後方出現暗影，主要原因是甚麼？', '[{"id": "a", "text": "卡紙使光線穿過牆壁"}, {"id": "b", "text": "卡紙擋住了部分光"}, {"id": "c", "text": "卡紙把光變成聲音"}, {"id": "d", "text": "卡紙使白牆自行發光"}]', '"b"', '不透光的卡紙擋住部分照向白牆的光，形成影子。'),
  ('5SC12', '小美要把手電筒的光轉向旁邊的牆面，哪種物品最適合用來改變光的方向？', '[{"id": "a", "text": "紙杯"}, {"id": "b", "text": "木塊"}, {"id": "c", "text": "平面鏡"}, {"id": "d", "text": "黑色毛巾"}]', '"c"', '轉動平面鏡可改變反射光的方向。'),
  ('5SC12', '小明在三張卡紙上各開一個小孔。用手電筒從一端照射，哪種擺法最容易讓光穿過三個小孔？', '[{"id": "a", "text": "讓三個小孔依次向左移"}, {"id": "b", "text": "讓中間的小孔高於另外兩個"}, {"id": "c", "text": "用不透光紙封住最後一孔"}, {"id": "d", "text": "讓三個小孔在同一直線上"}]', '"d"', '在均勻的空氣中，光沿直線傳播。'),
  ('5SC12', '用手輕按正在發聲的鼓面，聲音很快變弱。哪項解釋最合理？', '[{"id": "a", "text": "鼓面的振動減弱"}, {"id": "b", "text": "鼓面的顏色變淺"}, {"id": "c", "text": "鼓面的重量增加"}, {"id": "d", "text": "鼓面的光反射增加"}]', '"a"', '按着鼓面會抑制振動，聲音便減弱。'),
  ('5SC12', '用一條拉緊的棉線連接兩個紙杯，一人在杯口說話，另一人在另一杯口聽。哪一部分把振動由一個杯傳到另一個杯？', '[{"id": "a", "text": "杯口的光線"}, {"id": "b", "text": "棉線"}, {"id": "c", "text": "兩人之間的桌面"}, {"id": "d", "text": "聽者的衣服"}]', '"b"', '拉緊的棉線把兩個紙杯連接起來，讓振動沿線傳遞。'),
  ('5SC12', '把能振動的音叉輕觸水面，水面出現波紋。這項觀察支持哪個說法？', '[{"id": "a", "text": "水面使音叉發光"}, {"id": "b", "text": "波紋證明聲音只能在水中傳播"}, {"id": "c", "text": "發聲時音叉正在振動"}, {"id": "d", "text": "發聲時音叉一定變熱"}]', '"c"', '振動的音叉接觸水面時會使水面擾動。'),
  ('5SC12', '隔着門也能聽到房內的人說話。哪項解釋最合理？', '[{"id": "a", "text": "聲音只能沿着光線傳遞"}, {"id": "b", "text": "只有看見聲源才能聽見聲音"}, {"id": "c", "text": "聲音遇到門就會完全停止"}, {"id": "d", "text": "聲音的振動可經空氣和固體傳遞"}]', '"d"', '聲音可在空氣和固體中傳遞，門會削弱部分聲音。'),
  ('5SC12', '同一條橡筋在相同條件下，輕撥和較用力撥通常有甚麼分別？', '[{"id": "a", "text": "較用力撥時聲音較響"}, {"id": "b", "text": "輕撥時聲音一定較響"}, {"id": "c", "text": "兩次都完全沒有振動"}, {"id": "d", "text": "兩次聲音必定同樣響"}]', '"a"', '較用力撥通常使振動幅度較大，聲音較響。'),
  ('5SC12', '把一面鏡和一張白紙放在同一位置，用同一束光照射。哪項觀察最能區分它們反射光的方式？', '[{"id": "a", "text": "白紙會自行發光"}, {"id": "b", "text": "鏡面較容易把光集中反射到一個方向"}, {"id": "c", "text": "白紙完全不能反射光"}, {"id": "d", "text": "鏡面只反射聲音"}]', '"b"', '平滑鏡面的反射方向較集中，白紙把光反射到多個方向。'),
  ('5SC13', '一個簡單電路有電池、燈泡、開關和連接線。閉合開關時，開關在電路中有甚麼作用？', '[{"id": "a", "text": "把電池變成燈泡"}, {"id": "b", "text": "阻止電流流過燈泡"}, {"id": "c", "text": "接通電路"}, {"id": "d", "text": "切斷電路"}]', '"c"', '閉合開關接通導電路徑，燈泡才有可能亮起。'),
  ('5SC13', '電池和燈泡完好，但一條電線鬆脫。為甚麼燈泡不亮？', '[{"id": "a", "text": "電池兩端已連成完整通路"}, {"id": "b", "text": "燈泡改變了電池的大小"}, {"id": "c", "text": "空氣把燈泡遮住"}, {"id": "d", "text": "電路有斷開的位置"}]', '"d"', '電路中有斷開的位置，電流不能沿完整路徑流過燈泡。'),
  ('5SC13', '要使小燈泡接入簡單電路，電線應接觸燈泡的哪兩處？', '[{"id": "a", "text": "底部接點和金屬外殼接點"}, {"id": "b", "text": "玻璃頂和玻璃側"}, {"id": "c", "text": "同一處底部接點"}, {"id": "d", "text": "兩處玻璃表面"}]', '"a"', '底部和金屬外殼接點各連到燈絲的一端，可讓電流流過燈絲。'),
  ('5SC13', '在低電壓電池電路的缺口放入一件物品。哪件物品最有可能使燈泡亮起？', '[{"id": "a", "text": "橡膠擦"}, {"id": "b", "text": "金屬萬字夾"}, {"id": "c", "text": "塑膠間尺"}, {"id": "d", "text": "乾木筷子"}]', '"b"', '金屬萬字夾能導電，放入缺口可接通電路。'),
  ('5SC13', '電線通常由金屬線芯和塑膠外層組成。塑膠外層的作用是甚麼？', '[{"id": "a", "text": "增加金屬線芯的長度"}, {"id": "b", "text": "把電流變成光"}, {"id": "c", "text": "把導電的線芯與外界隔開"}, {"id": "d", "text": "把電流集中在塑膠外層"}]', '"c"', '塑膠通常是絕緣體，可把導電線芯與外界隔開。'),
  ('5SC13', '兩個電路只有一項分別。甲的開關閉合，乙的開關斷開。電池、燈泡及其餘接駁均正常。哪項結果合理？', '[{"id": "a", "text": "甲不亮，乙亮"}, {"id": "b", "text": "甲和乙都亮"}, {"id": "c", "text": "甲和乙都不亮"}, {"id": "d", "text": "甲亮，乙不亮"}]', '"d"', '只有甲有完整的導電路徑。'),
  ('5SC13', '同學要比較兩種材料能否導電。在同一低電壓電池電路測試時，應怎樣安排？', '[{"id": "a", "text": "只更換接在缺口的材料"}, {"id": "b", "text": "每次同時換材料和電池"}, {"id": "c", "text": "每次同時換材料和燈泡"}, {"id": "d", "text": "用不同數量的電池測試各材料"}]', '"a"', '只更換測試材料，較容易判斷結果是否與材料有關。'),
  ('5SC13', '電風扇正常運作時，電能主要轉化成甚麼形式的能量，使扇葉轉動？', '[{"id": "a", "text": "聲能"}, {"id": "b", "text": "動能"}, {"id": "c", "text": "光能"}, {"id": "d", "text": "化學能"}]', '"b"', '轉動的扇葉具有動能。聲音是運作時的附帶效果。'),
  ('5SC13', '哪一組連接最能使一枚電池和一個完好的小燈泡形成閉合電路？', '[{"id": "a", "text": "只接一條線到燈泡玻璃"}, {"id": "b", "text": "兩極都接到燈泡玻璃"}, {"id": "c", "text": "電池兩極分別接到燈泡的兩個接點"}, {"id": "d", "text": "兩條線都由正極接到同一接點"}]', '"c"', '電池兩極須分別與燈泡的兩個導電接點相連。'),
  ('5SC13', '老師把完好的電池和燈泡接成電路。閉合開關後燈泡不亮。哪項檢查最能找出有沒有斷路？', '[{"id": "a", "text": "比較兩條線的顏色"}, {"id": "b", "text": "量度桌面的長度"}, {"id": "c", "text": "查看燈泡外盒的圖案"}, {"id": "d", "text": "逐一查看各接點是否牢固接觸"}]', '"d"', '接點鬆脫會中斷通路，檢查接觸情況有助找出斷路位置。'),
  ('5SC14', '人體哪一個器官負責從血液中移除部分廢物和多餘水分，形成尿液？', '[{"id": "a", "text": "腎臟"}, {"id": "b", "text": "膀胱"}, {"id": "c", "text": "胃"}, {"id": "d", "text": "肺"}]', '"a"', '腎臟處理血液中的部分廢物和多餘水分，形成尿液。'),
  ('5SC14', '尿液形成後，經哪一部分由腎臟流往膀胱？', '[{"id": "a", "text": "氣管"}, {"id": "b", "text": "輸尿管"}, {"id": "c", "text": "尿道"}, {"id": "d", "text": "食道"}]', '"b"', '輸尿管連接腎臟和膀胱，把尿液送到膀胱。'),
  ('5SC14', '哪一個器官主要暫時儲存尿液？', '[{"id": "a", "text": "心臟"}, {"id": "b", "text": "小腸"}, {"id": "c", "text": "膀胱"}, {"id": "d", "text": "腎臟"}]', '"c"', '膀胱像一個儲存袋，排尿前暫時儲存尿液。'),
  ('5SC14', '排尿時，尿液由膀胱經哪一部分排出體外？', '[{"id": "a", "text": "輸尿管"}, {"id": "b", "text": "食道"}, {"id": "c", "text": "血管"}, {"id": "d", "text": "尿道"}]', '"d"', '尿道是尿液由膀胱排出體外的通道。'),
  ('5SC14', '由形成尿液到排出體外，哪個次序正確？', '[{"id": "a", "text": "腎臟→輸尿管→膀胱→尿道"}, {"id": "b", "text": "腎臟→尿道→膀胱→輸尿管"}, {"id": "c", "text": "膀胱→腎臟→尿道→輸尿管"}, {"id": "d", "text": "膀胱→輸尿管→腎臟→尿道"}]', '"a"', '尿液先在腎臟形成，經輸尿管流入膀胱，再經尿道排出。'),
  ('5SC14', '人體通常有多少個腎臟？', '[{"id": "a", "text": "四個"}, {"id": "b", "text": "兩個"}, {"id": "c", "text": "一個"}, {"id": "d", "text": "三個"}]', '"b"', '人體通常有兩個腎臟。'),
  ('5SC14', '在一張泌尿系統示意圖中，兩條管道各自從一個腎臟連到膀胱。這兩條管道是甚麼？', '[{"id": "a", "text": "食道"}, {"id": "b", "text": "氣管"}, {"id": "c", "text": "輸尿管"}, {"id": "d", "text": "尿道"}]', '"c"', '兩條輸尿管分別把兩個腎臟形成的尿液送到膀胱。'),
  ('5SC14', '小強說「膀胱形成尿液」。應怎樣修正？', '[{"id": "a", "text": "尿液在膀胱形成，腎臟儲存尿液"}, {"id": "b", "text": "尿液在尿道形成，膀胱儲存尿液"}, {"id": "c", "text": "尿液在輸尿管形成，膀胱儲存尿液"}, {"id": "d", "text": "尿液在腎臟形成，膀胱暫時儲存尿液"}]', '"d"', '形成和儲存尿液分別由腎臟和膀胱負責。'),
  ('5SC14', '哪一組是泌尿系統的器官或通道？', '[{"id": "a", "text": "腎臟和輸尿管"}, {"id": "b", "text": "心臟和血管"}, {"id": "c", "text": "口腔和食道"}, {"id": "d", "text": "氣管和肺"}]', '"a"', '腎臟形成尿液，輸尿管把尿液送到膀胱。'),
  ('5SC14', '哪項最能說明人體排尿的其中一個作用？', '[{"id": "a", "text": "把血液送到全身"}, {"id": "b", "text": "把部分廢物和多餘水分排出體外"}, {"id": "c", "text": "把氧氣送入肺部"}, {"id": "d", "text": "把食物送到胃部"}]', '"b"', '尿液帶走人體的部分廢物及多餘水分。'),
  ('5SC15', '地球上大多數地方有晝夜交替，主要原因是甚麼？', '[{"id": "a", "text": "太陽每天熄滅一次"}, {"id": "b", "text": "地球每天繞太陽一周"}, {"id": "c", "text": "地球繞着自己的地軸自轉"}, {"id": "d", "text": "月球每晚遮住太陽"}]', '"c"', '地球自轉，地方輪流朝向和背向太陽。'),
  ('5SC15', '地球繞太陽公轉一周約需多久？', '[{"id": "a", "text": "一天"}, {"id": "b", "text": "一星期"}, {"id": "c", "text": "一個月"}, {"id": "d", "text": "一年"}]', '"d"', '地球公轉一周約需一年。'),
  ('5SC15', '香港某處正朝向太陽，並受到陽光照射。該處大致處於甚麼時段？', '[{"id": "a", "text": "白天"}, {"id": "b", "text": "夜晚"}, {"id": "c", "text": "一定是午夜"}, {"id": "d", "text": "一定是日落"}]', '"a"', '受到陽光照射的地區處於白天。'),
  ('5SC15', '我們看見月球明亮的部分，主要是因為甚麼？', '[{"id": "a", "text": "月球內部每晚燃燒"}, {"id": "b", "text": "月球表面反射陽光"}, {"id": "c", "text": "月球像太陽般自行發光"}, {"id": "d", "text": "月球反射地球上的路燈"}]', '"b"', '月球表面受陽光照射後，反射的光可到達我們眼睛。'),
  ('5SC15', '哪項最能解釋月相為何會改變？', '[{"id": "a", "text": "地球每晚遮住月球一部分"}, {"id": "b", "text": "月球每月自行變成不同形狀"}, {"id": "c", "text": "月球繞地球運行，我們看見受光部分的比例改變"}, {"id": "d", "text": "月球每天改變實際大小"}]', '"c"', '月球位置改變，我們看見的受陽光照射部分也會改變。'),
  ('5SC15', '下列哪一項是太陽系的行星？', '[{"id": "a", "text": "太陽"}, {"id": "b", "text": "月球"}, {"id": "c", "text": "北極星"}, {"id": "d", "text": "火星"}]', '"d"', '火星繞太陽運行，是太陽系的行星。'),
  ('5SC15', '以下哪顆行星距離太陽最近？', '[{"id": "a", "text": "水星"}, {"id": "b", "text": "地球"}, {"id": "c", "text": "火星"}, {"id": "d", "text": "木星"}]', '"a"', '在八大行星中，水星最接近太陽。'),
  ('5SC15', '科學家想長期觀察火星表面的岩石，哪種工具最適合在當地移動和拍照？', '[{"id": "a", "text": "在海面航行的研究船"}, {"id": "b", "text": "火星探測車"}, {"id": "c", "text": "在地球使用的雨量計"}, {"id": "d", "text": "固定在地球的指南針"}]', '"b"', '火星探測車能在火星表面移動，收集岩石影像和其他資料。'),
  ('5SC15', '氣象人員想同時觀察大範圍的雲帶，哪項工具最適合？', '[{"id": "a", "text": "指南針"}, {"id": "b", "text": "日晷"}, {"id": "c", "text": "氣象衞星"}, {"id": "d", "text": "課室溫度計"}]', '"c"', '氣象衞星可從高空拍攝大片地區的雲層，協助觀察天氣。'),
  ('5SC15', '太陽系中的地球和月球有甚麼關係？', '[{"id": "a", "text": "地球是月球的天然衞星"}, {"id": "b", "text": "月球是比地球大的行星"}, {"id": "c", "text": "地球和月球都是恆星"}, {"id": "d", "text": "月球是地球的天然衞星"}]', '"d"', '月球繞地球運行，是地球的天然衞星。');

insert into public.questions (node_id, question_type, question_text, options, difficulty, source_type, status)
select n.id, 'multiple_choice', t.question_text, t.options, 3, 'teacher', 'published'
from p5_textbook_practice_seed t
join public.curriculum_nodes n on n.code = t.unit_code
join public.curriculum_domains d on d.id = n.domain_id and d.code = 'textbook_reference'
join public.curriculum_subjects s on s.id = d.subject_id and s.code = 'science' and s.grade = 'P5'
where not exists (
  select 1 from public.questions q where q.node_id = n.id and q.question_text = t.question_text
);

insert into public.question_answer_keys (question_id, correct_answer, explanation)
select q.id, t.correct_answer, t.explanation
from p5_textbook_practice_seed t
join public.curriculum_nodes n on n.code = t.unit_code
join public.curriculum_domains d on d.id = n.domain_id and d.code = 'textbook_reference'
join public.curriculum_subjects s on s.id = d.subject_id and s.code = 'science' and s.grade = 'P5'
join public.questions q on q.node_id = n.id and q.question_text = t.question_text
on conflict (question_id) do nothing;

do $$
begin
  if (
    select count(*)
    from p5_textbook_practice_seed t
    join public.curriculum_nodes n on n.code = t.unit_code and n.is_active
    join public.curriculum_domains d on d.id = n.domain_id and d.code = 'textbook_reference'
    join public.curriculum_subjects s on s.id = d.subject_id and s.code = 'science' and s.grade = 'P5'
    join public.questions q on q.node_id = n.id and q.question_text = t.question_text
      and q.status = 'published' and q.options = t.options
    join public.question_answer_keys k on k.question_id = q.id and k.correct_answer = t.correct_answer
  ) <> 40 then
    raise exception 'P5 textbook practice verification failed';
  end if;
end $$;

commit;
