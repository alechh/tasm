;@echo off
;goto build
.model tiny
.386
.code

org 100h
start:
	; --- set cursor position
	mov ah, 02h
	mov bh, 00h  ; display page number
	mov dx, 0  ; row=0, column=0
	int 10h
	
	; --- print one char 
	mov ah, 0Ah
	mov al, 'H'  ; symbol to print
	mov bh, 0  ; page number
	mov cx, 1  ; number of times to write the char
	int 10h
	
	; --- call shift_cursor
	mov ah, 02h
	mov bh, 00h  ; pisplay page number
	mov dl, 1  ; column=1
	mov dh, 0  ; row=0
	int 10h
	
	mov ah, 0Ah
	mov al, 'e'
	mov bh, 0
	mov cx, 1
	int 10h

	; --- call shift_cursor
	mov ah, 02h
	mov bh, 00h
	mov dl, 2
	mov dh, 0
	int 10h
	
	mov ah, 0Ah
	mov al, 'l'
	mov bh, 0
	mov cx, 2
	int 10h
		
	mov ah, 02h
	mov bh, 00h
	mov dl, 4
	mov dh, 0
	int 10h

	mov ah, 0Ah
	mov al, 'o'
	mov bh, 0
	mov cx, 1
	int 10h

	mov ah, 02h
	mov bh, 00h
	mov dl, 5
	mov dh, 0
	int 10h

	mov ah, 0Ah
	mov al, ','
	mov bh, 0
	mov cx, 1
	int 10h

	mov ah, 02h
	mov bh, 00h
	mov dl, 7
	mov dh, 0
	int 10h

	mov ah, 0Ah
	mov al, 'w'
	mov bh, 0
	mov cx, 1
	int 10h

	mov ah, 02h
	mov bh, 00h
	mov dl, 8
	mov dh, 0
	int 10h

	mov ah, 0Ah
	mov al, 'o'
	mov bh, 0
	mov cx, 1
	int 10h

	mov ah, 02h
	mov bh, 00h
	mov dl, 9
	mov dh, 0
	int 10h

	mov ah, 0Ah
	mov al, 'r'
	mov bh, 0
	mov cx, 1
	int 10h

	mov ah, 02h
	mov bh, 00h
	mov dl, 10
	mov dh, 0
	int 10h

	mov ah, 0Ah
	mov al, 'l'
	mov bh, 0
	mov cx, 1
	int 10h

	mov ah, 02h
	mov bh, 00h
	mov dl, 11
	mov dh, 0
	int 10h

	mov ah, 0Ah
	mov al, 'd'
	mov bh, 0
	mov cx, 1
	int 10h

	mov ah, 02h
	mov bh, 00h
	mov dl, 12
	mov dh, 0
	int 10h

	mov ah, 0Ah
	mov al, '!'
	mov bh, 0
	mov cx, 1
	int 10h

loop1:
	jmp loop1		

db	(510-($-start)) dup(0)
db	055h, 0AAh

end start

;:build
;tasm /m5 bootsector.bat
;tlink /x/t bootsector.obj