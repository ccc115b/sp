	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.file	"unroll.7c82aba3242b202e-cgu.0"
                                        # Start of file scope inline assembly
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


                                        # End of file scope inline assembly
	.option	push
	.option	arch, +zifencei
	.hidden	_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind # -- Begin function _RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind
	.globl	_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind
	.p2align	1
	.type	_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind,@function
_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind: # @_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind
# %bb.0:                                # %start
	addi	sp, sp, -16
	sd	ra, 8(sp)                       # 8-byte Folded Spill
.Lpcrel_hi1:
	auipc	a0, %pcrel_hi(.Lalloc_2e7e8fb95897d700cb0111de21c1fee5)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi1)
	li	a1, 7
	call	_RNvNtCsaGLuUiz9WQ4_6unroll2rt9sys_write
	li	a0, 134
	li	a7, 93
	#APP
	ecall
	#NO_APP
.LBB0_1:                                # %bb2
                                        # =>This Inner Loop Header: Depth=1
	j	.LBB0_1
.Lfunc_end0:
	.size	_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind, .Lfunc_end0-_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zifencei
	.p2align	1                               # -- Begin function _RNvNtCsaGLuUiz9WQ4_6unroll2rt5print
	.type	_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print,@function
_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print:   # @_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print
# %bb.0:                                # %start
	tail	_RNvNtCsaGLuUiz9WQ4_6unroll2rt9sys_write
.Lfunc_end1:
	.size	_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print, .Lfunc_end1-_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zifencei
	.p2align	1                               # -- Begin function _RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_i64
	.type	_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_i64,@function
_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_i64: # @_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_i64
# %bb.0:                                # %start
	bltz	a0, .LBB2_2
# %bb.1:                                # %bb6
	tail	_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_u64
.LBB2_2:                                # %bb1
	addi	sp, sp, -16
	sd	ra, 8(sp)                       # 8-byte Folded Spill
	sd	s0, 0(sp)                       # 8-byte Folded Spill
.Lpcrel_hi2:
	auipc	a2, %pcrel_hi(.Lalloc_3bb2650aa074fcfb8c10a9c40791bfbc)
	addi	a2, a2, %pcrel_lo(.Lpcrel_hi2)
	li	a1, 1
	mv	s0, a0
	mv	a0, a2
	call	_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print
	neg	a0, s0
	ld	ra, 8(sp)                       # 8-byte Folded Reload
	ld	s0, 0(sp)                       # 8-byte Folded Reload
	addi	sp, sp, 16
	tail	_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_u64
.Lfunc_end2:
	.size	_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_i64, .Lfunc_end2-_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_i64
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zifencei
	.p2align	1                               # -- Begin function _RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_u64
	.type	_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_u64,@function
_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_u64: # @_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_u64
# %bb.0:                                # %start
	beqz	a0, .LBB3_3
# %bb.1:                                # %bb3
	addi	sp, sp, -32
	sd	ra, 24(sp)                      # 8-byte Folded Spill
	sd	zero, 0(sp)
	sd	zero, 8(sp)
	sh	zero, 16(sp)
	sb	zero, 18(sp)
	lui	a1, 205
	addi	a1, a1, -819
	slli	a1, a1, 12
	addi	a1, a1, -819
	mul	a1, a0, a1
	srli	a1, a1, 35
	slli	a2, a1, 1
	slli	a3, a1, 3
	add	a2, a2, a3
	sub	a2, a0, a2
	ori	a2, a2, 48
	li	a3, 9
	sb	a2, 19(sp)
	bltu	a3, a0, .LBB3_4
# %bb.2:
	addi	a0, sp, 19
	li	a1, 1
	j	.LBB3_21
.LBB3_3:                                # %bb1
.Lpcrel_hi3:
	auipc	a0, %pcrel_hi(.Lalloc_dda1ee2b88b89b9cdac753eef7988035)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi3)
	li	a1, 1
	tail	_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print
.LBB3_4:                                # %bb5.1
	lui	a2, 104858
	addi	a2, a2, -1638
	mul	a3, a1, a2
	srli	a3, a3, 32
	slli	a4, a3, 1
	slli	a3, a3, 3
	add	a3, a3, a4
	sub	a1, a1, a3
	ori	a1, a1, 48
	li	a3, 100
	sb	a1, 18(sp)
	bgeu	a0, a3, .LBB3_6
