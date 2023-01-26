%include "srcs/ft_macro.s"
%include "srcs/ft_list.s"

default rel

global  _ft_list_size
SECTION .text align=16

_ft_list_size:
        ; size_t ft_list_size(t_list *begin_list)
        ; push    rbp
        ; mov     rbp, rsp
        ; prologue

        m_zeroize(rax)                  ; size = 0
.loop:
        m_jump_if_zero  rdi, .epilogue
        m_inc(rax)
        mov             rdi, next_of(rdi)
        jmp             .loop

.epilogue:
        ; pop     rbp
        ret
