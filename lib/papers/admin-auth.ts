const URL='https://noaoqdwllmcnmczroyfn.supabase.co';
const KEY='sb_publishable_-hYVvTs_A97aG_jT_nyiMA_dostycdf';
export class AccessError extends Error {constructor(public status:number,message:string){super(message);}}
export async function requirePaperAdmin(request:Request,fetcher:typeof fetch=fetch){
 const authHeader=request.headers.get('authorization')||'';
 if(!/^Bearer \S+$/i.test(authHeader)||authHeader.length>8192)throw new AccessError(401,'請先登入管理員帳戶。');
 const headers={apikey:KEY,Authorization:authHeader};
 try{
  const auth=await fetcher(`${URL}/auth/v1/user`,{headers,cache:'no-store',signal:AbortSignal.timeout(10000)});
  if(auth.status===401||auth.status===403)throw new AccessError(401,'登入已失效，請重新登入。');
  if(!auth.ok)throw new AccessError(503,'暫時無法核對登入身份。');
  const user=await auth.json();
  if(typeof user.id!=='string'||!/^[0-9a-f-]{36}$/i.test(user.id))throw new AccessError(401,'無法核對登入身份。');
  const res=await fetcher(`${URL}/rest/v1/profiles?id=eq.${encodeURIComponent(user.id)}&select=role,login_allowed&limit=1`,{headers,cache:'no-store',signal:AbortSignal.timeout(10000)});
  if(!res.ok)throw new AccessError(503,'暫時無法核對帳戶權限。');
  const profiles=await res.json();
  if(!Array.isArray(profiles)||profiles.length!==1||profiles[0].role!=='admin'||profiles[0].login_allowed!==true)throw new AccessError(403,'目前只供已啟用的管理員帳戶測試。');
  return user.id as string;
 }catch(e){if(e instanceof AccessError)throw e;throw new AccessError(503,'暫時無法核對帳戶權限，請稍後再試。');}
}
