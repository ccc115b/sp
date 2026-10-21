	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"
	.file	"float.71a0d895409d9963-cgu.0"

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
	call	_RNvNtCs9KQ82dgyMwh_5float2rt5print
	call	_RNvNtCs9KQ82dgyMwh_5float2rt8sys_exit
.Lfunc_end0:
	.size	_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind, .Lfunc_end0-_RNvCseLSQwpavqd5_7___rustc17rust_begin_unwind

	.section	.text._RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes,"ax",@progbits
	.p2align	1
	.type	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes,@function
_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes:
	tail	_RNvNtCs9KQ82dgyMwh_5float2rt9sys_write
.Lfunc_end1:
	.size	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes, .Lfunc_end1-_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes

	.section	.text._RNvNtCs9KQ82dgyMwh_5float2rt5print,"ax",@progbits
	.p2align	1
	.type	_RNvNtCs9KQ82dgyMwh_5float2rt5print,@function
_RNvNtCs9KQ82dgyMwh_5float2rt5print:
	tail	_RNvNtCs9KQ82dgyMwh_5float2rt9sys_write
.Lfunc_end2:
	.size	_RNvNtCs9KQ82dgyMwh_5float2rt5print, .Lfunc_end2-_RNvNtCs9KQ82dgyMwh_5float2rt5print

	.section	.text._RNvNtCs9KQ82dgyMwh_5float2rt8sys_exit,"ax",@progbits
	.p2align	1
	.type	_RNvNtCs9KQ82dgyMwh_5float2rt8sys_exit,@function
_RNvNtCs9KQ82dgyMwh_5float2rt8sys_exit:
	li	a0, 134
	li	a7, 93
	#APP
	ecall
	#NO_APP
.LBB3_1:
	j	.LBB3_1
.Lfunc_end3:
	.size	_RNvNtCs9KQ82dgyMwh_5float2rt8sys_exit, .Lfunc_end3-_RNvNtCs9KQ82dgyMwh_5float2rt8sys_exit

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI4_0:
	.quad	0x40f86a0000000000
.LCPI4_1:
	.quad	755578637259143235
	.section	.text._RNvNtCs9KQ82dgyMwh_5float2rt9print_f64,"ax",@progbits
	.p2align	1
	.type	_RNvNtCs9KQ82dgyMwh_5float2rt9print_f64,@function
_RNvNtCs9KQ82dgyMwh_5float2rt9print_f64:
	addi	sp, sp, -64
	sd	ra, 56(sp)
	sd	s0, 48(sp)
	sd	s1, 40(sp)
	fsd	fs0, 32(sp)
	fsd	fs1, 24(sp)
	fmv.d.x	fs0, zero
	flt.d	a0, fa0, fs0
	beqz	a0, .LBB4_3
.Lpcrel_hi2:
	auipc	s0, %pcrel_hi(.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.2)
	addi	s0, s0, %pcrel_lo(.Lpcrel_hi2)
.LBB4_2:
	fmv.d	fs1, fa0
	li	a1, 1
	mv	a0, s0
	call	_RNvNtCs9KQ82dgyMwh_5float2rt5print
	flt.d	a0, fs0, fs1
	fneg.d	fa0, fs1
	bnez	a0, .LBB4_2
.LBB4_3:
.Lpcrel_hi3:
	auipc	a0, %pcrel_hi(.LCPI4_0)
	fld	fa5, %pcrel_lo(.Lpcrel_hi3)(a0)
	li	a0, 511
.Lpcrel_hi4:
	auipc	a1, %pcrel_hi(.LCPI4_1)
	slli	a0, a0, 53
	fmul.d	fa5, fa0, fa5
	fmv.d.x	fa4, a0
	fadd.d	fa5, fa5, fa4
	fcvt.lu.d	a0, fa5, rtz
	feq.d	a2, fa5, fa5
	seqz	a2, a2
	ld	a1, %pcrel_lo(.Lpcrel_hi4)(a1)
	addi	a2, a2, -1
	and	s1, a2, a0
	srli	a0, s1, 5
	mulhu	s0, a0, a1
	srli	s0, s0, 7
	mv	a0, s0
	call	_RNvNtCs9KQ82dgyMwh_5float2rt9print_u64
