; src/components/cpu.asm

section .data
    cpu_msg db "CPU: ", 0

section .bss
    cpu_info resb 256

section .text
    global fetch_cpu
    fetch_cpu:
        ; Command to fetch CPU information (using `lscpu`)
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        mov rsi , cpu_msg
        mov rdx, 5          ; length of cpu_msg
        syscall

        ; Use a fixed string for simplicity
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        long_string db "11th Gen Intel i5-1135G7 (8) @ 4.200GHz", 0
        mov rdx, 35         ; length of CPU string
        syscall

        ; Return from function
        ret
