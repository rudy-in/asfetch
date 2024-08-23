; src/components/os.asm

section .data
    filename db "/etc/os-release", 0
    buffer_size equ 1024
    buffer resb buffer_size
    pretty_name_prefix db "PRETTY_NAME=", 0
    pretty_name_prefix_len equ $ - pretty_name_prefix
    newline db 0xA

section .text
    global fetch_os

fetch_os:
    ; Open the file
    mov rax, 2               ; syscall number for sys_open
    mov rdi, filename        ; pointer to filename
    mov rsi, 0               ; flags: O_RDONLY
    mov rdx, 0               ; mode: not used
    syscall

    ; Check if the file was opened successfully
    test rax, rax
    js open_error
    mov rdi, rax             ; save file descriptor

    ; Read the file
    mov rax, 0               ; syscall number for sys_read
    mov rsi, rdi             ; file descriptor
    mov rdx, buffer_size     ; number of bytes to read
    syscall

    ; Close the file
    mov rax, 3               ; syscall number for sys_close
    mov rdi, rdi             ; file descriptor
    syscall

    ; Find PRETTY_NAME
    lea rsi, [buffer]
    call find_pretty_name
    test rax, rax
    jz no_pretty_name

    ; Print the pretty name
    mov rax, 1               ; syscall number for sys_write
    mov rdi, 1               ; file descriptor 1 is stdout
    mov rdx, rax             ; length of the pretty name
    syscall

    ; Print newline
    mov rax, 1               ; syscall number for sys_write
    mov rdi, 1               ; file descriptor 1 is stdout
    lea rsi, [newline]       ; newline character
    mov rdx, 1               ; length of newline
    syscall

    ret

open_error:
    ; Handle error (e.g., print an error message)
    ; You might want to add error handling code here
    ret

no_pretty_name:
    ; Handle case where PRETTY_NAME was not found
    ; You might want to add code to handle this case
    ret

find_pretty_name:
    ; Searches for PRETTY_NAME= in the buffer
    ; Expects rsi to point to the buffer
    ; Returns length of PRETTY_NAME value in rax or 0 if not found

    ; Initialize registers
    mov rbx, rsi             ; rbx will be used to scan the buffer
    mov rcx, pretty_name_prefix_len

search_loop:
    ; Compare the current position in the buffer with the prefix
    repe cmpsb
    jne next_char

    ; Move to the start of the value
    add rsi, rcx
    mov rdx, buffer_size
    sub rdx, (rsi - rbx)     ; Calculate the remaining buffer size after prefix

    ; Find end of the line
find_end:
    mov al, [rsi]
    cmp al, [newline]
    je end_found
    inc rsi
    dec rdx
    test rdx, rdx
    jnz find_end
    xor rax, rax            ; Not found
    ret

end_found:
    ; Set rax to the length of the value
    sub rsi, rbx
    sub rsi, pretty_name_prefix_len
    mov rax, rsi
    ret

next_char:
    ; Move to the next character in the buffer
    inc rbx
    dec rdx
    test rdx, rdx
    jnz search_loop
    xor rax, rax            ; Not found
    ret
