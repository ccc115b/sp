	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.file	"mem2reg.c7c195e19bc9d952-cgu.0"
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
	call	_RNvNtCsh9irHALyA0w_7mem2reg2rt9sys_write
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
	.p2align	1                               # -- Begin function _RNvNtCsh9irHALyA0w_7mem2reg2rt5print
	.type	_RNvNtCsh9irHALyA0w_7mem2reg2rt5print,@function
_RNvNtCsh9irHALyA0w_7mem2reg2rt5print:  # @_RNvNtCsh9irHALyA0w_7mem2reg2rt5print
# %bb.0:                                # %start
	tail	_RNvNtCsh9irHALyA0w_7mem2reg2rt9sys_write
.Lfunc_end1:
	.size	_RNvNtCsh9irHALyA0w_7mem2reg2rt5print, .Lfunc_end1-_RNvNtCsh9irHALyA0w_7mem2reg2rt5print
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zifencei
	.p2align	1                               # -- Begin function _RNvNtCsh9irHALyA0w_7mem2reg2rt9print_i64
	.type	_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_i64,@function
_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_i64: # @_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_i64
# %bb.0:                                # %start
	bltz	a0, .LBB2_2
# %bb.1:                                # %bb6
	tail	_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_u64
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
	call	_RNvNtCsh9irHALyA0w_7mem2reg2rt5print
	neg	a0, s0
	ld	ra, 8(sp)                       # 8-byte Folded Reload
	ld	s0, 0(sp)                       # 8-byte Folded Reload
	addi	sp, sp, 16
	tail	_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_u64
.Lfunc_end2:
	.size	_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_i64, .Lfunc_end2-_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_i64
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zifencei
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0                          # -- Begin function _RNvNtCsh9irHALyA0w_7mem2reg2rt9print_u64
.LCPI3_0:
	.quad	1844674407370955162             # 0x199999999999999a
.LCPI3_1:
	.quad	2951479051793528259             # 0x28f5c28f5c28f5c3
.LCPI3_2:
	.quad	2361183241434822607             # 0x20c49ba5e353f7cf
.LCPI3_3:
	.quad	3777893186295716171             # 0x346dc5d63886594b
.LCPI3_4:
	.quad	755578637259143235              # 0xa7c5ac471b47843
.LCPI3_5:
	.quad	4835703278458516699             # 0x431bde82d7b634db
.LCPI3_6:
	.quad	-2972493582642298179            # 0xd6bf94d5e57a42bd
.LCPI3_7:
	.quad	-6067343680855748867            # 0xabcc77118461cefd
.LCPI3_8:
	.quad	19342813113834067               # 0x44b82fa09b5a53
.LCPI3_9:
	.quad	-2601111570856684097            # 0xdbe6fecebdedd5bf
.LCPI3_10:
	.quad	-5770238071427257601            # 0xafebff0bcb24aaff
.LCPI3_11:
	.quad	2535301200456458803             # 0x232f33025bd42233
.LCPI3_12:
	.quad	4056481920730334085             # 0x384b84d092ed0385
.LCPI3_13:
	.quad	811296384146066817              # 0xb424dc35095cd81
.LCPI3_14:
	.quad	633825300114115                 # 0x24075f3dceac3
.LCPI3_15:
	.quad	4153837486827862103             # 0x39a5652fb1137857
.LCPI3_16:
	.quad	101412048018259                 # 0x5c3bd5191b53
.LCPI3_17:
	.quad	81129638414607                  # 0x49c97747490f
	.text
	.p2align	1
	.type	_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_u64,@function
_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_u64: # @_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_u64
# %bb.0:                                # %start
	beqz	a0, .LBB3_3
# %bb.1:                                # %bb3
	addi	sp, sp, -32
	sd	ra, 24(sp)                      # 8-byte Folded Spill
	lui	a1, 838861
	addi	a1, a1, -819
	slli	a2, a1, 32
	add	a1, a1, a2
	li	a3, 246
	mulhu	a2, a0, a1
	srli	a2, a2, 3
	mul	a1, a2, a3
	add	a1, a1, a0
	ori	a1, a1, 48
	sb	a1, 19(sp)
	li	a1, 9
	sd	zero, 0(sp)
	sd	zero, 8(sp)
	sh	zero, 16(sp)
	sb	zero, 18(sp)
	bltu	a1, a0, .LBB3_4
# %bb.2:
	addi	a0, sp, 19
	li	a1, 1
	j	.LBB3_39
