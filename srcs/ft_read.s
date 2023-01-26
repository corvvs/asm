%include "srcs/ft_macro.s"

default rel

global  _ft_read
use_errno
SECTION .text align=16

_ft_read:
        m_start_func
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
        m_end_func
        ret
