import {validateMixedOptions,loadHumanitiesMixedBank,renderHumanitiesMixed} from '../../../../../lib/papers/humanities-mixed';
import {AccessError,requirePaperAdmin} from '../../../../../lib/papers/admin-auth';
import {BankSetupError} from '../../../../../lib/papers/private-bank';
import {PaperInputError} from '../../../../../lib/papers/generator';
import {loadHumanitiesBank,humanitiesInventory,validateHumanitiesOptions,selectHumanitiesQuestions,renderHumanitiesPaper} from '../../../../../lib/papers/humanities';
export const dynamic='force-dynamic';
export const maxDuration=60;
const headers={'Cache-Control':'private, no-store, max-age=0','Vary':'Authorization','X-Content-Type-Options':'nosniff'};
function failure(e:unknown){return Response.json({error:e instanceof AccessError||e instanceof BankSetupError?e.message:'暫時無法生成人文科試卷。'},{status:e instanceof AccessError?e.status:e instanceof BankSetupError?503:500,headers});}
export async function GET(request:Request){try{await requirePaperAdmin(request);return Response.json(humanitiesInventory(await loadHumanitiesBank(request)),{headers});}catch(e){return failure(e);}}
export async function POST(request:Request){try{
 await requirePaperAdmin(request);
 if(!request.headers.get('content-type')?.startsWith('application/json'))return Response.json({error:'設定格式不正確。'},{status:415,headers});
 const body=await request.text();if(body.length>10000)return Response.json({error:'配卷設定過長。'},{status:413,headers});
 const input=JSON.parse(body);
 if(input?.mode==='mixed'){validateMixedOptions(input);const b=await loadHumanitiesMixedBank(request);return Response.json({studentHtml:renderHumanitiesMixed(b),answerHtml:renderHumanitiesMixed(b,true),summary:{marks:50,items:22,responses:22,units:b.units,ids:[b.bankKey]}},{headers});}
 const o=validateHumanitiesOptions(input),bank=await loadHumanitiesBank(request),qs=selectHumanitiesQuestions(o,bank);
 return Response.json({studentHtml:renderHumanitiesPaper(o,qs,bank),answerHtml:renderHumanitiesPaper(o,qs,bank,true),summary:{marks:o.total,items:qs.length,responses:qs.length,units:[...new Set(qs.map(q=>q.unit))].map(code=>code+' '+bank.units.find(u=>u.code===code)!.title),ids:qs.map(q=>String(q.id))}},{headers});
 }catch(e){if(e instanceof PaperInputError||e instanceof SyntaxError)return Response.json({error:e instanceof SyntaxError?'配卷設定格式不正確。':e.message},{status:400,headers});return failure(e);}}
