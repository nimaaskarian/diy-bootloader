bits 16 ; this is 16 bit code
org 0x7c00 ; output stuff at offset 0x7c00
boot:
  mov ax, 0x2401 ; set the A20 address argument for BIOS interrupt
  int 0x15 ; enable A20 bit (with 0x15 interrupt)

  mov ax, 0x3
  int 0x10 ; set vga text mode to a safe value (mode 3)

  lgdt [gdt_pointer] ; load the gdt table
  mov eax, cr0 ; move the value of cr0 (special CPU reg) to eax
  or eax, 0x1 ; set eax 1 or its prev value
  mov cr0, eax ; set the protected mode bit

  jmp CODE_SEG:boot2 ; jump to the code segment

gdt_start:
  dq 0x0
gdt_code:
  dw 0xFFFF
  dw 0x0
  db 0x0
  db 10011010b
  db 11001111b
  db 0x0
gdt_data:
  dw 0xFFFF
  dw 0x0
  db 0x0
  db 10010010b
  db 11001111b
  db 0x0
gdt_end:
gdt_pointer:
  dw gdt_end - gdt_start
  dd gdt_start
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32
boot2:
  ; setting segments to the point of the data segment
  mov ax, DATA_SEG
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax

  mov esi,hello
  mov ebx,0xb8000
.loop:
  lodsb
  or al,al
  jz halt
  ; set the color of the text. first byte contains of two 4bit values
  ; first bg color and then fg color
  or eax,0xF000
  mov word [ebx], ax
  add ebx,2
  jmp .loop
halt:
  cli
  hlt
hello: db "Hello world!",0

; pad remaining 510 bytes ($-$$) with zeroes
times 510 - ($-$$) db 0 
; set the last 2 bytes into the magic bootloader 
; word that turns this into a bootable file
dw 0xaa55 