.Lpcrel_hi5:
	auipc	a0, %pcrel_hi(.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.1)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi5)
	li	a1, 1
	call	_RNvNtCs9KQ82dgyMwh_5float2rt5print
	lui	a6, 24
	lui	a7, 205
	lui	t0, 13
	lui	a3, 335544
	lui	a4, 67109
	li	t1, 205
	lui	a0, 210
	addi	a1, a6, 1696
	addi	a2, a7, -819
	addi	a5, t0, -819
	addi	a3, a3, 1311
	addi	a4, a4, -557
	addi	a0, a0, -1167
	mul	a1, s0, a1
	slli	a2, a2, 12
	slli	a0, a0, 12
	sub	s1, s1, a1
	addi	a1, a2, -819
	addi	a0, a0, 1881
	mul	a1, s1, a1
	mul	a2, s1, a3
	mul	a3, s1, a4
	mul	a6, s1, a0
	srli	a4, a1, 35
	srli	a2, a2, 37
	srli	a3, a3, 38
	slli	s0, a4, 1
	slli	a1, a4, 3
	add	a1, a1, s0
	mul	s0, a4, a5
	mul	a5, a2, a5
	mul	a0, a3, t1
	srli	s0, s0, 19
	srli	a5, a5, 19
	sub	s1, s1, a1
	slli	a1, s0, 1
	slli	s0, s0, 3
	add	a1, a1, s0
	slli	s0, a5, 1
	slli	a5, a5, 3
	add	a5, a5, s0
	srli	s0, a0, 10
	srli	a0, a0, 11
	andi	s0, s0, 62
	slli	a0, a0, 3
	add	a0, a0, s0
	ori	s1, s1, 48
	sb	s1, 8(sp)
	sub	a4, a4, a1
	sub	a2, a2, a5
	srli	a1, a6, 45
	ori	a1, a1, 48
	sub	a3, a3, a0
	ori	a0, a4, 48
	ori	a2, a2, 48
	ori	a3, a3, 48
	sb	a1, 4(sp)
	sb	a3, 5(sp)
	sb	a2, 6(sp)
	sb	a0, 7(sp)
	addi	a0, sp, 4
	li	a1, 5
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 56(sp)
	ld	s0, 48(sp)
	ld	s1, 40(sp)
	fld	fs0, 32(sp)
	fld	fs1, 24(sp)
	addi	sp, sp, 64
	ret
.Lfunc_end4:
	.size	_RNvNtCs9KQ82dgyMwh_5float2rt9print_f64, .Lfunc_end4-_RNvNtCs9KQ82dgyMwh_5float2rt9print_f64

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI5_0:
	.quad	1844674407370955162
.LCPI5_1:
	.quad	2951479051793528259
.LCPI5_2:
	.quad	2361183241434822607
.LCPI5_3:
	.quad	3777893186295716171
.LCPI5_4:
	.quad	755578637259143235
.LCPI5_5:
	.quad	4835703278458516699
.LCPI5_6:
	.quad	-2972493582642298179
.LCPI5_7:
	.quad	-6067343680855748867
.LCPI5_8:
	.quad	19342813113834067
.LCPI5_9:
	.quad	-2601111570856684097
.LCPI5_10:
	.quad	-5770238071427257601
.LCPI5_11:
	.quad	2535301200456458803
.LCPI5_12:
	.quad	4056481920730334085
.LCPI5_13:
	.quad	811296384146066817
.LCPI5_14:
	.quad	633825300114115
.LCPI5_15:
	.quad	4153837486827862103
.LCPI5_16:
	.quad	101412048018259
.LCPI5_17:
	.quad	81129638414607
.LCPI5_18:
	.quad	-8446744073709551616
	.section	.text._RNvNtCs9KQ82dgyMwh_5float2rt9print_u64,"ax",@progbits
	.p2align	1
	.type	_RNvNtCs9KQ82dgyMwh_5float2rt9print_u64,@function
