#!/usr/bin/env node
'use strict';
// xisp：用 tag ... _tag 取代括號的 Lisp（支援符號運算子）
// 用法：node xisp.js file.xisp
const fs = require('fs');

class XispError extends Error {}
const err = (x, msg) => new XispError(x && x.line ? `line ${x.line}: ${msg}` : msg);

// ───────── 1. Tokenizer ─────────
function tokenize(src) {
  const re = /"(?:\\.|[^"\\])*"|;[^\n]*|[^\s";]+/g;
  const toks = [];
  let m, line = 1, last = 0;
  while ((m = re.exec(src))) {
    for (let k = last; k < m.index; k++) if (src[k] === '\n') line++;
    last = m.index;
    const t = m[0];
    if (t[0] === ';') continue;
    if (t[0] === '"') toks.push({ str: true, v: JSON.parse(t), line });
    else toks.push({ str: false, v: t, line });
  }
  return toks;
}

const isClose = v => v.length > 1 && v[0] === '_';

// ───────── 2. Reader：tag ... _tag → 節點 ─────────
function parse(src) {
  const toks = tokenize(src);
  const openers = new Set(
    toks.filter(t => !t.str && isClose(t.v)).map(t => t.v.slice(1)));
  let i = 0;

  function read() {
    const tk = toks[i++];
    if (tk.str) return { s: tk.v };
    const v = tk.v;
    if (isClose(v)) throw err(tk, `多餘的結束標籤 ${v}`);
    if (!openers.has(v)) return v;

    const node = { tag: v, args: [], line: tk.line };
    if (v === 'fn' || v === 'lambda') {
      if (v === 'fn') {
        if (i >= toks.length || toks[i].str) throw err(tk, 'fn 後面需要函式名稱');
        node.args.push(toks[i++].v);
      }
      while (i < toks.length && !toks[i].str &&
             !isClose(toks[i].v) && !openers.has(toks[i].v))
        node.args.push(toks[i++].v);
    }
    for (;;) {
      if (i >= toks.length) throw err(tk, `${v} 沒有結束標籤 _${v}`);
      const nx = toks[i];
      if (!nx.str && nx.v === '_' + v) { i++; return node; }
      if (!nx.str && isClose(nx.v))
        throw err(nx, `預期 _${v}（${v} 開在第 ${tk.line} 行），卻看到 ${nx.v}`);
      node.args.push(read());
    }
  }

  const prog = [];
  while (i < toks.length) prog.push(read());
  return prog;
}

// ───────── 3. Environment ─────────
class Env {
  constructor(parent = null) { this.vars = new Map(); this.parent = parent; }
  define(k, v) { this.vars.set(k, v); }
  find(k) {
    for (let e = this; e; e = e.parent) if (e.vars.has(k)) return e;
    return null;
  }
  get(k) {
    const e = this.find(k);
    if (!e) throw new XispError(`未定義的名稱：${k}`);
    return e.vars.get(k);
  }
  set(k, v) {
    const e = this.find(k);
    if (!e) throw new XispError(`set 之前必須先定義：${k}`);
    e.vars.set(k, v);
  }
}

const truthy = v => v !== false && v !== null && v !== undefined;
const NUM = /^[+-]?(\d+\.?\d*|\.\d+)$/;

// ───────── 4. Evaluator ─────────
function run(list, env) {
  let r;
  for (const x of list) r = ev(x, env);
  return r;
}

function ev(x, env) {
  if (typeof x === 'string') {
    if (NUM.test(x)) return Number(x);
    if (x === 'true') return true;
    if (x === 'false') return false;
    if (x === 'nil') return [];
    return env.get(x);
  }
  if (x.tag === undefined) return x.s;
  const sf = special[x.tag];
  if (sf) return sf(x, env);
  const f = env.get(x.tag);
  if (typeof f !== 'function') throw err(x, `${x.tag} 不是函式`);
  return f(...x.args.map(a => ev(a, env)));
}

function makeFn(name, rest, env, x) {
  let idx = rest.findIndex(a => typeof a !== 'string');
  let params, body;
  if (idx === -1) { params = rest.slice(0, -1); body = rest.slice(-1); }
  else { params = rest.slice(0, idx); body = rest.slice(idx); }
  if (body.length === 0) throw err(x, `${name || 'lambda'} 缺少函式本體`);
  const f = (...a) => {
    if (a.length !== params.length)
      throw err(x, `${name || 'lambda'} 需要 ${params.length} 個參數，收到 ${a.length} 個`);
    const e = new Env(env);
    params.forEach((p, i) => e.define(p, a[i]));
    return run(body, e);
  };
  f.xname = name;
  return f;
}

