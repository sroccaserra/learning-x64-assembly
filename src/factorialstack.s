.globl _start

.section .data
value:
.word 5

.section .text
_start:
        push $0
        mov value, %ax
pushvalues:
        push %ax
        dec %ax
        jnz pushvalues

        mov $1, %ax
multiply:
        pop %cx
        cmp $0, %cx
        je complete
        mul %cx
        jmp multiply

complete:
        # Set return value and exit
        mov %al, %dil
        mov $60, %ax
        syscall
