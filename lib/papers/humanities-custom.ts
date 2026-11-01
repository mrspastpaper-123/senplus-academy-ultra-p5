import {PaperInputError} from './generator';
import {BankSetupError} from './private-bank';
import type {HumanitiesMixedBank,HumanitiesMixedPaper,Section} from './humanities-mixed';
export const MIXED_TYPES:Record<string,string>={choice:'選擇題',fill:'供詞填充',match:'配對題',analysis:'資料分析題',short:'短答及情境題'};
export type CustomMixedOptions={mode:'custom';title:string;minutes:number;total:number;units:string[];types:string[];seed:number};
export function validateCustomMixedOptions(v:unknown):CustomMixedOptions{
 if(!v||typeof v!=='object'||Array.isArray(v))throw new PaperInputError('配卷設定格式不正確。');const o=v as Record<string,unknown>;
 if(o.mode!=='custom'||typeof o.title!=='string'||!o.title.trim()||o.title.length>40||/[\u0000-\u001f]/.test(o.title))throw new PaperInputError('自選混合卷名稱須為 1 至 40 個字。');
 if(!Number.isInteger(o.minutes)||Number(o.minutes)<5||Number(o.minutes)>180||!Number.isInteger(o.total)||Number(o.total)<4||Number(o.total)>50||!Number.isInteger(o.seed)||Number(o.seed)<0||Number(o.seed)>4294967295)throw new PaperInputError('請核對時間及總分；首批混合題庫最多可配 50 分。');
 if(!Array.isArray(o.units)||!o.units.length||o.units.length>30||o.units.some(u=>typeof u!=='string'||!/^5H[1-9]\d*$/.test(u))||!Array.isArray(o.types)||new Set(o.types).size<2||o.types.some(t=>typeof t!=='string'||!Object.hasOwn(MIXED_TYPES,t)))throw new PaperInputError('請選擇單元及至少兩種題型。');
 return{mode:'custom',title:o.title.trim(),minutes:Number(o.minutes),total:Number(o.total),units:[...new Set(o.units as string[])],types:[...new Set(o.types as string[])],seed:Number(o.seed)};
}
function entries(b:HumanitiesMixedBank){return b.sections.flatMap(s=>{if(s.questions.some(q=>!q.unit||!b.units.some(u=>u.split(' ')[0]===q.unit)))throw new BankSetupError('混合題庫的單元分類尚未完整。');return s.kind==='analysis'?[{section:s,questions:s.questions,units:[...new Set(s.questions.map(q=>q.unit!))],marks:s.questions.reduce((a,q)=>a+q.marks,0)}]:s.questions.map(q=>({section:s,questions:[q],units:[q.unit!],marks:q.marks}));});}
export function customMixedInventory(b:HumanitiesMixedBank){const es=entries(b);return{units:b.units.map(label=>{const code=label.split(' ')[0],items=es.filter(e=>e.units.includes(code));return{code,title:label.slice(code.length).trim(),count:items.length,marks:items.reduce((n,e)=>n+e.marks,0)};}).filter(u=>u.count>0),types:MIXED_TYPES};}
function shuffle<T>(a:T[],seed:number){a=[...a];for(let i=a.length-1;i>0;i--){seed=(Math.imul(seed,1664525)+1013904223)>>>0;const j=Math.floor(seed/4294967296*(i+1));[a[i],a[j]]=[a[j],a[i]];}return a;}
export function selectCustomMixed(o:CustomMixedOptions,b:HumanitiesMixedBank):HumanitiesMixedPaper{
 const inventory=customMixedInventory(b);if(o.units.some(u=>!inventory.units.some(x=>x.code===u)))throw new PaperInputError('所選單元未有混合題目，請重新選擇範圍。');
 const available=shuffle(entries(b).filter(e=>e.units.every(u=>o.units.includes(u))&&o.types.includes(e.section.kind)),o.seed);
 for(const t of o.types)if(!available.some(e=>e.section.kind===t))throw new PaperInputError('所選單元暫無「'+MIXED_TYPES[t]+'」，請增加單元或取消該題型。');
 const targetMask=(1<<o.types.length)-1,states=new Map<string,number[]>([['0:0',[]]]);
 for(let i=0;i<available.length;i++){const e=available[i],bit=1<<o.types.indexOf(e.section.kind);for(const[key,path]of[...states]){const[score,mask]=key.split(':').map(Number),sum=score+e.marks;if(sum>o.total)continue;const next=sum+':'+(mask|bit);if(!states.has(next))states.set(next,[...path,i]);}}
 const path=states.get(o.total+':'+targetMask);if(!path)throw new PaperInputError('未能以所選範圍及全部所選題型剛好配足 '+o.total+' 分。請調整總分、增加單元或減少題型；資料分析題組會完整抽取（10 分）。');
 const chosen=path.map(i=>available[i]),sections:Section[]=[];
 for(const source of b.sections){const qs=chosen.filter(e=>e.section.kind===source.kind).flatMap(e=>e.questions);if(!qs.length)continue;sections.push({...source,questions:source.kind==='analysis'?source.questions:shuffle(qs,o.seed^sections.length),instructions:source.kind==='fill'?'從詞語框選出適當詞語，填在橫線上。每個詞語只可用一次，有些詞語多餘。':source.kind==='match'?'把合適說明前的英文字母，填在各題括號內。每個字母只可用一次，有些說明多餘。':source.instructions});}
 // A first-page data section needs room for the paper heading; repeat its source on the continuation.
 if(sections[0]?.kind==='analysis'){const s=sections.shift()!;sections.unshift({...s,questions:s.questions.slice(0,2)},{...s,title:s.title+'（續）',startNumber:2,questions:s.questions.slice(2)});}
 const labels=['一','二','三','四','五','六'];let sectionNumber=0;
 for(const s of sections){const continuation=s.title.endsWith('（續）');if(!continuation)sectionNumber++;s.title=labels[sectionNumber-1]+'、'+MIXED_TYPES[s.kind]+(continuation?'（續）':'');}
 const actualUnits=new Set(chosen.flatMap(e=>e.units));return{...b,title:o.title,minutes:o.minutes,total:o.total,units:b.units.filter(u=>actualUnits.has(u.split(' ')[0])),sections};
}
