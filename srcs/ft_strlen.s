; ** このファイルはマクロなしで **
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
        ; size_t ft_strlen(const char *str)
        ; push    rbp                   ; rbpレジスタの値をスタックに積んだあと,
        ; mov     rbp, rsp              ; rbpにレジスタにrspレジスタの値をコピーする.
        ;                               ; これはルーチンワーク.
                                        ; ...なのだがスタック使わないので不要
                                        ; rsp: スタックポインタ; スタックトップを指す
                                        ; rbp: (スタック)ベースポインタ; スタックベース(ボトム)を指す
                                        ; 「スタック」は「今いるサブルーチン(関数)が使っているスタック」.
                                        ; これはメモリのうち rbpからrspまでの領域にあたる.
                                        ; 最初の "push rbp" は, 「この関数の呼び出し元におけるrbp」をスタックに保存している.
                                        ; 保存するということは後で使うということ -> ret 直前を見る.
                                        ; 次の "mov rbp, rsp" は, rbp と rsp を一致させる -> この関数におけるスタックの使用量が0になる.

        mov     rax, -1                 ; レジスタraxに-1をコピーする
                                        ; raxは64ビットレジスタなので-1も64ビットunsigned整数.

align   8                               ; アライメントを8バイトにする.
                                        ; == 次の命令(データ)の開始アドレスが"可能な最小の8の倍数"になる.
                                        ; cf. https://www.nasm.us/doc/nasmdoc5.html#section-5.10.1
                                        ; この辺はコンパイラに逆アセさせたやつをみるとよくわかる

.loop_start:                            ; このシンボルは外向きではない

        test     byte [rdi + rax + 1], 255
                                        ; アドレス rdi + rax + 1 にあるデータを, 1バイトだと思って 255 とandをとる.
                                        ; 結果が0になるなら, eflagsレジスタのZFビットは1となる.
                                        ; そうでないなら0となる.
                                        ; cf. https://www.felixcloutier.com/x86/cmp
                                        ; rdi は第1引数が入っているアドレス.

        lea     rax, [rax + 1]          ; アドレス rax + 1 **そのもの**をraxレジスタにコピーする.
                                        ; 「アドレス rax + 1 にあるデータを」ではないことに注意.
                                        ; 要は rax += 1 である.
                                        ; "Load Effective Address"
                                        ; lea はフラグレジスタを変えないので

        jnz     .loop_start             ; eflagsレジスタのZFが**ゼロではない**場合, 与えられたラベルにジャンプする.
                                        ; "Jump if Non-Zero"

.epilogue:
                                        ; 返り値は rax そのまま
        ; pop     rbp                   ; スタックトップから1つポップしてrbpレジスタにコピー
                                        ; ...なのだがスタック使わないので不要
        ret                             ; 呼び出し元に戻る
                                        ; cf. https://tanakamura.github.io/pllp/docs/asm_language.html
                                        ; > 1. rsp が指すアドレスから8byte値をロードし、その値をプログラムカウンタに格納
                                        ; > 2. rsp を 8 増やす

align   8
global _ft_strlen_fast
_ft_strlen_fast:
        %define given   rdi
        %define hi      rsi
        %define lo      rdx
        %define str     rax
        %define x       rcx
        %define y       r8
        mov     hi, 8080808080808080H
        mov     lo, 0101010101010101H
        mov     str, given

.loop:
        ; x = *str
        ; while (!((x - lo) & ~x & hi))
        mov     x, [str]        ; x = *str
        mov     y, x            ; y = x
        sub     x, lo           ; x = x - lo
        not     y               ; y = ~y
        and     x, y            ; x = x & y
        test    x, hi           ; x = x & hi
        lea     str, [str + 8]
        jz      .loop

.found:
        lea     str, [str - 8]
        cmp     byte [str], 0
        je      .epilogue
        lea     str, [str + 1]
        cmp     byte [str], 0
        je      .epilogue
        lea     str, [str + 1]
        cmp     byte [str], 0
        je      .epilogue
        lea     str, [str + 1]
        cmp     byte [str], 0
        je      .epilogue
        lea     str, [str + 1]
        cmp     byte [str], 0
        je      .epilogue
        lea     str, [str + 1]
        cmp     byte [str], 0
        je      .epilogue
        lea     str, [str + 1]
        cmp     byte [str], 0
        je      .epilogue
        lea     str, [str + 1]
        cmp     byte [str], 0
        je      .epilogue
        lea     str, [str + 1]

.epilogue:
        lea     rax, [str]
        sub     rax, given
        %undef  given
        %undef  hi
        %undef  lo
        %undef  str
        %undef  x
        %undef  y
        ret