.LBB3_3:                                # %bb1
.Lpcrel_hi3:
	auipc	a0, %pcrel_hi(.Lalloc_dda1ee2b88b89b9cdac753eef7988035)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi3)
	li	a1, 1
	tail	_RNvNtCsh9irHALyA0w_7mem2reg2rt5print
.LBB3_4:                                # %bb5.1
.Lpcrel_hi4:
	auipc	a1, %pcrel_hi(.LCPI3_0)
	ld	a1, %pcrel_lo(.Lpcrel_hi4)(a1)
	mulhu	a3, a2, a1
	slli	a4, a3, 1
	slli	a3, a3, 3
	add	a3, a3, a4
	sub	a2, a2, a3
	ori	a2, a2, 48
	li	a3, 100
	sb	a2, 18(sp)
	bgeu	a0, a3, .LBB3_6
# %bb.5:
	addi	a0, sp, 18
	li	a1, 2
	j	.LBB3_39
.LBB3_6:                                # %bb5.2
.Lpcrel_hi5:
	auipc	a2, %pcrel_hi(.LCPI3_1)
	ld	a2, %pcrel_lo(.Lpcrel_hi5)(a2)
	srli	a3, a0, 2
	mulhu	a2, a3, a2
	srli	a2, a2, 2
	mulhu	a3, a2, a1
	slli	a4, a3, 1
	slli	a3, a3, 3
	add	a3, a3, a4
	sub	a2, a2, a3
	ori	a2, a2, 48
	li	a3, 1000
	sb	a2, 17(sp)
	bgeu	a0, a3, .LBB3_8
# %bb.7:
	addi	a0, sp, 17
	li	a1, 3
	j	.LBB3_39
.LBB3_8:                                # %bb5.3
.Lpcrel_hi6:
	auipc	a2, %pcrel_hi(.LCPI3_2)
	ld	a2, %pcrel_lo(.Lpcrel_hi6)(a2)
	srli	a3, a0, 3
	mulhu	a2, a3, a2
	srli	a2, a2, 4
	mulhu	a3, a2, a1
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
	j	.LBB3_39
.LBB3_10:                               # %bb5.4
.Lpcrel_hi7:
	auipc	a2, %pcrel_hi(.LCPI3_3)
	ld	a2, %pcrel_lo(.Lpcrel_hi7)(a2)
	mulhu	a2, a0, a2
	srli	a2, a2, 11
	mulhu	a3, a2, a1
	slli	a4, a3, 1
	slli	a3, a3, 3
	add	a3, a3, a4
	lui	a4, 24
	sub	a2, a2, a3
	ori	a2, a2, 48
	addi	a3, a4, 1696
	sb	a2, 15(sp)
	bgeu	a0, a3, .LBB3_12
# %bb.11:
	addi	a0, sp, 15
	li	a1, 5
	j	.LBB3_39
.LBB3_12:                               # %bb5.5
.Lpcrel_hi8:
	auipc	a2, %pcrel_hi(.LCPI3_4)
	ld	a2, %pcrel_lo(.Lpcrel_hi8)(a2)
	srli	a3, a0, 5
	mulhu	a2, a3, a2
	srli	a2, a2, 7
	mulhu	a3, a2, a1
	slli	a4, a3, 1
	slli	a3, a3, 3
	add	a3, a3, a4
	lui	a4, 244
	sub	a2, a2, a3
	ori	a2, a2, 48
	addi	a3, a4, 576
	sb	a2, 14(sp)
	bgeu	a0, a3, .LBB3_14
# %bb.13:
	addi	a0, sp, 14
	li	a1, 6
	j	.LBB3_39
.LBB3_14:                               # %bb5.6
.Lpcrel_hi9:
	auipc	a2, %pcrel_hi(.LCPI3_5)
	ld	a2, %pcrel_lo(.Lpcrel_hi9)(a2)
	mulhu	a2, a0, a2
	srli	a2, a2, 18
	mulhu	a3, a2, a1
	slli	a4, a3, 1
	slli	a3, a3, 3
	add	a3, a3, a4
	lui	a4, 2441
	sub	a2, a2, a3
	ori	a2, a2, 48
	addi	a3, a4, 1664
	sb	a2, 13(sp)
	bgeu	a0, a3, .LBB3_16
# %bb.15:
	addi	a0, sp, 13
	li	a1, 7
	j	.LBB3_39
.LBB3_16:                               # %bb5.7
.Lpcrel_hi10:
	auipc	a2, %pcrel_hi(.LCPI3_6)
	ld	a2, %pcrel_lo(.Lpcrel_hi10)(a2)
	mulhu	a2, a0, a2
	srli	a2, a2, 23
	mulhu	a3, a2, a1
	slli	a4, a3, 1
	slli	a3, a3, 3
	add	a3, a3, a4
	lui	a4, 24414
	sub	a2, a2, a3
	ori	a2, a2, 48
	addi	a3, a4, 256
	sb	a2, 12(sp)
	bgeu	a0, a3, .LBB3_18
