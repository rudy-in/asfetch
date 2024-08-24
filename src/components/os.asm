section .data
    filename db "/etc/os-release", 0           ; Path to the file
    buffer_size equ 1024                       ; Buffer size
    pretty_name_prefix db "PRETTY_NAME=", 0    ; Prefix to search for
    pretty_name_prefix_len equ $ - pretty_name_prefix ; Length of the prefix
    newline db 0xA                             ; Newline character

section .bss
    buffer resb buffer_size                    ; Buffer to read file content

section .text
    global fetch_os

fetch_os:
    ; Open the file
    mov rax, 2                     ; syscall: sys_open
    lea rdi, [rel filename]        ; Use RIP-relative addressing to get the address of filename
    xor rsi, rsi                   ; flags: O_RDONLY
    xor rdx, rdx                   ; mode: not used, must be zero
    syscall

    ; Check if the file was opened successfully
    test rax, rax
    js open_error
    mov rdi, rax                   ; save file descriptor in rdi

    ; Read the file
    mov rax, 0                     ; syscall: sys_read
    lea rsi, [rel buffer]          ; Use RIP-relative addressing for buffer
    mov rdx, buffer_size           ; number of bytes to read
    syscall

    ; Close the file
    mov rax, 3                     ; syscall: sys_close
    mov rdi, rdi                   ; file descriptor
    syscall

    ; Find PRETTY_NAME
    lea rsi, [rel buffer]          ; Load buffer address into rsi using RIP-relative addressing
    call find_pretty_name          ; Call function to find "PRETTY_NAME"
    test rax, rax                  ; Check if rax is zero (meaning not found)
    jz no_pretty_name

    ; Print the pretty name
    mov rdx, rax                   ; rax contains length of the pretty name
    mov rax, 1                     ; syscall: sys_write
    mov rdi, 1                     ; file descriptor: stdout
    syscall

    ; Print newline
    mov rax, 1                     ; syscall: sys_write
    mov rdi, 1                     ; file descriptor: stdout
    lea rsi, [rel newline]         ; address of newline character using RIP-relative addressing
    mov rdx, 1                     ; length of newline
    syscall

    ret                            ; Return from fetch_os

open_error:
    ; Handle error (e.g., print an error message)
    ret

no_pretty_name:
    ; Handle case where PRETTY_NAME was not found
    ret

find_pretty_name:
    ; Searches for "PRETTY_NAME=" in the buffer
    ; Expects rsi to point to the buffer
    ; Returns length of PRETTY_NAME value in rax or 0 if not found

    mov rbx, rsi                   ; rbx will be used to scan the buffer
    mov rcx, buffer_size           ; rcx holds the length of the buffer

search_loop:
    mov rdi, rbx                   ; rdi = current position in buffer
    lea rsi, [rel pretty_name_prefix] ; rsi = address of the prefix using RIP-relative addressing
    mov rdx, pretty_name_prefix_len ; rdx = length of the prefix

    cld                            ; Clear direction flag for forward string operations
    repe cmpsb                     ; Compare bytes in rdi and rsi
    jne next_char                  ; If not equal, check next character

    ; Move to the start of the value
    add rbx, pretty_name_prefix_len ; Move rbx past the prefix
    mov rsi, rbx                   ; rsi now points to the value
    mov rcx, buffer_size           ; rcx = max length to search (reset for new search)

    ; Find end of the line (end of the pretty name)
find_end:
    mov al, [rsi]                  ; Load current byte
    cmp al, newline                ; Check if it is a newline
    je end_found                   ; If newline, end of value found
    inc rsi                        ; Move to next byte
    dec rcx                        ; Decrement remaining length
    test rcx, rcx                  ; Check if end of buffer
    jnz find_end                   ; Continue until end of buffer

    ; If newline not found, return 0
    xor rax, rax                   ; Return 0 (not found)
    ret

end_found:
    sub rsi, rbx                   ; rsi - rbx = length of the value
    mov rax, rsi                   ; Set rax to length of the value
    ret

next_char:
    inc rbx                        ; Increment rbx to point to next character
    dec rcx                        ; Decrement remaining buffer length
    test rcx, rcx                  ; Check if we've exhausted the buffer
    jnz search_loop                ; Continue searching
    xor rax, rax                   ; Return 0 (not found)
    ret
