; src/components/pkgs.asm

section .data
    pkgs_msg db "Packages: ", 0
    pacman_cmd db "pacman -Q | wc -l", 0
    apt_cmd db "dpkg -l | grep ^ii | wc -l", 0
    yum_cmd db "yum list installed | wc -l", 0
    dnf_cmd db "dnf list installed | wc -l", 0
    zypper_cmd db "zypper se --installed-only | wc -l", 0
    unknown_pkg_mgr db "Unknown package manager", 0

section .bss
    pkgs_count resb 10
    buffer resb 256

section .text
    global fetch_pkgs
    fetch_pkgs:
        ; Detect package manager and get package count
        ; This example assumes you are running in a Unix-like environment

        ; Check for pacman
        mov rax, 0x02       ; syscall number for sys_open
        mov rdi, pacman_cmd ; command to run
        mov rsi, 0          ; flags (read-only)
        mov rdx, 0          ; mode
        syscall

        test rax, rax       ; Check if the command succeeded
        jz use_pacman

        ; Check for apt
        mov rax, 0x02       ; syscall number for sys_open
        mov rdi, apt_cmd    ; command to run
        mov rsi, 0          ; flags (read-only)
        mov rdx, 0          ; mode
        syscall

        test rax, rax       ; Check if the command succeeded
        jz use_apt

        ; Check for yum
        mov rax, 0x02       ; syscall number for sys_open
        mov rdi, yum_cmd    ; command to run
        mov rsi, 0          ; flags (read-only)
        mov rdx, 0          ; mode
        syscall

        test rax, rax       ; Check if the command succeeded
        jz use_yum

        ; Check for dnf
        mov rax, 0x02       ; syscall number for sys_open
        mov rdi, dnf_cmd    ; command to run
        mov rsi, 0          ; flags (read-only)
        mov rdx, 0          ; mode
        syscall

        test rax, rax       ; Check if the command succeeded
        jz use_dnf

        ; Check for zypper
        mov rax, 0x02       ; syscall number for sys_open
        mov rdi, zypper_cmd ; command to run
        mov rsi, 0          ; flags (read-only)
        mov rdx, 0          ; mode
        syscall

        test rax, rax       ; Check if the command succeeded
        jz use_zypper

        ; If no known package manager found
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        mov rsi, unknown_pkg_mgr
        mov rdx, 24         ; length of unknown_pkg_mgr
        syscall
        ret

    use_pacman:
        ; Execute pacman command to count packages
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        mov rsi, pkgs_msg
        mov rdx, 10         ; length of pkgs_msg
        syscall

        ; Print the number of packages
        ; Here we need to execute the command and fetch the result
        mov rax, 0x00       ; syscall number for sys_read
        mov rdi, 0x01       ; file descriptor (stdin)
        lea rsi, [buffer]
        mov rdx, 256        ; buffer size
        syscall

        ; Print result (example, modify as needed)
        mov rax, 0x01
        mov rdi, 0x01
        lea rsi, [buffer]
        mov rdx, 256
        syscall

        ret

    use_apt:
        ; Execute apt command to count packages
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        mov rsi, pkgs_msg
        mov rdx, 10         ; length of pkgs_msg
        syscall

        ; Print the number of packages
        ; Here we need to execute the command and fetch the result
        mov rax, 0x00       ; syscall number for sys_read
        mov rdi, 0x01       ; file descriptor (stdin)
        lea rsi, [buffer]
        mov rdx, 256        ; buffer size
        syscall

        ; Print result (example, modify as needed)
        mov rax, 0x01
        mov rdi, 0x01
        lea rsi, [buffer]
        mov rdx, 256
        syscall

        ret

    use_yum:
        ; Execute yum command to count packages
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        mov rsi, pkgs_msg
        mov rdx, 10         ; length of pkgs_msg
        syscall

        ; Print the number of packages
        ; Here we need to execute the command and fetch the result
        mov rax, 0x00       ; syscall number for sys_read
        mov rdi, 0x01       ; file descriptor (stdin)
        lea rsi, [buffer]
        mov rdx, 256        ; buffer size
        syscall

        ; Print result (example, modify as needed)
        mov rax, 0x01
        mov rdi, 0x01
        lea rsi, [buffer]
        mov rdx, 256
        syscall

        ret

    use_dnf:
        ; Execute dnf command to count packages
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        mov rsi, pkgs_msg
        mov rdx, 10         ; length of pkgs_msg
        syscall

        ; Print the number of packages
        ; Here we need to execute the command and fetch the result
        mov rax, 0x00       ; syscall number for sys_read
        mov rdi, 0x01       ; file descriptor (stdin)
        lea rsi, [buffer]
        mov rdx, 256        ; buffer size
        syscall

        ; Print result (example, modify as needed)
        mov rax, 0x01
        mov rdi, 0x01
        lea rsi, [buffer]
        mov rdx, 256
        syscall

        ret

    use_zypper:
        ; Execute zypper command to count packages
        mov rax, 0x01       ; syscall number for sys_write
        mov rdi, 0x01       ; file descriptor 1 is stdout
        mov rsi, pkgs_msg
        mov rdx, 10         ; length of pkgs_msg
        syscall

        ; Print the number of packages
        ; Here we need to execute the command and fetch the result
        mov rax, 0x00       ; syscall number for sys_read
        mov rdi, 0x01       ; file descriptor (stdin)
        lea rsi, [buffer]
        mov rdx, 256        ; buffer size
        syscall

        ; Print result (example, modify as needed)
        mov rax, 0x01
        mov rdi, 0x01
        lea rsi, [buffer]
        mov rdx, 256
        syscall

        ret
