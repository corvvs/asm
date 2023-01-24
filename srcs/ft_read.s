%include "srcs/ft_macro.s"

default rel

global  _ft_read
use_errno
SECTION .text align=16

_ft_read:

        ; prologue
        push    rbp
        mov     rbp, rsp
        push    rbx
        sub     rsp, 8

        ; invoke read(3) via syscall
        ft_syscall      NR_READ

        jnc     .epilogue

        mov     rbx, rax
        set_errno       ebx
        mov     rax, -1

.epilogue:
        add     rsp, 8
        pop     rbx
        pop     rbp
        ret
