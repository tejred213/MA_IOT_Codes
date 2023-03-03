section .data
gmsg db 10,10,"The contents of GDTR are:"
gmsg_len equ $-gmsg

lmsg db 10,10,"The contents of LDTR are:"
lmsg_len equ $-lmsg

imsg db 10,10,"The contents of IDTR are:"
imsg_len equ $-imsg

tmsg db 10,10,"The contents of TR are:"
tmsg_len equ $-tmsg

mmsg db 10,10,"The contents of MSW/CR0 are:"
mmsg_len equ $-mmsg

pro db 10,10,"The processor is in protected mode"
pro_len equ $-pro

real db 10,10,"The processor is in real mode"
real_len equ $-real

col db":"
col_len equ $-col

nline db 10,10
nlen equ $-nline

section .bss
 
buff  resb 4
gdt1  resb 6
idt1   resb 6
ldt1   resw 1
t1      resb 2
msw1   resb 4

%macro display 4
mov rax,%1                
mov rdi,%2                  
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .text
global _start
_start:
smsw eax
mov [msw1],eax
bt eax,0
jc protected
display 1,1,real,real_len  
jmp end

protected:
display 1,1,pro,pro_len  
sgdt [gdt1]
sldt [ldt1]
sidt [idt1]
str [t1]
display 1,1,gmsg,gmsg_len
mov bx,[gdt1+4]
call original_ascii
mov bx,[gdt1+2]
call original_ascii
display 1,1,col,col_len
mov bx,[gdt1]
call original_ascii

display 1,1,lmsg,lmsg_len
mov bx,[ldt1]
call original_ascii

display 1,1,imsg,imsg_len
mov bx,[idt1+4]
call original_ascii
mov bx,[idt1+2]
call original_ascii
display 1,1,col,col_len
mov bx,[idt1]
call original_ascii

display 1,1,tmsg,tmsg_len
mov bx,[t1]
call original_ascii

display 1,1,mmsg,mmsg_len
mov bx,[msw1+2]
call original_ascii
mov bx,[msw1]
call original_ascii

end:
display 1,1,nline,nlen
display 60,0,0,0

original_ascii:
mov rax,0
mov rcx,4
mov rdi,buff
up2: rol bx,4
mov dl,bl
and dl,0fh
cmp dl,09h
jbe down2
add dl,07h
down2: add dl,30h
mov [rdi],dl
inc rdi
loop up2
display 1,1,buff,4
ret