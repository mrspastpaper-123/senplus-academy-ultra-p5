import {AccessError,requirePaperAdmin} from '../../../../../lib/papers/admin-auth';
import {BankSetupError} from '../../../../../lib/papers/private-bank';
import {PaperInputError} from '../../../../../lib/papers/generator';
import {validateChineseOptions,selectChineseQuestions,customChineseInventory,renderCustomChinese,CHINESE_UNITS,CHINESE_TYPES} from '../../../../../lib/papers/chinese-custom';
import {loadChinesePaper,renderChinesePaper,chineseInventory} from '../../../../../lib/papers/chinese';
export const dynamic='force-dynamic';
const headers={'Cache-Control':'private, no-store, max-age=0','Vary':'Authorization','X-Content-Type-Options':'nosniff'};
const failure=(e:unknown)=>Response.json({error:e instanceof AccessError||e instanceof BankSetupError?e.message:'暫時無法生成中文試卷。'},{status:e instanceof AccessError?e.status:e instanceof BankSetupError?503:500,headers});
export async function GET(request:Request){try{await requirePaperAdmin(request);const bank=await loadChinesePaper(request);return Response.json(bank.questions?customChineseInventory(bank):chineseInventory(),{headers});}catch(e){return failure(e);}}
export async function POST(request:Request){try{
 await requirePaperAdmin(request);
 const body=await request.text();if(body.length>10000)return Response.json({error:'配卷設定過長。'},{status:413,headers});
 if(body.trim()&&!request.headers.get('content-type')?.startsWith('application/json'))return Response.json({error:'設定格式不正確。'},{status:415,headers});
 const options=validateChineseOptions(body.trim()?JSON.parse(body):{mode:'full',title:'小五中文綜合示範卷',minutes:60,total:100,units:Object.keys(CHINESE_UNITS),types:Object.keys(CHINESE_TYPES),seed:0});
 if(options.mode==='full'&&(options.title!=='小五中文綜合示範卷'||options.minutes!==60))throw new PaperInputError('綜合示範卷保留已確認的標題及 60 分鐘時間；如需調整，請使用自選配卷。');
 const bank=await loadChinesePaper(request);
 const qs=bank.questions?selectChineseQuestions(options,bank):[];
 if(options.mode==='custom'&&!qs.length)throw new PaperInputError('中文自選題庫尚未完成設定。');
 const render=(answers=false)=>options.mode==='custom'?renderCustomChinese(options,qs,bank,answers):renderChinesePaper(bank,answers);
 return Response.json({studentHtml:render(),answerHtml:render(true),summary:{marks:options.total,items:qs.length||49,responses:qs.length?qs.reduce((s,q)=>s+(q.subquestions?.length||q.responses||1),0):49,units:qs.length?[...new Set(qs.map(q=>CHINESE_UNITS[q.unit]))]:['語文能力 40 分','閱讀理解 60 分'],ids:qs.length?qs.map(q=>q.id):['p5-chinese-pilot-v1']}},{headers});
 }catch(e){if(e instanceof PaperInputError||e instanceof SyntaxError)return Response.json({error:e instanceof SyntaxError?'配卷設定格式不正確。':e.message},{status:400,headers});return failure(e);}}
