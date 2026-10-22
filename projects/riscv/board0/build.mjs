// 建置腳本：Node 只負責呼叫 cargo 並整理 dist/，執行期是純前端
import {execSync} from 'node:child_process';
import fs from 'node:fs';
const run=(c,cwd='.')=>execSync(c,{stdio:'inherit',cwd});
run('rustup target add wasm32-unknown-unknown riscv32i-unknown-none-elf');
run('cargo build --release --target wasm32-unknown-unknown','vm');
run('cargo build --release','examples');
fs.rmSync('dist',{recursive:true,force:true});
fs.mkdirSync('dist/examples',{recursive:true});
fs.cpSync('web','dist',{recursive:true});
fs.copyFileSync('vm/target/wasm32-unknown-unknown/release/rv32vm.wasm','dist/vm.wasm');
const names=fs.readdirSync('examples/src/bin').map(f=>f.replace('.rs','')).sort();
for(const n of names){
  fs.copyFileSync(`examples/target/riscv32i-unknown-none-elf/release/${n}`,`dist/examples/${n}.elf`);
  fs.copyFileSync(`examples/src/bin/${n}.rs`,`dist/examples/${n}.rs`);
}
fs.writeFileSync('dist/examples.json',JSON.stringify(names));
console.log('OK -> dist/');
