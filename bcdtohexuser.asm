section .data
msg db &quot;Enter the BCD number : &quot;,10
msglen equ $-msg
msg2 db &quot; Equivalent HEX Number is: &quot;
msg2len equ $-msg2
section .bss
bcdnum resb 10
temp resb 1
%macro rw 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .text
global _start
_start:
rw 1,1,msg,msglen
rw 0,0,bcdnum,10
rw 1,1,msg2,msg2len
mov rsi,bcdnum
mov cx,0Ah
mov bx,0
mov ax,0
again:
mov bl,[rsi]
cmp bl,0Ah
je done
sub bl,30h
mul cx
add ax,bx
inc rsi
jmp again
done:
mov bp,4
up: rol ax,4
mov bx,ax
and ax,000Fh
cmp al,09
jbe down1
add al,07h
down1: add al,30h
mov byte[temp],al
rw 1,1,temp,1
mov ax,bx
dec bp
jnz up
rw 60,0,0,0