# %bb.5:
	addi	a0, sp, 18
	li	a1, 2
	j	.LBB3_21
.LBB3_6:                                # %bb5.2
	lui	a1, 335544
	addi	a1, a1, 1311
	mul	a1, a0, a1
	srli	a1, a1, 37
	mul	a2, a1, a2
	srli	a2, a2, 32
	slli	a3, a2, 1
	slli	a2, a2, 3
	add	a2, a2, a3
	sub	a1, a1, a2
	ori	a1, a1, 48
	li	a2, 1000
	sb	a1, 17(sp)
	bgeu	a0, a2, .LBB3_8
# %bb.7:
	addi	a0, sp, 17
	li	a1, 3
	j	.LBB3_21
.LBB3_8:                                # %bb5.3
	lui	a1, 67109
	lui	a2, 104858
	addi	a3, a1, -557
	addi	a1, a2, -1638
	mul	a2, a0, a3
	srli	a2, a2, 38
	mul	a3, a2, a1
	srli	a3, a3, 32
	slli	a4, a3, 1
	slli	a3, a3, 3
	add	a3, a3, a4
	srli	a4, a0, 4
	sub	a2, a2, a3
	ori	a2, a2, 48
	li	a3, 625
	sb	a2, 16(sp)
	bgeu	a4, a3, .LBB3_10
# %bb.9:
	addi	a0, sp, 16
	li	a1, 4
	j	.LBB3_21
.LBB3_10:                               # %bb5.4
	lui	a2, 210
	addi	a2, a2, -1167
	slli	a2, a2, 12
	addi	a2, a2, 1881
	mul	a2, a0, a2
	srli	a2, a2, 45
	mul	a1, a2, a1
	srli	a1, a1, 32
	slli	a3, a1, 1
	slli	a1, a1, 3
	add	a1, a1, a3
	lui	a3, 24
	sub	a2, a2, a1
	ori	a1, a2, 48
	addi	a2, a3, 1696
	sb	a1, 15(sp)
	bgeu	a0, a2, .LBB3_12
# %bb.11:
	addi	a0, sp, 15
	li	a1, 5
	j	.LBB3_21
.LBB3_12:                               # %bb5.5
	srliw	a1, a0, 5
	lui	a2, 42950
	lui	a3, 13
	addi	a2, a2, -1339
	addi	a3, a3, -819
	mul	a1, a1, a2
	srli	a1, a1, 39
	mul	a2, a1, a3
	srli	a2, a2, 19
	slli	a3, a2, 1
	slli	a2, a2, 3
	add	a2, a2, a3
	lui	a3, 244
	sub	a1, a1, a2
	ori	a1, a1, 48
	addi	a2, a3, 576
	sb	a1, 14(sp)
	bgeu	a0, a2, .LBB3_14
# %bb.13:
	addi	a0, sp, 14
	li	a1, 6
	j	.LBB3_21
.LBB3_14:                               # %bb5.6
	lui	a1, 274878
	lui	a2, 2
	addi	a1, a1, -381
	addi	a2, a2, -1638
	mul	a1, a0, a1
	srli	a1, a1, 50
	mul	a2, a1, a2
	srli	a2, a2, 16
	slli	a3, a2, 1
	slli	a2, a2, 3
	add	a2, a2, a3
	lui	a3, 2441
	sub	a1, a1, a2
	ori	a1, a1, 48
	addi	a2, a3, 1664
	sb	a1, 13(sp)
	bgeu	a0, a2, .LBB3_16
# %bb.15:
	addi	a0, sp, 13
	li	a1, 7
	j	.LBB3_21
.LBB3_16:                               # %bb5.7
	lui	a1, 439805
	li	a2, 205
	addi	a1, a1, -1429
	mul	a1, a0, a1
	srli	a1, a1, 54
	mul	a2, a1, a2
	srli	a3, a2, 10
	srli	a2, a2, 11
	andi	a3, a3, 62
	slli	a2, a2, 3
	add	a2, a2, a3
	lui	a3, 24414
	sub	a1, a1, a2
	ori	a1, a1, 48
	addi	a2, a3, 256
	sb	a1, 12(sp)
	bgeu	a0, a2, .LBB3_18
