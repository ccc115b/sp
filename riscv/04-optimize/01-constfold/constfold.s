	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.file	"constfold.c"
	.option	push
	.option	arch, +zcd, +zifencei
	.text
	.globl	expression                      # -- Begin function expression
	.p2align	1
	.type	expression,@function
expression:                             # @expression
# %bb.0:
	li	a0, 96
	ret
.Lfunc_end0:
	.size	expression, .Lfunc_end0-expression
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zcd, +zifencei
	.globl	loop_const                      # -- Begin function loop_const
	.p2align	1
	.type	loop_const,@function
loop_const:                             # @loop_const
# %bb.0:
	lui	a0, 1
	addi	a0, a0, 854
	ret
.Lfunc_end1:
	.size	loop_const, .Lfunc_end1-loop_const
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zcd, +zifencei
	.globl	_start                          # -- Begin function _start
	.p2align	1
	.type	_start,@function
_start:                                 # @_start
# %bb.0:
	addi	sp, sp, -32
	lui	a1, %hi(.L.str)
	addi	a1, a1, %lo(.L.str)
	li	a2, 15
	li	a7, 64
	li	a0, 1
	li	a5, 54
	addi	a3, sp, 30
	#APP
	ecall
	#NO_APP
	li	a6, 57
	lui	a4, %hi(.L.str.1)
	addi	a4, a4, %lo(.L.str.1)
	sb	a6, 30(sp)
	sb	a5, 31(sp)
	li	a2, 2
	li	a7, 64
	li	a0, 1
	mv	a1, a3
	#APP
	ecall
	#NO_APP
	li	a5, 48
	li	a2, 16
	li	a7, 64
	li	a0, 1
	mv	a1, a4
	#APP
	ecall
	#NO_APP
	li	a0, 53
	addi	a1, sp, 28
	li	a2, 52
	lui	a3, %hi(.L.str.2)
	addi	a3, a3, %lo(.L.str.2)
	sb	a2, 28(sp)
	sb	a6, 29(sp)
	sb	a0, 30(sp)
	sb	a5, 31(sp)
	li	a2, 4
	li	a7, 64
	li	a0, 1
	#APP
	ecall
	#NO_APP
	li	a2, 1
	li	a7, 64
	li	a0, 1
	mv	a1, a3
	#APP
	ecall
	#NO_APP
	li	a7, 93
	li	a0, 0
	#APP
	ecall
	#NO_APP
.Lfunc_end2:
	.size	_start, .Lfunc_end2-_start
                                        # -- End function
	.option	pop
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"expression() = "
	.size	.L.str, 16

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"\nloop_const() = "
	.size	.L.str.1, 17

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"\n"
	.size	.L.str.2, 2

	.ident	"Homebrew clang version 22.1.4"
	.section	".note.GNU-stack","",@progbits