_RNvNtCs9KQ82dgyMwh_5float2rt9print_u64:
	beqz	a0, .LBB5_3
	addi	sp, sp, -32
	sd	ra, 24(sp)
	sd	zero, 0(sp)
	sd	zero, 8(sp)
	sh	zero, 16(sp)
	sb	zero, 18(sp)
	lui	a1, 838861
	addi	a1, a1, -819
	slli	a2, a1, 32
	add	a1, a1, a2
	mulhu	a1, a0, a1
	srli	a2, a1, 3
	andi	a1, a1, 248
	slli	a3, a2, 1
	sub	a1, a0, a1
	sub	a1, a1, a3
	ori	a1, a1, 48
	li	a3, 9
	sb	a1, 19(sp)
	bltu	a3, a0, .LBB5_4
	addi	a0, sp, 19
	li	a1, 1
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_3:
.Lpcrel_hi6:
	auipc	a0, %pcrel_hi(.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.3)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi6)
	li	a1, 1
	tail	_RNvNtCs9KQ82dgyMwh_5float2rt5print
.LBB5_4:
.Lpcrel_hi7:
	auipc	a1, %pcrel_hi(.LCPI5_0)
	ld	a1, %pcrel_lo(.Lpcrel_hi7)(a1)
	mulhu	a3, a2, a1
	slli	a4, a3, 1
	slli	a3, a3, 3
	add	a3, a3, a4
	sub	a2, a2, a3
	ori	a2, a2, 48
	li	a3, 100
	sb	a2, 18(sp)
	bgeu	a0, a3, .LBB5_6
	addi	a0, sp, 18
	li	a1, 2
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_6:
.Lpcrel_hi8:
	auipc	a2, %pcrel_hi(.LCPI5_1)
	ld	a2, %pcrel_lo(.Lpcrel_hi8)(a2)
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
	bgeu	a0, a3, .LBB5_8
	addi	a0, sp, 17
	li	a1, 3
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_8:
.Lpcrel_hi9:
	auipc	a2, %pcrel_hi(.LCPI5_2)
	ld	a2, %pcrel_lo(.Lpcrel_hi9)(a2)
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
	bgeu	a4, a3, .LBB5_10
	addi	a0, sp, 16
	li	a1, 4
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_10:
.Lpcrel_hi10:
	auipc	a2, %pcrel_hi(.LCPI5_3)
	ld	a2, %pcrel_lo(.Lpcrel_hi10)(a2)
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
	bgeu	a0, a3, .LBB5_12
	addi	a0, sp, 15
	li	a1, 5
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_12:
.Lpcrel_hi11:
	auipc	a2, %pcrel_hi(.LCPI5_4)
	ld	a2, %pcrel_lo(.Lpcrel_hi11)(a2)
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
	bgeu	a0, a3, .LBB5_14
	addi	a0, sp, 14
	li	a1, 6
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_14:
.Lpcrel_hi12:
	auipc	a2, %pcrel_hi(.LCPI5_5)
	ld	a2, %pcrel_lo(.Lpcrel_hi12)(a2)
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
	bgeu	a0, a3, .LBB5_16
	addi	a0, sp, 13
	li	a1, 7
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_16:
.Lpcrel_hi13:
	auipc	a2, %pcrel_hi(.LCPI5_6)
	ld	a2, %pcrel_lo(.Lpcrel_hi13)(a2)
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
	bgeu	a0, a3, .LBB5_18
	addi	a0, sp, 12
	li	a1, 8
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_18:
.Lpcrel_hi14:
	auipc	a2, %pcrel_hi(.LCPI5_7)
	ld	a2, %pcrel_lo(.Lpcrel_hi14)(a2)
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
	bgeu	a0, a3, .LBB5_20
	addi	a0, sp, 11
	li	a1, 9
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_20:
.Lpcrel_hi15:
	auipc	a2, %pcrel_hi(.LCPI5_8)
	ld	a2, %pcrel_lo(.Lpcrel_hi15)(a2)
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
	bgeu	a0, a3, .LBB5_22
	addi	a0, sp, 10
	li	a1, 10
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_22:
.Lpcrel_hi16:
	auipc	a1, %pcrel_hi(.LCPI5_9)
	ld	a1, %pcrel_lo(.Lpcrel_hi16)(a1)
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
	bgeu	a0, a3, .LBB5_24
	addi	a0, sp, 9
	li	a1, 11
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_24:
.Lpcrel_hi17:
	auipc	a1, %pcrel_hi(.LCPI5_10)
	ld	a2, %pcrel_lo(.Lpcrel_hi17)(a1)
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
	bgeu	a0, a4, .LBB5_26
	addi	a0, sp, 8
	li	a1, 12
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_26:
.Lpcrel_hi18:
	auipc	a2, %pcrel_hi(.LCPI5_11)
	ld	a2, %pcrel_lo(.Lpcrel_hi18)(a2)
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
	bgeu	a0, a3, .LBB5_28
	addi	a0, sp, 7
	li	a1, 13
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_28:
.Lpcrel_hi19:
	auipc	a1, %pcrel_hi(.LCPI5_12)
	ld	a2, %pcrel_lo(.Lpcrel_hi19)(a1)
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
	bgeu	a0, a4, .LBB5_30
	addi	a0, sp, 6
	li	a1, 14
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_30:
.Lpcrel_hi20:
	auipc	a2, %pcrel_hi(.LCPI5_13)
	ld	a2, %pcrel_lo(.Lpcrel_hi20)(a2)
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
	bgeu	a0, a3, .LBB5_32
	addi	a0, sp, 5
	li	a1, 15
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_32:
.Lpcrel_hi21:
	auipc	a1, %pcrel_hi(.LCPI5_14)
	ld	a1, %pcrel_lo(.Lpcrel_hi21)(a1)
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
	bgeu	a0, a3, .LBB5_34
	addi	a0, sp, 4
	li	a1, 16
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_34:
.Lpcrel_hi22:
	auipc	a1, %pcrel_hi(.LCPI5_15)
	ld	a1, %pcrel_lo(.Lpcrel_hi22)(a1)
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
	bgeu	a0, a3, .LBB5_36
	addi	a0, sp, 3
	li	a1, 17
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_36:
.Lpcrel_hi23:
	auipc	a1, %pcrel_hi(.LCPI5_16)
	ld	a1, %pcrel_lo(.Lpcrel_hi23)(a1)
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
	bgeu	a0, a3, .LBB5_38
	addi	a0, sp, 2
	li	a1, 18
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_38:
.Lpcrel_hi24:
	auipc	a1, %pcrel_hi(.LCPI5_17)
