;@echo off
;goto build
.model tiny
.386
.code

org 100h

start:	
	; --- open file
	mov ah, 3Dh
	mov al, 0  ; read-only mode
	lea dx, s1  ; pointer to filename
	int 21h

	jc error1  ; if error, print error message

	mov bx, ax  ; move filehandler (we write this in ax above)

	; --- read file
	mov ah, 3Fh
	mov cx, 512  ; number of bytes to read
	lea dx, buffer  ; address of buffer
	int 21h

	; --- close file
	mov ah, 3eh
	int 21h

	; --- write sectors from memory
	mov ah, 03h
	mov al, 01h  ; number of sectors to write (1 sector == 512 byte)
	mov ch, 0h  ; cylinder number
	mov cl, 1h  ; starting sector number
	mov dh, 0h  ; head number
	mov dl, 0h  ; drive number
	lea bx, buffer  ; address of memoty buffer
	int 13h

	jc error1  ; if error, print error message	

	ret
error1:	
	lea dx, er1
	mov ah, 09h
	int 21h
	ret
	
s1	db	'bootsector.com', 0
er1	db	'Cannot open file$'
buffer	db	512 dup(0)
end start

;:build
;tasm /m5 test.bat
;tlink /x/t test.obj