"""
py2ll.py - a self-hosting compiler: Python subset -> LLVM IR (.ll)

Usage:  python py2ll.py <script.py> [-o out.ll]

The compiler is itself written in the subset it accepts, so it can compile
itself:   python py2ll.py py2ll.py -o py2ll.ll
Then run: lli -extra-module=rt.ll py2ll.ll <script.py> -o out.ll

Supported subset: int/float/str/list/tuple/dict/set, functions (defaults),
classes (single inheritance), if/while/for/break/continue/return,
try/except/finally/raise, with, list comprehensions, f-strings, lambda
(no captured locals), global, import sys/math, and the builtins listed below.
Not supported: nested-function closures, *args/**kwargs, keyword arguments
(except print's sep/end/file), generators, decorators, big integers (63-bit).
"""

import sys

# ---------------------------------------------------------------- tables

BUILTIN_FUNCS = ['len', 'range', 'int', 'float', 'str', 'bool', 'list', 'tuple',
                 'dict', 'set', 'isinstance', 'abs', 'min', 'max', 'sum', 'round',
                 'sorted', 'reversed', 'enumerate', 'zip', 'map', 'filter', 'any',
                 'all', 'chr', 'ord', 'hex', 'bin', 'oct', 'repr', 'open', 'input',
                 'exit', 'divmod', 'pow', 'hasattr', 'getattr', 'setattr', 'callable']
BUILTIN_EXTRA = ['quit', 'print']
EXC_NAMES = ['Exception', 'ValueError', 'TypeError', 'NameError', 'AttributeError',
             'RuntimeError', 'AssertionError', 'StopIteration', 'OSError',
             'ArithmeticError', 'LookupError', 'ImportError', 'EOFError', 'IndexError',
             'KeyError', 'ZeroDivisionError', 'OverflowError', 'NotImplementedError',
             'FileNotFoundError', 'IOError']

BINOP_FN = {'+': 'rt_add', '-': 'rt_sub', '*': 'rt_mul', '/': 'rt_truediv',
            '//': 'rt_floordiv', '%': 'rt_mod', '**': 'rt_pow', '&': 'rt_and',
            '|': 'rt_or', '^': 'rt_xor', '<<': 'rt_lshift', '>>': 'rt_rshift'}
CMP_CODE = {'==': 0, '!=': 1, '<': 2, '<=': 3, '>': 4, '>=': 5, 'in': 6,
            'not in': 7, 'is': 8, 'is not': 9}
BINLEVELS = [['|'], ['^'], ['&'], ['<<', '>>'], ['+', '-'], ['*', '/', '//', '%']]
AUGOPS = ['+=', '-=', '*=', '/=', '//=', '%=', '**=', '&=', '|=', '^=', '<<=', '>>=']
OPS3 = ['**=', '//=', '>>=', '<<=', '...']
OPS2 = ['**', '//', '==', '!=', '<=', '>=', '+=', '-=', '*=', '/=', '%=', '&=',
        '|=', '^=', '->', '<<', '>>', ':=']
OPS1 = '+-*/%<>=()[]{},:.;&|^~@'
HEXD = '0123456789ABCDEF'

RT_DECLS = '''
declare void @rt_init(i32, ptr)
declare i64 @rt_mkstr(ptr, i64)
declare i64 @rt_mkfloat_cstr(ptr)
declare i64 @rt_add(i64, i64)
declare i64 @rt_sub(i64, i64)
declare i64 @rt_mul(i64, i64)
declare i64 @rt_truediv(i64, i64)
declare i64 @rt_floordiv(i64, i64)
declare i64 @rt_mod(i64, i64)
declare i64 @rt_pow(i64, i64)
declare i64 @rt_and(i64, i64)
declare i64 @rt_or(i64, i64)
declare i64 @rt_xor(i64, i64)
declare i64 @rt_lshift(i64, i64)
declare i64 @rt_rshift(i64, i64)
declare i64 @rt_neg(i64)
declare i64 @rt_invert(i64)
declare i64 @rt_not(i64)
declare i64 @rt_toint(i64)
declare i64 @rt_cmp(i64, i64, i64)
declare i64 @rt_truthy(i64)
declare i64 @rt_list_new(i64, ptr)
declare i64 @rt_tuple_new(i64, ptr)
declare i64 @rt_dict_new(i64, ptr)
declare i64 @rt_set_new(i64, ptr)
declare i64 @rt_list_append(i64, i64)
declare i64 @rt_empty_list()
declare i64 @rt_func_new(ptr, i64, i64, i64, ptr)
declare i64 @rt_class_new(i64, i64)
declare i64 @rt_class_set(i64, i64, i64)
declare i64 @rt_fstr(i64, ptr)
declare i64 @rt_format(i64, i64)
declare i64 @rt_str(i64)
declare i64 @rt_repr(i64)
declare i64 @rt_call(i64, i64, ptr)
declare i64 @rt_callmeth(i64, i64, i64, ptr)
declare i64 @rt_getattr(i64, i64)
declare i64 @rt_setattr(i64, i64, i64)
declare i64 @rt_getitem(i64, i64)
declare i64 @rt_setitem(i64, i64, i64)
declare i64 @rt_delitem(i64, i64)
declare i64 @rt_slice(i64, i64, i64, i64)
declare i64 @rt_iter_new(i64)
declare i64 @rt_iter_next(i64, ptr)
declare i64 @rt_unpack(i64, i64, ptr)
declare i64 @rt_print(i64, ptr, i64, i64, i64)
declare i64 @rt_import(i64)
declare i64 @rt_getbuiltin(ptr)
declare i64 @rt_raise(i64)
declare ptr @rt_try_push()
declare void @rt_try_pop()
declare i64 @rt_exc_cur()
declare i64 @rt_exc_match(i64, i64)
declare i64 @rt_assert_fail(i64)
declare i64 @rt_with_exit(i64)
declare i32 @_setjmp(ptr) returns_twice
@rt_none_v = external global i64
@rt_true_v = external global i64
@rt_false_v = external global i64
'''


def fail(msg, line):
    sys.stderr.write('py2ll: error (line %d): %s\n' % (line, msg))
    sys.exit(1)


# ---------------------------------------------------------------- tokenizer

def unescape(s):
    if '\\' not in s:
        return s
    out = []
    i = 0
    n = len(s)
    while i < n:
        c = s[i]
        if c != '\\' or i + 1 >= n:
            out.append(c)
            i += 1
            continue
        d = s[i + 1]
        i += 2
        if d == 'n':
            out.append('\n')
        elif d == 't':
            out.append('\t')
        elif d == 'r':
            out.append('\r')
        elif d == '0':
            out.append(chr(0))
        elif d == '\\':
            out.append('\\')
        elif d == '\'':
            out.append('\'')
        elif d == '"':
            out.append('"')
        elif d == '\n':
            pass
        elif d == 'x':
            out.append(chr(int(s[i:i + 2], 16)))
            i += 2
        else:
            out.append('\\')
            out.append(d)
    return ''.join(out)


def scan_string(src, i, line):
    # src[i] is the opening quote. returns [raw_text, index_after]
    q = src[i]
    n = len(src)
    if src[i:i + 3] == q * 3:
        j = i + 3
        while j < n:
            if src[j] == '\\':
                j += 2
                continue
            if src[j:j + 3] == q * 3:
                break
            j += 1
        if j >= n:
            fail('unterminated triple-quoted string', line)
        return [src[i + 3:j], j + 3]
    j = i + 1
    while j < n:
        c = src[j]
        if c == '\\':
            j += 2
            continue
        if c == q:
            break
        if c == '\n':
            fail('unterminated string literal', line)
        j += 1
    if j >= n:
        fail('unterminated string literal', line)
    return [src[i + 1:j], j + 1]


def is_name_start(c):
    return c.isalpha() or c == '_'


def is_name_char(c):
    return c.isalnum() or c == '_'