.Lpcrel_hi25:
	auipc	a2, %pcrel_hi(.LCPI5_18)
	ld	a1, %pcrel_lo(.Lpcrel_hi24)(a1)
	ld	a2, %pcrel_lo(.Lpcrel_hi25)(a2)
	srli	a3, a0, 18
	mulhu	a1, a3, a1
	sltu	a3, a0, a2
	srli	a1, a1, 24
	addi	a3, a3, -1
	andi	a3, a3, 246
	add	a1, a1, a3
	ori	a1, a1, 48
	sb	a1, 1(sp)
	bgeu	a0, a2, .LBB5_40
	addi	a0, sp, 1
	li	a1, 19
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.LBB5_40:
	li	a1, 49
	mv	a0, sp
	sb	a1, 0(sp)
	li	a1, 20
	call	_RNvNtCs9KQ82dgyMwh_5float2rt11print_bytes
	ld	ra, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end5:
	.size	_RNvNtCs9KQ82dgyMwh_5float2rt9print_u64, .Lfunc_end5-_RNvNtCs9KQ82dgyMwh_5float2rt9print_u64

	.section	.text._RNvNtCs9KQ82dgyMwh_5float2rt9sys_write,"ax",@progbits
	.p2align	1
	.type	_RNvNtCs9KQ82dgyMwh_5float2rt9sys_write,@function
_RNvNtCs9KQ82dgyMwh_5float2rt9sys_write:
	mv	a2, a1
	mv	a1, a0
	li	a0, 1
	li	a7, 64
	#APP
	ecall
	#NO_APP
	ret
