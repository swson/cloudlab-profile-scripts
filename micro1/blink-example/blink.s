	.syntax unified
	.cpu cortex-m0plus
	.thumb

	.global portTest1

	.section .text.portTest1, "ax", %progbits
	.thumb_func
portTest1:
	ldr	r0, =0x400140cc		// IO_BANK0.GPIO25_CTRL
	movs	r1, #5			// Func5 => SIO
	str	r1, [r0, #0]

	ldr	r0, =0xd0000020		// SIO_BASE.GPIO_OE
	movs	r1, #1			// GPIO25
	lsls	r1, r1, #25
	str	r1, [r0, #0]
	
	ldr	r0, =0xd0000014		// SIO_BASE.GPIO_OUT_SET
	movs	r1, #1			// GPIO25
	lsls	r1, r1, #25
	str	r1, [r0, #0]

toggle:
	//ldr	r0, =0x02A47915		// ~1 sec delay
	ldr	r0, =0x01523c8a		// ~0.5 sec
	ldr	r0, =0x00a91e45		// ~0.25 sec
delay:	
	adds	r0, r0, #-1
	cmp 	r0, #0
	bne	delay

	ldr	r2, =0xd000001c		// SIO_BASE.GPIO_OUR_XOR
	movs	r3, #1			// GPIO25
	lsls	r3, r3, #25
	str	r3, [r2, #0]
	b	toggle

	//bx 	lr
	
	//	.data
	//v1:	 .word 0x12345678
