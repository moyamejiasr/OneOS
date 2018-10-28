; OneOS Loader.
; Declare constants used for creating a multiboot header.
MAGIC_NUMBER equ 0x1BADB002     ; define the magic number constant
FLAGS        equ 0x0            ; multiboot flags
CHECKSUM     equ -MAGIC_NUMBER  ; calculate the checksum
                                ; (magic number + checksum + flags should equal 0)

; Declare a header as in the Multiboot Standard. We put this into a special
; section so we can force the header to be in the start of the final program.
; Documented in the multiboot standard. The bootloader will search for this
; magic sequence.
section .multiboot
align 4                         ; the code must be 4 byte aligned
    dd MAGIC_NUMBER             ; write the magic number to the machine code,
    dd FLAGS                    ; the flags,
    dd CHECKSUM                 ; and the checksum

; The stack pointer register (esp) points at anything and using it may
; cause massive harm. We'll provide our own temporary stack. We will allocate
; room for it by creating a symbol at the bottom of it, allocating 16384 bytes for it, 
; and finally creating a symbol at the top.
section .bootstrap_stack
KERNEL_STACK_SIZE equ 4096      ; size of stack in bytes

; The linker script specifies _start(loader here) as the entry point to the kernel.
section .text
global loader
    ; the loader label (defined as entry point in linker script)
    loader:

    ; Now in kernel mode! Now we must set the stack. Notice that processor is not 
    ; fully initialized yet and stuff like float point instructions are not available.
	; To set up a stack, we simply set the esp register to point to the top of
    ; our stack (it will grow downwards).
        mov esp, kernel_stack + KERNEL_STACK_SIZE   ; point esp to the start of the
                                                    ; stack (end of memory area)
    ; Now we call the C code from asm using GNU/GCC convention.
        ; The assembly code for C convention
        extern krnl_main            ; the function krnl_main is defined in kmain
        call krnl_main              ; call the function, the result will be in eax

    ; In case the function returns, we put the computer into a loop.
    .loop:
        jmp .loop                   ; loop forever

section .bss:
    align 4                         ; align at 4 bytes
    kernel_stack:                   ; label points to beginning of memory
        resb KERNEL_STACK_SIZE ; reserve stack for the kernel