import {AccessError} from './admin-auth';
import {BankSetupError} from './private-bank';
import {PaperInputError} from './generator';
export const HUMANITIES_TYPES:Record<string,string>={concept:'概念理解',scenario:'情境應用',analysis:'資料判讀',reasoning:'判斷與推理'};
type Unit={id:number;code:string;title:string};
export type HumanitiesQuestion={id:number;unit:string;prompt:string;options:{id:string;text:string}[];correct:string;explanation:string;type:string;concept:string};
export type HumanitiesBank={units:Unit[];questions:HumanitiesQuestion[]};
export type HumanitiesOptions={mode:'full'|'custom';title:string;minutes:number;total:number;questionCount:number;marksEach:number;seed:number;units:string[];types:string[]};
const record=(v:unknown):v is Record<string,unknown>=>!!v&&typeof v==='object'&&!Array.isArray(v);
const norm=(s:string)=>s.replace(/[\s\u0332\p{P}]/gu,'');
const clean=(s:string)=>s.replace(/^\s*【[^】\r\n]{1,30}】\s*/,'').trim();
const classify=(s:string)=>/【(?:模擬資料|閱讀|表格|資料|圖表|觀察)/.test(s)?'analysis':/【(?:多項陳述|步驟排序|配對分類|情境比較|判斷|原因|選出不|比較|配對|排序)/.test(s)?'reasoning':/【(?:人物對話|情境|生活)/.test(s)?'scenario':'concept';
export function buildHumanitiesBank(nodes:unknown,rows:unknown):HumanitiesBank{
 const fail=():never=>{throw new BankSetupError('人文科題庫資料未完整，請聯絡管理員。');};
 if(!Array.isArray(nodes)||!nodes.length||nodes.length>100||!Array.isArray(rows)||!rows.length||rows.length>5000)return fail();
 const units:Unit[]=[],questions:HumanitiesQuestion[]=[],ids=new Set<number>();
 for(const n of nodes){if(!record(n)||!Number.isSafeInteger(n.id)||Number(n.id)<1||typeof n.code!=='string'||!/^5H[1-9]\d*$/.test(n.code)||typeof n.title_zh!=='string'||!n.title_zh.trim()||units.some(u=>u.id===n.id||u.code===n.code))return fail();units.push({id:Number(n.id),code:n.code,title:n.title_zh});}
 for(const r of rows){if(!record(r)||!Number.isSafeInteger(r.id)||Number(r.id)<1||ids.has(Number(r.id))||typeof r.question_text!=='string'||!r.question_text.trim()||r.question_text.length>10000||!Array.isArray(r.options)||r.options.length!==4)return fail();
  const unit=units.find(u=>u.id===r.node_id);if(!unit)return fail();
  const options:{id:string;text:string}[]=[];
  for(const o of r.options){if(!record(o)||typeof o.id!=='string'||!o.id||o.id.length>20||typeof o.text!=='string'||!o.text.trim()||o.text.length>3000||options.some(x=>x.id===o.id||norm(x.text)===norm(String(o.text))))return fail();options.push({id:o.id,text:o.text});}
  const k=Array.isArray(r.question_answer_keys)&&r.question_answer_keys.length===1?r.question_answer_keys[0]:r.question_answer_keys;
  if(!record(k)||typeof k.correct_answer!=='string'||!options.some(o=>o.id===k.correct_answer)||typeof k.explanation!=='string'||!k.explanation.trim()||k.explanation.length>10000)return fail();
  ids.add(Number(r.id));questions.push({id:Number(r.id),unit:unit.code,prompt:r.question_text,options,correct:k.correct_answer,explanation:k.explanation,type:classify(r.question_text),concept:unit.code+':'+norm(clean(r.question_text))});
 }
 // Earlier units contain several formats of each topic; link them to the original concept.
 for(const u of units){const qs=questions.filter(q=>q.unit===u.code),topics=qs.filter(q=>/^\s*【選出正確答案】/.test(q.prompt)).map(q=>({title:q.prompt.match(/關於「([^」]+)」/)?.[1],phrase:norm(q.options.find(o=>o.id===q.correct)!.text)})).filter(t=>t.title);
  for(const q of qs){const p=norm(q.prompt),a=norm(q.options.find(o=>o.id===q.correct)!.text);const t=topics.find(t=>p.includes(norm(t.title!)))||topics.find(t=>t.phrase.length>=4&&p.includes(t.phrase))||topics.find(t=>t.phrase.length>=4&&a.includes(t.phrase));if(t)q.concept='topic:'+norm(t.title!);}
 }
 return{units,questions};
}
export async function loadHumanitiesBank(request:Request,fetcher:typeof fetch=fetch):Promise<HumanitiesBank>{
 const read=async(table:string,params:Record<string,string>)=>{const r=await fetcher('https://noaoqdwllmcnmczroyfn.supabase.co/rest/v1/'+table+'?'+new URLSearchParams(params),{headers:{apikey:'sb_publishable_-hYVvTs_A97aG_jT_nyiMA_dostycdf',Authorization:request.headers.get('authorization')||''},cache:'no-store',signal:AbortSignal.timeout(10000)});if(r.status===401||r.status===403)throw new AccessError(403,'帳戶未獲授權讀取人文科題庫。');if(!r.ok)throw new BankSetupError('暫時無法讀取人文科題庫。');const v=await r.json();if(!Array.isArray(v))throw new BankSetupError('人文科題庫格式不正確。');return v;};
 try{const subjects=await read('curriculum_subjects',{code:'eq.humanities',grade:'eq.P5',is_active:'eq.true',select:'id',limit:'2'});if(subjects.length!==1)throw new BankSetupError('未找到小五人文科。');const domains=await read('curriculum_domains',{subject_id:'eq.'+subjects[0].id,is_active:'eq.true',select:'id'});if(!domains.length)throw new BankSetupError('人文科尚未設定單元。');const nodes=await read('curriculum_nodes',{domain_id:'in.('+domains.map(d=>d.id).join(',')+')',is_active:'eq.true',select:'id,code,title_zh',order:'id'});if(!nodes.length)throw new BankSetupError('人文科尚未設定單元。');const rows:unknown[]=[];
 for(let offset=0;offset<=5000;offset+=500){const page=await read('questions',{node_id:'in.('+nodes.map(n=>n.id).join(',')+')',status:'eq.published',question_type:'eq.multiple_choice',select:'id,node_id,question_text,options,question_answer_keys(correct_answer,explanation)',order:'id',limit:'500',offset:String(offset)});rows.push(...page);if(rows.length>5000)throw new BankSetupError('題庫超出本版處理範圍。');if(page.length<500)break;}return buildHumanitiesBank(nodes,rows);
 }catch(e){if(e instanceof AccessError||e instanceof BankSetupError)throw e;throw new BankSetupError('暫時無法讀取人文科題庫，請稍後再試。');}
}
export function validateHumanitiesOptions(v:unknown):HumanitiesOptions{
 if(!record(v)||!['full','custom'].includes(String(v.mode)))throw new PaperInputError('請選擇有效配卷方式。');
 if(typeof v.title!=='string'||!v.title.trim()||v.title.length>60||/[\u0000-\u001f]/.test(v.title))throw new PaperInputError('試卷名稱須為 1 至 60 個字。');
 for(const[k,min,max]of [['minutes',5,180],['questionCount',5,50],['marksEach',1,5],['seed',0,4294967295]]as const)if(!Number.isInteger(v[k])||Number(v[k])<min||Number(v[k])>max)throw new PaperInputError('請核對時間、題數及每題分數。');
 if(v.total!==Number(v.questionCount)*Number(v.marksEach)||Number(v.total)>150)throw new PaperInputError('總分須等於題數乘每題分數，且不超過 150 分。');
 if(!Array.isArray(v.units)||!v.units.length||v.units.length>100||v.units.some(u=>typeof u!=='string'||!/^5H[1-9]\d*$/.test(u))||!Array.isArray(v.types)||!v.types.length||v.types.some(t=>typeof t!=='string'||!Object.hasOwn(HUMANITIES_TYPES,t)))throw new PaperInputError('請選擇有效單元及考核重點。');
 if(v.mode==='full'&&(v.questionCount!==25||v.marksEach!==2))throw new PaperInputError('綜合卷為 25 題，每題 2 分。');
 return{...v,title:v.title.trim(),units:[...new Set(v.units)],types:[...new Set(v.types)]}as HumanitiesOptions;
}
function shuffle<T>(values:T[],seed:number){const a=[...values];for(let i=a.length-1;i>0;i--){seed=(Math.imul(seed,1664525)+1013904223)>>>0;const j=Math.floor(seed/4294967296*(i+1));[a[i],a[j]]=[a[j],a[i]];}return a;}
export function selectHumanitiesQuestions(o:HumanitiesOptions,b:HumanitiesBank){
 const units=o.mode==='full'?b.units.map(u=>u.code):o.units,types=o.mode==='full'?Object.keys(HUMANITIES_TYPES):o.types;
 if(units.some(u=>!b.units.some(x=>x.code===u)))throw new PaperInputError('所選單元已變更，請重新載入。');
 const queues=shuffle(units,o.seed).map((u,i)=>shuffle(b.questions.filter(q=>q.unit===u&&types.includes(q.type)),(o.seed+i*997)>>>0));
 const out:HumanitiesQuestion[]=[],concepts=new Set<string>(),stems=new Set<string>();let added=true;
 while(out.length<o.questionCount&&added){added=false;for(const queue of queues){while(queue.length){const q=queue.pop()!,stem=norm(clean(q.prompt));if(concepts.has(q.concept)||stems.has(stem))continue;out.push(q);concepts.add(q.concept);stems.add(stem);added=true;break;}if(out.length===o.questionCount)break;}}
 if(out.length!==o.questionCount)throw new PaperInputError('所選範圍可配出 '+out.length+' 題不同知識點的題目，請降低題數或增加單元／考核重點。');return shuffle(out,o.seed^0x9e3779b9);
}
export function humanitiesInventory(b:HumanitiesBank){return{units:b.units.map(u=>({code:u.code,title:u.title,count:b.questions.filter(q=>q.unit===u.code).length,concepts:new Set(b.questions.filter(q=>q.unit===u.code).map(q=>q.concept)).size,marks:b.questions.filter(q=>q.unit===u.code).length*2})),types:HUMANITIES_TYPES};}
const esc=(s:string)=>s.replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]!));
const text=(s:string)=>s.split(/((?:[^\u0332]\u0332)+)/g).map(p=>p.includes('\u0332')?'<span class="proper-name">'+esc(p.replace(/\u0332/g,''))+'</span>':esc(p)).join('').replace(/\r?\n/g,'<br>');
export function renderHumanitiesPaper(o:HumanitiesOptions,qs:HumanitiesQuestion[],b:HumanitiesBank,answers=false){
 const body=qs.map((q,i)=>{const opts=shuffle(q.options,(o.seed^q.id)>>>0),index=opts.findIndex(x=>x.id===q.correct);return`${i===qs.length-1?'<div class="closing">':''}<article class="question"><h3>${i+1}. ${text(clean(q.prompt))}<span class="marks">（${o.marksEach}分）</span></h3>${answers?`<p class="answer">正確答案：${String.fromCharCode(65+index)} · ${text(opts[index].text)}（${o.marksEach}分）</p><p>${text(q.explanation)}</p>`:`<div class="choices${opts.every(x=>x.text.length<=18&&!x.text.includes('\n'))?' compact':''}">${opts.map((x,j)=>`<div class="choice"><span class="choice-box"></span><b>${String.fromCharCode(65+j)}.</b><span>${text(x.text)}</span></div>`).join('')}</div>`}</article>`;}).join('');
 return`<!doctype html><html lang="zh-Hant"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; script-src 'unsafe-inline'"><title>${esc(o.title)}${answers?'：答案及評分':''}</title><style>
@page{size:A4;margin:16mm;@bottom-center{content:"第 " counter(page) " 頁／共 " counter(pages) " 頁";font:10pt Arial,"Microsoft JhengHei","PingFang TC",sans-serif;color:#596579}}
*{box-sizing:border-box}body{margin:0;color:#182432;background:white;font:12.5pt/1.8 Arial,"Microsoft JhengHei","PingFang TC",sans-serif}main{max-width:178mm;margin:auto;padding:10mm}.watermark{position:fixed;inset:0;display:flex;align-items:center;justify-content:center;pointer-events:none;z-index:10;overflow:hidden}.watermark span{transform:rotate(-32deg);color:rgba(80,94,115,.085);font:700 30pt/1.4 Arial,sans-serif;white-space:nowrap}h1{font-size:21pt;line-height:1.5;margin:0 0 5mm}h2{font-size:15pt;margin:8mm 0 3mm;break-after:avoid}h3{font-size:12.5pt;line-height:1.85;margin:0 0 3mm;font-weight:600}.marks{white-space:nowrap}.range{font-size:10pt;color:#566171}.instructions{font-size:12pt;line-height:1.85;margin:4mm 0 7mm;break-after:avoid}.closing{break-inside:avoid}.question{break-inside:avoid;margin:0 0 7mm;padding-bottom:1mm}.question p{margin:2mm 0}.choice{display:grid;grid-template-columns:1em 1.3em minmax(0,1fr);align-items:start;gap:.45em;margin:2.2mm 0;line-height:1.8;overflow-wrap:anywhere}.choices.compact{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:1mm 5mm}.compact .choice{margin:1.8mm 0}.choice-box{width:1em;height:1em;border:1.2px solid currentColor;margin-top:.35em}.proper-name{text-decoration:underline;text-underline-offset:.18em;text-decoration-skip-ink:none}.answer{font-weight:700}.end-notice{text-align:center;font-weight:700;margin:12mm 0 5mm;padding-top:5mm;break-inside:avoid}.printbar{position:sticky;top:0;padding:8px;text-align:center;background:#f0f6f4;z-index:20}.printbar button{font:inherit;border:0;border-radius:8px;background:#18766a;color:white;padding:8px 20px;cursor:pointer}@media print{main{max-width:none;padding:0}.printbar{display:none}body{print-color-adjust:exact;-webkit-print-color-adjust:exact}}
</style></head><body><div class="printbar"><button onclick="window.print()">列印</button></div><div class="watermark" aria-hidden="true"><span>SENPlus+ Academy Ultra</span></div><main><h1>${text(o.title)}${answers?' — 答案及評分':''}</h1><p>姓名：________________　班別：________　日期：____________</p><p>時間：${o.minutes} 分鐘　總分：${o.total} 分　共 ${qs.length} 題</p><p class="range">範圍：${[...new Set(qs.map(q=>q.unit))].map(code=>text(code+' '+b.units.find(u=>u.code===code)!.title)).join('、')}</p><h2>選擇題（${o.total} 分）</h2>${answers?'<p class="instructions">每題答對得 '+o.marksEach+' 分；答錯或未作答得 0 分。</p>':'<p class="instructions">每題選出一個正確答案，並在該選項前的方格內加上 ☑。</p>'}${body}<p class="end-notice">${answers?'答案及評分完':'全卷完，請檢查是否已回答所有題目。'}</p></div></main></body></html>`;
}
