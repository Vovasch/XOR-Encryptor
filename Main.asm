include 'win32ax.inc'
include 'input.inc'
.data

;mes db 'zz', 0
;Encr_mes db '115 100', 0
mes rb 100
key db 0
Encr_mes rb 100

Mes1 db 'U want to encrypt or to decrypt?' , 0Dh, 'Enter 1 or 0' ,0

Mes21 db 'Enter message u want to encrypt', 0
Mes22 db 'Enter code u want to decrypt', 0

Mes3 db 'Enter binary mask', 0
 

.code 
start:
  
invoke  MessageBox, 0, Mes1, "Choise", MB_OK

input_dialog

mov esi, eax
call  ASCIIToNum_classic

cmp eax, 0
je .Decrypt

;enrcypt

call   get_key

invoke  MessageBox, 0, Mes21, "Encrypt", MB_OK

input_dialog

call encr


invoke  MessageBox, 0, esi, "Encrypted", MB_OK

jmp .Fin

.Decrypt:
;decrypt

call get_key

invoke  MessageBox, 0, Mes22, "Decrypt", MB_OK

input_dialog

call decr

invoke  MessageBox, 0, mes, "Encrypted", MB_OK

.Fin:

  
    invoke ExitProcess,0
.end start

.input_resources


proc get_key

invoke  MessageBox, 0, Mes3, "Mask", MB_OK

input_dialog

mov esi, eax

call ASCIIToNum_Binary_stirng_to_dec_num

mov [key], al


ret 
endp


proc encr

 mov esi, mes

.Again:

xor ebx, ebx

mov bl, [eax]

cmp bl, 0
je .Fin

xor bl, [key]
mov [esi], bl
inc eax
inc esi

jmp .Again

.Fin:

mov edi, mes
lea esi, [Encr_mes+99]
mov byte[esi], 0

.Again1:

xor ebx, ebx
mov bl, [edi]
cmp bl, 0
je .Fin1

xor eax, eax

mov al, [edi]

call NumToASCII

inc edi

jmp .Again1

.Fin1:
ret
endp

proc decr

 mov esi, Encr_mes

.Again:

xor ebx, ebx

mov bl, [eax]

cmp bl, 0
je .Fin

mov [esi], bl
inc eax
inc esi

jmp .Again

.Fin:

mov esi, Encr_mes
mov edi, mes


.Again1:

call ASCIIToNum_classic

xor ebx, ebx
mov bl, [key]
xor eax, ebx


mov [edi], eax
inc edi

inc esi


xor ebx, ebx

mov  bl, [esi]
cmp ebx, 0
je .Fin1



jmp .Again1
.Fin1:



ret
endp

proc NumToASCII
      push ecx edx
      dec esi
      mov byte [esi], ' '
      mov ecx, 10
.divloop:
      xor edx, edx
      div ecx
      add dl, 30h
      dec esi
      mov [esi], dl
      or  eax, eax    ; cmp eax, 0
      jnz .divloop
      pop edx ecx
      ret
endp

proc ASCIIToNum_classic
      push ebx ecx
      xor eax, eax      ; mov eax, 0
      xor ebx, ebx
      mov ecx, 10
.next:
      mov bl, [esi]
      cmp bl, 0
      jz  .done
      cmp bl, 20h
      jz  .done
      sub bl, 30h
      mul ecx
      add eax, ebx
      inc esi
      jmp .next   
.done:   
      pop ecx ebx
      ret
endp


proc ASCIIToNum_Binary_stirng_to_dec_num
      push ebx ecx
      xor eax, eax      ; mov eax, 0
      xor ebx, ebx
      mov ecx, 2
.next:
      mov bl, [esi]
      cmp bl, 0
      jz  .done
      sub bl, 30h
      mul ecx
      add eax, ebx
      inc esi
      jmp .next   
.done:   
      pop ecx ebx
      ret
endp


