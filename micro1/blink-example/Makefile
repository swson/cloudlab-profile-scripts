TARGET = firmware
CPU = cortex-m0plus
OBJS = boot2.o startup.o main.o init.o blink.o

all: $(TARGET).elf

%.o: %.s
	arm-none-eabi-as -mcpu=$(CPU) -mthumb -o $@ $<

$(TARGET).elf: $(OBJS) linker.ld
	arm-none-eabi-gcc -nostdlib -nostartfiles -T linker.ld \
	-mcpu=$(CPU) -mthumb -Wl,-Map=$(TARGET).map \
	-o $@ $(OBJS)

bin: $(TARGET).elf
	arm-none-eabi-objcopy -O binary $(TARGET).elf $(TARGET).bin

uf2: $(TARGET).elf
	if [ ! -d elf2uf2/.git ]; then git clone https://github.com/rej696/elf2uf2.git; fi
	if [ ! -f elf2uf2/elf2uf2 ]; then g++ -o elf2uf2/elf2uf2 elf2uf2/main.cpp; fi
	elf2uf2/elf2uf2 $(TARGET).elf $(TARGET).uf2

lst: $(TARGET).elf
	arm-none-eabi-objdump -d $(TARGET).elf > $(TARGET).lst

clean:
	rm -f *.o *.elf *.bin *.uf2 *.map *.lst *~
	rm -rf elf2uf2
