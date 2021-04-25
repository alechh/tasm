;echo off
;goto build
.model tiny
.386
.code
org 100h
start:
	jmp powerOff

powerOff:
	mov ax, 5300h
	mov bx, 0
	int 15h
	push ax

	mov ax, 5308h
	mov bx, 1
	mov cx, 1
	int 15h
	
	mov ax, 5308h
	mov bx, 0ffffh
	mov cx, 1
	int 15h

	mov ax, 5301h
	mov bx, 0
	int 15h

	mov ax, 530eh
	mov bx, 0
	pop cx
	int 15h

	mov ax, 530dh
	mov bx, 1
	mov cx, 1
	int 15h

	mov ax, 530fh
	mov bx, 1
	mov cx, 1
	int 15h

	mov ax, 5307h
	mov bx, 1
	mov cx, 3
	int 15h

	int 20h

end start
;:build
;tasm /m5 power_off.bat
;tlink /x/t power_off.obj