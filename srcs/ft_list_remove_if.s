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
        push    rbp
        mov     rbp, rsp
        push    r12
        sub     rsp, 8
        ; prologue
        test    rsi, rsi                        ; if (free_fct)
        jz      .epilogue
        mov     r12, rdi
        ; r12 = node
        mov     rdi, data_of(rdi)
        call    rsi                             ;       free_fct(node->data);
        mov     rdi, r12
        ; rdi = r12 = node

.epilogue:
        add     rsp, 8
        pop     r12
        pop     rbp
        jmp     _free                           ; free(node) ; 末尾呼び出し

_ft_list_clear:
        ; void ft_list_clear(t_list *list, void (*free_fct)(void *));
        push    rbp
        mov     rbp, rsp
        push    r12
        push    r13
        ; prologue

        mov     r12, rdi                        ; r12 = rdi = list
        mov     r13, rsi                        ; r13 = rsi = free_fct

.loop:                                          ; while (true) {
        test    r12, r12                        ;       if (!list)
        jz      .epilogue                       ;               break;

        mov     rax, next_of(r12)               ;       temp = list->next
        mov     rdi, r12
        mov     rsi, r13
        mov     r12, rax                        ;       list = temp(= list->next)
        call    _ft_list_delete                 ;       ft_list_delete(list, free_fct)
        jmp     .loop                           ; }

.epilogue:
        pop     r13
        pop     r12
        pop     rbp
        ret




_ft_list_remove_if:
        ; void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*compare)(), void (*free_fct)(void *));
        push    rbp
        mov     rbp, rsp
        ; rdi, rsi, rdx, rcx

        test    rdi, rdi
        jz      .epilogue
        test    rdx, rdx                ; if (!begin_list || !compare)
        jz      .epilogue               ;       return;


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

        xor     rax, rax
        mov     begin_list, rdi         ; r12 = rdi = begin_list
        mov     data_ref,   rsi         ; r13 = rsi = data_ref
        mov     compare,    rdx         ; r14 = rdx = compare
        mov     free_fct,   rcx         ; r15 = fcx = free_fct
        mov     curr,       [begin_list]; rbx = curr = *begin_list
        mov     _temp,      rax         ; [rsp + 24] = temp = NULL
        mov     _head,      rax         ; [rsp + 16] = head = NULL
        mov     _tail,      rax         ; [rsp + 8]  = tail = NULL

.loop:
        test    curr, curr
        jz      .semi_epilogue          ; while (curr) {

        mov     rax, next_of(curr)
        mov     _temp, rax              ;       temp = curr->next;

        mov     rdi, data_of(curr)
        mov     rsi, data_ref
        call    compare
        test    rax, rax
        jnz     .reserve                ;       if (compare(curr->data, data_ref) == 0) {
.remove:
        mov     rdi, curr
        mov     rsi, free_fct
        call    _ft_list_delete         ;               ft_list_delete(curr, free_fct);
        mov     curr, _temp             ;               curr = temp;
        jmp     .loop                   ;               continue;
                                        ;       }
.reserve:
        mov     rax, _tail
        test    rax, rax
        jz      .chained                ;       if (tail) {
        mov     rax, _tail
        mov     next_of(rax), curr      ;               tail->next = curr;
                                        ;       }
        ; 本当は mov next_of(_tail), curr(rbx) としたいが, それはできないので rax を経由する

.chained:
        mov     _tail, curr             ;       tail = curr;
        mov     curr, _temp             ;       curr = temp;
        mov     rax, _head
        test    rax, rax
        jnz     .loop                   ;       if (!head) {
        mov     rdi, _tail
        mov     _head, rdi              ;               head = tail
                                        ;       }
        jmp     .loop                   ; }


.semi_epilogue:
        mov     rax, _tail
        test    rax, rax
        jz      .nullified_tail_next    ; if (tail) {
        xor     rdi, rdi
        mov     rax, _tail
        mov     next_of(rax), rdi       ;       tail->next = NULL;
                                        ; }
.nullified_tail_next:
        mov     rax, _head
        mov     [begin_list], rax       ; *begin_list = head
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

.epilogue:
        pop     rbp
        ret
