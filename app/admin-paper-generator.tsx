'use client';
import {useEffect,useRef,useState} from 'react';
import type {SupabaseClient} from '@supabase/supabase-js';
import styles from './admin-paper-generator.module.css';
type Inventory={units:{code:string;title:string;count:number;marks:number}[];types:Record<string,string>};
type Result={studentHtml:string;answerHtml:string;summary:{marks:number;items:number;responses:number;units:string[];ids:string[]}};
type Mode='full'|'mini'|'custom';
export default function AdminPaperGenerator({supabase,onBack,onSignOut}:{supabase:SupabaseClient;onBack:()=>void;onSignOut:()=>void}){
 const[reloadCount,setReloadCount]=useState(0);
 const[bank,setBank]=useState<Inventory|null>(null),[error,setError]=useState(''),[busy,setBusy]=useState(false);
 const[mode,setMode]=useState<Mode>('full'),[title,setTitle]=useState('小五數學綜合練習卷'),[minutes,setMinutes]=useState(55),[total,setTotal]=useState(100);
 const[units,setUnits]=useState<string[]>([]),[types,setTypes]=useState<string[]>([]),[result,setResult]=useState<Result|null>(null),[answers,setAnswers]=useState(false);
 const frame=useRef<HTMLIFrameElement>(null),active=useRef<AbortController|null>(null);
 async function headers(){const{data,error:authError}=await supabase.auth.getSession();if(authError||!data.session)throw new Error('請重新登入管理員帳戶。');return{Authorization:'Bearer '+data.session.access_token,'Content-Type':'application/json'};}
 useEffect(()=>{let cancelled=false;const controller=new AbortController();(async()=>{try{
  const response=await fetch('/api/admin/papers',{headers:await headers(),cache:'no-store',signal:controller.signal});const data=await response.json();if(!response.ok)throw new Error(data.error||'無法載入題庫。');
  if(!cancelled){setBank(data);setUnits(data.units.map((u:Inventory['units'][number])=>u.code));setTypes(Object.keys(data.types));}
 }catch(e){if(!cancelled)setError(e instanceof Error?e.message:'無法載入題庫。');}})();return()=>{cancelled=true;controller.abort();active.current?.abort();};
 // The existing application memoizes the Supabase client.
 // eslint-disable-next-line react-hooks/exhaustive-deps
 },[supabase,reloadCount]);
 function choose(m:Mode){setMode(m);setResult(null);setError('');setTitle(m==='full'?'小五數學綜合練習卷':m==='mini'?'小五數學面積小測':'小五數學自選練習卷');setMinutes(m==='full'?55:m==='mini'?25:30);setTotal(m==='full'?100:m==='mini'?50:30);}
 function toggle(v:string,values:string[],set:(a:string[])=>void){set(values.includes(v)?values.filter(x=>x!==v):[...values,v]);setResult(null);}
 async function generate(){if(!bank)return;setBusy(true);setError('');setResult(null);const controller=new AbortController();active.current=controller;
  try{const response=await fetch('/api/admin/papers',{method:'POST',headers:await headers(),cache:'no-store',signal:controller.signal,body:JSON.stringify({mode,title,minutes,total,units:mode==='mini'?['5M1']:mode==='full'?bank.units.map(u=>u.code):units,types:mode==='custom'?types:Object.keys(bank.types),seed:crypto.getRandomValues(new Uint32Array(1))[0]})});const data=await response.json();if(!response.ok)throw new Error(data.error||'無法生成試卷。');setResult(data);setAnswers(false);}
  catch(e){if(!(e instanceof Error&&e.name==='AbortError'))setError(e instanceof Error?e.message:'無法生成試卷。');}finally{setBusy(false);}
 }
 return <main className={styles.page}><header className={styles.header}><div className={styles.brand}><span>S+</span><div><strong>SENPlus+</strong><small>管理員工作區 · P5</small></div></div><button onClick={onSignOut}>登出</button></header><div className={styles.wrap}>
 <button onClick={onBack}>← 返回管理員儀表板</button><section className={styles.hero}><span className={styles.badge}>僅限管理員 · 測試版</span><h1>試卷生成器</h1><p>選擇配卷方式，預覽題目，再分開列印學生卷及答案卷。</p><p className={styles.note}>35 道獨立新題、3 個共用題組，以及 8 道已核對的原有選擇題。原有網上練習維持原狀。</p></section>
 {error&&<div className={styles.error} role="alert"><p>{error}</p>{!bank&&<button onClick={()=>{setError('');setReloadCount(n=>n+1);}}>重新檢查題庫</button>}</div>}{!bank&&!error&&<p role="status">正在核對管理員權限及載入題庫…</p>}
 {bank&&<div className={styles.layout}><section className={styles.panel}><h2>配卷設定</h2><fieldset disabled={busy} onChange={()=>setResult(null)}><legend>配卷方式</legend><div className={styles.modes}>{([['full','綜合卷','100 分 · 55 分鐘'],['mini','面積小測','50 分 · 25 分鐘'],['custom','自選配卷','按單元及題型配卷']]as const).map(([v,label,note])=><label key={v} className={mode===v?styles.selected:''}><input type="radio" name="paper-mode" checked={mode===v} onChange={()=>choose(v)}/><strong>{label}</strong><small>{note}</small></label>)}</div>
 <label className={styles.field}>試卷名稱<input maxLength={60} value={title} onChange={e=>setTitle(e.target.value)}/></label><div className={styles.row}><label className={styles.field}>時間（分鐘）<input type="number" min={5} max={180} value={minutes} onChange={e=>setMinutes(Number(e.target.value))}/></label><label className={styles.field}>總分<input type="number" min={2} max={150} value={total} disabled={mode!=='custom'} onChange={e=>setTotal(Number(e.target.value))}/></label></div>
 {mode==='custom'?<><h3>選擇單元</h3><div className={styles.actions}><button type="button" onClick={()=>{setUnits(bank.units.map(u=>u.code));setResult(null);}}>全選</button><button type="button" onClick={()=>{setUnits([]);setResult(null);}}>清除</button></div><div className={styles.checks}>{bank.units.map(u=><label key={u.code}><input type="checkbox" checked={units.includes(u.code)} onChange={()=>toggle(u.code,units,setUnits)}/><span><b>{u.code} {u.title}</b><small>{u.count} 個題目／題組 · 合共 {u.marks} 分</small></span></label>)}</div><h3>選擇題型</h3><div className={styles.typeChecks}>{Object.entries(bank.types).map(([v,label])=><label key={v}><input type="checkbox" checked={types.includes(v)} onChange={()=>toggle(v,types,setTypes)}/>{label}</label>)}</div><p className={styles.note}>按原定分數配卷，不重複題目；共用題組完整保留。題量不足時，系統會提示調整設定。</p></>:<p className={styles.note}>{mode==='full'?'全年混合單元範本，未按特定學校的學期進度編排。':'面積專題範本，包含短答、計算、共用方格圖及應用題。'}可調整標題及時間；重新生成會調換同類題目次序。</p>}</fieldset>
 <button className={styles.primary} disabled={busy||!title.trim()||(mode==='custom'&&(!units.length||!types.length))} onClick={generate}>{busy?'正在生成…':result?'重新生成試卷':'生成試卷'}</button></section>
 <section className={styles.panel} aria-label="試卷預覽"><h2>試卷預覽</h2>{result?<><div className={styles.summary}><strong>{result.summary.marks} 分</strong><span>{result.summary.items} 個題目／題組</span><span>{result.summary.responses} 個作答項目</span></div><p className={styles.note}>實際涵蓋：{result.summary.units.join('、')}。學生卷不含答案；答案卷附分步評分，畫圖題須人手批改。</p><div className={styles.actions}><button aria-pressed={!answers} onClick={()=>setAnswers(false)}>學生卷</button><button aria-pressed={answers} onClick={()=>setAnswers(true)}>答案及評分</button></div><div className={styles.actions}><button className={styles.primary} onClick={()=>{frame.current?.contentWindow?.focus();frame.current?.contentWindow?.print();}}>列印目前預覽</button></div><p className={styles.note}>列印時選 A4，關閉瀏覽器頁首及頁尾。請分別切換學生卷和答案卷後列印。</p><iframe className={styles.preview} ref={frame} title={answers?'答案及評分預覽':'學生卷預覽'} srcDoc={answers?result.answerHtml:result.studentHtml}/></>:<div className={styles.empty}><h3>準備好你的第一份試卷</h3><p>完成設定後按「生成試卷」，即可查看題目、配圖及評分。</p></div>}</section></div>}
 </div></main>;
}
