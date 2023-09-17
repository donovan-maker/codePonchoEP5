[org 0x7e00]

jmp EnterProtectedMode

%include "Sector1/includes/print.asm"
%include "Sector2+/includes/gdt.asm"

EnterProtectedMode:
    call EnableA20
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp codeseg:StartProtectedMode

EnableA20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

[bits 32]

%include "Sector2+/includes/CPUID.asm"
%include "Sector2+/includes/page.asm"

StartProtectedMode:
    mov ax, dataseg
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    mov [0xb8000], byte 'H'
    mov [0xb8002], byte 'e'
    mov [0xb8004], byte 'l'
    mov [0xb8006], byte 'l'
    mov [0xb8008], byte 'o'
    mov [0xb800A], byte ' '
    mov [0xb800C], byte 'w'
    mov [0xb800E], byte 'o'
    mov [0xb8010], byte 'r'
    mov [0xb8012], byte 'l'
    mov [0xb8014], byte 'd'
    mov [0xb8016], byte '!'

    call DetectCPUID
    call DetectLongMode
    call SetUpIdentityPaging
    call EditGDT
    jmp codeseg:Start64Bit

[bits 64]

Start64Bit:
    mov edi, 0xb8000
	mov rax, 0x1f201f201f201f20
	mov ecx, 500
	rep stosq

    jmp $

times 2048-($-$$) db 0