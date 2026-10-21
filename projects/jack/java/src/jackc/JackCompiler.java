package jackc;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;
import java.util.stream.*;

/**
 * Jack (nand2tetris) -> JVM bytecode 編譯器。
 *
 * 流程: 原始碼 --lex--> Token --parse--> AST --codegen--> .class (version 50, 無 StackMapTable)
 *
 * 語意對應:
 *   int / char / boolean  -> JVM int   (true = -1, false = 0,所以 ~ 與 & | 同時適用於位元與邏輯運算)
 *   Array                 -> int[]
 *   String                -> jack.JString
 *   其他 class 名稱        -> 同名 JVM class (default package)
 *   field / static        -> public 實例欄位 / public static 欄位
 *   method / function     -> public 實例方法 / public static 方法
 *   constructor Foo bar() -> public static Foo $bar()  (內部 new 一個物件放進 this)
 *   function main() 另外產生 public static void main(String[]) 橋接方法
 */
public class JackCompiler {

    // =====================================================================
    //  Errors
    // =====================================================================
    public static class CompileError extends RuntimeException {
        CompileError(String file, int line, String msg) {
            super(file + ":" + line + ": error: " + msg);
        }
    }

    // =====================================================================
    //  Lexer
    // =====================================================================
    enum TT { KEYWORD, SYMBOL, INT, STRING, IDENT, EOF }

    record Token(TT type, String text, int line) {}

    static final Set<String> KEYWORDS = Set.of(
        "class", "constructor", "function", "method", "field", "static", "var",
        "int", "char", "boolean", "void", "true", "false", "null", "this",
        "let", "do", "if", "else", "while", "return");
    static final String SYMBOLS = "{}()[].,;+-*/&|<>=~";

    static List<Token> lex(String file, String s) {
        List<Token> out = new ArrayList<>();
        int i = 0, line = 1, n = s.length();
        while (i < n) {
            char c = s.charAt(i);
            if (c == '\n') { line++; i++; }
            else if (Character.isWhitespace(c)) i++;
            else if (s.startsWith("//", i)) { while (i < n && s.charAt(i) != '\n') i++; }
            else if (s.startsWith("/*", i)) {
                int end = s.indexOf("*/", i + 2);
                if (end < 0) throw new CompileError(file, line, "unterminated comment");
                for (int k = i; k < end; k++) if (s.charAt(k) == '\n') line++;
                i = end + 2;
            } else if (c == '"') {
                int end = s.indexOf('"', i + 1);
                if (end < 0 || s.substring(i + 1, end).indexOf('\n') >= 0)
                    throw new CompileError(file, line, "unterminated string constant");
                out.add(new Token(TT.STRING, s.substring(i + 1, end), line));
                i = end + 1;
            } else if (Character.isDigit(c)) {
                int j = i;
                while (j < n && Character.isDigit(s.charAt(j))) j++;
                out.add(new Token(TT.INT, s.substring(i, j), line));
                i = j;
            } else if (Character.isLetter(c) || c == '_') {
                int j = i;
                while (j < n && (Character.isLetterOrDigit(s.charAt(j)) || s.charAt(j) == '_')) j++;
                String w = s.substring(i, j);
                out.add(new Token(KEYWORDS.contains(w) ? TT.KEYWORD : TT.IDENT, w, line));
                i = j;
            } else if (SYMBOLS.indexOf(c) >= 0) {
                out.add(new Token(TT.SYMBOL, String.valueOf(c), line));
                i++;
            } else {
                throw new CompileError(file, line, "illegal character '" + c + "'");
            }
        }
        out.add(new Token(TT.EOF, "<eof>", line));
        return out;
    }

    // =====================================================================
    //  AST
    // =====================================================================
    static class VarDecl {
        final String name, type;
        VarDecl(String name, String type) { this.name = name; this.type = type; }
    }

    static class SubDecl {
        String kind;            // constructor | function | method
        String retType, name;
        int line;
        List<VarDecl> params = new ArrayList<>();
        List<VarDecl> locals = new ArrayList<>();
        List<Stmt> body = new ArrayList<>();
        String jvmName() { return kind.equals("constructor") ? "$" + name : name; }
    }

    static class ClassDecl {
        String name, file, jvmName;
        boolean builtin;
        List<VarDecl> statics = new ArrayList<>(), fields = new ArrayList<>();
        List<SubDecl> subs = new ArrayList<>();
    }

    interface Stmt {}
    record Let(String name, Expr index, Expr value, int line) implements Stmt {}
    record If(Expr cond, List<Stmt> then, List<Stmt> els, int line) implements Stmt {}
    record While(Expr cond, List<Stmt> body, int line) implements Stmt {}
    record Do(CallE call, int line) implements Stmt {}
    record Return(Expr value, int line) implements Stmt {}

    interface Expr {}
    record IntC(int v) implements Expr {}
    record StrC(String s) implements Expr {}
    record KwC(String k) implements Expr {}
    record VarE(String name, int line) implements Expr {}
    record IndexE(String name, Expr index, int line) implements Expr {}
    record CallE(String target, String name, List<Expr> args, int line) implements Expr {}
    record Bin(Expr l, String op, Expr r) implements Expr {}
    record Un(String op, Expr e) implements Expr {}

