export type Point={text:string;marks:number};
export type Sub={id:string;prompt:string;answer:string;marks:number;marking_points:Point[]};
export type Question=Sub&{unit_code:string;type:string;paper:string;section:string;diagram?:string|null;subquestions?:Sub[];options?:{id:string;text:string}[]};
export type Bank={schemaVersion:1;questions:Question[];diagrams:Record<string,{student:string;answer:string}>};
export const UNITS:Record<string,string>={'5N1':'大數','5N2':'分數加減','5N3':'分數乘法','5N4':'小數運算','5N5':'分數除法','5A1':'代數初步','5A2':'簡易方程','5M1':'面積','5M2':'體積','5S1':'圓','5S2':'立體圖形','5D1':'棒形圖'};
export const TYPES:Record<string,string>={short_answer:'基本短答',multiple_choice:'選擇題',calculation:'計算題',diagram:'圖形題',measurement:'度量題',drawing:'畫圖題',application:'應用題',shared_stimulus:'共用題組'};
export type Options={mode:'full'|'mini'|'custom';title:string;minutes:number;total:number;units:string[];types:string[];seed:number};
export class PaperInputError extends Error{}
export function validateOptions(value:unknown):Options{
 if(!value||typeof value!=='object')throw new PaperInputError('設定格式不正確。');
 const v=value as Record<string,unknown>;
 if(!['full','mini','custom'].includes(String(v.mode)))throw new PaperInputError('請選擇配卷方式。');
 if(typeof v.title!=='string'||!v.title.trim()||v.title.length>60||/[\u0000-\u001f]/.test(v.title))throw new PaperInputError('試卷名稱須為 1 至 60 個字。');
 if(!Number.isInteger(v.minutes)||Number(v.minutes)<5||Number(v.minutes)>180)throw new PaperInputError('時間須為 5 至 180 分鐘。');
 if(!Number.isInteger(v.total)||Number(v.total)<2||Number(v.total)>150)throw new PaperInputError('總分須為 2 至 150 分。');
 if(!Number.isInteger(v.seed)||Number(v.seed)<0||Number(v.seed)>4294967295)throw new PaperInputError('請重新生成試卷。');
 for(const [key,allowed]of [['units',UNITS],['types',TYPES]]as const){if(!Array.isArray(v[key])||!(v[key]as unknown[]).length||(v[key]as unknown[]).some(x=>typeof x!=='string'||!Object.prototype.hasOwnProperty.call(allowed,x)))throw new PaperInputError('請選擇有效的單元及題型。');}
 const o={...v,title:v.title.trim(),units:[...new Set(v.units as string[])],types:[...new Set(v.types as string[])]}as Options;
 if(o.mode==='full'&&o.total!==100||o.mode==='mini'&&o.total!==50)throw new PaperInputError('範本總分不正確。');return o;
}
function shuffle<T>(values:T[],seed:number){const a=[...values];for(let i=a.length-1;i>0;i--){seed=(Math.imul(1664525,seed)+1013904223)>>>0;const j=Math.floor(seed/4294967296*(i+1));[a[i],a[j]]=[a[j],a[i]];}return a;}
export function selectQuestions(o:Options,bank:Bank){
 let qs=bank.questions.filter(q=>o.units.includes(q.unit_code)&&o.types.includes(q.type));
 if(o.mode!=='custom'){
  qs=qs.filter(q=>q.paper===o.mode);
  if(qs.reduce((s,q)=>s+q.marks,0)!==o.total)throw new PaperInputError('範本須保留指定單元及題型。要篩選請使用自選配卷。');
  return [...new Set(qs.map(q=>q.section))].sort().flatMap((s,i)=>shuffle(qs.filter(q=>q.section===s),o.seed+i));
 }
 const sums=new Map<number,Question[]>([[0,[]]]);
 for(const q of shuffle(qs,o.seed))for(const [sum,list]of [...sums].sort((a,b)=>b[0]-a[0])){const n=sum+q.marks;if(n<=o.total&&!sums.has(n))sums.set(n,[...list,q]);}
 const found=sums.get(o.total);if(!found)throw new PaperInputError('所選單元及題型未能剛好配出 '+o.total+' 分，請降低總分或增加單元／題型。系統不會重複題目或改動原定分數。');
 const order=Object.keys(TYPES);return found.sort((a,b)=>order.indexOf(a.type)-order.indexOf(b.type));
}
const esc=(s:unknown)=>String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]!));
const text=(s:string)=>esc(s).replace(/(\d+)\/(\d+)/g,'<span class="fraction"><span>$1</span><span>$2</span></span>');
function diagram(kind:string,bank:Bank,answer=false){
 const d=bank.diagrams[kind];if(!d)throw new PaperInputError('缺少配圖，請聯絡管理員。');return answer?d.answer:d.student;
}
export function renderPaper(o:Options,qs:Question[],bank:Bank,answers=false){
 const titles:Record<string,string>={A:'基本短答',B:o.mode==='mini'?'計算題':'選擇題',C:o.mode==='mini'?'方格圖題組':'計算題',D:o.mode==='mini'?'應用題':'圖形與度量',E:'數據處理',F:'應用題'};let last='',n=0;
 const rubric=(q:Sub)=>`<p class="answer">${text(q.answer)}（${q.marks} 分）</p><ul>${q.marking_points.map(p=>`<li>${text(p.text)}：${p.marks} 分</li>`).join('')}</ul>`;
 const html=qs.map(q=>{
  const section=o.mode==='custom'?q.type:q.section;let head='';if(section!==last){head=`<h2>${esc(o.mode==='custom'?TYPES[q.type]:titles[q.section])}（${qs.filter(x=>(o.mode==='custom'?x.type:x.section)===section).reduce((s,x)=>s+x.marks,0)} 分）</h2>`;last=section;}n++;
  const prompt=`<h3>${n}. ${text(q.prompt)}（${q.marks} 分）</h3>`;
  if(q.subquestions)return head+`<article class="group">${prompt}${answers?'':diagram(q.diagram!,bank)}${q.subquestions.map((s,i)=>`<section class="subquestion"><p>(${String.fromCharCode(97+i)}) ${text(s.prompt)}（${s.marks} 分）</p>${answers?rubric(s):q.diagram==='grid'&&i===3?diagram('blankgrid',bank):'<div class="work short"></div>'}${answers&&q.diagram==='grid'&&i===3?diagram('blankgrid',bank,true):''}</section>`).join('')}</article>`;
  return head+`<article class="question">${prompt}${q.diagram&&(!answers||q.diagram==='circle')?diagram(q.diagram,bank,answers):''}${answers?rubric(q):q.options?`<div class="options">${q.options.map(a=>`<p>□ ${a.id.toUpperCase()}. ${text(a.text)}</p>`).join('')}</div>`:`<div class="work ${q.type==='short_answer'?'short':q.type==='application'?'large':''}"></div>`}</article>`;
 }).join('');
 return `<!doctype html><html lang="zh-Hant"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>${esc(o.title)}${answers?' - 答案':''}</title><style>@page{size:A4;margin:16mm}*{box-sizing:border-box}body{font:12pt/1.8 Arial,"Microsoft JhengHei","PingFang TC",sans-serif;color:#182432;background:#fff;margin:0}.watermark{position:fixed;inset:0;display:flex;align-items:center;justify-content:center;pointer-events:none;z-index:10;overflow:hidden}.watermark span{display:block;transform:rotate(-32deg);color:rgba(80,94,115,.09);font:700 30pt/1.4 Arial,sans-serif;text-align:center;white-space:nowrap}.printbar{z-index:20}main{max-width:180mm;margin:auto;padding:10mm}h1{font-size:21pt;line-height:1.5;margin:0 0 8mm}h2{font-size:15pt;margin:8mm 0 4mm;break-after:avoid}h3{font-size:12pt;line-height:1.9;margin:0 0 4mm}.notes{font-size:10pt;margin:5mm 0}.question,.subquestion{break-inside:avoid;margin-bottom:7mm}.group>h3{break-after:avoid}.figure{display:block;width:100%;max-width:160mm;margin:2mm auto 5mm;break-inside:avoid}p{margin:2mm 0}.work{height:24mm;background:repeating-linear-gradient(to bottom,transparent 0,transparent 8mm,#d0d4da 8.2mm,transparent 8.4mm)}.work.short{height:12mm}.work.large{height:34mm}.options{display:grid;grid-template-columns:1fr 1fr;gap:2mm 5mm}.answer{font-weight:bold}ul{font-size:10pt;padding-left:6mm}.fraction{display:inline-flex;flex-direction:column;vertical-align:middle;text-align:center;line-height:1.15;font-size:.82em;margin:0 .14em}.fraction>span:first-child{border-bottom:1px solid;padding:0 .12em .1em}.fraction>span+span{padding-top:.1em}.printbar{position:sticky;top:0;background:#f0f6f4;padding:8px;text-align:center;font-size:10pt}.printbar button{font:inherit;border:0;padding:8px 20px;border-radius:8px;background:#18766a;color:#fff;cursor:pointer}@media print{main{padding:0;max-width:none}.printbar{display:none}body{print-color-adjust:exact;-webkit-print-color-adjust:exact}}</style></head><body><div class="watermark" aria-hidden="true"><span>SENPlus+ Academy Ultra</span></div><div class="printbar"><button onclick="window.print()">列印</button>　選擇 A4，關閉瀏覽器頁首及頁尾。</div><main><h1>${esc(o.title)}${answers?'：答案及評分參考':''}</h1><p>P5 數學　${o.minutes} 分鐘　滿分 ${o.total} 分</p>${answers?'':'<p>姓名：________________　班別：________　日期：____________</p>'}<p class="notes">${answers?'基本短答答案正確即可得全分，所列步驟供解說。接受等值答案及正確的其他解法。計算與應用題可按錯誤延續原則給方法分，同一錯誤不重複扣分。畫圖題須人手評閱。':'須知：不可使用計算機。分數答案須化至最簡。計算與應用題須列式及寫出步驟。除畫圖題外，不可量度示意圖來求答案。'}</p>${html}<p class="notes">試卷完</p></main></body></html>`;
}
export function inventory(bank:Bank){return{units:Object.entries(UNITS).map(([code,title])=>({code,title,count:bank.questions.filter(q=>q.unit_code===code).length,marks:bank.questions.filter(q=>q.unit_code===code).reduce((s,q)=>s+q.marks,0)})),types:TYPES,standalone:35,groups:3,existingMcq:8};}
