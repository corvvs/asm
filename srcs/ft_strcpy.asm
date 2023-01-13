default rel

global _ft_strcpy
SECTION .text align=16

_ft_strcpy:                                     ; dst は rdi, src は rsi に入る.
        push    rbp
        mov     rbp, rsp

        mov     rax, 0

align   8

LOOP_START:
        cmp     byte [rsi + rax], 0
        mov     r11, [rsi + rax]                ; [rsi + rax] (src[i]) を一旦 r11 にコピー
        mov     [rdi + rax], r11                ; その後 r11 を [rdi + rax] (dst[i]) にコピー
                                                ; まとめて mov [rdi + rax], [rsi + rax] とするのはアウト
                                                ; -> mov はメモリtoメモリの転送ができないため
        lea     rax, [rax + 1]
        jnz     LOOP_START

        lea     rax, [rdi]                      ; rdi に入っているアドレスが指す値, ではなくアドレス自体をraxに入れる
                                                ; rax は(1st)リターンレジスタ
                                                ; -> 2nd以降のリターンレジスタって何に使うの?
        pop     rbp
        ret
