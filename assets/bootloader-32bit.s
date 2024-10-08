bits 32
boot2:
  ; setting segments to the point of the data segment
  mov ax, DATA_SEG
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax
