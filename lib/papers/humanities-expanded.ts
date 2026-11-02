import {validPictureAnswerSpace} from './picture-answer-space';
import {AccessError} from './admin-auth';
import {BankSetupError} from './private-bank';
import {PaperInputError} from './generator';
import {MIXED_TYPES, type CustomMixedOptions, validateCustomMixedOptions} from './humanities-custom';
import type {Section,HumanitiesMixedPaper} from './humanities-mixed';

type Kind=Section['kind'];
type Question=Section['questions'][number]&{unit:string;correct?:string};
type Group={id:string;unit:string;kind:Kind;title:string;questions:Question[];picture?:Section['picture'];instructions?:string;words?:string[];stimulus?:Section['stimulus']};
export type ExpandedHumanitiesBank={schemaVersion:2;subject:'humanities';bankKey:'p5-humanities-mixed-expanded-v1';version:string;units:{code:string;title:string}[];groups:Group[]};
export const EXPANDED_TYPES:Record<string,string>={...MIXED_TYPES,picture:'情景圖片題'};
const kinds=Object.keys(EXPANDED_TYPES) as Kind[];
const object=(v:unknown):v is Record<string,unknown>=>!!v&&typeof v==='object'&&!Array.isArray(v);
const string=(v:unknown,max=5000):v is string=>typeof v==='string'&&v.trim().length>0&&v.length<=max&&!/[\u0000-\u0008\u000b\u000c\u000e-\u001f\ufffd]/.test(v);
function validPictureSource(v:unknown):v is string{
 if(typeof v!=='string'||v.length>800000||!/^data:image\/webp;base64,[A-Za-z0-9+/]+={0,2}$/.test(v))return false;
 const encoded=v.slice('data:image/webp;base64,'.length);if(encoded.length%4)return false;
 try{const header=atob(encoded.slice(0,16));return header.slice(0,4)==='RIFF'&&header.slice(8,12)==='WEBP';}catch{return false;}
}
export function validateExpandedHumanitiesBank(v:unknown):ExpandedHumanitiesBank{
 const fail=():never=>{throw new BankSetupError('人文科擴充混合題庫資料不完整，請聯絡管理員。');};
 if(!object(v)||v.schemaVersion!==2||v.subject!=='humanities'||v.bankKey!=='p5-humanities-mixed-expanded-v1'||!string(v.version,80)||!Array.isArray(v.units)||!v.units.length||v.units.length>30||!Array.isArray(v.groups)||!v.groups.length||v.groups.length>500)return fail();
 const units=new Set<string>(),ids=new Set<string>(),groupIds=new Set<string>();
 for(const u of v.units){if(!object(u)||!string(u.code,10)||!/^5H[1-9]\d*$/.test(u.code)||units.has(u.code)||!string(u.title,100))return fail();units.add(u.code);}
 for(const g of v.groups){
  if(!object(g)||!string(g.id,60)||groupIds.has(g.id)||!string(g.unit,10)||!units.has(g.unit)||!kinds.includes(g.kind as Kind)||!string(g.title,100)||!Array.isArray(g.questions)||!g.questions.length||g.questions.length>20)return fail();groupIds.add(g.id);
  const kind=g.kind as Kind,words=g.words;
  if(kind!=='picture'&&g.picture!==undefined)return fail();
  if(g.instructions!==undefined&&!string(g.instructions,1500))return fail();
  if(kind==='fill'||kind==='match'){if(!Array.isArray(words)||words.length<g.questions.length||words.length>26||words.some(w=>!string(w,300))||new Set(words).size!==words.length)return fail();}
  if(kind==='picture'){const p=g.picture;if(!object(p)||!string(p.alt,500)||!Number.isInteger(p.width)||!Number.isInteger(p.height)||Number(p.width)<512||Number(p.width)>2400||Number(p.height)<256||Number(p.height)>1800||!validPictureSource(p.src)||g.questions.length!==4||g.questions.reduce((n,q)=>n+(object(q)?Number(q.marks):0),0)!==12)return fail();}
  if(kind==='analysis'){const s=g.stimulus;if(!object(s)||!string(s.intro,1500)||!string(s.note,300)||!Array.isArray(s.headers)||s.headers.length!==2||s.headers.some(h=>!string(h,100))||!Array.isArray(s.rows)||!s.rows.length||s.rows.length>12||s.rows.some(r=>!Array.isArray(r)||r.length!==2||r.some(c=>!string(c,300))))return fail();}
  const used=new Set<string>();
  for(const q of g.questions){
   if(!object(q)||!string(q.id,60)||ids.has(q.id)||q.unit!==g.unit||!string(q.prompt)||!string(q.answer)||!Number.isInteger(q.marks)||Number(q.marks)<1||Number(q.marks)>10||!Array.isArray(q.points)||!q.points.length||q.points.length>10)return fail();ids.add(q.id);
   if(q.answerSpace!==undefined&&(kind!=='picture'||!validPictureAnswerSpace(q.answerSpace)))return fail();
   let score=0;for(const p of q.points){if(!object(p)||!string(p.text)||!Number.isInteger(p.marks)||Number(p.marks)<1)return fail();score+=Number(p.marks);}if(score!==q.marks)return fail();
   if(kind==='choice'){if(!Array.isArray(q.options)||q.options.length!==4||q.options.some(x=>!string(x,500))||new Set(q.options).size!==4||typeof q.correct!=='string'||!/^[A-D]$/.test(q.correct)||q.answer!==q.correct+'．'+q.options[q.correct.charCodeAt(0)-65])return fail();}
   if(kind==='fill'){if(!(words as string[]).includes(q.answer)||!q.prompt.includes('〔填〕')||used.has(q.answer))return fail();used.add(q.answer);}
   if(kind==='match'){if(typeof q.correct!=='string'||!/^[A-Z]$/.test(q.correct)||(words as string[])[q.correct.charCodeAt(0)-65]===undefined||q.answer!==q.correct+'．'+(words as string[])[q.correct.charCodeAt(0)-65]||used.has(q.correct))return fail();used.add(q.correct);}
   if((kind==='short'||kind==='analysis'||kind==='picture')&&(!Number.isInteger(q.lines)||Number(q.lines)<1||Number(q.lines)>6))return fail();
  }
 }
 const groups=v.groups;
 if([...units].some(u=>!groups.some(g=>object(g)&&g.unit===u)))return fail();
 return v as unknown as ExpandedHumanitiesBank;
}
export async function loadExpandedHumanitiesBank(request:Request,fetcher:typeof fetch=fetch):Promise<ExpandedHumanitiesBank>{
 try{const r=await fetcher('https://noaoqdwllmcnmczroyfn.supabase.co/rest/v1/paper_generator_banks?bank_key=eq.p5-humanities-mixed-expanded-v1&select=payload&limit=1',{headers:{apikey:'sb_publishable_-hYVvTs_A97aG_jT_nyiMA_dostycdf',Authorization:request.headers.get('authorization')||''},cache:'no-store',signal:AbortSignal.timeout(10000)});if(r.status===401||r.status===403)throw new AccessError(403,'帳戶未獲授權讀取人文科擴充題庫。');if(!r.ok)throw new BankSetupError('暫時無法讀取人文科擴充題庫。');const rows=await r.json();if(!Array.isArray(rows)||rows.length!==1)throw new BankSetupError('人文科擴充題庫尚未設定。');return validateExpandedHumanitiesBank(rows[0].payload);}catch(e){if(e instanceof AccessError||e instanceof BankSetupError)throw e;throw new BankSetupError('暫時無法讀取人文科擴充題庫。');}
}
export function addHumanitiesPictures(base:ExpandedHumanitiesBank,v:unknown):ExpandedHumanitiesBank{
 if(!object(v)||v.schemaVersion!==1||v.subject!=='humanities-pictures'||v.bankKey!=='p5-humanities-pictures-v1'||!string(v.version,80)||!Array.isArray(v.groups)||!v.groups.length||v.groups.length>30||v.groups.some(g=>!object(g)||g.kind!=='picture'))throw new BankSetupError('人文科情景圖片題庫資料不完整。');
 return validateExpandedHumanitiesBank({...base,groups:[...base.groups,...v.groups]});
}
export async function loadHumanitiesPictures(request:Request,base:ExpandedHumanitiesBank,fetcher:typeof fetch=fetch):Promise<ExpandedHumanitiesBank>{
 try{const r=await fetcher('https://noaoqdwllmcnmczroyfn.supabase.co/rest/v1/paper_generator_banks?bank_key=eq.p5-humanities-pictures-v1&select=payload&limit=1',{headers:{apikey:'sb_publishable_-hYVvTs_A97aG_jT_nyiMA_dostycdf',Authorization:request.headers.get('authorization')||''},cache:'no-store',signal:AbortSignal.timeout(10000)});if(r.status===401||r.status===403)throw new AccessError(403,'帳戶未獲授權讀取情景圖片題。');if(!r.ok)throw new BankSetupError('暫時無法讀取情景圖片題庫。');const rows=await r.json();if(!Array.isArray(rows)||rows.length!==1)throw new BankSetupError('人文科情景圖片題庫尚未設定。');return addHumanitiesPictures(base,rows[0].payload);}catch(e){if(e instanceof AccessError||e instanceof BankSetupError)throw e;throw new BankSetupError('暫時無法讀取情景圖片題庫。');}
}
export const validateExpandedOptions=(v:unknown)=>validateCustomMixedOptions(v,EXPANDED_TYPES);
export function expandedHumanitiesInventory(b:ExpandedHumanitiesBank){return{units:b.units.map(u=>{const groups=b.groups.filter(g=>g.unit===u.code);return{...u,count:groups.reduce((n,g)=>n+(g.kind==='analysis'||g.kind==='picture'?1:g.questions.length),0),responses:groups.reduce((n,g)=>n+g.questions.length,0),marks:groups.reduce((n,g)=>n+g.questions.reduce((a,q)=>a+q.marks,0),0)};}),types:EXPANDED_TYPES,responses:b.groups.reduce((n,g)=>n+g.questions.length,0),typeCounts:Object.fromEntries(kinds.map(k=>[k,b.groups.filter(g=>g.kind===k).reduce((n,g)=>n+g.questions.length,0)])),maxMarks:100};}
function shuffle<T>(input:T[],seed:number){const a=[...input];for(let i=a.length-1;i>0;i--){seed=(Math.imul(seed,1664525)+1013904223)>>>0;const j=Math.floor(seed/4294967296*(i+1));[a[i],a[j]]=[a[j],a[i]];}return a;}
const wordKey=(word:string)=>word.replace(/\u0332/g,'').normalize('NFC').trim();
const instructions:Record<Kind,string>={choice:'每題選出一個正確答案，並在該選項前的方格內加上 ☑。',fill:'從本組詞語框選出適當詞語，填在橫線上。每個詞語只可用一次，有些詞語多餘。',match:'把本組合適說明前的英文字母，填在各題括號內。每個字母只可用一次，有些說明多餘。',analysis:'細閱本組資料，回答以下各題。',short:'按題目要求作答，提出合理做法並說明原因。',picture:'細閱圖一至圖四，回答以下問題。'};
export function selectExpandedHumanities(o:CustomMixedOptions,b:ExpandedHumanitiesBank):HumanitiesMixedPaper{
 if(o.units.some(u=>!b.units.some(x=>x.code===u)))throw new PaperInputError('所選單元未有混合題目，請重新選擇範圍。');
 const rawEntries=shuffle(b.groups.filter(g=>o.units.includes(g.unit)&&o.types.includes(g.kind)),o.seed).flatMap(group=>group.kind==='analysis'||group.kind==='picture'?[{group,questions:group.questions,marks:group.questions.reduce((n,q)=>n+q.marks,0)}]:group.questions.map(q=>({group,questions:[q],marks:q.marks}))); 
 // Matching letters are used once: equivalent descriptions cannot be selected
 // as different answers when combining contexts into one shared option box.
 const matchingAnswers=new Set<string>();
 const entries=rawEntries.filter(e=>{if(e.group.kind!=='match')return true;const key=wordKey(e.questions[0].answer.slice(2));if(matchingAnswers.has(key))return false;matchingAnswers.add(key);return true;});
 // Solve each type separately, then combine exact scores. State size is bounded by
 // score x 3, rather than score x 3^types for every question in the whole bank.
 type Path={indices:number[];count:number};
 let combined=new Map<number,Path>([[0,{indices:[],count:0}]]);
 for(const kind of kinds.filter(k=>o.types.includes(k))){
  const pool=entries.map((e,i)=>({e,i})).filter(x=>x.e.group.kind===kind);
  if(kind==='match'&&pool.length<5)throw new PaperInputError('所選單元不足 5 題不同答案的配對題。配對題須有 5–6 題，請增加單元或取消配對題。');
  if(!pool.length)throw new PaperInputError('所選單元暫無「'+EXPANDED_TYPES[kind]+'」，請調整範圍。');
  const states=new Map<string,Path>([['0:0',{indices:[],count:0}]]);
  for(const {e,i} of pool)for(const [key,p] of [...states]){const score=Number(key.split(':')[0])+e.marks;if(score>o.total)continue;const count=kind==='match'?p.count+e.questions.length:Math.min(2,p.count+e.questions.length);if(kind==='match'&&count>6)continue;const next=score+':'+count;if(!states.has(next))states.set(next,{indices:[...p.indices,i],count});}
  const next=new Map<number,Path>();
  for(const [score,p] of combined)for(const [key,q] of states){const [add,count]=key.split(':').map(Number),sum=score+add;if(!count||sum>o.total||kind==='match'&&count<5)continue;const quality=p.count+(kind==='match'||count===2?100000:0)-(add-o.total/o.types.length)**2,previous=next.get(sum);if(!previous||quality>previous.count)next.set(sum,{indices:[...p.indices,...q.indices],count:quality});}
  combined=next;
 }
 const path=combined.get(o.total);
 if(!path)throw new PaperInputError('未能以所選範圍及全部所選題型剛好配足 '+o.total+' 分。請調整總分、增加單元或減少題型；配對題須有 5–6 題，資料分析及情景圖片題每組 12 分，均會完整抽取。');
 const selected=path.indices.map(i=>entries[i]),sections:Section[]=[],active=kinds.filter(k=>o.types.includes(k));
 let sectionOffset=0;
 for(const kind of active){
  const numeral=['一','二','三','四','五','六'][active.indexOf(kind)];
  if(kind==='choice'||kind==='short'){sections.push({kind,title:numeral+'、'+EXPANDED_TYPES[kind],instructions:instructions[kind],startNumber:0,questions:shuffle(selected.filter(e=>e.group.kind===kind).flatMap(e=>e.questions),o.seed^sectionOffset++)});continue;}
  if(kind==='fill'){
   const groups=b.groups.filter(g=>g.kind==='fill'&&selected.some(e=>e.group.id===g.id));
   const questions=groups.flatMap(group=>shuffle(selected.filter(e=>e.group.id===group.id).flatMap(e=>e.questions),o.seed^sectionOffset++));
   // A shared word box must not list the same term twice, including terms with
   // different proper-name underline markup. Reuse is permitted when required.
   const key=wordKey;
   const unique=new Map<string,string>();for(const group of groups)for(const word of group.words||[])if(!unique.has(key(word)))unique.set(key(word),word);
   const repeated=new Set(questions.map(q=>key(q.answer))).size<questions.length;
   sections.push({kind,title:numeral+'、'+EXPANDED_TYPES[kind],instructions:'從詞語框選出適當詞語，填在橫線上。'+(repeated?'詞語可按需要重複使用':'每個詞語只可用一次')+'，有些詞語多餘。',startNumber:0,questions,words:shuffle([...unique.values()],o.seed^0x574f5244)});continue;
  }
  if(kind==='match'){
   const chosen=selected.filter(e=>e.group.kind==='match'),groups=b.groups.filter(g=>g.kind==='match'&&chosen.some(e=>e.group.id===g.id));
   sectionOffset+=groups.length;
   const questions=shuffle(chosen.flatMap(e=>e.questions),o.seed^0x4d415443),correct=new Map<string,string>();
   for(const q of questions){const description=q.answer.slice(2);correct.set(wordKey(description),description);}
   const extra=new Map<string,string>();for(const group of groups)for(const word of group.words||[])if(!correct.has(wordKey(word))&&!extra.has(wordKey(word)))extra.set(wordKey(word),word);
   const distractors=shuffle([...extra.values()],o.seed^0x44495354).slice(0,2),words=shuffle([...correct.values(),...distractors],o.seed^0x4c455454);
   sections.push({kind,title:numeral+'、'+EXPANDED_TYPES[kind],instructions:'把合適說明前的英文字母，填在各題括號內。每個字母只可用一次'+(distractors.length?'，有些說明多餘。':'。'),startNumber:0,words,questions:questions.map(q=>{const index=words.findIndex(w=>wordKey(w)===wordKey(q.answer.slice(2))),letter=String.fromCharCode(65+index);return{...q,correct:letter,answer:letter+'．'+words[index]};})});continue;
  }
  let startNumber=0;for(const group of b.groups.filter(g=>g.kind===kind)){
   const questions=selected.filter(e=>e.group.id===group.id).flatMap(e=>e.questions);if(!questions.length)continue;
   const numeral=['一','二','三','四','五','六'][active.indexOf(kind)];sections.push({kind,title:numeral+'、'+EXPANDED_TYPES[kind],instructions:group.instructions||instructions[kind],startNumber,questions:kind==='analysis'||kind==='picture'?(sectionOffset++,questions):shuffle(questions,o.seed^sectionOffset++),...(group.picture?{picture:group.picture}:{}),...(group.words?{words:group.words}:{}),...(group.stimulus?{stimulus:group.stimulus}:{})});startNumber+=questions.length;
  }}
 const actual=new Set(selected.map(e=>e.group.unit));return{title:o.title,minutes:o.minutes,total:o.total,units:b.units.filter(u=>actual.has(u.code)).map(u=>u.code+' '+u.title),sections,flow:true};
}
