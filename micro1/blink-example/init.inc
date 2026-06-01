.syntax unified
.cpu cortex-m0plus
.thumb

// reset related
.equ XOSC_BASE,              0x40024000
.equ XOSC_CTRL,              (XOSC_BASE + 0x00)
.equ XOSC_STATUS,            (XOSC_BASE + 0x04)
.equ XOSC_STARTUP,           (XOSC_BASE + 0x0C)

.equ CLOCKS_BASE,            0x40008000
.equ CLK_REF_CTRL,           (CLOCKS_BASE + 0x30)
.equ CLK_REF_SELECTED,       (CLOCKS_BASE + 0x38)
.equ CLK_SYS_CTRL,           (CLOCKS_BASE + 0x3C)
.equ CLK_SYS_SELECTED,       (CLOCKS_BASE + 0x44)

.equ PLL_SYS_BASE,           0x40028000
.equ PLL_SYS_CS,             (PLL_SYS_BASE + 0x00)
.equ PLL_SYS_PWR,            (PLL_SYS_BASE + 0x04)
.equ PLL_SYS_FBDIV_INT,      (PLL_SYS_BASE + 0x08)
.equ PLL_SYS_PRIM,           (PLL_SYS_BASE + 0x0C)

.equ RESETS_BASE,            0x4000C000
.equ RESETS_RESET,           (RESETS_BASE + 0x00)
.equ RESETS_RESET_DONE,      (RESETS_BASE + 0x08)

.equ RESET_PLL_SYS_BIT,      (1 << 12)

.equ XOSC_ENABLE_1_15MHZ,    0xFABAA0
.equ XOSC_STATUS_STABLE,     (1 << 31)

.equ PLL_CS_LOCK,            (1 << 31)

.equ PLL_PWR_PD,             (1 << 0)
.equ PLL_PWR_VCOPD,          (1 << 5)
.equ PLL_PWR_POSTDIVPD,      (1 << 3)
.equ PLL_PWR_DSMPD,          (1 << 2)

.equ CLK_REF_SRC_XOSC,       2
.equ CLK_SYS_SRC_CLK_REF,    0
.equ CLK_SYS_SRC_CLKSRC_CLK_SYS_AUX, 1
.equ CLK_SYS_AUXSRC_PLL_SYS, 0

// GPIO related
.equ IO_BANK0_BASE,         0x40014000
.equ GPIO25_CTRL,           (IO_BANK0_BASE + 0x0cc)

.equ SIO_BASE,              0xD0000000
.equ GPIO_OUT_SET,          (SIO_BASE + 0x14)
.equ GPIO_OUT_CLR,          (SIO_BASE + 0x18)
.equ GPIO_OE_SET,           (SIO_BASE + 0x24)

.equ LED_GPIO,              25
.equ LED_MASK,              (1 << LED_GPIO)
.equ GPIO_FUNC_SIO,         5
.equ IO_BANK0_AND_PADS,     ((1 << 5) | (1 << 8))

.global clock_init_125mhz
