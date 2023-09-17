nasm Sector1/bootloader.asm -f bin -o bin/bootloader.bin
nasm Sector2+/ExtProg.asm -f bin -o bin/ExtProg.bin
copy /b bin\bootloader.bin+bin\ExtProg.bin bootloader.flp
pause
