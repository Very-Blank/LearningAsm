.globl _start

.section .data
len:
    .quad 0
array:
    .quad 5, 20, 33, 80, 52, 10, 1

.section .text

_start:
    movq $112, %rdi
    movq len, %rcx
    cmp $0, %rcx
    je end

    movq array-8(, %rcx, 8), %rdi
    sub $1, %rcx
    cmp $0, %rcx
    je end

loop:
    movq array-8(, %rcx, 8), %rax
    cmp %rax, %rdi
    jbe continue
    movq %rax, %rdi

continue:
    loopq loop

end: 
    movq $60, %rax
    syscall
