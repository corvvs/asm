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

        xor     rax, rax        ; size = 0
.loop:
        test    rdi, rdi
        jz      .epilogue
        lea     rax, [rax + 1]
        mov     rdi, [rdi + ft_list_next]
        jmp     .loop

.epilogue:
        ; pop     rbp
        ret
