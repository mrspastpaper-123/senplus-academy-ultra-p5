-- Read only: export a single JSON payload to avoid the SQL Editor's 100-row cap.
-- Run in each P1-P6 Supabase project. This does not alter questions or answers.
with candidates as (
 select s.grade, s.code as subject_code, n.code as unit_code, n.title_zh as unit_title,
        q.id as question_id, q.question_text, q.options,
        case when q.question_text ~ '(圖卡|卡片)標題(是|為)?[：:[:space:]]*[「“"]'
             then 'title_card_candidate'
             when q.question_text ~ '(左圖|右圖|下圖|上圖|圖中|圖意|觀察圖片|看圖)'
             then 'other_visual_review'
             else 'card_mention_review' end as review_type
 from public.questions q
 join public.curriculum_nodes n on n.id=q.node_id
 join public.curriculum_domains d on d.id=n.domain_id
 join public.curriculum_subjects s on s.id=d.subject_id
 where s.grade in ('P1','P2','P3','P4','P5','P6')
   and q.status='published'
   and q.question_text ~ '(圖卡|卡片標題|文字卡|左圖|右圖|下圖|上圖|圖中|圖意|觀察圖片|看圖)'
)
select count(*) as candidate_count,
       coalesce(jsonb_agg(to_jsonb(candidates) order by grade,unit_code,question_id),'[]'::jsonb) as audit_payload
from candidates;
