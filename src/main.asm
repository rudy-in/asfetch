section .data
    newline db 0xA
    hostname_msg db "Hostname: ", 0
    os_version_msg db "OS: ", 0
    arch_msg db "Architecture: ", 0
    buffer_size equ 256

section .bss
    hostname resb buffer_size  ; Buffer for hostname
    uname_buffer resb buffer_size  ; Buffer for uname

section .text
    global _start
    extern fetch_os
    extern fetch_packages
    extern fetch_shell
    extern fetch_terminal
    extern fetch_resolution
    extern fetch_cpu
    extern fetch_gpu

_start:
    ; Print hostname
    mov rax, 0x00    ; syscall number for sys_gethostname
    mov rdi, hostname
    mov rsi, buffer_size
    syscall

    mov rax, 0x01    ; syscall number for sys_write
    mov rdi, 0x01    ; file descriptor 1 is stdout
    mov rsi, hostname_msg
    mov rdx, 10      ; length of hostname_msg
    syscall

    mov rax, 0x01    ; syscall number for sys_write
    mov rdi, 0x01    ; file descriptor 1 is stdout
    mov rsi, hostname
    mov rdx, 256     ; length of hostname buffer
    syscall

    ; Print newline
    mov rax, 0x01    ; syscall number for sys_write
    mov rdi, 0x01    ; file descriptor 1 is stdout
    mov rsi, newline
    mov rdx, 1       ; length of newline
    syscall

    ; Fetch and print OS version
    call fetch_os

    ; Print newline
    mov rax, 0x01    ; syscall number for sys_write
    mov rdi, 0x01    ; file descriptor 1 is stdout
    mov rsi, newline
    mov rdx, 1       ; length of newline
    syscall

    ; Fetch and print packages
    call fetch_packages

    ; Print newline
    mov rax, 0x01    ; syscall number for sys_write
    mov rdi, 0x01    ; file descriptor 1 is stdout
    mov rsi, newline
    mov rdx, 1       ; length of newline
    syscall

    ; Fetch and print shell
    call fetch_shell

    ; Print newline
    mov rax, 0x01    ; syscall number for sys_write
    mov rdi, 0x01    ; file descriptor 1 is stdout
    mov rsi, newline
    mov rdx, 1       ; length of newline
    syscall

    ; Fetch and print terminal
    call fetch_terminal

    ; Print newline
    mov rax, 0x01    ; syscall number for sys_write
    mov rdi, 0x01    ; file descriptor 1 is stdout
    mov rsi, newline
    mov rdx, 1       ; length of newline
    syscall

    ; Fetch and print resolution
    call fetch_resolution

    ; Print newline
    mov rax, 0x01    ; syscall number for sys_write
    mov rdi, 0x01    ; file descriptor 1 is stdout
    mov rsi, newline
    mov rdx, 1       ; length of newline
    syscall

    ; Fetch and print CPU
    call fetch_cpu

    ; Print newline
    mov rax, 0x01    ; syscall number for sys_write
    mov rdi, 0x01    ; file descriptor 1 is stdout
    mov rsi, newline
    mov rdx, 1       ; length of newline
    syscall

    ; Fetch and print GPU
    call fetch_gpu

    ; Exit the program
    mov rax, 60      ; syscall number for sys_exit
    xor rdi, rdi     ; exit code 0
    syscall