.Lfunc_end6:
	.size	_RNvNtCs9KQ82dgyMwh_5float2rt9sys_write, .Lfunc_end6-_RNvNtCs9KQ82dgyMwh_5float2rt9sys_write

	.section	.text.main,"ax",@progbits
	.globl	main
	.p2align	1
	.type	main,@function
main:
	addi	sp, sp, -32
	sd	ra, 24(sp)
	sd	s0, 16(sp)
	fsd	fs0, 8(sp)
	fsd	fs1, 0(sp)
.Lpcrel_hi26:
	auipc	a0, %pcrel_hi(.promoted_doubles.main)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi26)
	fld	fs0, 0(a0)
	fld	fs1, 8(a0)
.Lpcrel_hi27:
	auipc	a0, %pcrel_hi(.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.4)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi27)
	li	a1, 9
	call	_RNvNtCs9KQ82dgyMwh_5float2rt5print
	fmv.d	fa0, fs0
	call	_RNvNtCs9KQ82dgyMwh_5float2rt9print_f64
.Lpcrel_hi28:
	auipc	s0, %pcrel_hi(.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.5)
	addi	s0, s0, %pcrel_lo(.Lpcrel_hi28)
	li	a1, 1
	mv	a0, s0
	call	_RNvNtCs9KQ82dgyMwh_5float2rt5print
.Lpcrel_hi29:
	auipc	a0, %pcrel_hi(.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.6)
	addi	a0, a0, %pcrel_lo(.Lpcrel_hi29)
	li	a1, 6
	call	_RNvNtCs9KQ82dgyMwh_5float2rt5print
	fmv.d	fa0, fs1
	call	_RNvNtCs9KQ82dgyMwh_5float2rt9print_f64
	li	a1, 1
	mv	a0, s0
	call	_RNvNtCs9KQ82dgyMwh_5float2rt5print
	li	a0, 0
	ld	ra, 24(sp)
	ld	s0, 16(sp)
	fld	fs0, 8(sp)
	fld	fs1, 0(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end7:
	.size	main, .Lfunc_end7-main

	.type	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.0,@object
	.section	.rodata..Lanon.b79dca80f22cdd0372bbba4bb0e46d64.0,"a",@progbits
.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.0:
	.ascii	"panic!\n"
	.size	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.0, 7

	.type	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.1,@object
	.section	.rodata..Lanon.b79dca80f22cdd0372bbba4bb0e46d64.1,"a",@progbits
.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.1:
	.byte	46
	.size	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.1, 1

	.type	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.2,@object
	.section	.rodata..Lanon.b79dca80f22cdd0372bbba4bb0e46d64.2,"a",@progbits
.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.2:
	.byte	45
	.size	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.2, 1

	.type	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.3,@object
	.section	.rodata..Lanon.b79dca80f22cdd0372bbba4bb0e46d64.3,"a",@progbits
.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.3:
	.byte	48
	.size	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.3, 1

	.type	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.4,@object
	.section	.rodata..Lanon.b79dca80f22cdd0372bbba4bb0e46d64.4,"a",@progbits
.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.4:
	.ascii	"pi * 2 = "
	.size	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.4, 9

	.type	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.5,@object
	.section	.rodata..Lanon.b79dca80f22cdd0372bbba4bb0e46d64.5,"a",@progbits
.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.5:
	.byte	10
	.size	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.5, 1

	.type	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.6,@object
	.section	.rodata..Lanon.b79dca80f22cdd0372bbba4bb0e46d64.6,"a",@progbits
.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.6:
	.ascii	"1/3 = "
	.size	.Lanon.b79dca80f22cdd0372bbba4bb0e46d64.6, 6

	.type	.promoted_doubles.main,@object
	.section	.rodata..promoted_doubles.main,"a",@progbits
	.p2align	3, 0x0
.promoted_doubles.main:
	.quad	0x401921f9f01b866e
	.quad	0x3fd5555560000000
	.size	.promoted_doubles.main, 16

	.ident	"rustc version 1.98.0-nightly (23a3312d9 2026-05-23)"
	.section	".note.GNU-stack","",@progbits
