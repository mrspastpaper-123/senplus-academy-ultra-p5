import {AccessError} from './admin-auth';
import {BankSetupError} from './private-bank';
type Text={x:number;y:number;width:number;size:number;bold:boolean;text:string};
type Line={x1:number;y1:number;x2:number;y2:number;width:number};
type Page={texts:Text[];lines:Line[]};
export type ChinesePaper={schemaVersion:1;subject:'chinese';marks:100;minutes:60;responses:49;fonts?:{regular:string;bold:string};studentPages:Page[];answerPages:Page[]};
const numeric=(v:unknown,max:number)=>typeof v==='number'&&Number.isFinite(v)&&v>=0&&v<=max;
const object=(v:unknown):v is Record<string,unknown>=>!!v&&typeof v==='object'&&!Array.isArray(v);
export function validateChinesePaper(v:unknown):ChinesePaper{
 const fail=():never=>{throw new BankSetupError('中文示範卷資料格式不正確，請聯絡管理員。');};
 if(!object(v)||v.schemaVersion!==1||v.subject!=='chinese'||v.marks!==100||v.minutes!==60||v.responses!==49)return fail();
 if(v.fonts!==undefined&&(!object(v.fonts)||['regular','bold'].some(k=>typeof (v.fonts as Record<string,unknown>)[k]!=='string'||! /^[A-Za-z0-9+/=]{1,400000}$/.test(String((v.fonts as Record<string,unknown>)[k])))))return fail();
 for(const [key,count]of [['studentPages',8],['answerPages',4]]as const){const pages=v[key];if(!Array.isArray(pages)||pages.length!==count)return fail();for(const page of pages){
  if(!object(page)||!Array.isArray(page.texts)||!page.texts.length||page.texts.length>500||!Array.isArray(page.lines)||page.lines.length>500)return fail();
  for(const t of page.texts)if(!object(t)||!numeric(t.x,596)||!numeric(t.y,843)||!numeric(t.width,596)||!numeric(t.size,30)||typeof t.bold!=='boolean'||typeof t.text!=='string'||t.text.length>2000)return fail();
  for(const l of page.lines)if(!object(l)||!numeric(l.x1,596)||!numeric(l.x2,596)||!numeric(l.y1,843)||!numeric(l.y2,843)||!numeric(l.width,3))return fail();
 }}return v as unknown as ChinesePaper;
}
export async function loadChinesePaper(request:Request,fetcher:typeof fetch=fetch):Promise<ChinesePaper>{
 try{const response=await fetcher('https://noaoqdwllmcnmczroyfn.supabase.co/rest/v1/paper_generator_banks?bank_key=eq.p5-chinese-pilot-v1&select=payload&limit=1',{headers:{apikey:'sb_publishable_-hYVvTs_A97aG_jT_nyiMA_dostycdf',Authorization:request.headers.get('authorization')||''},cache:'no-store',signal:AbortSignal.timeout(10000)});
 if(response.status===401||response.status===403)throw new AccessError(403,'帳戶未獲授權讀取中文試卷。');
 if(!response.ok)throw new BankSetupError('暫時無法讀取中文試卷，請稍後再試。');
 const rows=await response.json();if(!Array.isArray(rows)||rows.length!==1)throw new BankSetupError('中文示範卷尚未完成設定。');return validateChinesePaper(rows[0].payload);
 }catch(e){if(e instanceof AccessError||e instanceof BankSetupError)throw e;throw new BankSetupError('暫時無法讀取中文試卷，請稍後再試。');}
}
const esc=(s:string)=>s.replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]!));
export function renderChinesePaper(bank:ChinesePaper,answers=false){
 const pages=answers?bank.answerPages:bank.studentPages;
 const fonts=bank.fonts?`@font-face{font-family:PaperTC;src:url(data:font/woff;base64,${bank.fonts.regular}) format('woff');font-weight:400}@font-face{font-family:PaperTC;src:url(data:font/woff;base64,${bank.fonts.bold}) format('woff');font-weight:700}`:'';
 const html=pages.map((p,i)=>`<section class="sheet" aria-label="第 ${i+1} 頁，共 ${pages.length} 頁"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 595.276 841.89" role="img" aria-label="${answers?'答案及評分':'學生卷'}第 ${i+1} 頁"><text x="297.638" y="420.945" text-anchor="middle" transform="rotate(-32 297.638 420.945)" font-family="Arial,sans-serif" font-size="27" font-weight="700" fill="#4d5c70" fill-opacity=".075">SENPlus+ Academy Ultra</text>${p.lines.map(l=>`<line x1="${l.x1}" y1="${l.y1}" x2="${l.x2}" y2="${l.y2}" stroke="#87939f" stroke-width="${l.width}"/>`).join('')}${p.texts.map(t=>`<text x="${t.x}" y="${t.y}" font-size="${t.size}" font-weight="${t.bold?700:400}"${t.width>0?` textLength="${t.width}" lengthAdjust="spacingAndGlyphs"`:''} fill="#172b3a">${esc(t.text)}</text>`).join('')}</svg></section>`).join('');
 return `<!doctype html><html lang="zh-Hant"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>小五中文綜合示範卷${answers?'：答案及評分':''}</title><style>${fonts}@page{size:A4;margin:0}*{box-sizing:border-box}body{margin:0;background:#e9edef;font-family:PaperTC,"Microsoft JhengHei","PingFang TC","Noto Sans TC",Arial,sans-serif}.sheet{width:min(100%,210mm);margin:12px auto;background:white;break-after:page;page-break-after:always}.sheet:last-child{break-after:auto;page-break-after:auto}svg{display:block;width:100%;height:auto}text{white-space:pre}.printbar{position:sticky;top:0;text-align:center;padding:10px;background:#f0f6f4;z-index:2;font-size:14px}.printbar button{padding:8px 20px;background:#18766a;color:white;border:0;border-radius:8px;font:inherit;cursor:pointer}@media print{body{background:white;print-color-adjust:exact;-webkit-print-color-adjust:exact}.sheet{width:210mm;height:297mm;margin:0;overflow:hidden}.printbar{display:none}}</style></head><body><div class="printbar"><button onclick="window.print()">列印</button>　A4、直向、100% 縮放，關閉瀏覽器頁首及頁尾。</div>${html}</body></html>`;
}
export const chineseInventory=()=>({units:[{code:'P5中文',title:'語文能力及閱讀理解',count:49,marks:100}],types:{language:'語文能力',reading:'閱讀理解'},subject:'chinese'});
