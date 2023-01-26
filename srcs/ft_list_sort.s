%include "srcs/ft_macro.s"
%include "srcs/ft_list.s"

default rel

global  _ft_merge_list
global  _ft_list_merge_sort
global  _ft_list_sort
SECTION .text align=16

; 2つのソート済みリスト top, bot を, コンパレータ compare を用いてマージする.
_ft_merge_list:
        ; t_list *ft_merge_list(t_list *top, t_list *bot, int (*compare)())
        push    rbp
        mov     rbp, rsp
        %define head    r12
        %define tail    r13
        %define top     r15
        %define bot     rbx
        %define compare r14
        push    head
        push    tail
        push    compare
        push    top
        push    bot
        sub     rsp, 8
        ; prologue
        m_zeroize(head)
        m_zeroize(tail)
        mov     top, rdi
        mov     bot, rsi
        mov     compare, rdx

.loop:                                          ; while (1) {
        test    head, head                      ; if (!head)
        cmove   head, tail                      ;       head = tail;

        m_zeroize(rax)
        or              rax, top
        or              rax, bot
        m_jump_if_zero  rax, .loop_end          ; if (!(top || bot))
                                                ;       break;

        ; top と bot のどちらを tail に追加するかを決める
        m_jump_if_zero  bot, .push_back_top     ; !bot -> push_back_top
        m_jump_if_zero  top, .push_back_bot     ; !top -> push_back_pop
        mov             rdi, data_of(top)
        mov             rsi, data_of(bot)
        call            compare
        test            eax, eax
                                                ; jns: jump if not signed
        jns     .push_back_bot                  ; eax >= 0      -> push_back_bot
                                                ; otherwise     -> push_back_top

.push_back_top:
        m_jump_if_zero  tail, .push_back_top_skip; if (tail)
        mov     next_of(tail), top              ;       tail->next = top
.push_back_top_skip:
        mov     tail, top                       ; tail = top
        mov     top, next_of(top)               ; top = top->next
        jmp     .loop

.push_back_bot:
        m_jump_if_zero  tail, .push_back_bot_skip; if (tail)
        mov     next_of(tail), bot              ;       tail->next = bot
.push_back_bot_skip:
        mov     tail, bot                       ; tail = bot
        mov     bot, next_of(bot)               ; bot = bot->next
        jmp     .loop


.loop_end:                                      ; }

        m_jump_if_zero  tail, .cutted_out
        m_zeroize(rax)
        mov     next_of(tail), rax              ; tail->next = NULL if (tail)
.cutted_out:
        mov     rax, head

.epilogue:
        add     rsp, 8
        pop     bot
        pop     top
        pop     compare
        pop     tail
        pop     head
        %undef  head
        %undef  tail
        %undef  top
        %undef  bot
        %undef  cmp
        pop     rbp
        ret

; (部分)リスト list に対し, コンパレータ compare によるマージソートを実施する.
_ft_list_merge_sort:
        ; t_list *ft_list_merge_sort(t_list *list, int (*compare)())
        push    rbp
        mov     rbp, rsp
        %define top             r12
        %define bot             r13
        %define bot_prev        r14
        push    top
        push    bot
        push    bot_prev
        sub     rsp, 8
        ; prologue

        mov     top, rdi
        mov     bot, rdi                        ; top = bot = list
                                                ; remark this: bot <= top
        m_zeroize(bot_prev)
.loop:
        m_jump_if_zero  top, .end_loop
        mov             bot_prev, bot           ; bot_prev = bot
        mov             bot, next_of(bot)       ; bot = bot->next
        mov             top, next_of(top)       ; top = top->next
        m_jump_if_zero  top,  .loop
        mov             top, next_of(top)       ; top = top->next if (top)
        jmp             .loop

.end_loop:
        m_jump_if_zero  bot_prev, .cutted_out

        m_zeroize(rax)
        mov             next_of(bot_prev), rax  ; bot_prev->next = 0 if (bot_prev)

.cutted_out:
        mov             rax, rdi                ; rax = list
        m_jump_if_zero  bot, .epilogue

        ; これ以降 bot_prev は使わないので, r14 を rsi(cmp) の退避先に使う
        mov     r14, rsi
        call    _ft_list_merge_sort             ; ft_list_merge_sort(list, cmp)
        mov     top, rax
        mov     rdi, bot
        mov     rsi, r14
        call    _ft_list_merge_sort             ; ft_list_merge_sort(bot, cmp)
        mov     rdi, top
        mov     rsi, rax                        ; rax is bot
        mov     rdx, r14
        call    _ft_merge_list                  ; ft_merge_list(top, bot, cmp)

.epilogue:
        add     rsp, 8
        pop     bot_prev
        pop     bot
        pop     top
        %undef  top
        %undef  bot
        %undef  bot_prev
        pop     rbp
        ret



_ft_list_sort:
        ; void ft_list_sort(t_list **begin_list, int (*cmp)())

        m_jump_if_zero  rdi, .epilogue  ; begin_list == NULL なら終了
        m_jump_if_zero  rsi, .epilogue  ; cmp == NULL なら終了

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
