; src/components/gpu.asm

section .data
    gpu_msg db "GPU: ", 0
    lspci_cmd db "/usr/bin/lspci", 0  ; Initialize with the command path
    lspci_args db "-vmm", 0           ; Initialize with arguments

section .bss
    buffer resb 1024         ; Reserve space for the command output buffer
    file_descriptor resq 1   ; Reserve space for the file descriptor
    newline db 0xA          ; Newline character

section .text
    global fetch_gpu

fetch_gpu:
    ; Prepare the lspci command
    ; In a real use case, you'd typically use execve to run lspci and capture output
    ; This example assumes lspci is available at /usr/bin/lspci and prints directly
    ; Note: `execve` does not directly capture output; additional code needed for full implementation.

    ; Print GPU message
    mov rax, 1              ; syscall number for sys_write
    mov rdi, 1              ; file descriptor 1 is stdout
    lea rsi, [gpu_msg]
    mov rdx, 5             ; length of gpu_msg
    syscall

    ; Call lspci command (placeholders, not a functional example)
    ; Normally this involves execve and capturing output; here for demonstration
    ; Example: mov rax, 59 (sys_execve), etc.

    ; Read the output of the lspci command (dummy implementation)
    ; Normally handled by the process output directly, here for demonstration purposes
    ; Print fixed GPU info
    mov rax, 1              ; syscall number for sys_write
    mov rdi, 1              ; file descriptor 1 is stdout
    lea rsi, [buffer]
    mov rdx, 39            ; length of the fixed GPU info
    syscall

    ; Print newline
    mov rax, 1              ; syscall number for sys_write
    mov rdi, 1              ; file descriptor 1 is stdout
    lea rsi, [newline]
    mov rdx, 1              ; length of newline
    syscall

    ret
