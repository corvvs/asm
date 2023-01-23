default rel

global  _ft_memset
global  _ft_is_sign
global  _ft_is_space
global  _make_map
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
        push    rbp
        mov     rbp, rsp
        ; prologue
        mov     rax, rdi

.loop:
        test    rdx, rdx
        jz      .epilogue
        mov     byte [rdi], sil
        lea     rdi, [rdi + 1]
        sub     rdx, 1
        jmp     .loop

.epilogue:
        ; epilogue
        pop     rbp
        ret

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
        ; int is_space(int c)
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
        mov     rsi, qword 100000000000000000011111000000000B
        bt      rsi, rdi
        setb    al

        and     eax, ecx                ; cl = al && cl
        ; epilogue
        pop     rbp
        ret

_make_map:
        ; int make_map(const char *base, int char_map[UCHAR_MAX + 1])
        push    rbp
        mov     rbp, rsp
        ; prologue
        ; rdi = base, rsi = char_map

        push    r12
        push    r13
        push    r14
        push    rbx
        ; sub     rsp, 8

        mov     r12, rdi                ; base
        mov     r13, rsi                ; char_map
        mov     r14, 0                  ; i = 0

        ; char_map を -1 で初期化する
        mov     rdi, r13
        mov     rsi, 255
        mov     rdx, 256
        call    _ft_memset

        xor     eax, eax

.loop:
        movzx   ebx, byte [r12 + r14]   ; ebx = (unsigned char) base[i]
                                        ; ebx のゴミビットを掃除
        test    ebx, ebx
        jz      .epilogue

        ; is_sign なら invalid
        mov     edi, ebx
        call    _ft_is_sign
        test    eax, eax
        jnz     .ret_invalid

        ; is_space なら invalid
        mov     edi, ebx
        call    _ft_is_space
        test    eax, eax
        jnz     .ret_invalid

        ; char_map[base[i]] が FFH でないなら invalid
        mov     rax, [r13 + rbx]
        cmp     byte [r13 + rbx], byte 255
        jnz     .ret_invalid

        mov     byte [r13 + rbx], r14b          ; char_map[base[i]] = r14
        lea     rax, [r13 + rbx]
        mov     rax, [r13 + rbx]
        mov     rax, [r13 + rbx + 1]
        add     r14, 1                          ; i += 1
        mov     rax, r14
        jmp     .loop

.ret_invalid:
        mov     r14, 0

.epilogue:
        ; epilogue
        mov     rax, r14
        xor     r14, r14
        cmp     eax, 2
        cmovc   eax, r14d
        ; add     rsp, 8
        pop     rbx
        pop     r14
        pop     r13
        pop     r12
        pop     rbp
        ret


_ft_atoi_base:
        ; int ft_atoi_base(const char *str, const char *base)
        push    rbp
        mov     rbp, rsp
        push    r12
        push    r13
        push    r14
        push    r15
        push    rbx

        sub     rsp, 256        ; char_map

        sub     rsp, 8
        ; prologue
        mov     r12, rdi        ; r12 = str
        mov     r13, rsi        ; r13 = base
        mov     r14, 0          ; i = 0
        mov     r15d, -1        ; sign = -1

.call_make_map:
        mov     rdi, rsi
        lea     rsi, [rsp + 8]
        call    _make_map
        mov     r13d, eax


.loop_skip_space:
        movzx   edi, byte [r12 + r14]
        test    edi, edi
        jz      .end_skip_space
        call    _ft_is_space
        test    eax, eax
        jz      .end_skip_space
        lea     r14, [r14 + 1]
        jmp     .loop_skip_space

.end_skip_space:

.loop_skip_sign:
        movzx   edi, byte [r12 + r14]
        mov     ebx, edi
        test    edi, edi
        jz      .end_skip_sign
        call    _ft_is_sign
        test    eax, eax
        jz      .end_skip_sign
        mov     eax, r15d
        neg     eax
        cmp     ebx, '-'
        cmove   r15d, eax

        lea     r14, [r14 + 1]
        jmp     .loop_skip_sign

.end_skip_sign:
        mov     ebx, 0

.loop_atoi:
        movzx   rdi, byte [r12 + r14]           ; rdi = str[i]
        test    rdi, rdi
        jz      .end_atoi
        movzx   edi, byte [rsp + rdi + 8]       ; edi = char_map[str[i]]
        cmp     dil, 255                        ; edi == -1
        jz      .end_atoi
        imul    ebx, r13d
        add     ebx, edi
        lea     r14, [r14 + 1]
        jmp     .loop_atoi

.end_atoi:

.epilogue:
        mov     eax, ebx
        ; epilogue
        add     rsp, 8
        add     rsp, 256
        pop     rbx
        pop     r15
        pop     r14
        pop     r13
        pop     r12
        pop     rbp
        ret
