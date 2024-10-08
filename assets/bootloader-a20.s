bits 16
org 0x7c00

boot:
  mov ax, 0x2401 ; set the A20 address argument for BIOS interrupt
  int 0x15 ; enable A20 bit (with 0x15 interrupt)

  mov ax, 0x3
  int 0x10 ; set vga text mode to a safe value (mode 3)