const special = {
  if(x, env) {
    if (x.args.length < 2) throw err(x, 'if 需要「條件」與「then 分支」');
    const [c, t, e] = x.args;
    if (truthy(ev(c, env))) return ev(t, env);
    return e === undefined ? undefined : ev(e, env);
  },
  cond(x, env) {
    for (const cl of x.args) {
      if (cl.tag === 'when') {
        if (truthy(ev(cl.args[0], env))) return run(cl.args.slice(1), env);
      } else if (cl.tag === 'else') return run(cl.args, env);
      else throw err(x, 'cond 裡只能有 when / else');
    }
  },
  let(x, env) {
    const k = x.args.indexOf('in');
    if (k < 0) throw err(x, 'let 需要 in 分隔綁定與本體');
    const e = new Env(env);
    const bs = x.args.slice(0, k);
    if (bs.length % 2) throw err(x, 'let 的綁定必須是「名稱 值」成對');
    for (let j = 0; j < bs.length; j += 2) {
      if (typeof bs[j] !== 'string') throw err(x, 'let 的名稱必須是原子');
      e.define(bs[j], ev(bs[j + 1], e));
    }
    return run(x.args.slice(k + 1), e);
  },
  fn(x, env) {
    const name = x.args[0];
    env.define(name, makeFn(name, x.args.slice(1), env, x));
  },
  lambda: (x, env) => makeFn(null, x.args, env, x),
  def(x, env) { env.define(x.args[0], ev(x.args[1], env)); },
  set(x, env) { env.set(x.args[0], ev(x.args[1], env)); },
  do: (x, env) => run(x.args, env),
  and(x, env) {
    let r = true;
    for (const a of x.args) { r = ev(a, env); if (!truthy(r)) return r; }
    return r;
  },
  or(x, env) {
    let r = false;
    for (const a of x.args) { r = ev(a, env); if (truthy(r)) return r; }
    return r;
  },
  call(x, env) {
    const f = ev(x.args[0], env);
    if (typeof f !== 'function') throw err(x, 'call 的第一個參數必須是函式');
    return f(...x.args.slice(1).map(a => ev(a, env)));
  },
  for(x, env) {
    const v = x.args[0];
    const from = ev(x.args[1], env), to = ev(x.args[2], env);
    for (let n = from; n <= to; n++) {
      const e = new Env(env);
      e.define(v, n);
      run(x.args.slice(3), e);
    }
  },
  while(x, env) {
    while (truthy(ev(x.args[0], env))) run(x.args.slice(1), env);
  },
};

// ───────── 5. 內建函式（包含運算子符號對映） ─────────
function show(v, quote) {
  if (Array.isArray(v)) return '(' + v.map(e => show(e, true)).join(' ') + ')';
  if (typeof v === 'string') return quote ? JSON.stringify(v) : v;
  if (typeof v === 'function') return `<fn ${v.xname || 'lambda'}>`;
  return String(v);
}
const same = (a, b) => a === b ||
  (Array.isArray(a) && Array.isArray(b) && JSON.stringify(a) === JSON.stringify(b));

const builtins = {
  add: (...a) => a.length ? a.reduce((s, v) => s + v) : 0,
  sub: (...a) => a.length === 1 ? -a[0] : a.reduce((s, v) => s - v),
  mul: (...a) => a.reduce((s, v) => s * v, 1),
  div: (...a) => a.reduce((s, v) => s / v),
  mod: (a, b) => a % b,
  lt: (a, b) => a < b, gt: (a, b) => a > b,
  le: (a, b) => a <= b, ge: (a, b) => a >= b,
  eq: same, ne: (a, b) => !same(a, b),
  
  // ── 符號運算子別名 ──
  '+': (...a) => a.length ? a.reduce((s, v) => s + v) : 0,
  '-': (...a) => a.length === 1 ? -a[0] : a.reduce((s, v) => s - v),
  '*': (...a) => a.reduce((s, v) => s * v, 1),
  '/': (...a) => a.reduce((s, v) => s / v),
  '%': (a, b) => a % b,
  '<': (a, b) => a < b,
  '>': (a, b) => a > b,
  '<=': (a, b) => a <= b,
  '>=': (a, b) => a >= b,
  '==': same,
  '!=': (a, b) => !same(a, b),

  not: a => !truthy(a),
  abs: Math.abs, min: Math.min, max: Math.max,
  list: (...a) => a,
  cons: (a, l) => [a, ...l],
  car: l => { if (!l.length) throw new XispError('car：空串列'); return l[0]; },
  cdr: l => l.slice(1),
  nth: (l, n) => l[n],
  append: (...ls) => [].concat(...ls),
  length: l => l.length,
  null: l => Array.isArray(l) && l.length === 0,
  range: (a, b) => Array.from({ length: Math.max(0, b - a + 1) }, (_, i) => a + i),
  map: (f, l) => l.map(v => f(v)),
  filter: (f, l) => l.filter(v => truthy(f(v))),
  reduce: (f, init, l) => l.reduce((s, v) => f(s, v), init),
  str: (...a) => a.map(v => show(v, false)).join(''),
  print: (...a) => { console.log(a.map(v => show(v, false)).join(' ')); },
};

// ───────── 6. 主程式 ─────────
function main() {
  const file = process.argv[2];
  if (!file) {
    console.error('用法：node xisp.js <檔案.xisp>');
    process.exit(1);
  }
  const global = new Env();
  for (const [k, v] of Object.entries(builtins)) global.define(k, v);
  try {
    const prog = parse(fs.readFileSync(file, 'utf8'));
    for (const form of prog) {
      const r = ev(form, global);
      if (r !== undefined) console.log(show(r, true));
    }
  } catch (e) {
    if (e instanceof XispError) console.error(`xisp 錯誤：${e.message}`);
    else if (e instanceof RangeError) console.error('xisp 錯誤：遞迴太深');
    else if (e.code === 'ENOENT') console.error(`找不到檔案：${file}`);
    else throw e;
    process.exit(1);
  }
}
main();