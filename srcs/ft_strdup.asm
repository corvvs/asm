default rel

global _ft_strdup

extern _ft_strlen
extern _malloc
extern _ft_strcpy

SECTION .text align=16

_ft_strdup:
        push    rbp
        mov     rbp, rsp

        ; char	*ft_strdup(const char *str)
        ; rdi = str
        ; [caller-saved]
        ; rcx, rdx, r11, rax(返り値になる)
        ; [callee-saved]
        ; rbx, rsp, rbp, r12-r15

        push    rbx                             ; rbx を使うので退避しておく
        xor     rcx, rcx                        ; rcx(i) = 0

        mov     rbx, rdi                        ; rbx = str (退避)
        call    _ft_strlen                      ; n = strlen(str)

        lea     rdi, [rax + 1]                  ; d = malloc(n + 1)
        call    _malloc
                                                ; これ以降 n は使わないので rax は退避しない

        test    rax, rax                        ; rax のNULLチェック
        jz      COPY_END
COPY_START:                                     ; if (!d) {

        mov     rdi, rax                        ; rax は d
        mov     rsi, rbx                        ; rbx は rdi
        call    _ft_strcpy                      ; ft_strcpy(d, str)

COPY_END:                                       ; }

        pop     rbx                             ; スタックに退避しておいた rbx を戻す
        pop     rbp
        ret
