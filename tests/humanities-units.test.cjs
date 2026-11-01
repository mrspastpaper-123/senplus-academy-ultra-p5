const {test}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const ts=require('typescript');
const moduleShim={exports:{}};
new Function('module','exports',ts.transpileModule(fs.readFileSync('app/humanities-units.ts','utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText)(moduleShim,moduleShim.exports);
const {groupHumanitiesUnits}=moduleShim.exports;
const unit=(code,term,id)=>({id,code,curriculum_domains:{code:term,title_zh:term==='first_term'?'上學期':'下學期'}});
test('both terms keep stable IDs and sort multi-digit codes numerically',()=>{
 const input=[unit('5H13','second_term',103),unit('5H2','first_term',47),unit('5H10','second_term',100),unit('5H1','first_term',46),unit('5H7','second_term',97)];
 const result=groupHumanitiesUnits(input);
 assert.deepEqual(result.map(g=>g.code),['first_term','second_term']);
 assert.deepEqual(result.flatMap(g=>g.units.map(u=>u.code)),['5H1','5H2','5H7','5H10','5H13']);
 assert.equal(result[0].units[0],input[3]);
 assert.deepEqual(input.map(u=>u.id),[103,47,100,46,97]);
});
test('empty data, missing domain and unrelated unit codes are handled',()=>{
 assert.deepEqual(groupHumanitiesUnits([]),[]);
 const result=groupHumanitiesUnits([{code:'5H14',curriculum_domains:null},unit('5SC1','first_term',1),unit('5H0','first_term',2)]);
 assert.equal(result.length,1);assert.equal(result[0].code,'other');assert.equal(result[0].units[0].code,'5H14');
});
