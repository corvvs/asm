default rel

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

_ft_is_sign:
        ; int is_sign(int c)
        push    rbp
        mov     rbp, rsp
        ; prologue

        ; al = c < 64
        xor     rcx, rcx                ; ゴミビットを消すため
        mov     eax, edi
        cmp     eax, 64
        setb    cl

        ; cl = c == '+' || c == '-'
        xor     rax, rax
        mov     rsi, qword 1010000000000000000000000000000000000000000000B
        bt      rsi, rdi
        setb    al

        and     eax, ecx                ; cl = al && cl
        ; epilogue
        pop     rbp
        ret

_ft_is_space:
        ; int is_sign(int c)
        push    rbp
        mov     rbp, rsp
        ; prologue

        ; al = c < 64
        xor     rcx, rcx                ; ゴミビットを消すため
        mov     eax, edi
        cmp     eax, 64
        setb    cl

        ; cl = is space
        xor     rax, rax
        mov     rsi, qword 100000011111000000000B
        bt      rsi, rdi
        setb    al

        and     eax, ecx                ; cl = al && cl
        ; epilogue
        pop     rbp
        ret

_ft_atoi_base:
        ; int ft_atoi_base(const char *str, const char *base)
        push    rbp
        mov     rbp, rsp
        ; prologue






        ; epilogue
        pop     rbp
        ret
