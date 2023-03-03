%macro rw 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro
section .data
;number dw 019CFH
msg1 db &quot;Enter the Hex Number :&quot;,10
msg1len equ $-msg1
msg db 10d,13d,&quot;Equivalent BCD Number is :&quot;,10
msglen equ $-msg
section .bss
    a resb 1            
num resb 5
section .code
global _start
_start:
    rw 1,1,msg1,msg1len
    rw 0,0,num,5            ;For input of hex number
    mov rsi,num
    mov rbp,00
   
    mov ax,00h
again:
    mov bl,byte[rsi]
    cmp bl,0ah
    je htob
    cmp bl,39h
    jbe sub30h
    sub bl,07h
   
sub30h:
    sub bl,30h
    rol ax,4

    add al,bl
    inc rsi
    jmp again
       
htob:
    mov dx,00
    mov bx,0Ah
    div bx
    push dx         ;push remainder into the stack
    inc rbp
    cmp eax,00
    jnz htob
    rw 1,1,msg,msglen
   
print:
    pop dx
   
nxt1:
    add dx,30h
    mov [a],dl
    rw 1,1,a,1
    dec rbp
    jnz print
    mov rax,60
    mov rdi,0
    syscall