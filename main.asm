section .data
    newline db 0xA
    hostname_msg db "Hostname: ", 0
    os_version_msg db "OS Version: ", 0
    arch_msg db "Architecture: ", 0
    buffer_size equ 256

section .bss
    hostname resb buffer_size        ; Buffer for hostname
    uname_buffer resb 256            ; Buffer for uname syscall data

section .text
    global _start

_start:
    ; Print hostname
    mov rax, 0x00            ; syscall number for sys_gethostname
    lea rdi, [hostname]
    mov rsi, buffer_size
    syscall

    ; Print hostname message
    mov rax, 0x01            ; syscall number for sys_write
    mov rdi, 0x01            ; file descriptor 1 is stdout
    lea rsi, [hostname_msg]
    mov rdx, 10              ; length of hostname_msg
    syscall

    ; Print hostname
    mov rax, 0x01            ; syscall number for sys_write
    mov rdi, 0x01            ; file descriptor 1 is stdout
    lea rsi, [hostname]
    mov rdx, buffer_size     ; length of hostname buffer
    syscall

    ; Print newline
    mov rax, 0x01            ; syscall number for sys_write
    mov rdi, 0x01            ; file descriptor 1 is stdout
    lea rsi, [newline]
    mov rdx, 1               ; length of newline
    syscall

    ; Print OS version (using uname syscall)
    mov rax, 0x3F           ; syscall number for sys_uname (63 in decimal)
    lea rdi, [uname_buffer] ; address of the buffer
    syscall

    ; Print OS version message
    mov rax, 0x01           ; syscall number for sys_write
    mov rdi, 0x01           ; file descriptor 1 is stdout
    lea rsi, [os_version_msg]
    mov rdx, 12             ; length of os_version_msg
    syscall

    ; Print OS version
    ; Note: The uname_buffer may include more information, need proper parsing
    mov rax, 0x01           ; syscall number for sys_write
    mov rdi, 0x01           ; file descriptor 1 is stdout
    lea rsi, [uname_buffer] ; Print the first part of uname_buffer
    mov rdx, 256            ; length of uname_buffer (adjust if necessary)
    syscall

    ; Print newline
    mov rax, 0x01           ; syscall number for sys_write
    mov rdi, 0x01           ; file descriptor 1 is stdout
    lea rsi, [newline]
    mov rdx, 1              ; length of newline
    syscall

    ; Print architecture message
    mov rax, 0x01           ; syscall number for sys_write
    mov rdi, 0x01           ; file descriptor 1 is stdout
    lea rsi, [arch_msg]
    mov rdx, 13             ; length of arch_msg
    syscall

    ; Print architecture (assuming it's fixed as x86_64)
    mov rax, 0x01           ; syscall number for sys_write
    mov rdi, 0x01           ; file descriptor 1 is stdout
    lea rsi, [arch_msg + 13] ; Point to the architecture string
    mov rdx, 7              ; length of architecture string
    syscall

    ; Print newline
    mov rax, 0x01           ; syscall number for sys_write
    mov rdi, 0x01           ; file descriptor 1 is stdout
    lea rsi, [newline]
    mov rdx, 1              ; length of newline
    syscall

    ; Exit the program
    mov rax, 60             ; syscall number for sys_exit
    xor rdi, rdi            ; exit code 0
    syscall
