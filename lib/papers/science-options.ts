import {readUnitCounts, type UnitCounts} from './unit-draw';
import {PaperInputError} from './generator';
export const SCIENCE_TYPES:Record<string,string>={choice:'選擇題',fill:'供詞填充',match:'配對題',analysis:'資料分析題',short:'短答及情境題'};
export type ScienceOptions={mode:'custom';title:string;minutes:number;total:number;units:string[];types:string[];seed:number;unitCounts?:UnitCounts};
export function validateScienceOptions(v:unknown,allowedTypes:Record<string,string>=SCIENCE_TYPES):ScienceOptions{
 if(!v||typeof v!=='object'||Array.isArray(v))throw new PaperInputError('配卷設定格式不正確。');const o=v as Record<string,unknown>;
 if(o.mode!=='custom'||typeof o.title!=='string'||!o.title.trim()||o.title.length>40||/[\u0000-\u001f]/.test(o.title))throw new PaperInputError('自選混合卷名稱須為 1 至 40 個字。');
 if(!Number.isInteger(o.minutes)||Number(o.minutes)<5||Number(o.minutes)>180||!Number.isInteger(o.total)||Number(o.total)<4||Number(o.total)>100||!Number.isInteger(o.seed)||Number(o.seed)<0||Number(o.seed)>4294967295)throw new PaperInputError('請核對時間及總分；混合題庫最多可配 100 分。');
 if(!Array.isArray(o.units)||!o.units.length||o.units.length>30||o.units.some(u=>typeof u!=='string'||!/^5SC[1-9]\d*$/.test(u))||!Array.isArray(o.types)||new Set(o.types).size<2||o.types.some(t=>typeof t!=='string'||!Object.hasOwn(allowedTypes,t)))throw new PaperInputError('請選擇單元及至少兩種題型。');
 const unitCounts=readUnitCounts(o.unitCounts,o.units,()=>{throw new PaperInputError("請檢查各單元的抽題數量。");});
 return{...(unitCounts?{unitCounts}:{}),mode:'custom',title:o.title.trim(),minutes:Number(o.minutes),total:Number(o.total),units:[...new Set(o.units as string[])],types:[...new Set(o.types as string[])],seed:Number(o.seed)};
}
