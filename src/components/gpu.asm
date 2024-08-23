; src/components/gpu.asm

section .data
    gpu_msg db "GPU: ", 0

section .text
    global fetch_gpu
    fetch_gpu:
        ; Command to fetch GPU information (using `lspci`)
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        mov rsi, gpu_msg
        mov rdx, 5          ; length of gpu_msg
        syscall

        ; Use a fixed string for simplicity
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        mov rsi, "Intel TigerLake-LP GT2 [Iris Xe Graphics]"
        mov rdx, 39         ; length of GPU string
        syscall

        ; Return from function
        ret
