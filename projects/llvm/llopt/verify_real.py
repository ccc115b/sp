import ctypes, random, llvmlite.binding as llvm
llvm.initialize_native_target(); llvm.initialize_native_asmprinter()
def jit(p):
    m = llvm.parse_assembly(open(p).read()); m.verify()
    tm = llvm.Target.from_default_triple().create_target_machine()
    e = llvm.create_mcjit_compiler(m, tm); e.finalize_object(); return e
funcs = {"gcd":2,"fib":1,"collatz":1,"poly":1,"arr":1,"sw":1,"mix":2}
random.seed(7)
for src in ("examples/real", "examples/real_named"):
    e1, e2 = jit(src + ".ll"), jit(src + ".opt.ll")
    for name, n in funcs.items():
        T = ctypes.CFUNCTYPE(ctypes.c_int32, *([ctypes.c_int32]*n))
        f1, f2 = T(e1.get_function_address(name)), T(e2.get_function_address(name))
        pool = [0,1,2,3,5,7,8,16,-1,-5,100,12345] + [random.randint(1,30) for _ in range(40)]
        if name == "fib": pool = list(range(0, 20))
        if name in ("mix",): pool = [0,1,7,8,15,16,17,1000,-3] + [random.randint(0, 2**31-1) for _ in range(30)]
        cnt = 0
        for a in pool:
            for b in (pool[:15] if n == 2 else [None]):
                args = [a] if n == 1 else [a, b]
                if name == "gcd" and b == 0 and a == 0: pass
                r1, r2 = f1(*args), f2(*args)
                assert r1 == r2, (src, name, args, r1, r2); cnt += 1
        print(f"  ✔ {src.split('/')[-1]}:{name} {cnt} 組一致")
print("REAL OK")
