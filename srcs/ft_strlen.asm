default rel                             ; これ以降のアドレッシングを相対にする. デフォルトは絶対.

global _ft_strlen                       ; シンボル _ft_strlen を外向きに公開する.
                                        ; cf. `$ nm ft_strlen.o`
                                        ; cf. `$ nm -g ft_strlen.o` (compare with above)
                                        ; cf. `man nm`
                                        ; > nm - display name list (symbol table)
                                        ;
                                        ; 「シンボル」は, 関数名, 変数名, 型名など何らかの「名前」となる文字列のこと?
                                        ; シンボルはユニークであるべき, だが"weak"なシンボルというものもある.
                                        ; -> weakシンボル同士は共存(というか合体)する.
                                        ;    weakシンボルとweakでないシンボルがある場合, 後者が勝つ(勝つとは?)

SECTION .text align=16                  ; これ以降のコードがどのセクションに配置されるかを指定する.
                                        ; cf. https://www.nasm.us/doc/nasmdoc7.html#section-7.3
                                        ; ".text" -> テキストセクション
                                        ; 名前的にはいかにも文字列がいそうだが, コード本体がいるところ.
                                        ; "align=16"
                                        ; cf. https://www.nasm.us/doc/nasmdoc8.html#section-8.1.2

_ft_strlen:                             ; これが global パワーで外部に公開される

        push    rbp                     ; rbpレジスタの値をスタックに積んだあと,
        mov     rbp, rsp                ; rbpにレジスタにrspレジスタの値をコピーする.
                                        ; これはルーチンワーク.
                                        ;
                                        ; rsp: スタックポインタ; スタックトップを指す
                                        ; rbp: (スタック)ベースポインタ; スタックベース(ボトム)を指す
                                        ; 「スタック」は「今いるサブルーチン(関数)が使っているスタック」.
                                        ; これはメモリのうち rbpからrspまでの領域にあたる.

                                        ; 最初の "push rbp" は, 「この関数の呼び出し元におけるrbp」をスタックに保存している.
                                        ; 保存するということは後で使うということ -> ret 直前を見る.
                                        ; 次の "mov rbp, rsp" は, rbp と rsp を一致させる -> この関数におけるスタックの使用量が0になる.

        mov     rax, -1                 ; レジスタraxに-1をコピーする
                                        ; raxは64ビットレジスタなので-1も64ビット整数.

align   8                               ; アライメントを8バイトにする.
                                        ; == 次の命令(データ)の開始アドレスが"可能な最小の8の倍数"になる.
                                        ; cf. https://www.nasm.us/doc/nasmdoc5.html#section-5.10.1
                                        ; この辺はコンパイラに逆アセさせたやつをみるとよくわかる

LOOP_START:                             ; このシンボルは外向きではない

        cmp     byte [rdi+rax+1], 0     ; アドレス rdi + rax + 1 にあるデータと 0 を, 1バイトだと思って比較する.
                                        ; 比較結果はeflagsレジスタのZFビットに書き込まれる.
                                        ; -> 一致するなら0, しないなら1
                                        ; cf. https://www.felixcloutier.com/x86/cmp

        lea     rax, [rax+1]            ; アドレス rax + 1 **そのもの**をraxレジスタにコピーする.
                                        ; 「アドレス rax + 1 にあるデータを」ではないことに注意.
                                        ; 要は rax += 1 である.
                                        ; "Load Effective Address"

        jnz     LOOP_START              ; eflagsレジスタのZFが**ゼロではない**場合, 与えられたラベルにジャンプする.
                                        ; "Jump if Non-Zero"

        pop     rbp                     ; スタックトップから1つポップしてrbpレジスタにコピー
        ret                             ; 呼び出し元に戻る
                                        ; cf. https://tanakamura.github.io/pllp/docs/asm_language.html
                                        ; > 1. rsp が指すアドレスから8byte値をロードし、その値をプログラムカウンタに格納
                                        ; > 2. rsp を 8 増やす