    // =====================================================================
    //  Parser
    // =====================================================================
    static class Parser {
        final String file;
        final List<Token> t;
        int p = 0;

        Parser(String file, List<Token> t) { this.file = file; this.t = t; }

        Token peek() { return t.get(p); }
        boolean isSym(String s) { Token k = peek(); return k.type() == TT.SYMBOL && k.text().equals(s); }
        boolean isKw(String s) { Token k = peek(); return k.type() == TT.KEYWORD && k.text().equals(s); }
        boolean acceptSym(String s) { if (isSym(s)) { p++; return true; } return false; }
        void expectSym(String s) { if (!acceptSym(s)) throw err("expected '" + s + "'"); }
        void expectKw(String s) { if (!isKw(s)) throw err("expected '" + s + "'"); p++; }
        String ident() {
            Token k = peek();
            if (k.type() != TT.IDENT) throw err("expected identifier");
            p++;
            return k.text();
        }
        CompileError err(String m) {
            Token k = peek();
            return new CompileError(file, k.line(), m + " but found '" + k.text() + "'");
        }

        List<ClassDecl> parseFile() {
            List<ClassDecl> list = new ArrayList<>();
            while (peek().type() != TT.EOF) list.add(parseClass());
            return list;
        }

        String parseType(boolean allowVoid) {
            Token k = peek();
            if (k.type() == TT.KEYWORD && (k.text().equals("int") || k.text().equals("char")
                    || k.text().equals("boolean") || (allowVoid && k.text().equals("void")))) {
                p++;
                return k.text();
            }
            if (k.type() == TT.IDENT) { p++; return k.text(); }
            throw err("expected type");
        }

        ClassDecl parseClass() {
            ClassDecl c = new ClassDecl();
            c.file = file;
            expectKw("class");
            c.name = ident();
            expectSym("{");
            while (isKw("static") || isKw("field")) {
                boolean st = peek().text().equals("static");
                p++;
                String ty = parseType(false);
                do {
                    VarDecl v = new VarDecl(ident(), ty);
                    (st ? c.statics : c.fields).add(v);
                } while (acceptSym(","));
                expectSym(";");
            }
            while (isKw("constructor") || isKw("function") || isKw("method")) c.subs.add(parseSub());
            expectSym("}");
            return c;
        }

        SubDecl parseSub() {
            SubDecl s = new SubDecl();
            s.line = peek().line();
            s.kind = t.get(p++).text();
            s.retType = parseType(true);
            s.name = ident();
            expectSym("(");
            if (!isSym(")")) {
                do {
                    String ty = parseType(false);
                    s.params.add(new VarDecl(ident(), ty));
                } while (acceptSym(","));
            }
            expectSym(")");
            expectSym("{");
            while (isKw("var")) {
                p++;
                String ty = parseType(false);
                do { s.locals.add(new VarDecl(ident(), ty)); } while (acceptSym(","));
                expectSym(";");
            }
            s.body = parseStatements();
            expectSym("}");
            return s;
        }

        List<Stmt> parseStatements() {
            List<Stmt> list = new ArrayList<>();
            while (isKw("let") || isKw("if") || isKw("while") || isKw("do") || isKw("return"))
                list.add(parseStatement());
            return list;
        }

        List<Stmt> parseBlock() {
            expectSym("{");
            List<Stmt> b = parseStatements();
            expectSym("}");
            return b;
        }

        Stmt parseStatement() {
            int ln = peek().line();
            if (isKw("let")) {
                p++;
                String name = ident();
                Expr idx = null;
                if (acceptSym("[")) { idx = parseExpr(); expectSym("]"); }
                expectSym("=");
                Expr v = parseExpr();
                expectSym(";");
                return new Let(name, idx, v, ln);
            }
            if (isKw("if")) {
                p++;
                expectSym("(");
                Expr c = parseExpr();
                expectSym(")");
                List<Stmt> then = parseBlock();
                List<Stmt> els = null;
                if (isKw("else")) { p++; els = parseBlock(); }
                return new If(c, then, els, ln);
            }
            if (isKw("while")) {
                p++;
                expectSym("(");
                Expr c = parseExpr();
                expectSym(")");
                return new While(c, parseBlock(), ln);
            }
            if (isKw("do")) {
                p++;
                String a = ident();
                CallE call = parseCallRest(a, ln);
                expectSym(";");
                return new Do(call, ln);
            }
            if (isKw("return")) {
                p++;
                Expr v = isSym(";") ? null : parseExpr();
                expectSym(";");
                return new Return(v, ln);
            }
            throw err("expected statement");
        }

        /** 已經讀過第一個識別字 first;接下來是 `.name(args)` 或 `(args)`。 */
        CallE parseCallRest(String first, int ln) {
            String target = null, name = first;
            if (acceptSym(".")) { target = first; name = ident(); }
            expectSym("(");
            List<Expr> args = new ArrayList<>();
            if (!isSym(")")) {
                do { args.add(parseExpr()); } while (acceptSym(","));
            }
            expectSym(")");
            return new CallE(target, name, args, ln);
        }

        boolean isOp() {
            Token k = peek();
            return k.type() == TT.SYMBOL && "+-*/&|<>=".contains(k.text());
        }

