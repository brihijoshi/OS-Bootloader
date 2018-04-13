mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov esi,hello
	mov ebx,0xb8000
	jmp .loop
.loop:
	lodsb
	or al,al
	jz halt
	or eax,0x0100
	mov word [ebx], ax
	add ebx,2
	jmp .loop
hello: db "Hello",0
halt: