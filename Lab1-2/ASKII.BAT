; goto compile
.model tiny
.486
.code
org 100h

start:
	jmp next
next:	
	mov cl, 0h	; askii code of symbol

	mov dh, 7h	; row
	mov dl, 15h	; column
print:
	add dl, 02h	; inc column by 2	

	cmp dl, (15h + 28h)	; if 15 column 
	jne not_full_line
	add dh, 01h		; next row
	mov dl, 15h

not_full_line:
	mov ah, 02h
	mov bh, 00h	; display page number
	int 10h		; cursor is set

	add cl, 01h	; next sybmol

	cmp cl, 0ffh	; if all symbols are printed
	je wait
	
	mov bl, cl	; save symbol

	mov ah, 0ah
	mov al, cl	; sybmol cl
	mov bh, 00h	; page number
	mov cx, 01h	; number of times to write a char
	int 10h		; write symb

	mov cl, bl	; restore symbol

	jmp print

wait:
	jmp wait

db (510-($-start)) dup(0)	
db 55h, 0AAh
	
end start

;:compile
;tasm /m5 askii.bat
;tlink /x/t askii
;del askii.obj