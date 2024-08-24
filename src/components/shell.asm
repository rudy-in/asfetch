; src/components/shell.asm

section .data
    shell_msg db "Shell: ", 0

section .text
    global fetch_shell
    fetch_shell:
        ; Command to fetch shell information (using `echo $SHELL`)
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        mov rsi, shell_msg
        mov rdx, 6          ; length of shell_msg
        syscall

        ; Use a fixed string for simplicity
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        long_string db "bash 5.2.32", 0
        mov rdx, 11         ; length of shell string
        syscall

        ; Return from function
        ret