# %bb.17:
	addi	a0, sp, 12
	li	a1, 8
	j	.LBB3_21
.LBB3_18:                               # %bb5.8
	lui	a1, 351844
	li	a2, 26
	addi	a1, a1, -1143
	mul	a1, a0, a1
	srli	a1, a1, 57
	mul	a2, a1, a2
	srli	a2, a2, 8
	slli	a3, a2, 1
	slli	a2, a2, 3
	add	a2, a2, a3
	lui	a3, 244141
	sub	a1, a1, a2
	ori	a1, a1, 48
	addi	a2, a3, -1536
	sb	a1, 11(sp)
	bgeu	a0, a2, .LBB3_20
# %bb.19:
	addi	a0, sp, 11
	li	a1, 9
	j	.LBB3_21
.LBB3_20:                               # %bb5.9
	addi	a1, sp, 10
	srliw	a2, a0, 9
	mv	a0, a1
	lui	a1, 69
	addi	a1, a1, -1149
	mul	a1, a2, a1
	srli	a1, a1, 39
	addi	a1, a1, 48
	sb	a1, 10(sp)
	li	a1, 10
.LBB3_21:                               # %bb11
	call	_RNvNtCsaGLuUiz9WQ4_6unroll2rt9sys_write
	ld	ra, 24(sp)                      # 8-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end3:
	.size	_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_u64, .Lfunc_end3-_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_u64
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zifencei
	.p2align	1                               # -- Begin function _RNvNtCsaGLuUiz9WQ4_6unroll2rt9sys_write
	.type	_RNvNtCsaGLuUiz9WQ4_6unroll2rt9sys_write,@function
_RNvNtCsaGLuUiz9WQ4_6unroll2rt9sys_write: # @_RNvNtCsaGLuUiz9WQ4_6unroll2rt9sys_write
# %bb.0:                                # %start
	mv	a2, a1
	mv	a1, a0
	li	a0, 1
	li	a7, 64
	#APP
	ecall
	#NO_APP
	ret
.Lfunc_end4:
	.size	_RNvNtCsaGLuUiz9WQ4_6unroll2rt9sys_write, .Lfunc_end4-_RNvNtCsaGLuUiz9WQ4_6unroll2rt9sys_write
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zifencei
	.globl	main                            # -- Begin function main
	.p2align	1
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %start
	addi	sp, sp, -48
	sd	ra, 40(sp)                      # 8-byte Folded Spill
	li	a6, 1
	li	a1, 2
	li	a2, 3
	li	a3, 4
	li	a4, 5
	li	a5, 6
	li	a0, 7
	sw	a6, 8(sp)
	sw	a1, 12(sp)
	sw	a2, 16(sp)
	sw	a3, 20(sp)
	li	a1, 8
	sw	a4, 24(sp)
	sw	a5, 28(sp)
	sw	a0, 32(sp)
	sw	a1, 36(sp)
.Lpcrel_hi4:
	auipc	a0, %pcrel_hi(.Lalloc_29d78056cfe802458b95f77e2827b831)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi4)
	li	a1, 18
	call	_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print
	li	a0, 10
	call	sum_squares
	sext.w	a0, a0
	call	_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_i64
.Lpcrel_hi5:
	auipc	a0, %pcrel_hi(.Lalloc_6dee07d88b55a8eb1972920b03a2e53b)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi5)
	li	a1, 15
	call	_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print
	addi	a0, sp, 8
	li	a1, 8
	call	scale_array
	sext.w	a0, a0
	call	_RNvNtCsaGLuUiz9WQ4_6unroll2rt9print_i64
.Lpcrel_hi6:
	auipc	a0, %pcrel_hi(.Lalloc_49a1e817e911805af64bbc7efb390101)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi6)
	li	a1, 1
	call	_RNvNtCsaGLuUiz9WQ4_6unroll2rt5print
	li	a0, 0
	ld	ra, 40(sp)                      # 8-byte Folded Reload
	addi	sp, sp, 48
	ret