# %bb.17:
	addi	a0, sp, 12
	li	a1, 8
	j	.LBB3_39
.LBB3_18:                               # %bb5.8
.Lpcrel_hi11:
	auipc	a2, %pcrel_hi(.LCPI3_7)
	ld	a2, %pcrel_lo(.Lpcrel_hi11)(a2)
	mulhu	a2, a0, a2
	srli	a2, a2, 26
	mulhu	a3, a2, a1
	slli	a4, a3, 1
	slli	a3, a3, 3
	add	a3, a3, a4
	lui	a4, 244141
	sub	a2, a2, a3
	ori	a2, a2, 48
	addi	a3, a4, -1536
	sb	a2, 11(sp)
	bgeu	a0, a3, .LBB3_20
# %bb.19:
	addi	a0, sp, 11
	li	a1, 9
	j	.LBB3_39
.LBB3_20:                               # %bb5.9
.Lpcrel_hi12:
	auipc	a2, %pcrel_hi(.LCPI3_8)
	ld	a2, %pcrel_lo(.Lpcrel_hi12)(a2)
	srli	a3, a0, 9
	mulhu	a2, a3, a2
	srli	a2, a2, 11
	mulhu	a1, a2, a1
	slli	a3, a1, 1
	slli	a1, a1, 3
	add	a1, a1, a3
	lui	a3, 2384
	addi	a3, a3, 761
	sub	a2, a2, a1
	ori	a1, a2, 48
	slli	a3, a3, 10
	sb	a1, 10(sp)
	bgeu	a0, a3, .LBB3_22
# %bb.21:
	addi	a0, sp, 10
	li	a1, 10
	j	.LBB3_39
.LBB3_22:                               # %bb5.10
.Lpcrel_hi13:
	auipc	a1, %pcrel_hi(.LCPI3_9)
	ld	a1, %pcrel_lo(.Lpcrel_hi13)(a1)
	lui	a2, 419430
	addi	a2, a2, 1639
	mulhu	a1, a0, a1
	srli	a1, a1, 33
	mul	a2, a1, a2
	srli	a2, a2, 34
	slli	a3, a2, 1
	slli	a2, a2, 3
	add	a2, a2, a3
	lui	a3, 11921
	addi	a3, a3, -291
	sub	a1, a1, a2
	ori	a1, a1, 48
	slli	a3, a3, 11
	sb	a1, 9(sp)
	bgeu	a0, a3, .LBB3_24
# %bb.23:
	addi	a0, sp, 9
	li	a1, 11
	j	.LBB3_39
.LBB3_24:                               # %bb5.11
.Lpcrel_hi14:
	auipc	a1, %pcrel_hi(.LCPI3_10)
	ld	a2, %pcrel_lo(.Lpcrel_hi14)(a1)
	lui	a1, 104858
	addi	a1, a1, -1638
	mulhu	a2, a0, a2
	srli	a2, a2, 36
	mul	a3, a2, a1
	srli	a3, a3, 32
	slli	a4, a3, 1
	slli	a3, a3, 3
	add	a3, a3, a4
	lui	a4, 59605
	addi	a4, a4, -1455
	sub	a2, a2, a3
	ori	a2, a2, 48
	slli	a4, a4, 12
	sb	a2, 8(sp)
	bgeu	a0, a4, .LBB3_26
# %bb.25:
	addi	a0, sp, 8
	li	a1, 12
	j	.LBB3_39
.LBB3_26:                               # %bb5.12
.Lpcrel_hi15:
	auipc	a2, %pcrel_hi(.LCPI3_11)
	ld	a2, %pcrel_lo(.Lpcrel_hi15)(a2)
	mulhu	a2, a0, a2
	srli	a2, a2, 37
	mul	a1, a2, a1
	srli	a1, a1, 32
	slli	a3, a1, 1
	slli	a1, a1, 3
	add	a1, a1, a3
	lui	a3, 298023
	addi	a3, a3, 917
	sub	a2, a2, a1
	ori	a1, a2, 48
	slli	a3, a3, 13
	sb	a1, 7(sp)
	bgeu	a0, a3, .LBB3_28
# %bb.27:
	addi	a0, sp, 7
	li	a1, 13
	j	.LBB3_39
