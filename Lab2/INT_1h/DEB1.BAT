; @echo off
; goto l1
.model	tiny
.386
.code
org 100h

_:	
	jmp	start

int1_handler:
	push	bp
	mov	bp, sp

	pusha
	push	ds

	push	cs
	pop	es
	push	cs
	pop	ds	

	lea	di, out
	mov	bx, [bp+4]	 ;cs to print
	call	h4
	lea	di, [out+5]	 
	mov	bx, [bp+2]	;ip to print
	call	h4

	lea	dx, out
	mov	ah, 09h
	int	21h

	pop	ds
	popa

	pop	bp
	iret

start:
	mov	ax, 3D00h	; Open file (mode: read-only)
	lea	dx, filename
	int	21h	
	
	mov	bx, ax		; Read file
	mov	ah, 3Fh
	mov	cx, 256h	; number of bytes to read
	lea	dx, buffer
	int	21h

	mov	ah, 3Eh		; Close file
	int	21h

	mov	ax, 2501h	;writer new 1 interrupt
	lea	dx, int1_handler	
	int	21h

	pushf			; Change flags register
	pop	dx
	or	dx, 100h	; TF:=1	

	mov	bx, 100h

	lea	cx, psp
	shr	cx, 4

	mov	ax, cs
	add	ax, cx
	
	push	ax
	pop	ds

	pushf
	push	cs			; address for called program
	lea	cx, after_debug		
	push	cx
	xor	cx, cx ;0
	push	cx

	push	dx	;called flags
	push	ax	;code segment
	push	bx	
	iret

after_debug:
	push	cs
	pop	ds

	lea	dx, finish
	mov	ah, 09h
	int	21h
	ret

h4:	ror	bx, 8
	call	h2
	ror	bx, 8
h2:	mov	al, bl
	shr	al, 4
	call	h1
	mov	al, bl
h1:
	and	ax, 0fh
	cmp	al, 10
	sbb	al, 69h
	das
	stosb
	ret

align	16
psp:
	iret
	db	100h-($-psp) dup(0)	; program segment prefix

buffer	db	256h dup(0)
filename db	"helloworld.com", 0
finish	db	"Finish debug",13,10,"$"
out	db	"0000:0000",13,10,"$"

end _	

; :l1
; tasm /m5 deb1.bat
; tlink /x/t deb1.obj
; del deb1.obj

