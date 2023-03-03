section .data
msg db "THE SORTED ARRAY IS : ",10
msglen equ $-msg

arr db 05h,0Ah,75h,0D3h,12h

%macro operate 4    ;macro declaration
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .bss
result resb 15                             ;used to display the sorted numbers(including the comma)

section .text

global _start
_start:
   mov bl,5
                                   ;outer loop runs for n times i.e. 5
loop_outer:
   mov cl,4                                
   mov rsi,arr
   
up:
   mov al,byte[rsi]
   cmp al,byte[rsi+1]
   jbe only_inc                            ;no swapping
   xchg al,byte[rsi+1]                     ;swap
   mov byte[rsi],al
   
only_inc:
   inc rsi
   dec cl                                  ;decrementing inner loop
   jnz up
   
   dec bl                                  ;decrementing outer loop
   jnz loop_outer
   operate 1,1, msg,msglen
   
   mov rdi,arr                             ;unpacking
   mov rsi,result
   mov dl,10                               ;for one number there are two digits
   
disp_loop1:
   mov cl,2
   mov al,[rdi]
   
;unpacking  
againx:
   rol al,4                                ;rotate by 4
   mov bl,al
   and al,0FH
   cmp al,09H
   jbe downx                              
   add al,07H
   

 downx:
   add al,30H
   mov byte[rsi],al
   mov al,bl
   inc rsi
   dec cl
   jnz againx
   
;vertically
   mov byte[rsi],0AH                       ;inserting enter
   inc rsi                                 ;result
   inc rdi
   dec dl
   jnz disp_loop1
   operate 1,1,result,15
   
   operate 60,0,0,0