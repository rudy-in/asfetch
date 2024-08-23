section .data
    newline db 0xA

section .text
    global print_string
    global read_file
    global print_file

; Function: print_string
; Arguments:
;   rdi - file descriptor (1 for stdout)
;   rsi - pointer to string
;   rdx - length of string
print_string:
    mov rax, 0x01    ; syscall number for sys_write
    syscall
    ret

; Function: read_file
; Arguments:
;   rdi - file descriptor
;   rsi - pointer to buffer
;   rdx - number of bytes to read
read_file:
    mov rax, 0x00    ; syscall number for sys_read
    syscall
    ret

; Function: print_file
; Arguments:
;   rdi - file descriptor (1 for stdout)
;   rsi - pointer to buffer
;   rdx - length of buffer
print_file:
    mov rax, 0x01    ; syscall number for sys_write
    syscall
    ret
