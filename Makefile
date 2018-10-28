OBJECTS = src/loader.o src/kmain.o src/io.o
CC = gcc
CFLAGS = -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
         -nostartfiles -nodefaultlibs -Wall -Wextra -Werror -c
LDFLAGS = -T src/linker.ld -melf_i386
AS = nasm
ASFLAGS = -f elf

all: kernel.elf

kernel.elf: $(OBJECTS)
	ld $(LDFLAGS) $(OBJECTS) -o src/kernel.elf

os.iso: kernel.elf
	cp src/kernel.elf iso/boot/kernel.elf
	grub-mkrescue -o os.iso iso
        
run: os.iso
	bochs -f bochsrc.txt -q

clean:
	for i in `find . -type f \( -name '*.elf' -o -name '*.o' \)`; do \
		rm -f $$i; \
	done
