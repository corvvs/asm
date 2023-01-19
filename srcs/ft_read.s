default rel

global  _ft_read
extern  ___error
SECTION .text align=16

_ft_read:

        ; prologue
        push    rbp
        mov     rbp, rsp
        push    rbx
        sub     rsp, 8

        ; invoke read(3) via syscall
        mov     rax, 3
        or      rax, 0x2000000
        syscall

        jnc     .epilogue

        mov     rbx, rax
        call    ___error
        mov     dword [rax], ebx        ; set errno
        mov     rax, -1

.epilogue:
        add     rsp, 8
        pop     rbx
        pop     rbp
        ret
