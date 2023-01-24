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

%endif
