; src/components/cpu.asm

section .data
    cpu_msg db "CPU: ", 0
    lscpu_cmd db "/usr/bin/lscpu", 0  ; Path to the lscpu command
    lscpu_args db "", 0              ; No arguments for lscpu in this example
    stdout db 1                      ; File descriptor for stdout
    buffer_size equ 256
    newline db 0xA                  ; Newline character

section .bss
    buffer resb buffer_size         ; Reserve space for command output

section .text
    global fetch_cpu

fetch_cpu:
    ; Print the CPU message
    mov rax, 1                      ; syscall number for sys_write
    mov rdi, 1                      ; file descriptor 1 is stdout
    lea rsi, [cpu_msg]
    mov rdx, 5                      ; length of cpu_msg
    syscall

    ; Prepare to execute lscpu
    mov rax, 59                     ; syscall number for sys_execve
    lea rdi, [lscpu_cmd]           ; path to lscpu
    lea rsi, [lscpu_args]          ; arguments (empty in this case)
    xor rdx, rdx                    ; environment (not used)
    syscall

    ; Check if execve succeeded
    ; If execve fails, control will return here. For this example, we'll just return.
    ; Normally, you would handle errors and process output more carefully.
    ret
