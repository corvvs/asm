%ifndef FT_MACRO_S
    %define FT_MACRO_S

; システムコール番号
%define NR_READ     3
%define NR_WRITE    4

; システムコール呼び出し
%macro  ft_syscall 1
    mov     rax, %1
    or      rax, 0x2000000
    syscall
%endmacro

; errno
%define ENOMEM  12

; errno使用準備
%macro  use_errno 0
    extern  ___error
%endmacro


; errno設定
%macro  set_errno 1
    call    ___error
    mov     dword [rax], %1 ; set errno
%endmacro

%macro  m_start_func 0
        push    rbp                   ; rbpレジスタの値をスタックに積んだあと,
        mov     rbp, rsp              ; rbpにレジスタにrspレジスタの値をコピーする.
%endmacro

%macro  m_end_func 0
        pop     rbp                   ; スタックトップから1つポップしてrbpレジスタにコピー
        ret
%endmacro

%define m_zeroize(reg)  xor     reg, reg

%macro  m_jump_if_zero      2
        ; reg, label
        ; reg の値が0なら label に飛ぶ
        test    %1, %1
        jz      %2
%endmacro

%macro  m_jump_if_nonzero   2
        ; reg, label
        ; reg の値が0でないなら label に飛ぶ
        test    %1, %1
        jnz     %2
%endmacro

%define m_inc(reg)  lea reg, [reg + 1]

%macro  m_mmmov 3
        ; to, via, from
        ; メモリ間ムーブ(memory to memory move)
        ; アドレス from のデータをレジスタ via を経由して アドレス to にコピーする
        ; eg.
        ; m_mmmov   [rdi], rax, [rdi + 8]
        ; は
        ; mov       rax, [rdi + 8]
        ; mov       [rdi], rax
        ; と等価.
        mov     %2, %3
        mov     %1, %2
%endmacro

; '-' or '+'
; 43, 45 が立っている
%define CHARSET_SIGN    qword   0000000000000000001010000000000000000000000000000000000000000000B

; ' ' or '\r' or '\f' or '\v' or '\n' or '\t'
; 9, 10, 11, 12, 13, 32 が立っている
%define CHARSET_SPACE   qword   0000000000000000000000000000000100000000000000000011111000000000B

%endif
