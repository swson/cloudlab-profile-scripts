	.syntax unified
	.cpu cortex-m0plus
	.thumb

	.include "init.inc"
	
	.global clock_init_125mhz
	.thumb_func
clock_init_125mhz:
	/* 1. Enable XOSC */
	ldr r1, =XOSC_STARTUP
	ldr r0, =47                  /* approx 1 ms startup delay value */
	str r0, [r1]

	ldr r1, =XOSC_CTRL
	ldr r0, =XOSC_ENABLE_1_15MHZ
	str r0, [r1]

wait_xosc_stable:
	ldr r1, =XOSC_STATUS
	ldr r0, [r1]
	ldr r2, =XOSC_STATUS_STABLE
	tst r0, r2
	beq wait_xosc_stable

	/* 2. Switch clk_ref to XOSC */
	ldr r1, =CLK_REF_CTRL
	movs r0, #CLK_REF_SRC_XOSC
	str r0, [r1]

wait_clk_ref_xosc:
	ldr r1, =CLK_REF_SELECTED
	ldr r0, [r1]
	movs r2, #(1 << CLK_REF_SRC_XOSC)
	tst r0, r2
	beq wait_clk_ref_xosc

	/* 3. Temporarily run clk_sys from clk_ref */
	ldr r1, =CLK_SYS_CTRL
	movs r0, #CLK_SYS_SRC_CLK_REF
	str r0, [r1]

wait_clk_sys_ref:
	ldr r1, =CLK_SYS_SELECTED
	ldr r0, [r1]
	movs r2, #1
	tst r0, r2
	beq wait_clk_sys_ref

	/* 4. Reset PLL_SYS */
	ldr r1, =RESETS_RESET
	ldr r0, [r1]
	ldr r2, =RESET_PLL_SYS_BIT
	orrs r0, r2
	str r0, [r1]

	ldr r0, [r1]
	bics r0, r2
	str r0, [r1]

wait_pll_sys_reset_done:
	ldr r1, =RESETS_RESET_DONE
	ldr r0, [r1]
	tst r0, r2
	beq wait_pll_sys_reset_done

	/* 5. Configure PLL_SYS:
	* refdiv = 1
	* fbdiv  = 125
	* postdiv1 = 6
	* postdiv2 = 2
	*/
	ldr r1, =PLL_SYS_CS
	movs r0, #1
	str r0, [r1]

	ldr r1, =PLL_SYS_FBDIV_INT
	movs r0, #125
	str r0, [r1]

	/* Power up PLL except post divider */
	ldr r1, =PLL_SYS_PWR
	ldr r0, =(PLL_PWR_PD | PLL_PWR_VCOPD)
	mvns r0, r0
	str r0, [r1]

wait_pll_lock:
	ldr r1, =PLL_SYS_CS
	ldr r0, [r1]
	ldr r2, =PLL_CS_LOCK
	tst r0, r2
	beq wait_pll_lock

	/* Set post dividers: POSTDIV1=6, POSTDIV2=2 */
	ldr r1, =PLL_SYS_PRIM
	ldr r0, =((6 << 16) | (2 << 12))
	str r0, [r1]

	/* Power up post divider */
	ldr r1, =PLL_SYS_PWR
	ldr r0, [r1]
	ldr r2, =PLL_PWR_POSTDIVPD
	bics r0, r2
	str r0, [r1]

	/* 6. Select PLL_SYS as clk_sys aux source.
	* CLK_SYS_CTRL:
	*   SRC    bits [1:0] = 1, aux source
	*   AUXSRC bits [7:5] = 0, PLL_SYS
	*/
	ldr r1, =CLK_SYS_CTRL
	movs r0, #CLK_SYS_SRC_CLKSRC_CLK_SYS_AUX
	str r0, [r1]

wait_clk_sys_pll:
	ldr r1, =CLK_SYS_SELECTED
	ldr r0, [r1]
	movs r2, #(1 << CLK_SYS_SRC_CLKSRC_CLK_SYS_AUX)
	tst r0, r2
	beq wait_clk_sys_pll

	bx lr


	.global init_iobank0_pads
        .thumb_func
init_iobank0_pads:	
	/* Release IO_BANK0 and PADS_BANK0 from reset */
        ldr r0, =RESETS_RESET                                      
        ldr r1, [r0]                                               
        ldr r2, =IO_BANK0_AND_PADS                                 
        bics r1, r2                                                
        str r1, [r0]                                               

wait_reset_done:
        ldr r0, =RESETS_RESET_DONE                                 
        ldr r1, [r0]                                               
        ldr r2, =IO_BANK0_AND_PADS                                 
        ands r1, r2                                                
        cmp r1, r2                                                 
        bne wait_reset_done                                        

	bx lr
