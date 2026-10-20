// 執行 examples/*.xisp，與同名的 .out 比對
const fs = require('fs'), path = require('path');
const { execFileSync } = require('child_process');
const dir = path.join(__dirname, '..', 'examples');
let fail = 0;
for (const f of fs.readdirSync(dir).filter(f => f.endsWith('.xisp')).sort()) {
  const exp = fs.readFileSync(path.join(dir, f.replace(/\.xisp$/, '.out')), 'utf8');
  let got;
  try { got = execFileSync('node', [path.join(__dirname, '..', 'xisp.js'), path.join(dir, f)], { encoding: 'utf8' }); }
  catch (e) { got = 'ERROR: ' + e.stderr; }
  const ok = got === exp;
  if (!ok) fail++;
  console.log(`${ok ? 'PASS' : 'FAIL'}  ${f}`);
}
process.exit(fail ? 1 : 0);
