; src/components/gpu.asm

section .data
    gpu_msg db "GPU: ", 0

section .bss
    lspci_cmd resb 16        ; Reserve space for the lspci command path
    lspci_args resb 4        ; Reserve space for the lspci arguments
    buffer resb 1024         ; Reserve space for the command output buffer
    file_descriptor resq 1   ; Reserve space for the file descriptor
    newline db 0xA          ; Newline character

section .text
    global fetch_gpu

fetch_gpu:
    ; Prepare the lspci command
    mov rdi, lspci_cmd
    mov byte [rdi], '/'
    mov byte [rdi+1], 'u'
    mov byte [rdi+2], 's'
    mov byte [rdi+3], 'r'
    mov byte [rdi+4], '/'
    mov byte [rdi+5], 'b'
    mov byte [rdi+6], 'i'
    mov byte [rdi+7], 'n'
    mov byte [rdi+8], '/'
    mov byte [rdi+9], 'l'
    mov byte [rdi+10], 's'
    mov byte [rdi+11], 'p'
    mov byte [rdi+12], 'c'
    mov byte [rdi+13], 'i'
    mov byte [rdi+14], 0

    mov rsi, lspci_args
    mov byte [rsi], '-'
    mov byte [rsi+1], 'v'
    mov byte [rsi+2], 'm'
    mov byte [rsi+3], 'm'
    mov byte [rsi+4], 0

    ; Execute the lspci command
    mov rax, 59              ; syscall number for sys_execve
    lea rdi, [lspci_cmd]    ; pointer to the command
    lea rsi, [lspci_args]   ; pointer to the arguments
    xor rdx, rdx             ; no environment variables
    syscall

    ; Check if the command was executed successfully
    test rax, rax
    js exec_error

    ; Print GPU message
    mov rax, 1              ; syscall number for sys_write
    mov rdi, 1              ; file descriptor 1 is stdout
    lea rsi, [gpu_msg]
    mov rdx, 5             ; length of gpu_msg
    syscall

    ; Read the output of the lspci command
    mov rax, 0             ; syscall number for sys_read
    mov rdi, rax          ; file descriptor (lspci output)
    lea rsi, [buffer]     ; buffer to store the output
    mov rdx, 1024         ; number of bytes to read
    syscall

    ; Print the GPU information
    mov rax, 1            ; syscall number for sys_write
    mov rdi, 1            ; file descriptor 1 is stdout
    lea rsi, [buffer]    ; pointer to the buffer
    mov rdx, 1024        ; length of buffer
    syscall

    ; Print newline
    mov rax, 1            ; syscall number for sys_write
    mov rdi, 1            ; file descriptor 1 is stdout
    lea rsi, [newline]
    mov rdx, 1            ; length of newline
    syscall

    ret

exec_error:
    ; Handle execution error (e.g., print an error message)
    ret
