; @echo off
; goto l1
.model tiny
.386
.code
org 100h

_:	
	jmp start 

vendors_file	db "vendors.txt", 0
devices_file	db "devices.txt", 0
vendor_id	db "0000"
device_id	db "0000"
shift	db "0000",13,10,'$'

enter	db "-------------------------------------------------------",13,10,'$'
string	db "                                                                                ",'$'

start:
	xor ecx, ecx

bus_lp:
	mov eax, 80000000h	
	shl ecx, 8		; bus number

	or eax, ecx		; add bus number
	shr ecx, 8		; to needed position

	mov dx, 0cf8h		; 0cf8h - PCI Index
	out dx, eax		; request PCI for data

	mov dx, 0cfch		; read data from port
	in eax, dx		; 0cfch - PCI DATA

	cmp eax, 0FFFFFFFFh	; compare with -1
	je skip

	mov ebx, eax		; fill vendor_id
	lea di, vendor_id
	call h4

	shr ebx, 16		; fill device_id
	lea di, device_id
	call h4

	push cx

	call find_vendor
	call find_device

	pop cx
	
skip:
	inc cx
	cmp cx, 0FFFFh
	jne bus_lp
	ret

find_device:
	lea dx, devices_file	; open file
	mov ah, 3dh
	mov al, 0h
	int 21h

	mov bx, ax	; save file handler to bx

	mov ah, 42h			; set current file position
	mov al, 0			; start of file
	mov ch, byte ptr [shift]	; cx:dx = offset from origin
	mov cl, byte ptr [shift+1]	; of new file position
	mov dh, byte ptr [shift+2]
	mov dl, byte ptr [shift+3]
	int 21h

read_device:
	mov ah, 3fh	; read file
	mov cx, 80	; number of bytes to read
	lea dx, string	
	int 21h

	lea di, device_id
	jmp cmp_nums_device

close_device:
	mov ah, 3eh	; close file
	int 21h	

	mov ah, 09h	; print string
	lea dx, string
	int 21h

	mov ah, 09h	; print enter
	lea dx, enter
	int 21h

	ret

find_vendor:
	lea dx, vendors_file	; open file
	mov ah, 3dh
	mov al, 0h
	int 21h

	mov bx, ax	; save file handler to bx

read_vendor:
	mov ah, 3fh	; read from file
	mov cx, 76	; number of bytes to read
	lea dx, string
	int 21h

	mov ah, 3fh	; read vendor id to shift	
	mov cx, 4
	lea dx, shift
	int 21h

	lea di, vendor_id
	jmp cmp_nums_vendor

close_vendor:
	mov ah, 3eh	; close file
	int 21h	
	
	mov ah, 09h	; print string
	lea dx, string
	int 21h
	
	ret

cmp_nums_vendor:
	lea si, string
	cmpsb		; compare byte strings si and di
	jne read_vendor
	cmpsb
	jne read_vendor
	cmpsb
	jne read_vendor
	cmpsb
	jne read_vendor

	je close_vendor

cmp_nums_device:
	lea si, string
	cmpsb		; compare byte strings si and di
	jne read_device
	cmpsb
	jne read_device
	cmpsb
	jne read_device
	cmpsb
	jne read_device

	je close_device


h4:	ror bx, 8
	call h2
	ror bx, 8
h2:	mov al, bl
	shr al, 4
	call h1
	mov al, bl
h1:	and ax, 0fh
	cmp al, 10
	sbb al, 69h
	das
	stosb
	ret
end _

; :l1
; tasm /m5  prog.bat
; tlink /x/t prog.obj
; del prog.obj