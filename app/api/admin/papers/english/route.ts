import {AccessError,requirePaperAdmin} from '../../../../../lib/papers/admin-auth';
import {BankSetupError} from '../../../../../lib/papers/private-bank';
import {PaperInputError} from '../../../../../lib/papers/generator';
import {loadEnglishPaper,renderEnglishPaper,englishInventory} from '../../../../../lib/papers/english';
import {validateEnglishOptions,selectEnglishQuestions,customEnglishInventory,renderCustomEnglish,ENGLISH_UNITS} from '../../../../../lib/papers/english-custom';
export const dynamic='force-dynamic';
const headers={'Cache-Control':'private, no-store, max-age=0','Vary':'Authorization','X-Content-Type-Options':'nosniff'};
const failure=(e:unknown)=>Response.json({error:e instanceof AccessError||e instanceof BankSetupError?e.message:'暫時無法生成英文試卷。'},{status:e instanceof AccessError?e.status:e instanceof BankSetupError?503:500,headers});
export async function GET(request:Request){try{await requirePaperAdmin(request);const bank=await loadEnglishPaper(request);return Response.json(bank.questions?customEnglishInventory(bank):englishInventory(),{headers});}catch(e){return failure(e);}}
export async function POST(request:Request){try{
 await requirePaperAdmin(request);
 const body=await request.text();if(body.length>10000)return Response.json({error:'配卷設定過長。'},{status:413,headers});
 if(!request.headers.get('content-type')?.startsWith('application/json'))return Response.json({error:'設定格式不正確。'},{status:415,headers});
 const o=validateEnglishOptions(JSON.parse(body)),bank=await loadEnglishPaper(request);
 const qs=o.mode==='custom'?selectEnglishQuestions(o,bank):[];
 const render=(answers=false)=>o.mode==='custom'?renderCustomEnglish(o,qs,bank,answers):renderEnglishPaper(bank,answers);
 return Response.json({studentHtml:render(),answerHtml:render(true),summary:{marks:o.total,items:qs.length||43,responses:qs.length?qs.reduce((s,q)=>s+(q.subquestions?.length||1),0):bank.responses,units:qs.length?[...new Set(qs.map(q=>ENGLISH_UNITS[q.unit]))]:['語文運用 60 分','閱讀理解 25 分'],ids:qs.length?qs.map(q=>q.id):['p5-english-pilot-v1']}},{headers});
 }catch(e){if(e instanceof PaperInputError||e instanceof SyntaxError)return Response.json({error:e instanceof SyntaxError?'配卷設定格式不正確。':e.message},{status:400,headers});return failure(e);}}
