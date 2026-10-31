import {AccessError,requirePaperAdmin} from '../../../../lib/papers/admin-auth';
import {BankSetupError,loadPrivateBank} from '../../../../lib/papers/private-bank';
export const dynamic='force-dynamic';
const headers={'Cache-Control':'private, no-store, max-age=0','Vary':'Authorization','X-Content-Type-Options':'nosniff'};
const failure=(e:unknown)=>Response.json({error:e instanceof AccessError||e instanceof BankSetupError?e.message:'暫時無法生成試卷。'},{status:e instanceof AccessError?e.status:e instanceof BankSetupError?503:500,headers});
export async function GET(request:Request){try{await requirePaperAdmin(request);const bank=await loadPrivateBank(request);const{inventory}=await import('../../../../lib/papers/generator');return Response.json(inventory(bank),{headers});}catch(e){return failure(e);}}
export async function POST(request:Request){try{
 await requirePaperAdmin(request);
 if(!request.headers.get('content-type')?.startsWith('application/json'))return Response.json({error:'設定格式不正確。'},{status:415,headers});
 const body=await request.text();if(body.length>10000)return Response.json({error:'配卷設定過長。'},{status:413,headers});
 const{validateOptions,selectQuestions,renderPaper,PaperInputError}=await import('../../../../lib/papers/generator');
 try{const o=validateOptions(JSON.parse(body));const bank=await loadPrivateBank(request);const qs=selectQuestions(o,bank);return Response.json({studentHtml:renderPaper(o,qs,bank),answerHtml:renderPaper(o,qs,bank,true),summary:{marks:qs.reduce((s,q)=>s+q.marks,0),items:qs.length,responses:qs.reduce((s,q)=>s+(q.subquestions?.length||1),0),units:[...new Set(qs.map(q=>q.unit_code))],ids:qs.map(q=>q.id)}},{headers});}
 catch(e){if(e instanceof PaperInputError||e instanceof SyntaxError)return Response.json({error:e instanceof SyntaxError?'配卷設定格式不正確。':e.message},{status:400,headers});throw e;}
 }catch(e){return failure(e);}}
