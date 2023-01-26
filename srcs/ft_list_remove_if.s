%include "srcs/ft_macro.s"
%include "srcs/ft_list.s"

default rel

global  _ft_list_delete
global  _ft_list_clear
global  _ft_list_remove_if
extern  _free
SECTION .text align=16

_ft_list_delete:
        ; void ft_list_delete(t_list *node, void (*free_fct)(void *))
        m_jump_if_zero  rsi, .return            ; !free_fct ならprologueすら飛ばして即 free に移る

        push    rbp
        mov     rbp, rsp
        push    r12
        sub     rsp, 8
        ; prologue
        mov     r12, rdi                ; r12 = node
        mov     rdi, data_of(rdi)
        call    rsi                     ; free_fct(node->data);
        mov     rdi, r12                ; rdi = r12 = node

        add     rsp, 8
        pop     r12
        pop     rbp
.return:
        jmp     _free                   ; free(node) ; 末尾呼び出し

_ft_list_clear:
        ; void ft_list_clear(t_list *list, void (*free_fct)(void *));
        push    rbp
        mov     rbp, rsp
        %define list            r12
        %define free_fct        r13
        push    list
        push    free_fct
        ; prologue
        mov     list, rdi
        mov     free_fct, rsi

.loop:                                          ; while (1) {
        m_jump_if_zero  list, .epilogue         ;       break if (!list)

        mov     rax, next_of(list)              ;       temp = list->next
        mov     rdi, list
        mov     rsi, free_fct
        mov     list, rax                       ;       list = temp(= list->next)
        call    _ft_list_delete                 ;       ft_list_delete(list, free_fct)
        jmp     .loop                           ; }

.epilogue:
        pop     free_fct
        pop     list
        %undef  list
        %undef  free_fct
        pop     rbp
        ret




_ft_list_remove_if:
        ; void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*compare)(), void (*free_fct)(void *));
        m_jump_if_zero  rdi, .return    ; return if (!begin_list)
        m_jump_if_zero  rdx, .return    ; return if (!compare)

        push    rbp
        mov     rbp, rsp
        %define begin_list      r12
        %define data_ref        r13
        %define compare         r14
        %define free_fct        r15
        %define curr            rbx
        %define _temp           [rsp + 24]
        %define _head           [rsp + 16]
        %define _tail           [rsp + 8]
        push    begin_list
        push    data_ref
        push    compare
        push    free_fct
        push    curr
        sub     rsp, 40

        mov     begin_list, rdi
        mov     data_ref,   rsi
        mov     compare,    rdx
        mov     free_fct,   rcx
        mov     curr,       [begin_list]; curr = *begin_list
        m_zeroize(rax)
        mov     _temp,      rax         ; temp = NULL
        mov     _head,      rax         ; head = NULL
        mov     _tail,      rax         ; tail = NULL

.loop:
        m_jump_if_zero  curr, .semi_epilogue
                                        ; while (curr) {
        m_mmmov _temp, rax, next_of(curr)
                                        ; temp = curr->next;

        mov     rdi, data_of(curr)
        mov     rsi, data_ref
        call    compare
        m_jump_if_nonzero       rax, .reserve
                                        ;       if (compare(curr->data, data_ref) == 0) {
.remove:
        mov     rdi, curr
        mov     rsi, free_fct
        call    _ft_list_delete         ;               ft_list_delete(curr, free_fct);
        mov     curr, _temp             ;               curr = temp;
        jmp     .loop                   ;               continue;
                                        ;       }
.reserve:
        mov     rax, _tail
        m_jump_if_zero  rax, .chained   ;       if (tail) {
        mov     next_of(rax), curr      ;               tail->next = curr;
                                        ;       }
        ; 本当は mov next_of(_tail), curr(rbx) としたいが, それはできないので rax を経由する

.chained:
        mov     _tail, curr             ;       tail = curr;
        mov     curr, _temp             ;       curr = temp;
        mov     rax, _head
        m_jump_if_nonzero       rax, .loop
        m_mmmov _head, rdi, _tail       ;       head = tail if (!head);        
        jmp     .loop                   ; }


.semi_epilogue:
        mov     rax, _tail
        m_jump_if_zero  rax, .nullified_tail_next
                                        ; if (tail) {
        m_zeroize(rdi)
        mov     rax, _tail
        mov     next_of(rax), rdi       ;       tail->next = NULL;
                                        ; }
.nullified_tail_next:
        m_mmmov [begin_list], rax, _head; *begin_list = head
        add     rsp, 40
        pop     curr
        pop     free_fct
        pop     compare
        pop     data_ref
        pop     begin_list
        %undef  begin_list
        %undef  data_ref
        %undef  compare
        %undef  free_fct
        %undef  curr
        %undef  _temp
        %undef  _head
        %undef  _tail
        pop     rbp

.return:
        ret