        /** Jack 沒有運算子優先順序,一律由左至右。 */
        Expr parseExpr() {
            Expr l = parseTerm();
            while (isOp()) {
                String op = t.get(p++).text();
                l = new Bin(l, op, parseTerm());
            }
            return l;
        }

        Expr parseTerm() {
            Token k = peek();
            int ln = k.line();
            switch (k.type()) {
                case INT -> {
                    p++;
                    long v = Long.parseLong(k.text());
                    if (v > Integer.MAX_VALUE) throw new CompileError(file, ln, "integer constant too large");
                    return new IntC((int) v);
                }
                case STRING -> { p++; return new StrC(k.text()); }
                case KEYWORD -> {
                    if (k.text().equals("true") || k.text().equals("false")
                            || k.text().equals("null") || k.text().equals("this")) {
                        p++;
                        return new KwC(k.text());
                    }
                    throw err("expected expression");
                }
                case IDENT -> {
                    p++;
                    if (isSym("[")) {
                        p++;
                        Expr idx = parseExpr();
                        expectSym("]");
                        return new IndexE(k.text(), idx, ln);
                    }
                    if (isSym("(") || isSym(".")) return parseCallRest(k.text(), ln);
                    return new VarE(k.text(), ln);
                }
                case SYMBOL -> {
                    if (k.text().equals("(")) {
                        p++;
                        Expr e = parseExpr();
                        expectSym(")");
                        return e;
                    }
                    if (k.text().equals("-") || k.text().equals("~")) {
                        p++;
                        return new Un(k.text(), parseTerm());
                    }
                    throw err("expected expression");
                }
                default -> throw err("expected expression");
            }
        }
    }

    // =====================================================================
    //  Class file writer
    // =====================================================================
    static class ConstPool {
        final ByteArrayOutputStream bos = new ByteArrayOutputStream();
        final DataOutputStream out = new DataOutputStream(bos);
        final Map<String, Integer> map = new HashMap<>();
        int count = 1;

        private void w(int tag, int... vals) {
            try {
                out.writeByte(tag);
                for (int v : vals) out.writeShort(v);
            } catch (IOException e) { throw new UncheckedIOException(e); }
        }
        private int done(String key) { map.put(key, count); return count++; }

        int utf8(String s) {
            Integer k = map.get("U" + s);
            if (k != null) return k;
            try { out.writeByte(1); out.writeUTF(s); } catch (IOException e) { throw new UncheckedIOException(e); }
            return done("U" + s);
        }
        int cls(String n) {
            Integer k = map.get("C" + n);
            if (k != null) return k;
            w(7, utf8(n));
            return done("C" + n);
        }
        int string(String s) {
            Integer k = map.get("S" + s);
            if (k != null) return k;
            w(8, utf8(s));
            return done("S" + s);
        }
        int integer(int v) {
            Integer k = map.get("I" + v);
            if (k != null) return k;
            try { out.writeByte(3); out.writeInt(v); } catch (IOException e) { throw new UncheckedIOException(e); }
            return done("I" + v);
        }
        int nameType(String n, String d) {
            String key = "N" + n + ":" + d;
            Integer k = map.get(key);
            if (k != null) return k;
            w(12, utf8(n), utf8(d));
            return done(key);
        }
        int ref(int tag, String owner, String n, String d) {
            String key = "R" + tag + owner + "." + n + ":" + d;
            Integer k = map.get(key);
            if (k != null) return k;
            w(tag, cls(owner), nameType(n, d));
            return done(key);
        }
        int field(String o, String n, String d) { return ref(9, o, n, d); }
        int method(String o, String n, String d) { return ref(10, o, n, d); }
    }

    static class ClassFile {
        final ConstPool cp = new ConstPool();
        final int thisIdx, superIdx, codeAttrIdx;
        final List<byte[]> fields = new ArrayList<>(), methods = new ArrayList<>();

        ClassFile(String name) {
            thisIdx = cp.cls(name);
            superIdx = cp.cls("java/lang/Object");
            codeAttrIdx = cp.utf8("Code");
        }

        void addField(int acc, String name, String desc) {
            ByteArrayOutputStream b = new ByteArrayOutputStream();
            DataOutputStream d = new DataOutputStream(b);
            try {
                d.writeShort(acc); d.writeShort(cp.utf8(name)); d.writeShort(cp.utf8(desc)); d.writeShort(0);
            } catch (IOException e) { throw new UncheckedIOException(e); }
            fields.add(b.toByteArray());
        }

        void addMethod(int acc, String name, String desc, Code code) {
            ByteArrayOutputStream b = new ByteArrayOutputStream();
            DataOutputStream d = new DataOutputStream(b);
            try {
                d.writeShort(acc); d.writeShort(cp.utf8(name)); d.writeShort(cp.utf8(desc));
                d.writeShort(1);                                  // attributes_count
                d.writeShort(codeAttrIdx);
                d.writeInt(2 + 2 + 4 + code.n + 2 + 2);           // attribute_length
                d.writeShort(code.max); d.writeShort(code.maxLocals);
                d.writeInt(code.n); d.write(code.a, 0, code.n);
                d.writeShort(0);                                  // exception_table_length
                d.writeShort(0);                                  // attributes_count
            } catch (IOException e) { throw new UncheckedIOException(e); }
            methods.add(b.toByteArray());
        }

