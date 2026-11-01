const {test}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const ts=require('typescript');
const Module=require('node:module');
const React=require('react');
const {renderToStaticMarkup}=require('react-dom/server');
function compile(path,requireFn=require){
 const m={exports:{}};
 const code=ts.transpileModule(fs.readFileSync(path,'utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022,jsx:ts.JsxEmit.ReactJSX,esModuleInterop:true}}).outputText;
 new Function('module','exports','require',code)(m,m.exports,requireFn);return m.exports;
}
const data=compile('app/science-record-data.ts');
const fixture='【探究資料題】\n這是測試資料。\n【觀察記錄】\n項目｜讀數\n甲｜2\n乙｜5\n【問題】\n請比較讀數。';
test('science records keep headers, rows, units and question text without duplicating the table',()=>{
 const record=data.readScienceRecord(fixture,'5SC10');
 assert.deepEqual(record.headers,['項目','讀數']);assert.deepEqual(record.rows,[['甲','2'],['乙','5']]);
 assert.match(record.prompt,/請比較讀數/);assert.doesNotMatch(record.prompt,/甲｜2/);
 assert.deepEqual(data.readScienceRecord(fixture.replaceAll('\n','\r\n'),'5SC8'),record);
});
test('ordinary questions and malformed records retain the complete original prompt',()=>{
 for(const text of ['普通問題',fixture.replace('乙｜5','乙｜5｜6'),fixture.replace('【問題】','【其他】'),fixture.replace('乙｜5','乙｜'),fixture+'\n【問題】\n另一題']){
  assert.equal(data.readScienceRecord(text,'5SC1'),null);assert.equal(data.scienceQuestionPrompt(text,'5SC1'),text);
 }
 assert.equal(data.readScienceRecord(fixture,'5H1'),null);
 assert.equal(data.readScienceRecord(fixture,'5SC0'),null);
});
const component=compile('app/science-record.tsx',(name)=>name==='./science-record-data'?data:name.endsWith('.css')?{card:'record-card',table:'record-table'}:require(name));
test('rendered records use accessible table headings, escape content, and preserve proper-name underlines',()=>{
 const text=fixture.replace('甲｜2','高̲錕̲｜<script>alert(1)</script>');
 const html=renderToStaticMarkup(React.createElement(component.ScienceRecordCard,{text,unitCode:'5SC11'}));
 assert.match(html,/<caption>觀察記錄<\/caption>/);assert.match(html,/scope="col"/);assert.match(html,/scope="row"/);
 assert.match(html,/class="proper-name">高錕/);assert.doesNotMatch(html,/<script>/);assert.match(html,/&lt;script&gt;/);
 assert.equal(renderToStaticMarkup(React.createElement(component.ScienceRecordCard,{text:'普通問題',unitCode:'5SC1'})),'');
});
