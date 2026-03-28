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

movq $60, %rax
syscall
