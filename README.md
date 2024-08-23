# asfetch

`asfetch` is a simple fetch utility written in x86_64 assembly. It prints system information such as hostname, OS version, and architecture. (Currently Under development)

## Building

To build `asfetch`, use `nasm` and `ld`:

```bash
nasm -f elf64 main.asm -o main.o
ld main.o -o asfetch
```

Todo:

- Make the fetch detect architecure
- Make it detect Hostname
- Add ascii for distros
