"""用 llvmlite 驗證：優化前後的 IR 都合法，且對大量輸入結果一致。"""
import sys, ctypes, random
import llvmlite.binding as llvm

llvm.initialize_native_target(); llvm.initialize_native_asmprinter()

def jit(path):
    mod = llvm.parse_assembly(open(path).read())
    mod.verify()
    tm = llvm.Target.from_default_triple().create_target_machine()
    ee = llvm.create_mcjit_compiler(mod, tm)
    ee.finalize_object()
    return ee, mod

def run(orig, opt, funcs):
    e1, m1 = jit(orig); e2, m2 = jit(opt)
    random.seed(1)
    for name, nargs in funcs:
        t = ctypes.CFUNCTYPE(ctypes.c_int32, *([ctypes.c_int32] * nargs))
        f1 = t(e1.get_function_address(name)); f2 = t(e2.get_function_address(name))
        vals = [0, 1, -1, 2, 3, 7, 100, -100, 2**31 - 1, -2**31] + [random.randint(-2**31, 2**31 - 1) for _ in range(300)]
        if name == "sumloop": vals = list(range(0, 60)) + [1000, 2000]
        n = 0
        for a in vals:
            for b in (vals[:20] if nargs == 2 else [None]):
                args = [a] if nargs == 1 else [a, b]
                r1, r2 = f1(*args), f2(*args)
                assert r1 == r2, f"{name}{tuple(args)}: orig={r1} opt={r2}"
                n += 1
        print(f"  ✔ {name}: {n} 組輸入結果一致")

for base, funcs in [("examples/demo", [("compute", 1), ("sumloop", 1)]),
                    ("examples/clang_o0", [("classify", 1), ("branchy", 2)])]:
    print(base)
    run(base + ".ll", base + ".opt.ll", funcs)
print("ALL OK")