        byte[] toBytes() {
            ByteArrayOutputStream b = new ByteArrayOutputStream();
            DataOutputStream d = new DataOutputStream(b);
            try {
                d.writeInt(0xCAFEBABE);
                d.writeShort(0);
                d.writeShort(50);          // Java 6: 不需要 StackMapTable
                d.writeShort(cp.count);
                d.write(cp.bos.toByteArray());
                d.writeShort(0x0021);      // ACC_PUBLIC | ACC_SUPER
                d.writeShort(thisIdx);
                d.writeShort(superIdx);
                d.writeShort(0);           // interfaces
                d.writeShort(fields.size());
                for (byte[] f : fields) d.write(f);
                d.writeShort(methods.size());
                for (byte[] m : methods) d.write(m);
                d.writeShort(0);           // class attributes
            } catch (IOException e) { throw new UncheckedIOException(e); }
            return b.toByteArray();
        }
    }

    // JVM opcodes
    static final int ACONST_NULL = 1, ILOAD = 21, ALOAD = 25, ISTORE = 54, ASTORE = 58,
        IALOAD = 46, IASTORE = 79, POP = 87, DUP = 89,
        IADD = 96, ISUB = 100, IMUL = 104, IDIV = 108, INEG = 116, IAND = 126, IOR = 128, IXOR = 130,
        IFEQ = 153, IF_ICMPEQ = 159, IF_ICMPLT = 161, IF_ICMPGT = 163, IF_ACMPEQ = 165, GOTO = 167,
        IRETURN = 172, ARETURN = 176, RETURN = 177,
        GETSTATIC = 178, PUTSTATIC = 179, GETFIELD = 180, PUTFIELD = 181,
        INVOKEVIRTUAL = 182, INVOKESPECIAL = 183, INVOKESTATIC = 184, NEW = 187, NEWARRAY = 188;

    /** 位元組碼緩衝區,同時追蹤運算堆疊深度以計算 max_stack。 */
    static class Code {
        static class Label {
            int pos = -1, depth = -1;
            final List<int[]> fix = new ArrayList<>();
        }

        final ConstPool cp;
        byte[] a = new byte[256];
        int n, cur, max, maxLocals;

        Code(ConstPool cp) { this.cp = cp; }

        void u1(int b) { if (n == a.length) a = Arrays.copyOf(a, n * 2); a[n++] = (byte) b; }
        void u2(int v) { u1(v >> 8); u1(v); }
        void adj(int d) { cur += d; if (cur > max) max = cur; }
        void op(int o, int d) { u1(o); adj(d); }

        void pushInt(int v) {
            if (v >= -1 && v <= 5) op(3 + v, 1);
            else if (v >= -128 && v <= 127) { u1(16); u1(v); adj(1); }
            else if (v >= -32768 && v <= 32767) { u1(17); u2(v); adj(1); }
            else {
                int idx = cp.integer(v);
                if (idx < 256) { u1(18); u1(idx); } else { u1(19); u2(idx); }
                adj(1);
            }
        }

        void pushString(String s) {
            int idx = cp.string(s);
            if (idx < 256) { u1(18); u1(idx); } else { u1(19); u2(idx); }
            adj(1);
        }

        void local(int op, int slot, int delta) {
            if (slot < 256) { u1(op); u1(slot); } else { u1(196); u1(op); u2(slot); }
            adj(delta);
        }

        void invoke(int op, String owner, String name, String desc) {
            u1(op);
            u2(cp.method(owner, name, desc));
            int args = 0, i = 1;
            while (desc.charAt(i) != ')') {
                while (desc.charAt(i) == '[') i++;
                if (desc.charAt(i) == 'L') i = desc.indexOf(';', i);
                i++;
                args++;
            }
            adj((desc.endsWith(")V") ? 0 : 1) - args - (op == INVOKESTATIC ? 0 : 1));
        }

        void field(int op, String owner, String name, String desc) {
            u1(op);
            u2(cp.field(owner, name, desc));
            adj(switch (op) { case GETSTATIC -> 1; case PUTSTATIC -> -1; case GETFIELD -> 0; default -> -2; });
        }

        void newObj(String cls) { u1(NEW); u2(cp.cls(cls)); adj(1); }

        void jump(int op, int pops, Label l) {
            int at = n;
            u1(op);
            if (l.pos >= 0) u2(l.pos - at);
            else { l.fix.add(new int[]{at, n}); u2(0); }
            adj(-pops);
            if (l.depth < 0) l.depth = cur;
        }

        void place(Label l) {
            l.pos = n;
            if (l.depth >= 0) cur = l.depth; else l.depth = cur;
            for (int[] f : l.fix) {
                int off = n - f[0];
                if (off > 32767) throw new IllegalStateException("method too large");
                a[f[1]] = (byte) (off >> 8);
                a[f[1] + 1] = (byte) off;
            }
            l.fix.clear();
        }
    }

    // =====================================================================
    //  Code generator
    // =====================================================================
    static class Var {
        final String name, kind, type, desc;   // kind: local | field | static
        final int slot;
        Var(String name, String kind, String type, String desc, int slot) {
            this.name = name; this.kind = kind; this.type = type; this.desc = desc; this.slot = slot;
        }
    }

    static class Gen {
        final Map<String, ClassDecl> classes;
        ClassDecl cls;
        ClassFile cf;
        Code code;
        SubDecl sub;
        Map<String, Var> vars = new HashMap<>(), classVars = new HashMap<>();
        int thisSlot, line;

