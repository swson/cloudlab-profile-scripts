	.syntax unified
	.cpu cortex-m0plus
	.thumb

	.global main
	.extern clock_init_125mhz
	.extern reset_iobank0_pads
	.extern portTest1

	.section .text.main, "ax", %progbits
	.thumb_func
main:
	bl clock_init_125mhz
	bl init_iobank0_pads
	bl portTest1
1:
	b 1b