def tokenize(src):
    toks = []
    indents = [0]
    i = 0
    n = len(src)
    line = 1
    depth = 0
    at_start = True
    while i < n:
        if at_start and depth == 0:
            col = 0
            j = i
            while j < n and (src[j] == ' ' or src[j] == '\t'):
                if src[j] == '\t':
                    col = (col // 8 + 1) * 8
                else:
                    col += 1
                j += 1
            if j >= n:
                i = j
                break
            c = src[j]
            if c == '\n' or c == '#' or c == '\r':
                while j < n and src[j] != '\n':
                    j += 1
                if j < n:
                    j += 1
                line += 1
                i = j
                continue
            if col > indents[-1]:
                indents.append(col)
                toks.append(('IND', '', line))
            else:
                while col < indents[-1]:
                    indents.pop()
                    toks.append(('DED', '', line))
            i = j
            at_start = False
            continue
        c = src[i]
        if c == '\r':
            i += 1
            continue
        if c == '\n':
            line += 1
            i += 1
            if depth == 0:
                toks.append(('NL', '', line - 1))
                at_start = True
            continue
        if c == ' ' or c == '\t':
            i += 1
            continue
        if c == '#':
            while i < n and src[i] != '\n':
                i += 1
            continue
        if c == '\\' and i + 1 < n and (src[i + 1] == '\n' or src[i + 1] == '\r'):
            i += 1
            while i < n and src[i] != '\n':
                i += 1
            i += 1
            line += 1
            continue
        if is_name_start(c):
            j = i
            while j < n and is_name_char(src[j]):
                j += 1
            word = src[i:j]
            if j < n and (src[j] == '"' or src[j] == '\'') and word.lower() in ['f', 'r', 'b', 'u', 'rb', 'br', 'fr', 'rf']:
                res = scan_string(src, j, line)
                lw = word.lower()
                if 'f' in lw:
                    toks.append(('FSTR', res[0], line))
                elif 'r' in lw:
                    toks.append(('STR', res[0], line))
                else:
                    toks.append(('STR', unescape(res[0]), line))
                line += res[0].count('\n')
                i = res[1]
                continue
            toks.append(('NAME', word, line))
            i = j
            continue
        if c.isdigit():
            j = i
            if c == '0' and i + 1 < n and (src[i + 1] == 'x' or src[i + 1] == 'X'):
                j = i + 2
                while j < n and (src[j].isdigit() or src[j] in 'abcdefABCDEF'):
                    j += 1
                toks.append(('INT', int(src[i:j], 16), line))
                i = j
                continue
            while j < n and src[j].isdigit():
                j += 1
            is_float = False
            if j + 1 < n and src[j] == '.' and src[j + 1].isdigit():
                is_float = True
                j += 1
                while j < n and src[j].isdigit():
                    j += 1
            if j < n and (src[j] == 'e' or src[j] == 'E'):
                k = j + 1
                if k < n and (src[k] == '+' or src[k] == '-'):
                    k += 1
                if k < n and src[k].isdigit():
                    is_float = True
                    j = k
                    while j < n and src[j].isdigit():
                        j += 1
            if is_float:
                toks.append(('FLOAT', src[i:j], line))
            else:
                toks.append(('INT', int(src[i:j]), line))
            i = j
            continue
        if c == '"' or c == '\'':
            res = scan_string(src, i, line)
            toks.append(('STR', unescape(res[0]), line))
            line += res[0].count('\n')
            i = res[1]
            continue
        op = ''
        if src[i:i + 3] in OPS3:
            op = src[i:i + 3]
        elif src[i:i + 2] in OPS2:
            op = src[i:i + 2]
        elif c in OPS1:
            op = c
        else:
            fail('unexpected character %s' % repr(c), line)
        if op == '(' or op == '[' or op == '{':
            depth += 1
        elif op == ')' or op == ']' or op == '}':
            depth -= 1
        toks.append(('OP', op, line))
        i += len(op)
    if len(toks) > 0 and toks[-1][0] != 'NL':
        toks.append(('NL', '', line))
    while len(indents) > 1:
        indents.pop()
        toks.append(('DED', '', line))
    toks.append(('EOF', '', line))
    return toks


# ---------------------------------------------------------------- parser

class Node:
    def __init__(self, kind, line):
        self.kind = kind
        self.line = line


def str_node(s, line):
    n = Node('Str', line)
    n.value = s
    return n


def parse_fstring(raw, line):
    parts = []
    lit = []
    i = 0
    n = len(raw)
    while i < n:
        c = raw[i]
        if c == '{':
            if i + 1 < n and raw[i + 1] == '{':
                lit.append('{')
                i += 2
                continue
            if len(lit) > 0:
                parts.append(str_node(unescape(''.join(lit)), line))
                lit = []
            k = i + 1
            depth = 0
            colon = -1
            bang = -1
            quote = ''
            while k < n:
                ch = raw[k]
                if quote != '':
                    if ch == quote:
                        quote = ''
                elif ch == '\'' or ch == '"':
                    quote = ch
                elif ch == '(' or ch == '[' or ch == '{':
                    depth += 1
                elif ch == ')' or ch == ']':
                    depth -= 1
                elif ch == '}':
                    if depth == 0:
                        break
                    depth -= 1
                elif depth == 0 and ch == '!' and k + 2 < n and (raw[k + 1] == 'r' or raw[k + 1] == 's') and (raw[k + 2] == '}' or raw[k + 2] == ':'):
                    bang = k
                elif depth == 0 and ch == ':':
                    colon = k
                    while k < n and raw[k] != '}':
                        k += 1
                    break
                k += 1
            if k >= n:
                fail('unterminated { in f-string', line)
            end = k
            if bang >= 0:
                end = bang
            elif colon >= 0:
                end = colon
            fv = Node('FormattedValue', line)
            ptoks = tokenize(raw[i + 1:end].strip())
            sub = Parser(ptoks)
            fv.value = sub.parse_testlist()
            fv.conv = ''
            if bang >= 0:
                fv.conv = raw[bang + 1]
            fv.spec = ''
            if colon >= 0:
                fv.spec = raw[colon + 1:k]
            parts.append(fv)
            i = k + 1
            continue
        if c == '}':
            if i + 1 < n and raw[i + 1] == '}':
                lit.append('}')
                i += 2
                continue
            fail('single } in f-string', line)
        lit.append(c)
        i += 1
    if len(lit) > 0:
        parts.append(str_node(unescape(''.join(lit)), line))
    return parts


class Parser:
    def __init__(self, toks):
        self.toks = toks
        self.pos = 0

    def kind(self):
        return self.toks[self.pos][0]

    def val(self):
        return self.toks[self.pos][1]

    def line(self):
        return self.toks[self.pos][2]

    def at_op(self, v):
        t = self.toks[self.pos]
        return t[0] == 'OP' and t[1] == v

    def at_kw(self, v):
        t = self.toks[self.pos]
        return t[0] == 'NAME' and t[1] == v

    def accept_op(self, v):
        if self.at_op(v):
            self.pos += 1
            return True
        return False

    def accept_kw(self, v):
        if self.at_kw(v):
            self.pos += 1
            return True
        return False

    def expect_op(self, v):
        if not self.accept_op(v):
            fail('expected %s but found %s' % (repr(v), repr(self.val())), self.line())

    def expect_kw(self, v):
        if not self.accept_kw(v):
            fail('expected %s but found %s' % (repr(v), repr(self.val())), self.line())

    def expect_name(self):
        if self.kind() != 'NAME':
            fail('expected a name but found %s' % repr(self.val()), self.line())
        v = self.val()
        self.pos += 1
        return v

    # ---- module / blocks

    def parse_module(self):
        body = []
        while self.kind() != 'EOF':
            if self.kind() == 'NL':
                self.pos += 1
                continue
            self.parse_stmt_into(body)
        return body

    def parse_block(self):
        self.expect_op(':')
        body = []
        if self.kind() == 'NL':
            self.pos += 1
            if self.kind() != 'IND':
                fail('expected an indented block', self.line())
            self.pos += 1
            while self.kind() != 'DED' and self.kind() != 'EOF':
                if self.kind() == 'NL':
                    self.pos += 1
                    continue
                self.parse_stmt_into(body)
            if self.kind() == 'DED':
                self.pos += 1
        else:
            self.parse_simple_line(body)
        return body

    def parse_stmt_into(self, out):
        if self.kind() == 'NAME':
            v = self.val()
            if v == 'if':
                out.append(self.parse_if())
                return
            if v == 'while':
                out.append(self.parse_while())
                return
            if v == 'for':
                out.append(self.parse_for())
                return
            if v == 'def':
                out.append(self.parse_def())
                return
            if v == 'class':
                out.append(self.parse_class())
                return
            if v == 'try':
                out.append(self.parse_try())
                return
            if v == 'with':
                out.append(self.parse_with())
                return
        if self.at_op('@'):
            fail('decorators are not supported', self.line())
        self.parse_simple_line(out)

    def parse_simple_line(self, out):
        out.append(self.parse_simple())
        while self.accept_op(';'):
            if self.kind() == 'NL':
                break
            out.append(self.parse_simple())
        if self.kind() == 'NL':
            self.pos += 1
        elif self.kind() != 'EOF' and self.kind() != 'DED':
            fail('unexpected token %s' % repr(self.val()), self.line())

    # ---- compound statements

    def parse_if(self):
        line = self.line()
        self.pos += 1
        n = Node('If', line)
        n.test = self.parse_expr()
        n.body = self.parse_block()
        n.orelse = []
        if self.at_kw('elif'):
            n.orelse = [self.parse_if()]
        elif self.at_kw('else'):
            self.pos += 1
            n.orelse = self.parse_block()
        return n

    def parse_while(self):
        n = Node('While', self.line())
        self.pos += 1
        n.test = self.parse_expr()
        n.body = self.parse_block()
        n.orelse = []
        if self.at_kw('else'):
            self.pos += 1
            n.orelse = self.parse_block()
        return n

    def parse_target_list(self):
        line = self.line()
        first = self.parse_bin(0)
        if not self.at_op(','):
            return first
        elts = [first]
        while self.accept_op(','):
            if self.at_kw('in') or self.at_op('='):
                break
            elts.append(self.parse_bin(0))
        t = Node('Tuple', line)
        t.elts = elts
        return t

    def parse_for(self):
        n = Node('For', self.line())
        self.pos += 1
        n.target = self.parse_target_list()
        self.expect_kw('in')
        n.iter = self.parse_testlist()
        n.body = self.parse_block()
        n.orelse = []
        if self.at_kw('else'):
            self.pos += 1
            n.orelse = self.parse_block()
        return n

    def parse_def(self):
        n = Node('FunctionDef', self.line())
        self.pos += 1
        n.name = self.expect_name()
        self.expect_op('(')
        n.params = []
        n.defaults = []
        while not self.at_op(')'):
            if self.at_op('*') or self.at_op('**'):
                fail('*args/**kwargs are not supported', self.line())
            n.params.append(self.expect_name())
            if self.accept_op(':'):
                self.parse_expr()
            if self.accept_op('='):
                n.defaults.append(self.parse_expr())
            elif len(n.defaults) > 0:
                fail('non-default argument follows default argument', self.line())
            if not self.accept_op(','):
                break
        self.expect_op(')')
        if self.accept_op('->'):
            self.parse_expr()
        n.body = self.parse_block()
        return n

    def parse_class(self):
        n = Node('ClassDef', self.line())
        self.pos += 1
        n.name = self.expect_name()
        n.base = None
        if self.accept_op('('):
            if not self.at_op(')'):
                n.base = self.parse_expr()
            self.expect_op(')')
        n.body = self.parse_block()
        return n

    def parse_try(self):
        n = Node('Try', self.line())
        self.pos += 1
        n.body = self.parse_block()
        n.handlers = []
        n.orelse = []
        n.finalbody = []
        while self.at_kw('except'):
            h = Node('Handler', self.line())
            self.pos += 1
            h.type = None
            h.name = None
            if not self.at_op(':'):
                h.type = self.parse_expr()
                if self.accept_kw('as'):
                    h.name = self.expect_name()
            h.body = self.parse_block()
            n.handlers.append(h)
        if self.at_kw('else'):
            self.pos += 1
            n.orelse = self.parse_block()
        if self.at_kw('finally'):
            self.pos += 1
            n.finalbody = self.parse_block()
        if len(n.handlers) == 0 and len(n.finalbody) == 0:
            fail('try needs except or finally', n.line)
        return n

    def parse_with(self):
        n = Node('With', self.line())
        self.pos += 1
        n.items = []
        while True:
            e = self.parse_expr()
            t = None
            if self.accept_kw('as'):
                t = self.parse_bin(0)
            n.items.append([e, t])
            if not self.accept_op(','):
                break
        n.body = self.parse_block()
        return n

    # ---- simple statements

    def parse_simple(self):
        line = self.line()
        if self.kind() == 'NAME':
            v = self.val()
            if v == 'return':
                self.pos += 1
                n = Node('Return', line)
                n.value = None
                if self.kind() != 'NL' and not self.at_op(';') and self.kind() != 'EOF':
                    n.value = self.parse_testlist()
                return n
            if v == 'pass':
                self.pos += 1
                return Node('Pass', line)
            if v == 'break':
                self.pos += 1
                return Node('Break', line)
            if v == 'continue':
                self.pos += 1
                return Node('Continue', line)
            if v == 'global' or v == 'nonlocal':
                self.pos += 1
                n = Node('Global', line)
                n.names = [self.expect_name()]
                while self.accept_op(','):
                    n.names.append(self.expect_name())
                return n
            if v == 'import':
                self.pos += 1
                n = Node('Import', line)
                n.names = []
                while True:
                    name = self.expect_name()
                    while self.accept_op('.'):
                        name = name + '.' + self.expect_name()
                    asname = name
                    if self.accept_kw('as'):
                        asname = self.expect_name()
                    n.names.append([name, asname])
                    if not self.accept_op(','):
                        break
                return n
            if v == 'from':
                self.pos += 1
                n = Node('ImportFrom', line)
                n.module = self.expect_name()
                while self.accept_op('.'):
                    n.module = n.module + '.' + self.expect_name()
                self.expect_kw('import')
                n.names = []
                paren = self.accept_op('(')
                while True:
                    name = self.expect_name()
                    asname = name
                    if self.accept_kw('as'):
                        asname = self.expect_name()
                    n.names.append([name, asname])
                    if not self.accept_op(','):
                        break
                if paren:
                    self.expect_op(')')
                return n
            if v == 'assert':
                self.pos += 1
                n = Node('Assert', line)
                n.test = self.parse_expr()
                n.msg = None
                if self.accept_op(','):
                    n.msg = self.parse_expr()
                return n
            if v == 'del':
                self.pos += 1
                n = Node('Delete', line)
                n.targets = [self.parse_bin(0)]
                while self.accept_op(','):
                    n.targets.append(self.parse_bin(0))
                return n
            if v == 'raise':
                self.pos += 1
                n = Node('Raise', line)
                n.exc = None
                if self.kind() != 'NL' and not self.at_op(';') and self.kind() != 'EOF':
                    n.exc = self.parse_expr()
                    if self.accept_kw('from'):
                        self.parse_expr()
                return n
        first = self.parse_testlist()
        if self.at_op('='):
            n = Node('Assign', line)
            n.targets = []
            cur = first
            while self.accept_op('='):
                n.targets.append(cur)
                cur = self.parse_testlist()
            n.value = cur
            return n
        if self.kind() == 'OP' and self.val() in AUGOPS:
            n = Node('AugAssign', line)
            n.op = self.val()[:-1]
            self.pos += 1
            n.target = first
            n.value = self.parse_testlist()
            return n
        if self.at_op(':') and first.kind == 'Name':
            self.pos += 1
            self.parse_expr()
            if self.accept_op('='):
                n = Node('Assign', line)
                n.targets = [first]
                n.value = self.parse_testlist()
                return n
            return Node('Pass', line)
        n = Node('Expr', line)
        n.value = first
        return n

    # ---- expressions

    def at_list_end(self):
        t = self.toks[self.pos]
        if t[0] == 'NL' or t[0] == 'EOF':
            return True
        if t[0] == 'OP' and t[1] in [')', ']', '}', '=', ':', ';']:
            return True
        return False

    def parse_testlist(self):
        line = self.line()
        e = self.parse_expr()
        if not self.at_op(','):
            return e
        elts = [e]
        while self.accept_op(','):
            if self.at_list_end():
                break
            elts.append(self.parse_expr())
        t = Node('Tuple', line)
        t.elts = elts
        return t

    def parse_expr(self):
        if self.at_kw('lambda'):
            return self.parse_lambda()
        e = self.parse_or()
        if self.at_kw('if'):
            n = Node('IfExp', self.line())
            self.pos += 1
            n.test = self.parse_or()
            self.expect_kw('else')
            n.body = e
            n.orelse = self.parse_expr()
            return n
        return e

    def parse_lambda(self):
        n = Node('Lambda', self.line())
        self.pos += 1
        n.params = []
        n.defaults = []
        while not self.at_op(':'):
            n.params.append(self.expect_name())
            if self.accept_op('='):
                n.defaults.append(self.parse_expr())
            if not self.accept_op(','):
                break
        self.expect_op(':')
        n.body = self.parse_expr()
        return n

    def parse_or(self):
        line = self.line()
        e = self.parse_and()
        if not self.at_kw('or'):
            return e
        n = Node('BoolOp', line)
        n.op = 'or'
        n.values = [e]
        while self.accept_kw('or'):
            n.values.append(self.parse_and())
        return n

    def parse_and(self):
        line = self.line()
        e = self.parse_not()
        if not self.at_kw('and'):
            return e
        n = Node('BoolOp', line)
        n.op = 'and'
        n.values = [e]
        while self.accept_kw('and'):
            n.values.append(self.parse_not())
        return n

    def parse_not(self):
        if self.at_kw('not'):
            n = Node('UnaryOp', self.line())
            self.pos += 1
            n.op = 'not'
            n.operand = self.parse_not()
            return n
        return self.parse_comparison()

    def cmp_op(self):
        t = self.toks[self.pos]
        if t[0] == 'OP' and t[1] in ['<', '>', '==', '>=', '<=', '!=']:
            return [t[1], 1]
        if t[0] == 'NAME':
            nxt = self.toks[self.pos + 1]
            if t[1] == 'in':
                return ['in', 1]
            if t[1] == 'is':
                if nxt[0] == 'NAME' and nxt[1] == 'not':
                    return ['is not', 2]
                return ['is', 1]
            if t[1] == 'not' and nxt[0] == 'NAME' and nxt[1] == 'in':
                return ['not in', 2]
        return None

    def parse_comparison(self):
        line = self.line()
        left = self.parse_bin(0)
        op = self.cmp_op()
        if op is None:
            return left
        n = Node('Compare', line)
        n.left = left
        n.ops = []
        n.comps = []
        while op is not None:
            self.pos += op[1]
            n.ops.append(op[0])
            n.comps.append(self.parse_bin(0))
            op = self.cmp_op()
        return n

    def parse_bin(self, lvl):
        if lvl >= 6:
            return self.parse_unary()
        line = self.line()
        left = self.parse_bin(lvl + 1)
        while self.kind() == 'OP' and self.val() in BINLEVELS[lvl]:
            n = Node('BinOp', line)
            n.op = self.val()
            self.pos += 1
            n.left = left
            n.right = self.parse_bin(lvl + 1)
            left = n
        return left

    def parse_unary(self):
        if self.kind() == 'OP' and self.val() in ['-', '+', '~']:
            n = Node('UnaryOp', self.line())
            n.op = self.val()
            self.pos += 1
            n.operand = self.parse_unary()
            return n
        return self.parse_power()

    def parse_power(self):
        line = self.line()
        base = self.parse_postfix()
        if self.at_op('**'):
            self.pos += 1
            n = Node('BinOp', line)
            n.op = '**'
            n.left = base
            n.right = self.parse_unary()
            return n
        return base

    def parse_postfix(self):
        e = self.parse_atom()
        while True:
            line = self.line()
            if self.at_op('('):
                self.pos += 1
                n = Node('Call', line)
                n.func = e
                n.args = []
                n.keywords = []
                while not self.at_op(')'):
                    if self.at_op('*') or self.at_op('**'):
                        fail('*args/**kwargs in calls are not supported', line)
                    nt = self.toks[self.pos + 1]
                    if self.kind() == 'NAME' and nt[0] == 'OP' and nt[1] == '=':
                        kname = self.val()
                        self.pos += 2
                        n.keywords.append([kname, self.parse_expr()])
                    else:
                        a = self.parse_expr()
                        if self.at_kw('for'):
                            a = self.parse_comp_rest(a, line)
                        n.args.append(a)
                    if not self.accept_op(','):
                        break
                self.expect_op(')')
                e = n
            elif self.at_op('['):
                self.pos += 1
                n = Node('Subscript', line)
                n.value = e
                lo = None
                if not self.at_op(':'):
                    lo = self.parse_expr()
                if self.at_op(':'):
                    self.pos += 1
                    sl = Node('Slice', line)
                    sl.lo = lo
                    sl.hi = None
                    sl.step = None
                    if not self.at_op(']') and not self.at_op(':'):
                        sl.hi = self.parse_expr()
                    if self.accept_op(':'):
                        if not self.at_op(']'):
                            sl.step = self.parse_expr()
                    n.index = sl
                else:
                    n.index = lo
                self.expect_op(']')
                e = n
            elif self.at_op('.'):
                self.pos += 1
                n = Node('Attribute', line)
                n.value = e
                n.attr = self.expect_name()
                e = n
            else:
                break
        return e

    def parse_comp_rest(self, elt, line):
        n = Node('ListComp', line)
        n.elt = elt
        n.gens = []
        while self.at_kw('for'):
            g = Node('Comp', self.line())
            self.pos += 1
            g.target = self.parse_target_list()
            self.expect_kw('in')
            g.iter = self.parse_or()
            g.ifs = []
            while self.at_kw('if'):
                self.pos += 1
                g.ifs.append(self.parse_or())
            n.gens.append(g)
        return n

    def parse_atom(self):
        t = self.toks[self.pos]
        line = t[2]
        k = t[0]
        if k == 'INT':
            self.pos += 1
            n = Node('Num', line)
            n.value = t[1]
            return n
        if k == 'FLOAT':
            self.pos += 1
            n = Node('Float', line)
            n.text = t[1]
            return n
        if k == 'STR' or k == 'FSTR':
            parts = []
            has_f = False
            while self.kind() == 'STR' or self.kind() == 'FSTR':
                tk = self.toks[self.pos]
                self.pos += 1
                if tk[0] == 'STR':
                    parts.append(str_node(tk[1], line))
                else:
                    has_f = True
                    for p in parse_fstring(tk[1], line):
                        parts.append(p)
            if not has_f:
                s = ''
                for p in parts:
                    s = s + p.value
                return str_node(s, line)
            merged = []
            for p in parts:
                if p.kind == 'Str' and len(merged) > 0 and merged[-1].kind == 'Str':
                    merged[-1] = str_node(merged[-1].value + p.value, line)
                else:
                    merged.append(p)
            n = Node('JoinedStr', line)
            n.values = merged
            return n
        if k == 'NAME':
            v = t[1]
            if v == 'True' or v == 'False' or v == 'None':
                self.pos += 1
                n = Node('NameConst', line)
                n.v = v
                return n
            if v in ['if', 'else', 'elif', 'while', 'for', 'def', 'class', 'return', 'in', 'is', 'and', 'or', 'not', 'import', 'from', 'try', 'except', 'finally', 'lambda']:
                fail('unexpected keyword %s' % v, line)
            self.pos += 1
            n = Node('Name', line)
            n.id = v
            return n
        if k == 'OP':
            v = t[1]
            if v == '(':
                self.pos += 1
                if self.accept_op(')'):
                    n = Node('Tuple', line)
                    n.elts = []
                    return n
                e = self.parse_expr()
                if self.at_kw('for'):
                    e = self.parse_comp_rest(e, line)
                    self.expect_op(')')
                    return e
                if self.at_op(','):
                    elts = [e]
                    while self.accept_op(','):
                        if self.at_op(')'):
                            break
                        elts.append(self.parse_expr())
                    self.expect_op(')')
                    n = Node('Tuple', line)
                    n.elts = elts
                    return n
                self.expect_op(')')
                return e
            if v == '[':
                self.pos += 1
                if self.accept_op(']'):
                    n = Node('List', line)
                    n.elts = []
                    return n
                e = self.parse_expr()
                if self.at_kw('for'):
                    e = self.parse_comp_rest(e, line)
                    self.expect_op(']')
                    return e
                elts = [e]
                while self.accept_op(','):
                    if self.at_op(']'):
                        break
                    elts.append(self.parse_expr())
                self.expect_op(']')
                n = Node('List', line)
                n.elts = elts
                return n
            if v == '{':
                self.pos += 1
                if self.accept_op('}'):
                    n = Node('Dict', line)
                    n.keys = []
                    n.values = []
                    return n
                first = self.parse_expr()
                if self.accept_op(':'):
                    n = Node('Dict', line)
                    n.keys = [first]
                    n.values = [self.parse_expr()]
                    while self.accept_op(','):
                        if self.at_op('}'):
                            break
                        n.keys.append(self.parse_expr())
                        self.expect_op(':')
                        n.values.append(self.parse_expr())
                    self.expect_op('}')
                    return n
                n = Node('Set', line)
                n.elts = [first]
                while self.accept_op(','):
                    if self.at_op('}'):
                        break
                    n.elts.append(self.parse_expr())
                self.expect_op('}')
                return n
        fail('unexpected token %s' % repr(t[1]), line)


# ---------------------------------------------------------------- code generator

def ll_escape(s):
    out = []
    for c in s:
        o = ord(c)
        if o < 32 or o > 126 or c == '"' or c == '\\':
            out.append('\\' + HEXD[o // 16] + HEXD[o % 16])
        else:
            out.append(c)
    return ''.join(out)


class Gen:
    def __init__(self):
        self.chunks = []
        self.strs = {}
        self.str_list = []
        self.floats = {}
        self.float_list = []
        self.gnames = {}
        self.pending = []
        self.nfunc = 0
        self.nlabel = 0
        self.ntmp = 0
        self.lines = []
        self.allocas = []
        self.locals = {}
        self.fglobals = {}
        self.is_module = False
        self.term = False
        self.loops = []
        self.try_stack = []

    # ---- low-level emission

    def tmp(self):
        self.ntmp += 1
        return '%t' + str(self.ntmp)

    def label(self, base):
        self.nlabel += 1
        return 'L' + str(self.nlabel) + '_' + base

    def start_block(self, name):
        if not self.term:
            self.lines.append('  br label %' + name)
        self.lines.append(name + ':')
        self.term = False

    def emit(self, s):
        if self.term:
            self.start_block(self.label('dead'))
        self.lines.append('  ' + s)

    def emit_term(self, s):
        if self.term:
            self.start_block(self.label('dead'))
        self.lines.append('  ' + s)
        self.term = True

    def br(self, name):
        self.emit_term('br label %' + name)

    def cbr(self, cond, a, b):
        self.emit_term('br i1 %s, label %%%s, label %%%s' % (cond, a, b))

    def new_alloca(self):
        self.ntmp += 1
        name = '%a' + str(self.ntmp)
        self.allocas.append('  ' + name + ' = alloca i64')
        return name

    def new_array(self, n):
        self.ntmp += 1
        name = '%a' + str(self.ntmp)
        self.allocas.append('  %s = alloca [%d x i64]' % (name, n))
        return name

    def callv(self, fname, args):
        # all-i64 call
        t = self.tmp()
        parts = []
        for a in args:
            parts.append('i64 ' + a)
        self.emit('%s = call i64 @%s(%s)' % (t, fname, ', '.join(parts)))
        return t

    def callraw(self, fname, argtext):
        t = self.tmp()
        self.emit('%s = call i64 @%s(%s)' % (t, fname, argtext))
        return t

    def load_ptr(self, p):
        t = self.tmp()
        self.emit('%s = load i64, ptr %s' % (t, p))
        return t

    def none(self):
        return self.load_ptr('@rt_none_v')

    def bool_obj(self, c):
        a = self.load_ptr('@rt_true_v')
        b = self.load_ptr('@rt_false_v')
        t = self.tmp()
        self.emit('%s = select i1 %s, i64 %s, i64 %s' % (t, c, a, b))
        return t

    def sconst(self, s):
        if s in self.strs:
            return self.strs[s]
        idx = len(self.str_list)
        self.strs[s] = idx
        self.str_list.append(s)
        return idx

    def load_str(self, s):
        idx = self.sconst(s)
        return self.load_ptr('@.sv.' + str(idx))

    def cstr_ptr(self, s):
        return '@.str.' + str(self.sconst(s))

    def float_const(self, text):
        if text in self.floats:
            idx = self.floats[text]
        else:
            idx = len(self.float_list)
            self.floats[text] = idx
            self.float_list.append(text)
            self.sconst(text)
        return self.load_ptr('@.fv.' + str(idx))

    def build_array(self, vals):
        if len(vals) == 0:
            return 'null'
        arr = self.new_array(len(vals))
        i = 0
        for v in vals:
            p = self.tmp()
            self.emit('%s = getelementptr i64, ptr %s, i64 %d' % (p, arr, i))
            self.emit('store i64 %s, ptr %s' % (v, p))
            i += 1
        return arr

    # ---- names

    def is_user_name(self, name):
        return name in self.locals or name in self.gnames

    def load_name(self, name, line):
        if name in self.locals:
            return self.load_ptr('%v.' + name)
        if name in self.gnames:
            return self.load_ptr('@g.' + name)
        if name in BUILTIN_FUNCS or name in BUILTIN_EXTRA or name in EXC_NAMES:
            return self.callraw('rt_getbuiltin', 'ptr ' + self.cstr_ptr(name))
        fail("undefined name '%s'" % name, line)

    def add_local(self, name):
        self.locals[name] = True
        self.allocas.append('  %%v.%s = alloca i64' % name)
        self.allocas.append('  store i64 0, ptr %%v.%s' % name)

    def store_name(self, name, v):
        if self.is_module or name in self.fglobals:
            self.gnames[name] = True
            self.emit('store i64 %s, ptr @g.%s' % (v, name))
            return
        if name not in self.locals:
            self.add_local(name)
        self.emit('store i64 %s, ptr %%v.%s' % (v, name))

    # ---- scope analysis

    def collect_target(self, t, out):
        if t.kind == 'Name':
            out[t.id] = True
        elif t.kind == 'Tuple' or t.kind == 'List':
            for e in t.elts:
                self.collect_target(e, out)

    def collect(self, stmts, assigned, gl):
        for s in stmts:
            k = s.kind
            if k == 'Assign':
                for t in s.targets:
                    self.collect_target(t, assigned)
            elif k == 'AugAssign':
                self.collect_target(s.target, assigned)
            elif k == 'For':
                self.collect_target(s.target, assigned)
                self.collect(s.body, assigned, gl)
                self.collect(s.orelse, assigned, gl)
            elif k == 'While' or k == 'If':
                self.collect(s.body, assigned, gl)
                self.collect(s.orelse, assigned, gl)
            elif k == 'Try':
                self.collect(s.body, assigned, gl)
                for h in s.handlers:
                    if h.name is not None:
                        assigned[h.name] = True
                    self.collect(h.body, assigned, gl)
                self.collect(s.orelse, assigned, gl)
                self.collect(s.finalbody, assigned, gl)
            elif k == 'With':
                for it in s.items:
                    if it[1] is not None:
                        self.collect_target(it[1], assigned)
                self.collect(s.body, assigned, gl)
            elif k == 'FunctionDef' or k == 'ClassDef':
                assigned[s.name] = True
            elif k == 'Import':
                for nm in s.names:
                    assigned[nm[1]] = True
            elif k == 'ImportFrom':
                for nm in s.names:
                    assigned[nm[1]] = True
            elif k == 'Global':
                for nm in s.names:
                    gl[nm] = True

    # ---- functions

    def queue_function(self, name, params, body):
        self.nfunc += 1
        irname = '@f' + str(self.nfunc) + '_' + name
        self.pending.append([irname, params, body])
        return irname

    def make_func_value(self, irname, name, params, defaults):
        dvals = []
        for d in defaults:
            dvals.append(self.expr(d))
        darr = self.build_array(dvals)
        namev = self.load_str(name)
        return self.callraw('rt_func_new', 'ptr %s, i64 %d, i64 %s, i64 %d, ptr %s' % (irname, len(params), namev, len(defaults), darr))

    def compile_func(self, irname, params, body, is_module):
        self.lines = []
        self.allocas = []
        self.locals = {}
        self.fglobals = {}
        self.is_module = is_module
        self.term = False
        self.loops = []
        self.try_stack = []
        if not is_module:
            assigned = {}
            gl = {}
            self.collect(body, assigned, gl)
            for g in gl:
                self.fglobals[g] = True
                self.gnames[g] = True
            for p in params:
                if p not in self.locals:
                    self.add_local(p)
            for a in assigned:
                if a not in self.fglobals and a not in self.locals:
                    self.add_local(a)
            i = 0
            for p in params:
                ptr = self.tmp()
                self.emit('%s = getelementptr i64, ptr %%argv, i64 %d' % (ptr, i))
                v = self.load_ptr(ptr)
                self.emit('store i64 %s, ptr %%v.%s' % (v, p))
                i += 1
        else:
            nv = self.load_str('__main__')
            self.gnames['__name__'] = True
            self.emit('store i64 %s, ptr @g.__name__' % nv)
        for s in body:
            self.stmt(s)
        if not self.term:
            r = self.none()
            self.emit_term('ret i64 ' + r)
        out = ['define i64 %s(i64 %%argc, ptr %%argv) {' % irname, 'entry:']
        for a in self.allocas:
            out.append(a)
        out.append('  br label %start')
        out.append('start:')
        for l in self.lines:
            out.append(l)
        out.append('}')
        self.chunks.append('\n'.join(out))

    def compile_module(self, body):
        assigned = {}
        gl = {}
        self.collect(body, assigned, gl)
        for a in assigned:
            self.gnames[a] = True
        self.compile_func('@py_module_body', [], body, True)
        while len(self.pending) > 0:
            p = self.pending.pop(0)
            self.compile_func(p[0], p[1], p[2], False)
        return self.assemble()

    def assemble(self):
        out = ['; generated by py2ll.py', RT_DECLS.strip()]
        for b in BUILTIN_FUNCS:
            out.append('declare i64 @b_%s(i64, ptr)' % b)
        i = 0
        for s in self.str_list:
            out.append('@.str.%d = private unnamed_addr constant [%d x i8] c"%s\\00"' % (i, len(s) + 1, ll_escape(s)))
            out.append('@.sv.%d = global i64 0' % i)
            i += 1
        i = 0
        for f in self.float_list:
            out.append('@.fv.%d = global i64 0' % i)
            i += 1
        for g in self.gnames:
            out.append('@g.%s = global i64 0' % g)
        for c in self.chunks:
            out.append(c)
        out.append('define void @init_consts() {')
        out.append('entry:')
        i = 0
        for s in self.str_list:
            out.append('  %%s%d = call i64 @rt_mkstr(ptr @.str.%d, i64 %d)' % (i, i, len(s)))
            out.append('  store i64 %%s%d, ptr @.sv.%d' % (i, i))
            i += 1
        i = 0
        for f in self.float_list:
            out.append('  %%f%d = call i64 @rt_mkfloat_cstr(ptr @.str.%d)' % (i, self.strs[f]))
            out.append('  store i64 %%f%d, ptr @.fv.%d' % (i, i))
            i += 1
        out.append('  ret void')
        out.append('}')
        out.append('define i32 @main(i32 %argc, ptr %argv) {')
        out.append('entry:')
        out.append('  call void @rt_init(i32 %argc, ptr %argv)')
        out.append('  call void @init_consts()')
        out.append('  %r = call i64 @py_module_body(i64 0, ptr null)')
        out.append('  ret i32 0')
        out.append('}')
        return '\n'.join(out) + '\n'

    # ---- statements

    def stmt(self, n):
        k = n.kind
        if k == 'Expr':
            if n.value.kind != 'Str':
                self.expr(n.value)
        elif k == 'Assign':
            v = self.expr(n.value)
            for t in n.targets:
                self.assign_target(t, v)
        elif k == 'AugAssign':
            self.stmt_augassign(n)
        elif k == 'If':
            self.stmt_if(n)
        elif k == 'While':
            self.stmt_while(n)
        elif k == 'For':
            self.stmt_for(n)
        elif k == 'FunctionDef':
            irname = self.queue_function(n.name, n.params, n.body)
            fv = self.make_func_value(irname, n.name, n.params, n.defaults)
            self.store_name(n.name, fv)
        elif k == 'ClassDef':
            self.stmt_class(n)
        elif k == 'Return':
            if self.is_module:
                fail('return outside function', n.line)
            if n.value is None:
                v = self.none()
            else:
                v = self.expr(n.value)
            self.unwind(0)
            self.emit_term('ret i64 ' + v)
        elif k == 'Break':
            if len(self.loops) == 0:
                fail("'break' outside loop", n.line)
            lp = self.loops[-1]
            self.unwind(lp[2])
            self.br(lp[1])
        elif k == 'Continue':
            if len(self.loops) == 0:
                fail("'continue' outside loop", n.line)
            lp = self.loops[-1]
            self.unwind(lp[2])
            self.br(lp[0])
        elif k == 'Pass' or k == 'Global':
            pass
        elif k == 'Import':
            for nm in n.names:
                if '.' in nm[0]:
                    fail('dotted imports are not supported', n.line)
                v = self.callv('rt_import', [self.load_str(nm[0])])
                self.store_name(nm[1], v)
        elif k == 'ImportFrom':
            m = self.callv('rt_import', [self.load_str(n.module)])
            for nm in n.names:
                a = self.callv('rt_getattr', [m, self.load_str(nm[0])])
                self.store_name(nm[1], a)
        elif k == 'Assert':
            c = self.cond(n.test)
            lok = self.label('assert_ok')
            lbad = self.label('assert_fail')
            self.cbr(c, lok, lbad)
            self.start_block(lbad)
            if n.msg is None:
                m = self.none()
            else:
                m = self.expr(n.msg)
            self.callv('rt_assert_fail', [m])
            self.br(lok)
            self.start_block(lok)
        elif k == 'Delete':
            for t in n.targets:
                if t.kind == 'Subscript':
                    o = self.expr(t.value)
                    key = self.expr(t.index)
                    self.callv('rt_delitem', [o, key])
                elif t.kind == 'Name':
                    self.store_name(t.id, self.none())
                else:
                    fail('unsupported del target', n.line)
        elif k == 'Raise':
            if n.exc is None:
                v = self.callraw('rt_exc_cur', '')
            else:
                v = self.expr(n.exc)
            self.callv('rt_raise', [v])
            self.emit_term('unreachable')
        elif k == 'Try':
            self.stmt_try(n)
        elif k == 'With':
            self.stmt_with(n)
        else:
            fail('unsupported statement %s' % k, n.line)

    def unwind(self, target):
        # leave enclosing try blocks down to depth 'target': pop active
        # handlers and run pending 'finally' bodies inline.
        saved = self.try_stack
        i = len(saved) - 1
        while i >= target:
            ent = saved[i]
            if ent[1]:
                self.emit('call void @rt_try_pop()')
            if len(ent[0]) > 0:
                self.try_stack = saved[:i]
                self.block(ent[0])
            i -= 1
        self.try_stack = saved

    def block(self, stmts):
        for s in stmts:
            self.stmt(s)

    def stmt_if(self, n):
        c = self.cond(n.test)
        lthen = self.label('then')
        lend = self.label('endif')
        lelse = lend
        if len(n.orelse) > 0:
            lelse = self.label('else')
        self.cbr(c, lthen, lelse)
        self.start_block(lthen)
        self.block(n.body)
        self.br(lend)
        if len(n.orelse) > 0:
            self.start_block(lelse)
            self.block(n.orelse)
            self.br(lend)
        self.start_block(lend)

    def stmt_while(self, n):
        lhead = self.label('while')
        lbody = self.label('wbody')
        lend = self.label('wend')
        lelse = lend
        if len(n.orelse) > 0:
            lelse = self.label('welse')
        self.start_block(lhead)
        c = self.cond(n.test)
        self.cbr(c, lbody, lelse)
        self.start_block(lbody)
        self.loops.append([lhead, lend, len(self.try_stack)])
        self.block(n.body)
        self.loops.pop()
        self.br(lhead)
        if len(n.orelse) > 0:
            self.start_block(lelse)
            self.block(n.orelse)
            self.br(lend)
        self.start_block(lend)

    def const_int(self, n):
        if n.kind == 'Num':
            return [True, n.value]
        if n.kind == 'UnaryOp' and n.op == '-' and n.operand.kind == 'Num':
            return [True, 0 - n.operand.value]
        return [False, 0]

    def stmt_for(self, n):
        it = n.iter
        if it.kind == 'Call' and it.func.kind == 'Name' and it.func.id == 'range' and not self.is_user_name('range') and len(it.keywords) == 0 and len(it.args) >= 1 and len(it.args) <= 3:
            step = 1
            ok = True
            if len(it.args) == 3:
                ci = self.const_int(it.args[2])
                ok = ci[0] and ci[1] != 0
                step = ci[1]
            if ok:
                self.for_range(n, step)
                return
        itv = self.callv('rt_iter_new', [self.expr(it)])
        slot = self.new_alloca()
        lhead = self.label('for')
        lbody = self.label('fbody')
        lend = self.label('fend')
        lelse = lend
        if len(n.orelse) > 0:
            lelse = self.label('felse')
        self.start_block(lhead)
        ok = self.callraw('rt_iter_next', 'i64 %s, ptr %s' % (itv, slot))
        c = self.tmp()
        self.emit('%s = icmp ne i64 %s, 0' % (c, ok))
        self.cbr(c, lbody, lelse)
        self.start_block(lbody)
        v = self.load_ptr(slot)
        self.assign_target(n.target, v)
        self.loops.append([lhead, lend, len(self.try_stack)])
        self.block(n.body)
        self.loops.pop()
        self.br(lhead)
        if len(n.orelse) > 0:
            self.start_block(lelse)
            self.block(n.orelse)
            self.br(lend)
        self.start_block(lend)

    def for_range(self, n, step):
        args = n.iter.args
        if len(args) == 1:
            start = '0'
            stop = self.callv('rt_toint', [self.expr(args[0])])
        else:
            start = self.callv('rt_toint', [self.expr(args[0])])
            stop = self.callv('rt_toint', [self.expr(args[1])])
        cnt = self.new_alloca()
        self.emit('store i64 %s, ptr %s' % (start, cnt))
        lhead = self.label('rfor')
        lbody = self.label('rbody')
        linc = self.label('rinc')
        lend = self.label('rend')
        lelse = lend
        if len(n.orelse) > 0:
            lelse = self.label('relse')
        self.start_block(lhead)
        c = self.load_ptr(cnt)
        cc = self.tmp()
        if step > 0:
            self.emit('%s = icmp slt i64 %s, %s' % (cc, c, stop))
        else:
            self.emit('%s = icmp sgt i64 %s, %s' % (cc, c, stop))
        self.cbr(cc, lbody, lelse)
        self.start_block(lbody)
        c2 = self.load_ptr(cnt)
        sh = self.tmp()
        self.emit('%s = shl i64 %s, 1' % (sh, c2))
        tg = self.tmp()
        self.emit('%s = or i64 %s, 1' % (tg, sh))
        self.assign_target(n.target, tg)
        self.loops.append([linc, lend, len(self.try_stack)])
        self.block(n.body)
        self.loops.pop()
        self.br(linc)
        self.start_block(linc)
        c3 = self.load_ptr(cnt)
        nx = self.tmp()
        self.emit('%s = add i64 %s, %d' % (nx, c3, step))
        self.emit('store i64 %s, ptr %s' % (nx, cnt))
        self.br(lhead)
        if len(n.orelse) > 0:
            self.start_block(lelse)
            self.block(n.orelse)
            self.br(lend)
        self.start_block(lend)

    def stmt_class(self, n):
        namev = self.load_str(n.name)
        if n.base is None:
            base = self.none()
        else:
            base = self.expr(n.base)
        cls = self.callv('rt_class_new', [namev, base])
        for s in n.body:
            if s.kind == 'FunctionDef':
                irname = self.queue_function(n.name + '_' + s.name, s.params, s.body)
                fv = self.make_func_value(irname, s.name, s.params, s.defaults)
                self.callv('rt_class_set', [cls, self.load_str(s.name), fv])
            elif s.kind == 'Assign' and len(s.targets) == 1 and s.targets[0].kind == 'Name':
                v = self.expr(s.value)
                self.callv('rt_class_set', [cls, self.load_str(s.targets[0].id), v])
            elif s.kind == 'Pass' or s.kind == 'Expr':
                pass
            else:
                fail('unsupported statement in class body', s.line)
        self.store_name(n.name, cls)

    def stmt_with(self, n):
        ctxs = []
        for it in n.items:
            c = self.expr(it[0])
            ctxs.append(c)
            if it[1] is not None:
                self.assign_target(it[1], c)
        self.block(n.body)
        i = len(ctxs) - 1
        while i >= 0:
            self.callv('rt_with_exit', [ctxs[i]])
            i -= 1

    def stmt_try(self, n):
        ltry = self.label('try')
        lexc = self.label('exc')
        lfin = self.label('fin')
        jb = self.tmp()
        self.emit('%s = call ptr @rt_try_push()' % jb)
        r = self.tmp()
        self.emit('%s = call i32 @_setjmp(ptr %s) returns_twice' % (r, jb))
        c = self.tmp()
        self.emit('%s = icmp eq i32 %s, 0' % (c, r))
        self.cbr(c, ltry, lexc)
        self.start_block(ltry)
        self.try_stack.append([n.finalbody, True])
        self.block(n.body)
        self.try_stack.pop()
        if not self.term:
            self.emit('call void @rt_try_pop()')
            if len(n.finalbody) > 0:
                self.try_stack.append([n.finalbody, False])
            self.block(n.orelse)
            if len(n.finalbody) > 0:
                self.try_stack.pop()
            self.br(lfin)
        self.start_block(lexc)
        exc = self.callraw('rt_exc_cur', '')
        for h in n.handlers:
            lnext = self.label('nexth')
            lbody = self.label('handler')
            if h.type is None:
                self.br(lbody)
            else:
                tv = self.expr(h.type)
                m = self.callv('rt_exc_match', [exc, tv])
                mc = self.tmp()
                self.emit('%s = icmp ne i64 %s, 0' % (mc, m))
                self.cbr(mc, lbody, lnext)
            self.start_block(lbody)
            if h.name is not None:
                self.store_name(h.name, exc)
            if len(n.finalbody) > 0:
                self.try_stack.append([n.finalbody, False])
            self.block(h.body)
            if len(n.finalbody) > 0:
                self.try_stack.pop()
            self.br(lfin)
            self.start_block(lnext)
        if len(n.finalbody) > 0:
            self.block(n.finalbody)
        self.callv('rt_raise', [exc])
        self.emit_term('unreachable')
        self.start_block(lfin)
        self.block(n.finalbody)

    # ---- assignment

    def assign_target(self, t, v):
        k = t.kind
        if k == 'Name':
            self.store_name(t.id, v)
        elif k == 'Attribute':
            o = self.expr(t.value)
            self.callv('rt_setattr', [o, self.load_str(t.attr), v])
        elif k == 'Subscript':
            if t.index.kind == 'Slice':
                fail('slice assignment is not supported', t.line)
            o = self.expr(t.value)
            key = self.expr(t.index)
            self.callv('rt_setitem', [o, key, v])
        elif k == 'Tuple' or k == 'List':
            cnt = len(t.elts)
            arr = self.new_array(cnt)
            self.callraw('rt_unpack', 'i64 %s, i64 %d, ptr %s' % (v, cnt, arr))
            i = 0
            for e in t.elts:
                p = self.tmp()
                self.emit('%s = getelementptr i64, ptr %s, i64 %d' % (p, arr, i))
                x = self.load_ptr(p)
                self.assign_target(e, x)
                i += 1
        else:
            fail('cannot assign to %s' % k, t.line)

    def stmt_augassign(self, n):
        t = n.target
        fn = BINOP_FN[n.op]
        if t.kind == 'Name':
            cur = self.expr(t)
            v = self.expr(n.value)
            r = self.callv(fn, [cur, v])
            self.store_name(t.id, r)
        elif t.kind == 'Attribute':
            o = self.expr(t.value)
            nm = self.load_str(t.attr)
            cur = self.callv('rt_getattr', [o, nm])
            v = self.expr(n.value)
            r = self.callv(fn, [cur, v])
            self.callv('rt_setattr', [o, nm, r])
        elif t.kind == 'Subscript':
            o = self.expr(t.value)
            key = self.expr(t.index)
            cur = self.callv('rt_getitem', [o, key])
            v = self.expr(n.value)
            r = self.callv(fn, [cur, v])
            self.callv('rt_setitem', [o, key, r])
        else:
            fail('bad augmented assignment target', n.line)

    # ---- conditions

    def truthy_i1(self, v):
        t = self.callv('rt_truthy', [v])
        c = self.tmp()
        self.emit('%s = icmp ne i64 %s, 0' % (c, t))
        return c

    def cond(self, n):
        if n.kind == 'Compare':
            return self.cond_compare(n)
        if n.kind == 'UnaryOp' and n.op == 'not':
            c = self.cond(n.operand)
            x = self.tmp()
            self.emit('%s = xor i1 %s, true' % (x, c))
            return x
        return self.truthy_i1(self.expr(n))

    def cond_compare(self, n):
        if len(n.ops) == 1:
            a = self.expr(n.left)
            b = self.expr(n.comps[0])
            r = self.callv('rt_cmp', [str(CMP_CODE[n.ops[0]]), a, b])
            c = self.tmp()
            self.emit('%s = icmp ne i64 %s, 0' % (c, r))
            return c
        res = self.new_alloca()
        self.emit('store i64 0, ptr %s' % res)
        lend = self.label('cmpend')
        a = self.expr(n.left)
        last = len(n.ops) - 1
        i = 0
        while i <= last:
            b = self.expr(n.comps[i])
            r = self.callv('rt_cmp', [str(CMP_CODE[n.ops[i]]), a, b])
            if i == last:
                self.emit('store i64 %s, ptr %s' % (r, res))
                self.br(lend)
            else:
                nz = self.tmp()
                self.emit('%s = icmp ne i64 %s, 0' % (nz, r))
                lnext = self.label('cmpnext')
                self.cbr(nz, lnext, lend)
                self.start_block(lnext)
            a = b
            i += 1
        self.start_block(lend)
        rv = self.load_ptr(res)
        c = self.tmp()
        self.emit('%s = icmp ne i64 %s, 0' % (c, rv))
        return c

    # ---- expressions

    def expr(self, n):
        k = n.kind
        if k == 'Num':
            return str(n.value * 2 + 1)
        if k == 'Name':
            return self.load_name(n.id, n.line)
        if k == 'Str':
            return self.load_str(n.value)
        if k == 'Float':
            return self.float_const(n.text)
        if k == 'NameConst':
            if n.v == 'True':
                return self.load_ptr('@rt_true_v')
            if n.v == 'False':
                return self.load_ptr('@rt_false_v')
            return self.none()
        if k == 'BinOp':
            a = self.expr(n.left)
            b = self.expr(n.right)
            return self.callv(BINOP_FN[n.op], [a, b])
        if k == 'UnaryOp':
            if n.op == 'not':
                c = self.cond(n.operand)
                x = self.tmp()
                self.emit('%s = xor i1 %s, true' % (x, c))
                return self.bool_obj(x)
            v = self.expr(n.operand)
            if n.op == '-':
                if n.operand.kind == 'Num':
                    return str((0 - n.operand.value) * 2 + 1)
                return self.callv('rt_neg', [v])
            if n.op == '~':
                return self.callv('rt_invert', [v])
            return v
        if k == 'BoolOp':
            return self.expr_boolop(n)
        if k == 'Compare':
            return self.bool_obj(self.cond_compare(n))
        if k == 'Call':
            return self.expr_call(n)
        if k == 'Attribute':
            o = self.expr(n.value)
            return self.callv('rt_getattr', [o, self.load_str(n.attr)])
        if k == 'Subscript':
            o = self.expr(n.value)
            if n.index.kind == 'Slice':
                sl = n.index
                lo = self.opt_expr(sl.lo)
                hi = self.opt_expr(sl.hi)
                st = self.opt_expr(sl.step)
                return self.callv('rt_slice', [o, lo, hi, st])
            key = self.expr(n.index)
            return self.callv('rt_getitem', [o, key])
        if k == 'List' or k == 'Tuple' or k == 'Set':
            vals = []
            for e in n.elts:
                vals.append(self.expr(e))
            arr = self.build_array(vals)
            fn = 'rt_list_new'
            if k == 'Tuple':
                fn = 'rt_tuple_new'
            elif k == 'Set':
                fn = 'rt_set_new'
            return self.callraw(fn, 'i64 %d, ptr %s' % (len(vals), arr))
        if k == 'Dict':
            vals = []
            i = 0
            while i < len(n.keys):
                vals.append(self.expr(n.keys[i]))
                vals.append(self.expr(n.values[i]))
                i += 1
            arr = self.build_array(vals)
            return self.callraw('rt_dict_new', 'i64 %d, ptr %s' % (len(n.keys), arr))
        if k == 'IfExp':
            res = self.new_alloca()
            c = self.cond(n.test)
            la = self.label('ifa')
            lb = self.label('ifb')
            lend = self.label('ifend')
            self.cbr(c, la, lb)
            self.start_block(la)
            va = self.expr(n.body)
            self.emit('store i64 %s, ptr %s' % (va, res))
            self.br(lend)
            self.start_block(lb)
            vb = self.expr(n.orelse)
            self.emit('store i64 %s, ptr %s' % (vb, res))
            self.br(lend)
            self.start_block(lend)
            return self.load_ptr(res)
        if k == 'Lambda':
            ret = Node('Return', n.line)
            ret.value = n.body
            irname = self.queue_function('lambda', n.params, [ret])
            return self.make_func_value(irname, '<lambda>', n.params, n.defaults)
        if k == 'ListComp':
            res = self.callraw('rt_empty_list', '')
            self.gen_comp(n.gens, 0, n.elt, res)
            return res
        if k == 'JoinedStr':
            return self.expr_fstring(n)
        fail('unsupported expression %s' % k, n.line)

    def opt_expr(self, n):
        if n is None:
            return self.none()
        return self.expr(n)

    def expr_boolop(self, n):
        res = self.new_alloca()
        lend = self.label('boolend')
        last = len(n.values) - 1
        i = 0
        while i <= last:
            v = self.expr(n.values[i])
            self.emit('store i64 %s, ptr %s' % (v, res))
            if i < last:
                c = self.truthy_i1(v)
                lnext = self.label('boolnext')
                if n.op == 'and':
                    self.cbr(c, lnext, lend)
                else:
                    self.cbr(c, lend, lnext)
                self.start_block(lnext)
            i += 1
        self.br(lend)
        self.start_block(lend)
        return self.load_ptr(res)

    def gen_comp(self, gens, idx, elt, res):
        if idx >= len(gens):
            v = self.expr(elt)
            self.callv('rt_list_append', [res, v])
            return
        g = gens[idx]
        it = self.callv('rt_iter_new', [self.expr(g.iter)])
        slot = self.new_alloca()
        lhead = self.label('chead')
        lbody = self.label('cbody')
        lend = self.label('cend')
        self.start_block(lhead)
        ok = self.callraw('rt_iter_next', 'i64 %s, ptr %s' % (it, slot))
        c = self.tmp()
        self.emit('%s = icmp ne i64 %s, 0' % (c, ok))
        self.cbr(c, lbody, lend)
        self.start_block(lbody)
        v = self.load_ptr(slot)
        self.assign_target(g.target, v)
        for f in g.ifs:
            fc = self.cond(f)
            lok = self.label('cok')
            self.cbr(fc, lok, lhead)
            self.start_block(lok)
        self.gen_comp(gens, idx + 1, elt, res)
        self.br(lhead)
        self.start_block(lend)

    def expr_fstring(self, n):
        parts = []
        for v in n.values:
            if v.kind == 'Str':
                parts.append(self.load_str(v.value))
            else:
                x = self.expr(v.value)
                if v.conv == 'r':
                    x = self.callv('rt_repr', [x])
                elif v.conv == 's':
                    x = self.callv('rt_str', [x])
                if v.spec != '':
                    x = self.callv('rt_format', [x, self.load_str(v.spec)])
                elif v.conv == '':
                    x = self.callv('rt_str', [x])
                parts.append(x)
        arr = self.build_array(parts)
        return self.callraw('rt_fstr', 'i64 %d, ptr %s' % (len(parts), arr))

    def eval_args(self, args):
        vals = []
        for a in args:
            vals.append(self.expr(a))
        return vals

    def expr_call(self, n):
        f = n.func
        if f.kind == 'Name' and not self.is_user_name(f.id):
            if f.id == 'print':
                return self.gen_print(n)
            if f.id in BUILTIN_FUNCS:
                if len(n.keywords) > 0:
                    fail('keyword arguments are not supported', n.line)
                vals = self.eval_args(n.args)
                arr = self.build_array(vals)
                return self.callraw('b_' + f.id, 'i64 %d, ptr %s' % (len(vals), arr))
        if len(n.keywords) > 0:
            fail('keyword arguments are not supported', n.line)
        if f.kind == 'Attribute':
            o = self.expr(f.value)
            nm = self.load_str(f.attr)
            vals = self.eval_args(n.args)
            arr = self.build_array(vals)
            return self.callraw('rt_callmeth', 'i64 %s, i64 %s, i64 %d, ptr %s' % (o, nm, len(vals), arr))
        fv = self.expr(f)
        vals = self.eval_args(n.args)
        arr = self.build_array(vals)
        return self.callraw('rt_call', 'i64 %s, i64 %d, ptr %s' % (fv, len(vals), arr))

    def gen_print(self, n):
        sep = None
        end = None
        fl = None
        for kw in n.keywords:
            if kw[0] == 'sep':
                sep = kw[1]
            elif kw[0] == 'end':
                end = kw[1]
            elif kw[0] == 'file':
                fl = kw[1]
            else:
                fail('unsupported print keyword %s' % kw[0], n.line)
        vals = self.eval_args(n.args)
        sv = self.opt_expr(sep)
        ev = self.opt_expr(end)
        fv = self.opt_expr(fl)
        arr = self.build_array(vals)
        return self.callraw('rt_print', 'i64 %d, ptr %s, i64 %s, i64 %s, i64 %s' % (len(vals), arr, sv, ev, fv))


# ---------------------------------------------------------------- driver

def read_file(path):
    f = open(path, 'rb')
    s = f.read()
    f.close()
    return s.decode('latin-1')


def write_file(path, text):
    f = open(path, 'wb')
    f.write(text.encode('latin-1'))
    f.close()


def compile_source(src):
    toks = tokenize(src)
    p = Parser(toks)
    body = p.parse_module()
    g = Gen()
    return g.compile_module(body)


def main():
    args = sys.argv
    if len(args) < 2:
        sys.stderr.write('usage: py2ll.py <script.py> [-o out.ll]\n')
        sys.exit(1)
    out = None
    if len(args) >= 4 and args[2] == '-o':
        out = args[3]
    text = compile_source(read_file(args[1]))
    if out is None:
        sys.stdout.write(text)
    else:
        write_file(out, text)


if __name__ == '__main__':
    main()
