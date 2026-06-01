.syntax unified
.cpu cortex-m0plus
.thumb

.global reset_handler
.global _start
.extern main

.section .vectors, "a", %progbits
.word __stack_top
.word reset_handler + 1

.section .text.startup, "ax", %progbits
.thumb_func
reset_handler:
_start:
    /* Copy .data from flash to RAM */
    ldr r0, =__data_load_start
    ldr r1, =__data_start
    ldr r2, =__data_end
1:
    cmp r1, r2
    bcs 2f
    ldr r3, [r0]
    str r3, [r1]
    adds r0, r0, #4
    adds r1, r1, #4
    b 1b

    /* Zero .bss */
2:
    ldr r1, =__bss_start
    ldr r2, =__bss_end
    movs r3, #0
3:
    cmp r1, r2
    bcs 4f
    str r3, [r1]
    adds r1, r1, #4
    b 3b

4:
    bl main
5:
    b 5b