        Gen(Map<String, ClassDecl> classes) { this.classes = classes; }

        CompileError err(String msg) { return new CompileError(cls.file, line, msg); }

        // ---------- types ----------
        String desc(String t) {
            switch (t) {
                case "int": case "char": case "boolean": return "I";
                case "void": return "V";
                case "Array": return "[I";
                case "Object": return "Ljava/lang/Object;";
                default:
                    ClassDecl c = classes.get(t);
                    if (c == null) throw err("unknown type '" + t + "'");
                    return "L" + c.jvmName + ";";
            }
        }

        static boolean isRef(String d) { return !d.equals("I") && !d.equals("V"); }

        static String show(String d) {
            if (d.equals("I")) return "int";
            if (d.equals("N")) return "null";
            if (d.equals("V")) return "void";
            if (d.equals("[I")) return "Array";
            if (d.equals("Ljack/JString;")) return "String";
            return d.substring(1, d.length() - 1).replace("jack/", "");
        }

        String subDesc(SubDecl s) {
            StringBuilder sb = new StringBuilder("(");
            for (VarDecl p : s.params) sb.append(desc(p.type));
            return sb.append(')').append(desc(s.retType)).toString();
        }

        SubDecl findSub(ClassDecl c, String name) {
            for (SubDecl s : c.subs) if (s.name.equals(name)) return s;
            return null;
        }

        // ---------- class ----------
        byte[] genClass(ClassDecl c) {
            cls = c;
            line = 1;
            cf = new ClassFile(c.jvmName);
            classVars.clear();
            for (VarDecl v : c.statics) {
                if (classVars.containsKey(v.name)) throw err("duplicate field '" + v.name + "'");
                String d = desc(v.type);
                classVars.put(v.name, new Var(v.name, "static", v.type, d, -1));
                cf.addField(0x0009, v.name, d);
            }
            for (VarDecl v : c.fields) {
                if (classVars.containsKey(v.name)) throw err("duplicate field '" + v.name + "'");
                String d = desc(v.type);
                classVars.put(v.name, new Var(v.name, "field", v.type, d, -1));
                cf.addField(0x0001, v.name, d);
            }
            Set<String> seen = new HashSet<>();
            for (SubDecl s : c.subs) {
                if (!seen.add(s.name)) { line = s.line; throw err("duplicate subroutine '" + s.name + "'"); }
            }

            // 預設建構子
            Code init = new Code(cf.cp);
            init.local(ALOAD, 0, 1);
            init.invoke(INVOKESPECIAL, "java/lang/Object", "<init>", "()V");
            init.op(RETURN, 0);
            init.maxLocals = 1;
            cf.addMethod(0x0001, "<init>", "()V", init);

            for (SubDecl s : c.subs) genSub(s);
            return cf.toBytes();
        }

        void genSub(SubDecl s) {
            sub = s;
            line = s.line;
            code = new Code(cf.cp);
            vars.clear();
            boolean isMethod = s.kind.equals("method"), isCtor = s.kind.equals("constructor");
            int slot = 0;
            if (isMethod) { thisSlot = 0; slot = 1; }
            for (VarDecl p : s.params) slot = declare(p, slot);
            if (isCtor) thisSlot = slot++;
            for (VarDecl v : s.locals) slot = declare(v, slot);
            code.maxLocals = slot;

            String selfDesc = "L" + cls.jvmName + ";";
            String retDesc = desc(s.retType);
            if (isCtor && !retDesc.equals(selfDesc))
                throw err("constructor must return " + cls.name);

            if (isCtor) {
                code.newObj(cls.jvmName);
                code.op(DUP, 1);
                code.invoke(INVOKESPECIAL, cls.jvmName, "<init>", "()V");
                code.local(ASTORE, thisSlot, -1);
            }
            for (VarDecl v : s.locals) {
                Var var = vars.get(v.name);
                pushDefault(var.desc);
                storeLocal(var);
            }

            genStatements(s.body);

            // 保險用的結尾 return(讓控制流不會掉出方法尾端)
            line = s.line;
            if (isCtor) { code.local(ALOAD, thisSlot, 1); code.op(ARETURN, -1); }
            else if (retDesc.equals("V")) code.op(RETURN, 0);
            else if (retDesc.equals("I")) { code.pushInt(0); code.op(IRETURN, -1); }
            else { code.op(ACONST_NULL, 1); code.op(ARETURN, -1); }

            int acc = isMethod ? 0x0001 : 0x0009;
            String d = subDesc(s);
            cf.addMethod(acc, s.jvmName(), d, code);

            // function main() -> public static void main(String[])
            if (s.kind.equals("function") && s.name.equals("main") && s.params.isEmpty()) {
                Code br = new Code(cf.cp);
                br.invoke(INVOKESTATIC, cls.jvmName, "main", d);
                if (!retDesc.equals("V")) br.op(POP, -1);
                br.op(RETURN, 0);
                br.maxLocals = 1;
                cf.addMethod(0x0009, "main", "([Ljava/lang/String;)V", br);
            }
        }

        int declare(VarDecl v, int slot) {
            if (vars.containsKey(v.name)) throw err("duplicate variable '" + v.name + "'");
            vars.put(v.name, new Var(v.name, "local", v.type, desc(v.type), slot));
            return slot + 1;
        }

