  mov esi,hello
  mov ebx,0xb8000
.loop:
  lodsb
  or al,al
  jz halt
  or eax,0xF000
  mov word [ebx], ax
  add ebx,2
  jmp .loop
halt:
  cli
  hlt
hello: db "Hello world!",0
