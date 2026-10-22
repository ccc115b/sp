const $ = s => document.querySelector(s), dec = new TextDecoder();
const { instance } = await WebAssembly.instantiateStreaming(fetch('vm.wasm'));
const vm = instance.exports;
let plugs = {}, sel = 'led', us = 0, last = 0, running = false;
const px = i => 40 + i * 50;

function drawBoard() {
  let h = '<rect x="5" y="5" width="430" height="190" rx="12" fill="#0a6c55"/><text x="220" y="108" fill="#fff" text-anchor="middle" font-size="14">board0 · RV32I · 128KB RAM</text>';
  const pin = (k, x, y, up) => {
    const c = plugs[k]; let g = `<g data-k="${k}"><rect x="${x-11}" y="${y-11}" width="22" height="22" rx="3" fill="#222" stroke="#999"/><text x="${x}" y="${y+4}" fill="#fc6" font-size="10" text-anchor="middle">${k}</text>`;
    if (c) { const cy = y + (up ? -38 : 38); g += `<line x1="${x}" x2="${x}" y1="${y}" y2="${cy}" stroke="#ddd" stroke-width="2"/>`;
      g += c.type === 'led' ? `<circle id="led-${k}" cx="${x}" cy="${cy}" r="11" fill="#ff3b3b" fill-opacity=".15" stroke="#fff"/>`
         : c.type === 'button' ? `<rect x="${x-12}" y="${cy-12}" width="24" height="24" rx="4" fill="#58a" stroke="#fff"/>`
         : `<circle cx="${x}" cy="${cy}" r="13" fill="#b84" stroke="#fff"/><text x="${x}" y="${cy+4}" font-size="10" text-anchor="middle" fill="#fff">POT</text>`; }
    return g + '</g>';
  };
  for (let i = 0; i < 8; i++) h += pin('D' + i, px(i), 50, true);
  for (let i = 0; i < 4; i++) h += pin('A' + i, px(i), 160, false);
  $('#board').innerHTML = h; drawPlugs();
}
function drawPlugs() {
  $('#plugs').innerHTML = Object.entries(plugs).map(([k, c]) => `<div class="row"><b>${k}</b> ${c.type}` +
    (c.type === 'button' ? ` <button data-b="${k}">按住</button>` : '') +
    (c.type === 'pot' ? ` <input type="range" min="0" max="1023" value="${c.val}" data-p="${k}"> <span id="v-${k}">${c.val}</span>` : '') + '</div>').join('');
}
$('#board').onclick = e => {
  const g = e.target.closest('[data-k]'); if (!g) return; const k = g.dataset.k;
  if (plugs[k]) delete plugs[k]; else if ((sel === 'pot') === (k[0] === 'A')) plugs[k] = { type: sel, val: 512, down: false };
  drawBoard();
};
$('#pal').onchange = e => sel = e.target.value;
const pl = $('#plugs');
pl.oninput = e => { const k = e.target.dataset.p; if (k) { plugs[k].val = +e.target.value; $('#v-' + k).textContent = e.target.value; } };
for (const [ev, v] of [['pointerdown', true], ['pointerup', false], ['pointerleave', false]])
  pl.addEventListener(ev, e => { const k = e.target.dataset?.b; if (k && plugs[k]) plugs[k].down = v; }, true);

async function load(name) {
  const buf = new Uint8Array(await (await fetch(`examples/${name}.elf`)).arrayBuffer());
  const dv = new DataView(buf.buffer);
  const mem = new Uint8Array(vm.memory.buffer, vm.ram_ptr(), 128 * 1024); mem.fill(0);
  const phoff = dv.getUint32(0x1c, true), phsz = dv.getUint16(0x2a, true), n = dv.getUint16(0x2c, true);
  for (let i = 0; i < n; i++) { const o = phoff + i * phsz; if (dv.getUint32(o, true) !== 1) continue;   // PT_LOAD
    const off = dv.getUint32(o + 4, true), va = dv.getUint32(o + 8, true), fs = dv.getUint32(o + 16, true);
    mem.set(buf.subarray(off, off + fs), va); }
  vm.reset(dv.getUint32(0x18, true)); us = 0; $('#ser').textContent = '';
  $('#src').textContent = await (await fetch(`examples/${name}.rs`)).text();
  setRun(true);
}
function setRun(r) { running = r; $('#run').textContent = r ? '⏸ 暫停' : '▶ 執行'; }

function frame(t) {
  const dt = Math.min(t - last, 50); last = t;
  if (running) {
    us += dt * 1000; vm.set_time(us >>> 0);
    let m = 0;
    for (const [k, c] of Object.entries(plugs)) {
      if (c.type === 'button' && c.down) m |= 1 << +k[1];
      if (c.type === 'pot') vm.set_adc(+k[1], c.val);
    }
    vm.set_in(m);
    if (vm.run(300000)) { setRun(false); $('#st').textContent = 'CPU 已停止'; } else $('#st').textContent = '';
    const a = []; let c; while ((c = vm.tx_pop()) >= 0) a.push(c);
    if (a.length) { const s = $('#ser'); s.textContent += dec.decode(new Uint8Array(a), { stream: true }); s.scrollTop = 1e9; }
  }
  const dir = vm.get_dir(), out = vm.get_out();
  for (const [k, c] of Object.entries(plugs)) if (c.type === 'led') {
    const p = +k[1], w = vm.get_pwm(p), b = w & 256 ? (w & 255) / 255 : ((dir >> p) & (out >> p) & 1);
    $('#led-' + k)?.setAttribute('fill-opacity', .15 + .85 * b);
  }
  requestAnimationFrame(frame);
}
const names = await (await fetch('examples.json')).json();
$('#ex').innerHTML = names.map(n => `<option>${n}</option>`).join('');
$('#ex').onchange = () => load($('#ex').value);
$('#run').onclick = () => setRun(!running);
$('#rst').onclick = () => load($('#ex').value);
plugs = { D3: { type: 'led', val: 0, down: false } }; drawBoard();
await load(names[0]); requestAnimationFrame(frame);
