	.file	"float.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	3
.LC2:
	.string	"pi * 2 = %.5f\n"
	.align	3
.LC4:
	.string	"1/3 = %.5f\n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	lui	a5,%hi(.LC0)
	fld	fa5,%lo(.LC0)(a5)
	fsd	fa5,-24(s0)
	lui	a5,%hi(.LC1)
	fld	fa5,%lo(.LC1)(a5)
	fsd	fa5,-32(s0)
	fld	fa4,-24(s0)
	fld	fa5,-32(s0)
	fmul.d	fa5,fa4,fa5
	fmv.x.d	a1,fa5
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
	call	printf
	lui	a5,%hi(.LC3)
	flw	fa5,%lo(.LC3)(a5)
	fsw	fa5,-36(s0)
	flw	fa5,-36(s0)
	fcvt.d.s	fa5,fa5
	fmv.x.d	a1,fa5
	lui	a5,%hi(.LC4)
	addi	a0,a5,%lo(.LC4)
	call	printf
	li	a5,0
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.section	.rodata
	.align	3
.LC0:
	.word	-266631570
	.word	1074340345
	.align	3
.LC1:
	.word	0
	.word	1073741824
	.align	2
.LC3:
	.word	1051372203
	.ident	"GCC: (gc891d8dc2) 13.2.0"
