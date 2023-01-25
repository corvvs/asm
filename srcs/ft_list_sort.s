%include "srcs/ft_macro.s"
%include "srcs/ft_list.s"

default rel

global  _ft_merge_list
global  _ft_list_merge_sort
global  _ft_list_sort
SECTION .text align=16

_ft_merge_list:
        ; t_list *ft_merge_list(t_list *top, t_list *bot, int (*cmp)())
        push    rbp
        mov     rbp, rsp
        push    r12
        push    r13
        push    r14
        push    r15
        push    rbx
        sub     rsp, 8
        ; prologue

        xor     r12, r12                        ; head  = r12
        xor     r13, r13                        ; tail  = r13
        mov     r15, rdi                        ; top   = r15
        mov     rbx, rsi                        ; bot   = rbx
        mov     r14, rdx                        ; cmp   = r14

.loop:
        test    r12, r12
        cmove   r12, r13                        ; head = tail if (!head)

        xor     rax, rax
        or      rax, r15
        or      rax, rbx
        test    rax, rax                        ; !!(top | bot)
        jz      .loop_end                       ; !(top || bot) -> 脱出

        ; top と bot のどちらを tail に追加するかを決める
        test    rbx, rbx
        jz      .push_back_top                  ; !bot -> push_back_top
        test    r15, r15
        jz      .push_back_bot                  ; !top -> push_back_pop
        mov     rdi, [r15 + ft_list_data]
        mov     rsi, [rbx + ft_list_data]
        call    r14                             ; r14 には cmp が入っている
        test    eax, eax
                                                ; jns: jump if not signed
        jns     .push_back_bot                  ; eax >= 0      -> push_back_bot
                                                ; otherwise     -> push_back_top

.push_back_top:
        test    r13, r13
        jz      .push_back_top_skip             ; if (tail)
        mov     [r13 + ft_list_next], r15       ;       tail->next = top
.push_back_top_skip:
        mov     r13, r15                        ; tail = top
        mov     r15, [r15 + ft_list_next]       ; top = top->next
        jmp     .loop

.push_back_bot:
        test    r13, r13
        jz      .push_back_bot_skip             ; if (tail)
        mov     [r13 + ft_list_next], rbx       ;       tail->next = bot
.push_back_bot_skip:
        mov     r13, rbx                        ; tail = bot
        mov     rbx, [rbx + ft_list_next]       ; bot = bot->next
        jmp     .loop


.loop_end:

        test    r13, r13
        jz      .cutted_out

        xor     rax, rax
        mov     [r13 + ft_list_next], rax
.cutted_out:
        mov     rax, r12

.epilogue:
        add     rsp, 8
        pop     rbx
        pop     r15
        pop     r14
        pop     r13
        pop     r12
        pop     rbp
        ret

_ft_list_merge_sort:
        ; t_list *ft_list_merge_sort(t_list *list, int (*cmp)())
        push    rbp
        mov     rbp, rsp
        push    r12                             ; r12 = top
        push    r13                             ; r13 = bot
        push    r14                             ; r14 = bot_prev
        sub     rsp, 8
        ; prologue

        mov     r12, rdi
        mov     r13, rdi                        ; top = bot = list
                                                ; remark this: bot <= top
        xor     r14, r14
.loop:
        test    r12, r12
        jz      .end_loop
        mov     r14, r13                        ; bot_prev = bot
        mov     r13, [r13 + ft_list_next]       ; bot = bot->next
        mov     r12, [r12 + ft_list_next]       ; top = top->next
        test    r12, r12
        jz      .loop
        mov     r12, [r12 + ft_list_next]       ; top = top->next if (top)
        jmp     .loop

.end_loop:
        test    r14, r14
        jz      .cutted_out

        xor     rax, rax
        mov     [r14 + ft_list_next], rax       ; bot_prev->next = 0 if (bot_prev)

.cutted_out:
        mov     rax, rdi                        ; rax = list
        test    r13, r13
        jz      .epilogue

        mov     r14, rsi                        ; r14 = cmp
        call    _ft_list_merge_sort             ; ft_list_merge_sort(list, cmp)
        mov     r12, rax
        mov     rdi, r13
        mov     rsi, r14
        call    _ft_list_merge_sort             ; ft_list_merge_sort(bot, cmp)
        mov     rdi, r12
        mov     rsi, rax
        mov     rdx, r14
        call    _ft_merge_list

.epilogue:
        add     rsp, 8
        pop     r14
        pop     r13
        pop     r12
        pop     rbp
        ret



_ft_list_sort:
        ; void ft_list_sort(t_list **begin_list, int (*cmp)())

        test    rdi, rdi
        jz      .epilogue       ; begin_list == NULL なら終了
        test    rsi, rsi
        jz      .epilogue       ; cmp == NULL なら終了

        push    rbp
        mov     rbp, rsp
        push    r12
        sub     rsp, 8
        ; prologue

        mov     r12, rdi
        mov     rdi, [rdi]
        call    _ft_list_merge_sort
        mov     [r12], rax

        add     rsp, 8
        pop     r12
        pop     rbp

.epilogue:
        ret