        // ---------- helpers ----------
        Var lookup(String name) {
            Var v = vars.get(name);
            return v != null ? v : classVars.get(name);
        }

        boolean isStatic() { return sub.kind.equals("function"); }

        void loadThis() {
            if (isStatic()) throw err("'this' / field access is not allowed inside a function");
            code.local(ALOAD, thisSlot, 1);
        }

        void loadVar(Var v) {
            switch (v.kind) {
                case "local" -> code.local(v.desc.equals("I") ? ILOAD : ALOAD, v.slot, 1);
                case "field" -> { loadThis(); code.field(GETFIELD, cls.jvmName, v.name, v.desc); }
                default -> code.field(GETSTATIC, cls.jvmName, v.name, v.desc);
            }
        }

        void storeLocal(Var v) { code.local(v.desc.equals("I") ? ISTORE : ASTORE, v.slot, -1); }

        void pushDefault(String d) {
            if (d.equals("I")) code.pushInt(0); else code.op(ACONST_NULL, 1);
        }

        void coerce(String from, String to) {
            if (from.equals("V")) throw err("void subroutine used as a value");
            if (from.equals(to)) return;
            if (from.equals("N")) {
                if (to.equals("I")) { code.op(POP, -1); code.pushInt(0); }
                return;
            }
            if (to.equals("Ljava/lang/Object;") && isRef(from)) return;
            throw err("type mismatch: expected " + show(to) + " but got " + show(from));
        }

        /** 產生 e 並轉成型別 to;`0` 常數可以當作 null 使用。 */
        void genAs(Expr e, String to) {
            if (e instanceof IntC ic && ic.v() == 0 && isRef(to)) { code.op(ACONST_NULL, 1); return; }
            coerce(gen(e), to);
        }

        // ---------- statements ----------
        void genStatements(List<Stmt> list) { for (Stmt s : list) genStatement(s); }

        void genStatement(Stmt s) {
            if (s instanceof Let st) {
                line = st.line();
                Var v = lookup(st.name());
                if (v == null) throw err("undefined variable '" + st.name() + "'");
                if (st.index() != null) {
                    if (!v.desc.equals("[I")) throw err("'" + v.name + "' is not an Array");
                    loadVar(v);
                    genAs(st.index(), "I");
                    genAs(st.value(), "I");
                    code.op(IASTORE, -3);
                } else if (v.kind.equals("local")) {
                    genAs(st.value(), v.desc);
                    storeLocal(v);
                } else if (v.kind.equals("field")) {
                    loadThis();
                    genAs(st.value(), v.desc);
                    code.field(PUTFIELD, cls.jvmName, v.name, v.desc);
                } else {
                    genAs(st.value(), v.desc);
                    code.field(PUTSTATIC, cls.jvmName, v.name, v.desc);
                }
            } else if (s instanceof If st) {
                line = st.line();
                Code.Label els = new Code.Label(), end = new Code.Label();
                genAs(st.cond(), "I");
                code.jump(IFEQ, 1, els);
                genStatements(st.then());
                if (st.els() != null) {
                    code.jump(GOTO, 0, end);
                    code.place(els);
                    genStatements(st.els());
                    code.place(end);
                } else {
                    code.place(els);
                }
            } else if (s instanceof While st) {
                line = st.line();
                Code.Label top = new Code.Label(), end = new Code.Label();
                code.place(top);
                genAs(st.cond(), "I");
                code.jump(IFEQ, 1, end);
                genStatements(st.body());
                code.jump(GOTO, 0, top);
                code.place(end);
            } else if (s instanceof Do st) {
                line = st.line();
                String r = genCall(st.call());
                if (!r.equals("V")) code.op(POP, -1);
            } else if (s instanceof Return st) {
                line = st.line();
                String rd = desc(sub.retType);
                if (rd.equals("V")) {
                    if (st.value() != null) throw err("void subroutine cannot return a value");
                    code.op(RETURN, 0);
                } else {
                    if (st.value() == null) throw err("non-void subroutine must return a value");
                    genAs(st.value(), rd);
                    code.op(rd.equals("I") ? IRETURN : ARETURN, -1);
                }
            }
        }

        // ---------- expressions ----------
        /** 產生運算式,回傳其 descriptor ("I", "[I", "LFoo;", 或 null 常數的 "N")。 */
        String gen(Expr e) {
            if (e instanceof IntC x) { code.pushInt(x.v()); return "I"; }
            if (e instanceof StrC x) {
                code.newObj("jack/JString");
                code.op(DUP, 1);
                code.pushString(x.s());
                code.invoke(INVOKESPECIAL, "jack/JString", "<init>", "(Ljava/lang/String;)V");
                return "Ljack/JString;";
            }
            if (e instanceof KwC x) {
                switch (x.k()) {
                    case "true" -> { code.pushInt(-1); return "I"; }
                    case "false" -> { code.pushInt(0); return "I"; }
                    case "null" -> { code.op(ACONST_NULL, 1); return "N"; }
                    default -> { loadThis(); return "L" + cls.jvmName + ";"; }
                }
            }
            if (e instanceof VarE x) {
                line = x.line();
                Var v = lookup(x.name());
                if (v == null) throw err("undefined variable '" + x.name() + "'");
                loadVar(v);
                return v.desc;
            }
            if (e instanceof IndexE x) {
                line = x.line();
                Var v = lookup(x.name());
                if (v == null) throw err("undefined variable '" + x.name() + "'");
                if (!v.desc.equals("[I")) throw err("'" + v.name + "' is not an Array");
                loadVar(v);
                genAs(x.index(), "I");
                code.op(IALOAD, -1);
                return "I";
            }
            if (e instanceof CallE x) return genCall(x);
            if (e instanceof Bin x) return genBin(x);
            if (e instanceof Un x) {
                genAs(x.e(), "I");
                if (x.op().equals("-")) code.op(INEG, 0);
                else { code.pushInt(-1); code.op(IXOR, -1); }
                return "I";
            }
            throw new IllegalStateException("unknown expr " + e);
        }

