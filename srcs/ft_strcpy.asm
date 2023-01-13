default rel

global _ft_strcpy
SECTION .text align=16

_ft_strcpy:                                     ; dst は rdi, src は rsi に入る.
        push    rbp
        mov     rbp, rsp

        mov     rax, 0                          ; インデックスi; dst[i], src[i] として使う.

align   8

LOOP_START:
        mov     dl, [rsi + rax]                 ; [rsi + rax] (src[i]) を一旦 dl(rdx) にコピー
        mov     [rdi + rax], dl                 ; その後 rl を [rdi + rax] (dst[i]) にコピー
                                                ; まとめて mov [rdi + rax], [rsi + rax] とするのはアウト
                                                ; -> mov はメモリtoメモリの転送ができないため
                                                ; 8ビットだけなら本当はできるんじゃね？
        lea     rax, [rax + 1]
        cmp     dl, 0
        jnz     LOOP_START

        lea     rax, [rdi]                      ; rdi に入っているアドレスが指す値, ではなくアドレス自体をraxに入れる
                                                ; rax は(1st)リターンレジスタ
                                                ; -> 2nd以降のリターンレジスタって何に使うの?
        pop     rbp
        ret
