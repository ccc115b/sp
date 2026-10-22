import http from 'node:http';import fs from 'node:fs';import path from 'node:path';
const T={'.html':'text/html;charset=utf-8','.js':'text/javascript','.wasm':'application/wasm','.rs':'text/plain;charset=utf-8','.json':'application/json'};
http.createServer((q,s)=>{const p=path.join('dist',q.url==='/'?'index.html':q.url.split('?')[0]);
fs.readFile(p,(e,d)=>{if(e){s.writeHead(404);return s.end()}s.writeHead(200,{'content-type':T[path.extname(p)]||'application/octet-stream'});s.end(d)})}).listen(8080,()=>console.log('http://localhost:8080'));
