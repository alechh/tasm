; @echo off
; goto l1
.model	tiny
.386
.code
org	100h

_:
	jmp start

out  db '     ', 13,10,'$'

start:
	mov ah, 00h	; get next key
			; al -- ascii code
			; ah -- scan code
	int 16h		

	mov cx, ax	; save ax to cx (ascii symbol)

	lea di, out	
	mov bl, ah 	; scan-code
	call h2		

	mov ax, cx	; return old ax value
			; to get ascii symbol

	cmp al, 1Bh 	; if escape is pressed
	je exit

	cmp al, 24h	; if $ is pressed
	jne print	
	mov al, 53h	; convert $ to S

print:
	inc di		; space to write ascii symbol
	stosb		; write al (ascii symbol) to di

	mov ah, 09h	;
	lea dx, out	; print string
	int 21h		;

	cli		; ignore interrupts

	push es		; save es  
	push 0		;
	pop es		; es := 0

	mov al, es:[41Ah]  
	mov es:[41Ch], al	; tail := head

	pop es		; return old es value

	sti		; un-ignore interrupts

	jmp start

h2: 
	mov al, bl	; bl = ah = scan-code

	shr al, 4	; al = high nibble (4 bits)
	call h1

	mov al, bl	; al = low nibble

h1:
	; DI - start of string

	and ax, 0fh	; ah = last nibble
	cmp al, 0Ah 	; check if its letter or number
			; if letter or number -- CF = 1
	sbb al, 69h	; al = al - (69h + CF)
	das	     
	stosb		; store al in di

	
exit:   ret
end _
	
; :l1
; tasm /m5 buffer.bat
; tlink /x/t buffer.obj
; del buffer.obj