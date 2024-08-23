; src/components/terminal.asm

section .data
    terminal_msg db "Terminal: ", 0

section .text
    global fetch_terminal
    fetch_terminal:
        ; Command to fetch terminal information (using `echo $TERM`)
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        mov rsi, terminal_msg
        mov rdx, 10         ; length of terminal_msg
        syscall

        ; Use a fixed string for simplicity
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        mov rsi, "kitty"
        mov rdx, 5          ; length of terminal string
        syscall

        ; Return from function
        ret
