	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.file	"hello.12bf9e1e413be47-cgu.0"

	.section	.text._start,"ax",@progbits
	.p2align	2
	.globl	_start
	.type	_start,@function
_start:
.Lpcrel_hi0:
	auipc	gp, %pcrel_hi(__global_pointer$)
	addi	gp, gp, %pcrel_lo(.Lpcrel_hi0)
	call	main
	li	a7, 93
	ecall
.Lfunc_end__start:
.Ltmp0:
	.size	_start, .Ltmp0-_start
	.text



	.section	.text._RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind,"ax",@progbits
	.hidden	_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind
	.globl	_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind
	.p2align	1
	.type	_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind,@function
_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind:
	addi	sp, sp, -16
	sd	ra, 8(sp)
.Lpcrel_hi1:
	auipc	a0, %pcrel_hi(.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.0)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi1)
	li	a1, 7
	call	_RNvNtCs6eIr1kDM7H_5hello2rt5print
	call	_RNvNtCs6eIr1kDM7H_5hello2rt8sys_exit
.Lfunc_end0:
	.size	_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind, .Lfunc_end0-_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind

	.section	.text._RNvNtCs6eIr1kDM7H_5hello2rt5print,"ax",@progbits
	.p2align	1
	.type	_RNvNtCs6eIr1kDM7H_5hello2rt5print,@function
_RNvNtCs6eIr1kDM7H_5hello2rt5print:
	tail	_RNvNtCs6eIr1kDM7H_5hello2rt9sys_write
.Lfunc_end1:
	.size	_RNvNtCs6eIr1kDM7H_5hello2rt5print, .Lfunc_end1-_RNvNtCs6eIr1kDM7H_5hello2rt5print

	.section	.text._RNvNtCs6eIr1kDM7H_5hello2rt8sys_exit,"ax",@progbits
	.p2align	1
	.type	_RNvNtCs6eIr1kDM7H_5hello2rt8sys_exit,@function
_RNvNtCs6eIr1kDM7H_5hello2rt8sys_exit:
	li	a0, 134
	li	a7, 93
	#APP
	ecall
	#NO_APP
.LBB2_1:
	j	.LBB2_1
.Lfunc_end2:
	.size	_RNvNtCs6eIr1kDM7H_5hello2rt8sys_exit, .Lfunc_end2-_RNvNtCs6eIr1kDM7H_5hello2rt8sys_exit

	.section	.text._RNvNtCs6eIr1kDM7H_5hello2rt9sys_write,"ax",@progbits
	.p2align	1
	.type	_RNvNtCs6eIr1kDM7H_5hello2rt9sys_write,@function
_RNvNtCs6eIr1kDM7H_5hello2rt9sys_write:
	mv	a2, a1
	mv	a1, a0
	li	a0, 1
	li	a7, 64
	#APP
	ecall
	#NO_APP
	ret
.Lfunc_end3:
	.size	_RNvNtCs6eIr1kDM7H_5hello2rt9sys_write, .Lfunc_end3-_RNvNtCs6eIr1kDM7H_5hello2rt9sys_write

	.section	.text.main,"ax",@progbits
	.globl	main
	.p2align	1
	.type	main,@function
main:
	addi	sp, sp, -16
	sd	ra, 8(sp)
.Lpcrel_hi2:
	auipc	a0, %pcrel_hi(.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.1)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi2)
	li	a1, 15
	call	_RNvNtCs6eIr1kDM7H_5hello2rt5print
	li	a0, 0
	ld	ra, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.type	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.0,@object
	.section	.rodata..Lanon.b79dca80f22cdd0372bbba4bb0e46d64.0,"a",@progbits
.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.0:
	.ascii	"panic!\n"
	.size	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.0, 7

	.type	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.1,@object
	.section	.rodata..Lanon.b79dca80f22cdd0372bbba4bb0e46d64.1,"a",@progbits
.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.1:
	.ascii	"Hello, RISC-V!\n"
	.size	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.1, 15

	.ident	"rustc version 1.98.0-nightly (23a3312d9 2026-05-23)"
	.section	".note.GNU-stack","",@progbits
