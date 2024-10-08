bits 16 ; this is 16 bit code
org 0x7c00 ; output stuff at offset 0x7c00
boot:
  mov si,hello ; point si register to hello label memory location
  mov ah,0x0e ; 0x0e means 'Write Character in TTY mode'
.loop:
  lodsb
  or al,al ; is al == 0 ?
  jz halt  ; if al == 0 jump to halt label
  int 0x10 ; runs BIOS interrupt 0x10 - Video Services
  jmp .loop
halt:
  cli ; clear interrupt flag
  hlt ; halt execution
hello: db "Hello world!",0

; pad remaining 510 bytes ($-$$) with zeroes
times 510 - ($-$$) db 0 
; set the last 2 bytes into the magic bootloader 
; word that turns this into a bootable file
dw 0xaa55 
