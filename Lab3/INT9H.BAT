; goto cmpl
.model tiny
.386
.code
org 100h

start:
	jmp next
out 	db '__',13,10,'$'
code 	db 0

int9handler: 
	pusha		; save registers
	push ds		;
	push es		;

	push cs
	pop ds
	push cs
	pop es

	in al, 60h   	; scan-code of pressed key
	mov code, al

	mov bl, al	; print scan-code
	lea di, [out]	;
	call h2		;
	lea dx, out	;
	mov ah, 09h	;
	int 21h		;

	in al, 61h		
	or al, 10000000b
	out 61h, al
	and al, 01111111b
	out 61h, al
	
	mov al, 20h		
	out 20h, al

	pop es		; restoring registers
	pop ds
	popa
	iret

next:
	xor ax, ax
	push ax
	pop es

	mov cx, [es:4 * 9]	; rewrite the interrupt to vector
	push cx			;
	mov cx, [es:4 * 9 + 2]	;
	push cx			;
				;
	push cs			;
	pop ax			;
				;
	lea bx, [int9handler]	;
	
	cli			; disable interrupt
	mov [es: 4 * 9 ], bx
	mov [es: 4 * 9 + 2], ax
	sti

lp1:
	mov bl, code
	cmp bl, 01h	; if Esc is pressed

	jnz lp1

	xor ax, ax
	push ax
	pop es

	pop bx 		; cs
	cli
	mov [es:4 * 9 + 2], bx
	pop bx
	mov [es:4 * 9], bx	
	sti	
	
	ret
h8:
	ror ebx, 16
	call h4
	ror ebx, 16
h4:
	ror bx, 8
	call h2
	ror bx, 8
h2:
	mov al, bl
	shr al, 4
	cmp al, 10
	sbb al, 69h
	das
	cld
	stosb
	mov al, bl
	and al, 0fh
	cmp al, 10
	sbb al, 69h
	das
	stosb
	ret

end start

; :cmpl
; tasm /m5  int9h.bat
; tlink /x/t int9h.obj
; del int9h.obj