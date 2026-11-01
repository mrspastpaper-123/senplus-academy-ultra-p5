import {AccessError,requirePaperAdmin} from '../../../../../lib/papers/admin-auth';
import {BankSetupError} from '../../../../../lib/papers/private-bank';
import {loadEnglishPaper,renderEnglishPaper,englishInventory} from '../../../../../lib/papers/english';
export const dynamic='force-dynamic';
const headers={'Cache-Control':'private, no-store, max-age=0','Vary':'Authorization','X-Content-Type-Options':'nosniff'};
const failure=(e:unknown)=>Response.json({error:e instanceof AccessError||e instanceof BankSetupError?e.message:'暫時無法生成英文試卷。'},{status:e instanceof AccessError?e.status:e instanceof BankSetupError?503:500,headers});
export async function GET(request:Request){try{await requirePaperAdmin(request);await loadEnglishPaper(request);return Response.json(englishInventory(),{headers});}catch(e){return failure(e);}}
export async function POST(request:Request){try{
 await requirePaperAdmin(request);
 const body=await request.text();if(body.length>10000)return Response.json({error:'配卷設定過長。'},{status:413,headers});
 if(!request.headers.get('content-type')?.startsWith('application/json'))return Response.json({error:'設定格式不正確。'},{status:415,headers});
 let o;try{o=JSON.parse(body);}catch{return Response.json({error:'配卷設定格式不正確。'},{status:400,headers});}
 if(!o||typeof o!=='object'||Array.isArray(o)||o.mode!=='full'||o.title!=='P5 English Practice Paper'||o.total!==85||o.minutes!==60||!Array.isArray(o.units)||o.units.length!==1||o.units[0]!=='P5-English-Pilot'||!Array.isArray(o.types)||o.types.length!==2||!o.types.includes('language')||!o.types.includes('reading'))return Response.json({error:'英文目前提供已確認的 85 分、60 分鐘綜合示範卷，請使用完整範圍。'},{status:400,headers});
 const bank=await loadEnglishPaper(request);
 return Response.json({studentHtml:renderEnglishPaper(bank),answerHtml:renderEnglishPaper(bank,true),summary:{marks:bank.marks,items:43,responses:bank.responses,units:['語文運用 60 分','閱讀理解 25 分'],ids:['p5-english-pilot-v1']}},{headers});
 }catch(e){return failure(e);}}
