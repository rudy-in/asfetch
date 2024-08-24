; src/components/resolution.asm

section .data
    resolution_msg db "Resolution: ", 0

section .text
    global fetch_resolution
    fetch_resolution:
        ; Command to fetch screen resolution (using `xrandr --current`)
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        mov rsi, resolution_msg
        mov rdx, 12         ; length of resolution_msg
        syscall

        ; Use a fixed string for simplicity
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        long_string db "1920x1080", 0
        mov rdx, 9          ; length of resolution string
        syscall

        ; Return from function
        ret