.LBB3_28:                               # %bb5.13
.Lpcrel_hi16:
	auipc	a1, %pcrel_hi(.LCPI3_12)
	ld	a2, %pcrel_lo(.Lpcrel_hi16)(a1)
	lui	a1, 104858
	addi	a1, a1, -1638
	mulhu	a2, a0, a2
	srli	a2, a2, 41
	mul	a3, a2, a1
	srli	a3, a3, 32
	slli	a4, a3, 1
	slli	a3, a3, 3
	add	a3, a3, a4
	lui	a4, 372529
	slli	a4, a4, 2
	addi	a4, a4, 489
	sub	a2, a2, a3
	ori	a2, a2, 48
	slli	a4, a4, 14
	sb	a2, 6(sp)
	bgeu	a0, a4, .LBB3_30
# %bb.29:
	addi	a0, sp, 6
	li	a1, 14
	j	.LBB3_39
.LBB3_30:                               # %bb5.14
.Lpcrel_hi17:
	auipc	a2, %pcrel_hi(.LCPI3_13)
	ld	a2, %pcrel_lo(.Lpcrel_hi17)(a2)
	mulhu	a2, a0, a2
	srli	a2, a2, 42
	mul	a1, a2, a1
	srli	a1, a1, 32
	slli	a3, a1, 1
	slli	a1, a1, 3
	add	a1, a1, a3
	lui	a3, 1819
	addi	a3, a3, -43
	slli	a3, a3, 12
	addi	a3, a3, -1651
	sub	a2, a2, a1
	ori	a1, a2, 48
	slli	a3, a3, 15
	sb	a1, 5(sp)
	bgeu	a0, a3, .LBB3_32
# %bb.31:
	addi	a0, sp, 5
	li	a1, 15
	j	.LBB3_39
.LBB3_32:                               # %bb5.15
.Lpcrel_hi18:
	auipc	a1, %pcrel_hi(.LCPI3_14)
	ld	a1, %pcrel_lo(.Lpcrel_hi18)(a1)
	srli	a2, a0, 15
	lui	a3, 6
	addi	a3, a3, 1639
	mulhu	a1, a2, a1
	srli	a1, a1, 20
	mul	a2, a1, a3
	srli	a2, a2, 18
	slli	a3, a2, 1
	slli	a2, a2, 3
	add	a2, a2, a3
	lui	a3, 9095
	addi	a3, a3, -217
	slli	a3, a3, 12
	addi	a3, a3, -63
	sub	a1, a1, a2
	ori	a1, a1, 48
	slli	a3, a3, 16
	sb	a1, 4(sp)
	bgeu	a0, a3, .LBB3_34
# %bb.33:
	addi	a0, sp, 4
	li	a1, 16
	j	.LBB3_39
.LBB3_34:                               # %bb5.16
.Lpcrel_hi19:
	auipc	a1, %pcrel_hi(.LCPI3_15)
	ld	a1, %pcrel_lo(.Lpcrel_hi19)(a1)
	lui	a2, 2
	addi	a2, a2, -1638
	mulhu	a1, a0, a1
	srli	a1, a1, 51
	mul	a2, a1, a2
	srli	a2, a2, 16
	slli	a3, a2, 1
	slli	a2, a2, 3
	add	a2, a2, a3
	lui	a3, 45475
	addi	a3, a3, -1085
	slli	a3, a3, 12
	addi	a3, a3, -315
	sub	a1, a1, a2
	ori	a1, a1, 48
	slli	a3, a3, 17
	sb	a1, 3(sp)
	bgeu	a0, a3, .LBB3_36
# %bb.35:
	addi	a0, sp, 3
	li	a1, 17
	j	.LBB3_39
.LBB3_36:                               # %bb5.17
.Lpcrel_hi20:
	auipc	a1, %pcrel_hi(.LCPI3_16)
	ld	a1, %pcrel_lo(.Lpcrel_hi20)(a1)
	srli	a2, a0, 17
	li	a3, 205
	mulhu	a1, a2, a1
	srli	a1, a1, 22
	mul	a2, a1, a3
	srli	a2, a2, 11
	slli	a3, a2, 1
	slli	a2, a2, 3
	add	a2, a2, a3
	lui	a3, 227374
	addi	a3, a3, -1329
	slli	a3, a3, 12
	addi	a3, a3, -1575
	sub	a1, a1, a2
	ori	a1, a1, 48
	slli	a3, a3, 18
	sb	a1, 2(sp)
	bgeu	a0, a3, .LBB3_38
# %bb.37:
	addi	a0, sp, 2
	li	a1, 18
	j	.LBB3_39
