# README for GTK+3 Demo Programs

## Require Software Components

- MSYS2 on windows
- GTK+3 development components
- basic toolchain
- meson
- perl (to generate headers)

## Build Steps

* enter appropriate building environment such as MSYS2 MinGW x64
* goto project root folder
* type "meson builddir && meson compile -C builddir"

## Run Programs

After build successfully, goto project root folder, type the following line 
to execute the specified program.

./builddir/gtk-demo/gtk3-demo.exe

