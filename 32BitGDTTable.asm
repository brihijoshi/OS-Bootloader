.Start:
	dq 0x0
.Code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0
.Data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
.End:
.Pointer:
	dw .End - .Start
	dd .Start