        String genBin(Bin b) {
            String l = gen(b.l());
            String r;
            if (b.op().equals("=") && isRef(l) && b.r() instanceof IntC ic && ic.v() == 0) {
                code.op(ACONST_NULL, 1);
                r = "N";
            } else r = gen(b.r());

            switch (b.op()) {
                case "+" -> arith(IADD, l, r);
                case "-" -> arith(ISUB, l, r);
                case "*" -> arith(IMUL, l, r);
                case "/" -> arith(IDIV, l, r);
                case "&" -> arith(IAND, l, r);
                case "|" -> arith(IOR, l, r);
                case "<" -> { intsOnly(l, r); compare(IF_ICMPLT); }
                case ">" -> { intsOnly(l, r); compare(IF_ICMPGT); }
                default -> {   // "="
                    boolean li = l.equals("I"), ri = r.equals("I");
                    if (li && ri) compare(IF_ICMPEQ);
                    else if (li || ri) throw err("cannot compare " + show(l) + " with " + show(r));
                    else compare(IF_ACMPEQ);
                }
            }
            return "I";
        }

        void intsOnly(String l, String r) {
            if (l.equals("V") || r.equals("V")) throw err("void subroutine used as a value");
            if (!l.equals("I") || !r.equals("I"))
                throw err("operator needs int operands, got " + show(l) + " and " + show(r));
        }

        void arith(int op, String l, String r) { intsOnly(l, r); code.op(op, -1); }

        /** 比較後在堆疊上放 -1(true) 或 0(false)。 */
        void compare(int ifop) {
            Code.Label t = new Code.Label(), end = new Code.Label();
            code.jump(ifop, 2, t);
            code.pushInt(0);
            code.jump(GOTO, 0, end);
            code.place(t);
            code.pushInt(-1);
            code.place(end);
        }

        void genArgs(SubDecl s, CallE c) {
            if (s.params.size() != c.args().size())
                throw err("'" + s.name + "' expects " + s.params.size() + " argument(s) but got " + c.args().size());
            for (int i = 0; i < s.params.size(); i++) genAs(c.args().get(i), desc(s.params.get(i).type));
        }

        String genCall(CallE c) {
            line = c.line();
            if (c.target() == null) {                       // foo(...)  -> 目前類別的 method
                SubDecl s = findSub(cls, c.name());
                if (s == null) throw err("undefined subroutine '" + c.name() + "' in class " + cls.name);
                if (s.kind.equals("method")) {
                    loadThis();
                    genArgs(s, c);
                    code.invoke(INVOKEVIRTUAL, cls.jvmName, s.jvmName(), subDesc(s));
                } else {
                    genArgs(s, c);
                    code.invoke(INVOKESTATIC, cls.jvmName, s.jvmName(), subDesc(s));
                }
                return desc(s.retType);
            }

            Var v = lookup(c.target());
            if (v != null) {                                // obj.method(...)
                ClassDecl oc = classes.get(v.type);
                if (oc == null) throw err("cannot call a method on '" + v.name + "' of type " + v.type);
                SubDecl s = findSub(oc, c.name());
                if (s == null) throw err("class " + oc.name + " has no subroutine '" + c.name() + "'");
                if (!s.kind.equals("method")) throw err("'" + oc.name + "." + s.name + "' is not a method");
                loadVar(v);
                if (oc.name.equals("Array")) {              // Array.dispose(): int[] 由 GC 管理
                    code.op(POP, -1);
                    return "V";
                }
                genArgs(s, c);
                code.invoke(INVOKEVIRTUAL, oc.jvmName, s.jvmName(), subDesc(s));
                return desc(s.retType);
            }

            ClassDecl oc = classes.get(c.target());         // Class.function(...) / Class.new(...)
            if (oc == null) throw err("undefined variable or class '" + c.target() + "'");
            SubDecl s = findSub(oc, c.name());
            if (s == null) throw err("class " + oc.name + " has no subroutine '" + c.name() + "'");
            if (s.kind.equals("method")) throw err("'" + oc.name + "." + s.name + "' is a method; call it on an object");
            if (oc.name.equals("Array") && s.name.equals("new")) {
                genArgs(s, c);
                code.u1(NEWARRAY); code.u1(10);             // T_INT
                return "[I";
            }
            genArgs(s, c);
            code.invoke(INVOKESTATIC, oc.jvmName, s.jvmName(), subDesc(s));
            return desc(s.retType);
        }
    }