.Lfunc_end5:
	.size	main, .Lfunc_end5-main
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zifencei
	.globl	scale_array                     # -- Begin function scale_array
	.p2align	1
	.type	scale_array,@function
scale_array:                            # @scale_array
# %bb.0:                                # %start
	beqz	a1, .LBB6_4
# %bb.1:                                # %bb3.preheader
	mv	a2, a0
	li	a0, 0
	slli	a1, a1, 2
.LBB6_2:                                # %bb3
                                        # =>This Inner Loop Header: Depth=1
	lw	a3, 0(a2)
	addi	a2, a2, 4
	slli	a3, a3, 2
	addi	a1, a1, -4
	addw	a0, a0, a3
	bnez	a1, .LBB6_2
# %bb.3:                                # %bb2
	ret
.LBB6_4:
	li	a0, 0
	ret
.Lfunc_end6:
	.size	scale_array, .Lfunc_end6-scale_array
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zifencei
	.globl	sum_squares                     # -- Begin function sum_squares
	.p2align	1
	.type	sum_squares,@function
sum_squares:                            # @sum_squares
# %bb.0:                                # %start
	blez	a0, .LBB7_5
# %bb.1:                                # %bb2.i.preheader
	mv	a1, a0
	li	a0, 0
	li	a2, 1
.LBB7_2:                                # %bb2.i
                                        # =>This Inner Loop Header: Depth=1
	mul	a3, a2, a2
	addw	a0, a0, a3
	bge	a2, a1, .LBB7_4
# %bb.3:                                # %bb2.i
                                        #   in Loop: Header=BB7_2 Depth=1
	slt	a3, a2, a1
	addw	a2, a2, a3
	bge	a1, a2, .LBB7_2
.LBB7_4:                                # %bb4
	ret
.LBB7_5:
	li	a0, 0
	ret
.Lfunc_end7:
	.size	sum_squares, .Lfunc_end7-sum_squares
                                        # -- End function
	.option	pop
	.type	.Lalloc_2e7e8fb95897d700cb0111de21c1fee5,@object # @alloc_2e7e8fb95897d700cb0111de21c1fee5
	.section	.rodata,"a",@progbits
.Lalloc_2e7e8fb95897d700cb0111de21c1fee5:
	.ascii	"panic!\n"
	.size	.Lalloc_2e7e8fb95897d700cb0111de21c1fee5, 7

	.type	.Lalloc_3bb2650aa074fcfb8c10a9c40791bfbc,@object # @alloc_3bb2650aa074fcfb8c10a9c40791bfbc
.Lalloc_3bb2650aa074fcfb8c10a9c40791bfbc:
	.byte	45
	.size	.Lalloc_3bb2650aa074fcfb8c10a9c40791bfbc, 1

	.type	.Lalloc_dda1ee2b88b89b9cdac753eef7988035,@object # @alloc_dda1ee2b88b89b9cdac753eef7988035
.Lalloc_dda1ee2b88b89b9cdac753eef7988035:
	.byte	48
	.size	.Lalloc_dda1ee2b88b89b9cdac753eef7988035, 1

	.type	.Lalloc_29d78056cfe802458b95f77e2827b831,@object # @alloc_29d78056cfe802458b95f77e2827b831
.Lalloc_29d78056cfe802458b95f77e2827b831:
	.ascii	"sum_squares(10) = "
	.size	.Lalloc_29d78056cfe802458b95f77e2827b831, 18

	.type	.Lalloc_6dee07d88b55a8eb1972920b03a2e53b,@object # @alloc_6dee07d88b55a8eb1972920b03a2e53b
.Lalloc_6dee07d88b55a8eb1972920b03a2e53b:
	.ascii	"\nscale_array = "
	.size	.Lalloc_6dee07d88b55a8eb1972920b03a2e53b, 15

	.type	.Lalloc_49a1e817e911805af64bbc7efb390101,@object # @alloc_49a1e817e911805af64bbc7efb390101
.Lalloc_49a1e817e911805af64bbc7efb390101:
	.byte	10
	.size	.Lalloc_49a1e817e911805af64bbc7efb390101, 1

	.ident	"rustc version 1.98.0-nightly (23a3312d9 2026-05-23)"
	.section	".note.GNU-stack","",@progbits
