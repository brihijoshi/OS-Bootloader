;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;																			;
;Brihi Joshi - 2016142														;
;Taejas Gupta - 2016204														;		
;																			;																		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



mov ax, DATA_SEG		; Attach the segment register ds, es, fs, gs, ss to the Data Segment 
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

; Writing Hello World in a 32 Bit Protected Environment

; mov esi,hello
; mov ebx,0xb8000
; jmp .loop
; .loop:
; 	lodsb
; 	or al,al
; 	jz halt
; 	or eax,0x0100
; 	mov word [ebx], ax
; 	add ebx,2
; 	jmp .loop
; hello: db "Hello",0
; halt: