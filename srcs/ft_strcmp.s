%include "srcs/ft_macro.s"
default rel

global _ft_strcmp
SECTION .text align=16

_ft_strcmp:
        ; push    rbp                   ; スタック使わないのでコメントアウト
        ; mov     rbp, rsp

        m_zeroize(rdx)                  ; rdx(i) を0初期化

.comparison:
        movzx   eax, byte [rdi + rdx]   ; s1[i] を rax に代入するのだが...
                                        ; - ソースに byte がついているので, コピーされるのは下位1バイト.
                                        ; - 代入先が eax なので, rax の下位4バイト.
                                        ; - movzx は, ソースのサイズがデスティネーションより小さい時に使うコピー命令.
                                        ;   - `z`はゼロ拡張, つまり余分なビットを0で埋めることを示す.
        movzx   ecx, byte [rsi + rdx]   ; こっちは s2[i] をゼロ拡張で rcx に代入.
        m_inc(rdx)

        cmp     al, cl                  ; al と cl を比較
                                        ; al, cl は rax, rcx の下位8バイト.
                                        ; 前もってゼロ拡張でコピーしているので, man の通り
                                        ; "The comparison is done using unsigned characters"となっている.
        jnz     .epilogue               ; al != cl ならループ脱出

        m_jump_if_nonzero       al, .comparison
                                        ; test op1 op2 は op1 & op2 を計算する.
                                        ; 計算結果自体は破棄されるが, 計算結果に応じてフラグレジスタを更新する:
                                        ; - SF: 結果が"マイナス"なら立つ
                                        ;   - MSBそのものと思えばよい
                                        ; - ZF: 結果が0なら立つ
                                        ; - PF: 結果のパリティ
                                        ; al & al がtrueなら, つまり al がヌル文字でないならループ継続

.epilogue:
        sub     eax, ecx                ; 返り値は s1[i] - s2[i].
                                        ; どちらもゼロ拡張になってるので普通に引いてok.

        ; pop     rbp                   ; スタック使わないのでコメントアウト
        ret
