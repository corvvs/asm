%include "srcs/ft_macro.s"

default rel
global  _ft_write
use_errno
SECTION .text align=16

_ft_write:
        ; prologue
        m_start_func
        push    rbx
        sub     rsp, 8

        ; invoke write(4) via syscall
        ft_syscall      NR_WRITE

        jnc     .epilogue

        mov     rbx, rax
        set_errno       ebx
        mov     rax, -1

.epilogue:
        add     rsp, 8
        pop     rbx
        m_end_func
        ret
