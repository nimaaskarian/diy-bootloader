boot:
  ; ...
  lgdt [gdt_pointer] ; load the gdt table
  mov eax, cr0 ; move the value of cr0 (special CPU reg) to eax
  or eax, 0x1 ; set eax 1 or its prev value
  mov cr0, eax ; set the protected mode bit

  jmp CODE_SEG:boot2 ; jump to the code segment
