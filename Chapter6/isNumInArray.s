.globl _start

.section .data

len:
    .quad 7
array:
    .quad 5, 20, 33, 80, 52, 10, 1
num:
    .quad 80

.section .text

_start:

movq $0, %rdi
movq len, %rcx

loop:
movq array-8(, %rcx, 8), %rax
cmp num, %rax
jne skip


movq $1, %rdi
jmp end

skip:
loopq loop

end:
movq $60, %rax
syscall
