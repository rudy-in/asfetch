section .data
    filename db "/etc/os-release", 0
    pretty_name_prefix db "PRETTY_NAME=", 0
    pretty_name_prefix_len equ $ - pretty_name_prefix
    newline db 0xA

section .bss
    buffer resb 1024

section .text
    global fetch_os

fetch_os:
    ; Open the file
    mov rax, 2                 ; sys_open
    mov rdi, filename          ; File path
    mov rsi, 0                 ; O_RDONLY
    syscall

    ; Check for errors
    test rax, rax
    js open_error
    mov rdi, rax               ; File descriptor

    ; Read the file
    mov rax, 0                 ; sys_read
    lea rsi, [buffer]          ; Buffer address
    mov rdx, 1024              ; Number of bytes to read
    syscall

    ; Close the file
    mov rax, 3                 ; sys_close
    syscall

    ; Find PRETTY_NAME
    lea rsi, [buffer]          ; Buffer address
    call find_pretty_name
    test rax, rax              ; Check if found
    jz no_pretty_name

    ; Print the pretty name
    mov rax, 1                 ; sys_write
    mov rdi, 1                 ; File descriptor: stdout
    lea rsi, [buffer]          ; Buffer with pretty name
    mov rdx, rax               ; Length of pretty name
    syscall

    ; Print newline
    mov rax, 1                 ; sys_write
    mov rdi, 1                 ; File descriptor: stdout
    lea rsi, [newline]         ; Newline character
    mov rdx, 1                 ; Length of newline
    syscall

    ; Exit
    mov rax, 60                ; sys_exit
    xor rdi, rdi               ; Exit code 0
    syscall

open_error:
    ; Exit with error code
    mov rax, 60                ; sys_exit
    mov rdi, 1                 ; Exit code 1
    syscall

no_pretty_name:
    ; Exit with code 0
    mov rax, 60                ; sys_exit
    xor rdi, rdi               ; Exit code 0
    syscall

find_pretty_name:
    ; Searches for "PRETTY_NAME=" in the buffer
    ; Expects rsi to point to the buffer
    ; Returns length of PRETTY_NAME value in rax or 0 if not found

    mov rbx, rsi                    ; Start position
    mov rcx, pretty_name_prefix_len ; Prefix length

search_loop:
    lea rsi, [pretty_name_prefix]   ; Prefix address
    mov rdi, rbx                    ; Buffer position
    mov rax, rcx                    ; Length of prefix
    repe cmpsb                     ; Compare prefix
    jne next_char                   ; Not a match, check next

    ; Move to the start of the value
    add rbx, pretty_name_prefix_len
    mov rsi, rbx                    ; Point to the value
    mov rcx, 1024                   ; Max length to search

find_end:
    mov al, [rsi]                   ; Load byte
    cmp al, [newline]               ; Check for newline
    je end_found                    ; End found
    inc rsi                         ; Move to next byte
    dec rcx                         ; Decrement length
    test rcx, rcx                   ; Check if end of buffer
    jnz find_end                    ; Continue searching

    xor rax, rax                    ; Not found
    ret

end_found:
    sub rsi, rbx                    ; Length of value
    mov rax, rsi                    ; Set length
    ret

next_char:
    inc rbx                         ; Move to next character
    test rbx, rbx                   ; Check if end of buffer
    jnz search_loop                 ; Continue searching
    xor rax, rax                    ; Not found
    ret
