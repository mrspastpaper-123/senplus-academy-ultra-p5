import {AccessError,requirePaperAdmin} from '../../../../../lib/papers/admin-auth';
import {BankSetupError} from '../../../../../lib/papers/private-bank';
import {loadChinesePaper,renderChinesePaper,chineseInventory} from '../../../../../lib/papers/chinese';
export const dynamic='force-dynamic';
const headers={'Cache-Control':'private, no-store, max-age=0','Vary':'Authorization','X-Content-Type-Options':'nosniff'};
const failure=(e:unknown)=>Response.json({error:e instanceof AccessError||e instanceof BankSetupError?e.message:'暫時無法生成中文試卷。'},{status:e instanceof AccessError?e.status:e instanceof BankSetupError?503:500,headers});
export async function GET(request:Request){try{await requirePaperAdmin(request);await loadChinesePaper(request);return Response.json(chineseInventory(),{headers});}catch(e){return failure(e);}}
export async function POST(request:Request){try{await requirePaperAdmin(request);const bank=await loadChinesePaper(request);return Response.json({studentHtml:renderChinesePaper(bank),answerHtml:renderChinesePaper(bank,true),summary:{marks:100,items:49,responses:49,units:['語文能力 40 分','閱讀理解 60 分'],ids:['p5-chinese-pilot-v1']}},{headers});}catch(e){return failure(e);}}
