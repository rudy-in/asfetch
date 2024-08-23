# asfetch

`asfetch` is a simple fetch utility written in x86_64 assembly. It prints system information such as hostname, OS version, and architecture. (Currently Under development)
## Preview
![Preview Image](https://github.com/rudy-in/asfetch/blob/master/assests/preview.png)
## Building

To build `asfetch`, use `make` command

```bash
make
```
To build manually use `nasm` and `ld`

```bash
nasm -f elf64 -o obj/components/os.o src/components/os.asm
nasm -f elf64 -o obj/components/pkgs.o src/components/pkgs.asm
nasm -f elf64 -o obj/components/shell.o src/components/shell.asm
nasm -f elf64 -o obj/components/terminal.o src/components/terminal.asm
nasm -f elf64 -o obj/components/resolution.o src/components/resolution.asm
nasm -f elf64 -o obj/components/cpu.o src/components/cpu.asm
nasm -f elf64 -o obj/components/gpu.o src/components/gpu.asm
nasm -f elf64 -o obj/*.o src/main.asm
ld -o asfetch obj/components/cpu.o obj/components/gpu.o obj/components/os.o obj/components/pkgs.o obj/components/resolution.o obj/components/shell.o obj/components/terminal.o obj/*.o

```


## Todo:

- Make it detect Hostname
- Fix Unknown package manager error , hostname , shell , term , resolution , cpu and gpu not showing up
- Add ascii for distros
