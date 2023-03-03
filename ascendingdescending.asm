%macro operate 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data
arr db 05h, 0Ah, 75h, 0D3h, 12h
msg1 db " ",10
msg1len equ $-msg1
msg3 db "press 1 for descending: ",10
msg3len equ $-msg3
msg2 db "press 2 for ascending: ",10
msg2len equ $-msg2
msg6 db "press 3 to exit: ",10
msg6len equ $-msg6
msg db "Sorted array is(ascending): ",10
msglen equ $-msg
msg4 db "Sorted array is(descending): ",10
msg4len equ $-msg4
msg5 db "Bye Bye",10
msg5len equ $-msg5

section .bss
result resb 15
choice resb 2
section .text
global _start
 _start:
  operate 1,1,msg1,msg1len
  operate 1,1,msg3,msg3len
  operate 1,1,msg2,msg2len
  operate 1,1,msg6,msg6len
  operate 0,0,choice,2
  cmp byte[choice],31H
  jne next
  call proc_ascending
  call display
  jmp exit
  next:
  cmp byte[choice],32H
  jne exit
  call proc_descending
  call display
  jmp exit
  exit:
  operate 1,1,msg5,msg5len
  operate 60,0,0,0
 
  proc_ascending:
  mov edi,arr
  mov bl,5
  loop_outer:
  mov cl,4
  mov esi,arr
  up:
  mov al,byte[esi+1]
  cmp al,byte[esi]
  jbe only_inc
  xchg al,byte[esi]
  mov byte[esi+1],al
only_inc:
inc esi
dec cl
jnz up
dec bl
jnz loop_outer
  operate 1,1,msg4,msg4len
  ret
 
  proc_descending:
  mov edi,arr
  mov bl,5
  loop_outer1:
  mov cl,4
  mov esi,arr
  up1:
  mov al,byte[esi+1]
  cmp al,byte[esi]
  jae only_inc1
  xchg al, byte[esi]
  mov byte[esi+1],al
  only_inc1:
  inc esi
  dec cl
  jnz up1
  dec bl
  jnz loop_outer1
  operate 1,1,msg,msglen
  ret
 
  display:
  mov edi,arr
  mov esi,result
  mov dl,10
  disp_loop1:
  mov cl,2
  mov al,[edi]
  againx:
  rol al,4
  mov bl,al
  and al,0FH
  cmp al,09H
  jbe downx
  add al,07H
  downx:
  add al,30H
  mov byte[esi],al
  mov al,bl
  inc esi
  dec cl
  jnz againx
 
  mov byte[esi],0AH
  inc esi
  inc edi
  dec dl
  jnz disp_loop1
  operate 1,1,result,15
 
  ret
 
  operate 60,0,0,0