.LBB3_38:                               # %bb5.18
.Lpcrel_hi21:
	auipc	a1, %pcrel_hi(.LCPI3_17)
	ld	a1, %pcrel_lo(.Lpcrel_hi21)(a1)
	addi	a2, sp, 1
	srli	a3, a0, 18
	mv	a0, a2
	mulhu	a1, a3, a1
	srli	a1, a1, 24
	ori	a1, a1, 48
	sb	a1, 1(sp)
	li	a1, 19
.LBB3_39:                               # %bb11
	call	_RNvNtCsh9irHALyA0w_7mem2reg2rt9sys_write
	ld	ra, 24(sp)                      # 8-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end3:
	.size	_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_u64, .Lfunc_end3-_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_u64
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zifencei
	.p2align	1                               # -- Begin function _RNvNtCsh9irHALyA0w_7mem2reg2rt9sys_write
	.type	_RNvNtCsh9irHALyA0w_7mem2reg2rt9sys_write,@function
_RNvNtCsh9irHALyA0w_7mem2reg2rt9sys_write: # @_RNvNtCsh9irHALyA0w_7mem2reg2rt9sys_write
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
	.size	_RNvNtCsh9irHALyA0w_7mem2reg2rt9sys_write, .Lfunc_end4-_RNvNtCsh9irHALyA0w_7mem2reg2rt9sys_write
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zifencei
	.globl	fib                             # -- Begin function fib
	.p2align	1
	.type	fib,@function
fib:                                    # @fib
# %bb.0:                                # %start
	blez	a0, .LBB5_4
# %bb.1:                                # %bb2.preheader
	li	a3, 0
	li	a2, 1
.LBB5_2:                                # %bb2
                                        # =>This Inner Loop Header: Depth=1
	addw	a4, a2, a3
	addiw	a0, a0, -1
	mv	a1, a2
	mv	a3, a2
	mv	a2, a4
	bnez	a0, .LBB5_2
# %bb.3:                                # %bb3
	mv	a0, a1
	ret
.LBB5_4:
	li	a0, 0
	ret
.Lfunc_end5:
	.size	fib, .Lfunc_end5-fib
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +zifencei
	.globl	main                            # -- Begin function main
	.p2align	1
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %start
	addi	sp, sp, -16
	sd	ra, 8(sp)                       # 8-byte Folded Spill
.Lpcrel_hi22:
	auipc	a0, %pcrel_hi(.Lalloc_d28fc9fc1da7316a755065e135ea1a1c)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi22)
	li	a1, 10
	call	_RNvNtCsh9irHALyA0w_7mem2reg2rt5print
	li	a0, 10
	call	fib
	sext.w	a0, a0
	call	_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_i64
.Lpcrel_hi23:
	auipc	a0, %pcrel_hi(.Lalloc_ef1871ad43a681666f6c5514219e6da0)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi23)
	li	a1, 11
	call	_RNvNtCsh9irHALyA0w_7mem2reg2rt5print
	li	a0, 20
	call	fib
	sext.w	a0, a0
	call	_RNvNtCsh9irHALyA0w_7mem2reg2rt9print_i64
.Lpcrel_hi24:
	auipc	a0, %pcrel_hi(.Lalloc_49a1e817e911805af64bbc7efb390101)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi24)
	li	a1, 1
	call	_RNvNtCsh9irHALyA0w_7mem2reg2rt5print
	li	a0, 0
	ld	ra, 8(sp)                       # 8-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end6:
	.size	main, .Lfunc_end6-main
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

	.type	.Lalloc_d28fc9fc1da7316a755065e135ea1a1c,@object # @alloc_d28fc9fc1da7316a755065e135ea1a1c
.Lalloc_d28fc9fc1da7316a755065e135ea1a1c:
	.ascii	"fib(10) = "
	.size	.Lalloc_d28fc9fc1da7316a755065e135ea1a1c, 10

	.type	.Lalloc_ef1871ad43a681666f6c5514219e6da0,@object # @alloc_ef1871ad43a681666f6c5514219e6da0
.Lalloc_ef1871ad43a681666f6c5514219e6da0:
	.ascii	"\nfib(20) = "
	.size	.Lalloc_ef1871ad43a681666f6c5514219e6da0, 11

	.type	.Lalloc_49a1e817e911805af64bbc7efb390101,@object # @alloc_49a1e817e911805af64bbc7efb390101
.Lalloc_49a1e817e911805af64bbc7efb390101:
	.byte	10
	.size	.Lalloc_49a1e817e911805af64bbc7efb390101, 1

	.ident	"rustc version 1.98.0-nightly (23a3312d9 2026-05-23)"
	.section	".note.GNU-stack","",@progbits
