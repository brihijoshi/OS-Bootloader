;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;																			;
;Brihi Joshi - 2016142														;
;Taejas Gupta - 2016204														;		
;																			;																		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


.Start:
	dq 0x0
.Code:
	dw 0xFFFF				; Limit - Describing where the segment ends
	dw 0x0					; Base level
	db 0x0					; Ring level
	db 10011010b			; Accessed - Whether this segment has already been accessed
	db 11001111b			; Granularity - Defining limit of the blocks (The size till which the blocks can extend)
	db 0x0					; Base - describes where the segment begins
.Data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
.End:
.Pointer:					; Pointer to the GDT Table itself
	dw .End - .Start		; Size of the GDT
	dd .Start				; 32 bit pointer to the start of the GDT