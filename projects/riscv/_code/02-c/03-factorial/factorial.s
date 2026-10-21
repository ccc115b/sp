	.file	"factorial.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	factorial
	.type	factorial, @function
factorial:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	sd	s1,24(sp)
	addi	s0,sp,48
	mv	a5,a0
	sw	a5,-36(s0)
	lw	a5,-36(s0)
	sext.w	a4,a5
	li	a5,1
	bgt	a4,a5,.L2
	li	a5,1
	j	.L3
.L2:
	lw	s1,-36(s0)
	lw	a5,-36(s0)
	addiw	a5,a5,-1
	sext.w	a5,a5
	mv	a0,a5
	call	factorial
	mv	a5,a0
	mul	a5,s1,a5
.L3:
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	ld	s1,24(sp)
	addi	sp,sp,48
	jr	ra
	.size	factorial, .-factorial
	.section	.rodata
	.align	3
.LC0:
	.string	"%d! = %ld\n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sd	ra,24(sp)
	sd	s0,16(sp)
	addi	s0,sp,32
	sw	zero,-20(s0)
	j	.L5
.L6:
	lw	a5,-20(s0)
	mv	a0,a5
	call	factorial
	mv	a4,a0
	lw	a5,-20(s0)
	mv	a2,a4
	mv	a1,a5
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	printf
	lw	a5,-20(s0)
	addiw	a5,a5,1
	sw	a5,-20(s0)
.L5:
	lw	a5,-20(s0)
	sext.w	a4,a5
	li	a5,10
	ble	a4,a5,.L6
	li	a5,0
	mv	a0,a5
	ld	ra,24(sp)
	ld	s0,16(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (gc891d8dc2) 13.2.0"
