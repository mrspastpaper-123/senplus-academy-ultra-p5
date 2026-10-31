import {AccessError} from './admin-auth';
import {TYPES,UNITS,type Bank,type Question} from './generator';
const URL='https://noaoqdwllmcnmczroyfn.supabase.co';
const KEY='sb_publishable_-hYVvTs_A97aG_jT_nyiMA_dostycdf';
export class BankSetupError extends Error{}
function record(v:unknown):v is Record<string,unknown>{return !!v&&typeof v==='object'&&!Array.isArray(v);}
function safeSvg(v:unknown):v is string{
 if(typeof v!=='string'||v.length>100000||!/^\s*<svg\b[^>]*>[\s\S]*<\/svg>\s*$/i.test(v))return false;
 if(/<\s*(script|foreignObject|iframe|image|a|style|use)\b|\bon[a-z]+\s*=|(?:href|src)\s*=|<!|<\?|url\s*\(/i.test(v))return false;
 const tags=v.match(/<\/?\s*([a-zA-Z][a-zA-Z0-9]*)\b/g)||[];
 return tags.every(t=>/^<\/?\s*(svg|g|text|tspan|rect|line|path|circle|polyline|polygon|ellipse|title|desc)\b/i.test(t));
}
export function validateBank(value:unknown):Bank{
 const fail=():never=>{throw new BankSetupError('私人題庫資料格式不正確，請管理員重新匯入。');};
 if(!record(value)||value.schemaVersion!==1||!Array.isArray(value.questions)||!value.questions.length||value.questions.length>5000||!record(value.diagrams))return fail();
 const ids=new Set<string>();
 for(const q of value.questions){
  if(!record(q)||typeof q.id!=='string'||ids.has(q.id)||typeof q.prompt!=='string'||!q.prompt.trim()||q.prompt.length>10000||typeof q.unit_code!=='string'||!Object.hasOwn(UNITS,q.unit_code)||typeof q.type!=='string'||!Object.hasOwn(TYPES,q.type)||!Number.isInteger(q.marks)||Number(q.marks)<1||Number(q.marks)>100||!['full','mini'].includes(String(q.paper))||typeof q.section!=='string')return fail();
  ids.add(q.id);
  const targets=q.type==='shared_stimulus'?q.subquestions:[q];
  if(!Array.isArray(targets)||targets.length<1||targets.length>30)return fail();
  for(const sub of targets){if(!record(sub)||typeof sub.prompt!=='string'||typeof sub.answer!=='string'||!Number.isInteger(sub.marks)||Number(sub.marks)<1||!Array.isArray(sub.marking_points)||!sub.marking_points.length)return fail();let total=0;
   for(const p of sub.marking_points){if(!record(p)||typeof p.text!=='string'||!Number.isInteger(p.marks)||Number(p.marks)<1)return fail();total+=Number(p.marks);}if(total!==sub.marks)return fail();
  }
  if(q.type==='shared_stimulus'&&targets.reduce((s,t)=>s+Number(t.marks),0)!==q.marks)return fail();
  if(q.type==='multiple_choice'&&(!Array.isArray(q.options)||q.options.length!==4||q.options.some(o=>!record(o)||typeof o.id!=='string'||typeof o.text!=='string')))return fail();
  if(q.diagram!==null&&q.diagram!==undefined&&(typeof q.diagram!=='string'||!Object.hasOwn(value.diagrams,q.diagram)))return fail();
 }
 for(const d of Object.values(value.diagrams)){if(!record(d)||!safeSvg(d.student)||!safeSvg(d.answer))return fail();}
 if(value.questions.some(q=>(q as Question).diagram==='grid')&&!Object.hasOwn(value.diagrams,'blankgrid'))return fail();
 return value as unknown as Bank;
}
// Caller authenticates first. Database RLS independently enforces enabled-admin access.
export async function loadPrivateBank(request:Request,fetcher:typeof fetch=fetch):Promise<Bank>{
 try{
  const response=await fetcher(`${URL}/rest/v1/paper_generator_banks?bank_key=eq.p5-maths-pilot-v1&select=payload&limit=1`,{headers:{apikey:KEY,Authorization:request.headers.get('authorization')||''},cache:'no-store',signal:AbortSignal.timeout(10000)});
  if(response.status===401||response.status===403)throw new AccessError(403,'帳戶未獲授權讀取私人題庫。');
  if(!response.ok)throw new BankSetupError('管理員私人題庫尚未完成設定，請先建立資料表並匯入題目。');
  const rows=await response.json();if(!Array.isArray(rows)||rows.length!==1)throw new BankSetupError('管理員私人題庫尚未匯入，請先完成私人題庫設定。');
  return validateBank(rows[0].payload);
 }catch(e){if(e instanceof AccessError||e instanceof BankSetupError)throw e;throw new BankSetupError('暫時無法讀取私人題庫，請稍後再試。');}
}
