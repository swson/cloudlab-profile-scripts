# RP2040 split bare-metal blink package (fixed)

This package is for the original Raspberry Pi Pico (not Pico W).

Files:
- `boot2.s` - second-stage bootloader blob placed at flash offset 0x000
- `startup.s` - vector table, reset handler, `.data` copy, `.bss` clear
- `main.s` - application entry point
- `blink.s` - GPIO 25 setup and blink loop
- `linker.ld` - places `.boot2` at `0x10000000` and vectors at `0x10000100`

## Build

```bash
make
make uf2
```

## Flash

Hold **BOOTSEL** while plugging in the Pico, then copy `firmware.uf2` to the mounted drive.

## Important notes

- This targets the original Raspberry Pi Pico, whose onboard LED is on GPIO 25.
- The reset vector is emitted as `reset_handler + 1` so the core enters Thumb state correctly.
- The reset-done wait loop masks the relevant bits before comparing, so it does not hang if other reset-done bits are also set.
