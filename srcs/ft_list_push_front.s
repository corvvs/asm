%include "srcs/ft_macro.s"
%include "srcs/ft_list.s"

default rel

global  _ft_list_push_front
global  _ft_list_new
extern  _malloc
SECTION .text align=16

_ft_list_new:
        ; t_list *ft_list_new(void *data)
        push    rbp
        mov     rbp, rsp
        push    r12
        sub     rsp, 8
        ; prologue

        mov     r12, rdi                        ; data を退避
        mov     rdi, ft_list_size               ; rdi = sizeof(t_list)
        call    _malloc                         ; rax = new list node
        m_jump_if_zero  rax, .epilogue          ; rax == NULL なら終了

.set_fields:
        mov     data_of(rax), r12               ; rax->data = r12 (data)
        m_zeroize(r12)
        mov     next_of(rax), r12               ; rax->next = 0

.epilogue:
        add     rsp, 8
        pop     r12
        pop     rbp
        ret

_ft_list_push_front:
        ; void ft_list_push_front(t_list **begin_list, void *data)
        m_jump_if_zero  rdi, .return            ; rdi == NULL なら即終了
        push    rbp
        mov     rbp, rsp
        push    r12
        sub     rsp, 8
        ; prologue
        m_zeroize(rax)

        mov             r12, rdi
        mov             rdi, rsi
        call            _ft_list_new            ; rax = ft_list_new(rsi)
        m_jump_if_zero  rax, .epilogue          ; rax == NULL なら即終了

        mov             rdi, [r12]              ; rdi = *r12 (*begin_list)
        mov             next_of(rax), rdi       ; rax->next = rdi = *begin_list
        mov             [r12], rax              ; *r12 (*begin_list) = rax

.epilogue:
        add     rsp, 8
        pop     r12
        pop     rbp
.return:
        ret
