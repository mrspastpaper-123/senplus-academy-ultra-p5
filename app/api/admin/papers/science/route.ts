import {requirePaperAdmin,AccessError} from '../../../../../lib/papers/admin-auth';
import {BankSetupError} from '../../../../../lib/papers/private-bank';
import {PaperInputError} from '../../../../../lib/papers/generator';
import {loadScienceBank,scienceInventory,selectSciencePaper} from '../../../../../lib/papers/science';
import {SCIENCE_TYPES,validateScienceOptions} from '../../../../../lib/papers/science-options';
import {renderHumanitiesMixed} from '../../../../../lib/papers/humanities-mixed';
export const dynamic='force-dynamic';
export const maxDuration=60;
const headers={'Cache-Control':'private, no-store, max-age=0','Vary':'Authorization','X-Content-Type-Options':'nosniff'};
function failure(e:unknown){return Response.json({error:e instanceof AccessError||e instanceof BankSetupError?e.message:'暫時無法生成科學科試卷。'},{status:e instanceof AccessError?e.status:e instanceof BankSetupError?503:500,headers});}
export async function GET(request:Request){try{await requirePaperAdmin(request);return Response.json(scienceInventory(await loadScienceBank(request)),{headers});}catch(e){return failure(e);}}
export async function POST(request:Request){try{
 await requirePaperAdmin(request);
 if(!request.headers.get('content-type')?.startsWith('application/json'))return Response.json({error:'設定格式不正確。'},{status:415,headers});
 const body=await request.text();if(body.length>10000)return Response.json({error:'配卷設定過長。'},{status:413,headers});
 const input=JSON.parse(body);
 // Validate before reading the private bank. Full mode always means all units,
 // five kinds and exactly 50 marks; custom mode honours the requested scope.
 const full=input?.mode==='full';
 const o=validateScienceOptions(full?{...input,mode:'custom',total:50,units:['5SC1'],types:Object.keys(SCIENCE_TYPES)}:input);
 const bank=await loadScienceBank(request);
 if(full){o.units=bank.units.map(u=>u.code);o.types=Object.keys(SCIENCE_TYPES);}
 const paper=selectSciencePaper(o,bank),qs=paper.sections.flatMap(s=>s.questions);
 return Response.json({studentHtml:renderHumanitiesMixed(paper),answerHtml:renderHumanitiesMixed(paper,true),summary:{marks:paper.total,items:qs.length,responses:qs.length,units:paper.units,ids:qs.map(q=>q.id)}},{headers});
 }catch(e){if(e instanceof PaperInputError||e instanceof SyntaxError)return Response.json({error:e instanceof SyntaxError?'配卷設定格式不正確。':e.message},{status:400,headers});return failure(e);}}
