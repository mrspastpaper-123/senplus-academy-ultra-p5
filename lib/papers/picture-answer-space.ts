export type PictureAnswerSpace={kind:'sequence';slots:number}|{kind:'table';headers:string[];rows:string[]};
export function validPictureAnswerSpace(v:unknown):v is PictureAnswerSpace{
 if(!v||typeof v!=='object'||Array.isArray(v))return false;const a=v as Record<string,unknown>;
 if(a.kind==='sequence')return Number.isInteger(a.slots)&&Number(a.slots)>=3&&Number(a.slots)<=6;
 const text=(x:unknown)=>typeof x==='string'&&x.trim().length>0&&x.length<=100&&!/[\u0000-\u001f\ufffd]/.test(x);
 return a.kind==='table'&&Array.isArray(a.headers)&&a.headers.length>=2&&a.headers.length<=3&&a.headers.every(text)&&Array.isArray(a.rows)&&a.rows.length>=2&&a.rows.length<=6&&a.rows.every(text);
}
