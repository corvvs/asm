%include "srcs/ft_macro.s"

default rel

global  _ft_memset
global  _ft_is_sign
global  _ft_is_space
global  _ft_atoi_base

SECTION .text align=16

; [引数]
; rdi, rsi, rdx, rcx, r8, r9
; [callee-save]
; rbx, rsp, rbp, r12-15
; [caller-save]
; others

_ft_memset:
        ; void *memset(void *dst, int ch, size_t n)
        ; push    rbp
        ; mov     rbp, rsp
        ; prologue
        mov             rax, rdi

.loop:
        m_jump_if_zero  rdx, .epilogue
        mov             byte [rdi], sil
        m_inc(rdi)
        sub             rdx, 1
        jmp             .loop

.epilogue:
        ; epilogue
        ; pop     rbp
        ret

; レジスタ %1 内の文字が64未満の文字の集合 %2 に含まれるかどうかを al にセットする
%macro  in_charset      3
        mov     rsi, qword %2
        bt      rsi, %1
        setb    %3
%endmacro

; レジスタ %1 の値が %2 より小さいかどうかを cl にセットする
; rax を破壊する
%macro  is_lt           3
        mov     eax, %1
        cmp     eax, %2
        setb    %3
%endmacro

; レジスタ %1 の値が 64 より小さいかどうかを cl にセットする
; rax を破壊する
%macro  is_lt_64        2
        mov     eax, %1
        test    eax, dword 4294967232  ; eax が 64より小さい == eax が下位6ビットのみ == eax & 0xFFFFFFC0 がゼロ
        setz    %2
%endmacro

_ft_is_sign:
        ; int is_sign(int c)
        ; push    rbp
        ; mov     rbp, rsp
        ; prologue

        m_zeroize(rax)
        m_zeroize(rcx)
        is_lt_64        edi, al
        in_charset      rdi, CHARSET_SIGN, cl
                                        ; cl = c == '+' || c == '-'
        and             eax, ecx        ; cl = al && cl
        ; epilogue
        ; pop     rbp
        ret

_ft_is_space:
        ; int is_space(int c)
        ; push    rbp
        ; mov     rbp, rsp
        ; prologue

        m_zeroize(rax)
        m_zeroize(rcx)
        is_lt_64        edi, al
        in_charset      rdi, CHARSET_SPACE, cl
                                        ; cl = is space
        and             eax, ecx        ; cl = al && cl
        ; epilogue
        ; pop     rbp
        ret

_make_map:
        ; int make_map(const char *base, int char_map[UCHAR_MAX + 1])
        m_start_func
        ; prologue
        ; rdi = base, rsi = char_map
        %define base            r12
        %define char_map        r13
        push    base
        push    char_map
        push    r14
        push    rbx
        ; sub     rsp, 8

        mov     base, rdi
        mov     char_map, rsi
        m_zeroize(r14)                  ; i = 0

        ; char_map を -1 で初期化する
        mov     rdi, char_map
        mov     rsi, 255
        mov     rdx, 256
        call    _ft_memset

        m_zeroize(eax)
        m_zeroize(rbx)

.loop:
        movzx           ebx, byte [base + r14]  ; ebx = (unsigned char) base[i]
                                                ; ebx のゴミビットを掃除
        m_jump_if_zero  ebx, .epilogue          ; while (base[i]) {

        mov                     edi, ebx
        call                    _ft_is_sign
        m_jump_if_nonzero       eax, .invalid   ; break if (!ft_is_sign(base[i]));

        mov                     edi, ebx
        call                    _ft_is_space
        m_jump_if_nonzero       eax, .invalid   ; break if (!ft_is_space(base[i]));

        ; char_map[base[i]] が FFH でないなら invalid
        lea     rax, [char_map + rbx]
        cmp     byte [rax], byte 255
        jnz     .invalid                        ; break if (char_map[base[i]] != 255);
        mov     byte [rax], r14b                ; char_map[base[i]] = r14;
        m_inc(r14)
        jmp     .loop                           ; }

.invalid:
        m_zeroize(r14)

.epilogue:
        ; epilogue
        mov     rax, r14
        m_zeroize(r14)
        cmp     eax, 2
        cmovc   eax, r14d       ; eax = eax < 2 ? 0 : eax
        ; add     rsp, 8
        pop     rbx
        pop     r14
        pop     char_map
        pop     base
        %undef  base
        %undef  char_map
        m_end_func
        ret

_ft_atoi_base:
        ; int ft_atoi_base(const char *str, const char *base)
        m_start_func
        %define str     r12
        %define i       r14
        push    str
        push    r13             ; r13 = base OR len of base
        push    i
        push    r15
        push    rbx
        sub     rsp, 256        ; char_map
        sub     rsp, 8
        ; prologue

        mov     str, rdi        ; r12 = str
        mov     r13, rsi        ; r13 = base
        m_zeroize(i)            ; i = 0
        mov     r15d, -1        ; sign = -1
        m_zeroize(rbx)

.call_make_map:
        mov             rdi, rsi
        lea             rsi, [rsp + 8]
        call            _make_map
        m_jump_if_zero  eax, .epilogue
        mov             r13d, eax

.loop_skip_space:
        movzx           edi, byte [str + i]
        m_jump_if_zero  edi, .end_skip_space            ; NUL文字チェック
        call            _ft_is_space
        m_jump_if_zero  eax, .end_skip_space
        m_inc(i)
        jmp             .loop_skip_space
.end_skip_space:

.loop_skip_sign:                                        ; ここでは, ebx は一時変数として使う
        movzx           edi, byte [str + i]
        m_jump_if_zero  edi, .end_skip_sign             ; NUL文字チェック
        mov             ebx, edi                        ; call で破壊されたくないので ebx に入れておく
        call            _ft_is_sign
        m_jump_if_zero  eax, .end_skip_sign

        mov             eax, r15d                       ; もし符号が-だった場合はsignを反転する
        neg             eax                             ; eax = -sign
        cmp             ebx, '-'
        cmove           r15d, eax                       ; ebx == '-' だったなら sign = -sign

        m_inc(i)
        jmp             .loop_skip_sign
.end_skip_sign:

        m_zeroize(ebx)                                  ; これ以降, ebx は val として使う
.loop_atoi:
        movzx           rdi, byte [str + i]             ; rdi = str[i]
        m_jump_if_zero  rdi, .end_atoi                  ; NUL文字チェック
        movzx           edi, byte [rsp + rdi + 8]       ; edi = char_map[str[i]]
        cmp             dil, 255                        ; edi == -1
        jz              .end_atoi
        imul            ebx, r13d
        add             ebx, edi
        m_inc(i)
        jmp             .loop_atoi
.end_atoi:

.epilogue:
        mov     eax, ebx

        ; epilogue
        add     rsp, 8
        add     rsp, 256
        pop     rbx
        pop     r15
        pop     i
        pop     r13
        pop     str
        %undef  str
        %undef  i
        m_end_func
        ret