    // =====================================================================
    //  Jack OS 的宣告(只有簽章,實作在 jack.* 套件)
    // =====================================================================
    static final String BUILTINS = """
        class Math { function int multiply(int x, int y) {} function int divide(int x, int y) {}
                     function int min(int a, int b) {} function int max(int a, int b) {}
                     function int abs(int x) {} function int sqrt(int x) {} }
        class String { constructor String new(int maxLength) {}
                       method void dispose() {} method int length() {} method char charAt(int j) {}
                       method void setCharAt(int j, char c) {} method String appendChar(char c) {}
                       method void eraseLastChar() {} method int intValue() {} method void setInt(int j) {}
                       function char backSpace() {} function char doubleQuote() {} function char newLine() {} }
        class Output { function void printString(String s) {} function void printInt(int i) {}
                       function void println() {} function void printChar(char c) {}
                       function void backSpace() {} }
        class Sys { function void halt() {} function void error(int errorCode) {} function void wait(int duration) {} }
        class Memory { function Array alloc(int size) {} function void deAlloc(Object o) {} }
        class Array { constructor Array new(int size) {} method void dispose() {} }
        """;

    // =====================================================================
    //  Public API
    // =====================================================================

    /** @param sources 檔名 -> Jack 原始碼。@return 類別名稱 -> class 檔位元組。 */
    public static Map<String, byte[]> compile(Map<String, String> sources) {
        Map<String, ClassDecl> classes = new LinkedHashMap<>();
        for (ClassDecl c : new Parser("<builtin>", lex("<builtin>", BUILTINS)).parseFile()) {
            c.builtin = true;
            c.jvmName = "jack/" + (c.name.equals("String") ? "JString" : c.name);
            classes.put(c.name, c);
        }
        List<ClassDecl> user = new ArrayList<>();
        for (var e : sources.entrySet()) {
            for (ClassDecl c : new Parser(e.getKey(), lex(e.getKey(), e.getValue())).parseFile()) {
                if (classes.containsKey(c.name))
                    throw new CompileError(e.getKey(), 1, "class '" + c.name + "' is already defined");
                c.jvmName = c.name;
                classes.put(c.name, c);
                user.add(c);
            }
        }
        Gen gen = new Gen(classes);
        Map<String, byte[]> out = new LinkedHashMap<>();
        for (ClassDecl c : user) out.put(c.jvmName, gen.genClass(c));
        return out;
    }

    static class MemLoader extends ClassLoader {
        final Map<String, byte[]> m;
        MemLoader(Map<String, byte[]> m) { super(JackCompiler.class.getClassLoader()); this.m = m; }
        @Override protected Class<?> findClass(String n) throws ClassNotFoundException {
            byte[] b = m.get(n);
            if (b == null) throw new ClassNotFoundException(n);
            return defineClass(n, b, 0, b.length);
        }
    }

    static void usage() {
        System.err.println("""
            Usage: jackc [-d outDir] [--run] <file.jack | dir> ...

              -d outDir   把產生的 .class 寫到 outDir(之後可用 java -cp outDir:jackc.jar Main 執行)
              --run       編譯後直接在本程序中執行 Main.main()
            """);
        System.exit(2);
    }

    public static void main(String[] args) throws Exception {
        String outDir = null;
        boolean run = false;
        List<Path> inputs = new ArrayList<>();
        for (int i = 0; i < args.length; i++) {
            switch (args[i]) {
                case "-d" -> { if (++i >= args.length) usage(); outDir = args[i]; }
                case "--run" -> run = true;
                case "-h", "--help" -> usage();
                default -> inputs.add(Path.of(args[i]));
            }
        }
        if (inputs.isEmpty()) usage();

        List<Path> files = new ArrayList<>();
        for (Path p : inputs) {
            if (Files.isDirectory(p)) {
                try (Stream<Path> s = Files.list(p)) {
                    s.filter(f -> f.toString().endsWith(".jack")).sorted().forEach(files::add);
                }
            } else files.add(p);
        }
        if (files.isEmpty()) { System.err.println("no .jack files found"); System.exit(2); }

        Map<String, byte[]> classes;
        try {
            Map<String, String> src = new LinkedHashMap<>();
            for (Path f : files) src.put(f.getFileName().toString(), Files.readString(f, StandardCharsets.UTF_8));
            classes = compile(src);
        } catch (CompileError e) {
            System.err.println(e.getMessage());
            System.exit(1);
            return;
        }

        if (outDir != null) {
            Files.createDirectories(Path.of(outDir));
            for (var e : classes.entrySet()) Files.write(Path.of(outDir, e.getKey() + ".class"), e.getValue());
            System.err.println("wrote " + classes.size() + " class file(s) to " + outDir);
        }

        if (run) {
            if (!classes.containsKey("Main")) { System.err.println("error: no class Main"); System.exit(1); }
            try {
                Class<?> main = new MemLoader(classes).loadClass("Main");
                main.getMethod("main", String[].class).invoke(null, (Object) new String[0]);
            } catch (NoSuchMethodException e) {
                System.err.println("error: Main has no 'function void main()'");
                System.exit(1);
            } catch (java.lang.reflect.InvocationTargetException e) {
                throw e.getCause() instanceof Exception ex ? ex : e;
            }
        }
    }
}
