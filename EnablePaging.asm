;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;																			;
;Brihi Joshi - 2016142														;
;Taejas Gupta - 2016204														;		
;																			;																		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



mov eax, cr0                                   ; Set the A-register to control register 0.
and eax, 01111111111111111111111111111111b     ; Clear the PG-bit, which is bit 31.
mov cr0, eax                                   ; Set control register 0 to the A-register.

mov edi, 0x1000    ; Set the destination index to 0x1000.
mov cr3, edi       ; Set control register 3 to the destination index.
xor eax, eax       ; Nullify the A-register.
mov ecx, 4096      ; Set the C-register to 4096.
rep stosd          ; Clear the memory.
mov edi, cr3       ; Set the destination index to control register 3.

mov DWORD [edi], 0x2003      ; Set the uint32_t at the destination index to 0x2003.
add edi, 0x1000              ; Add 0x1000 to the destination index.
mov DWORD [edi], 0x3003      ; Set the uint32_t at the destination index to 0x3003.
add edi, 0x1000              ; Add 0x1000 to the destination index.
mov DWORD [edi], 0x4003      ; Set the uint32_t at the destination index to 0x4003.
add edi, 0x1000              ; Add 0x1000 to the destination index.


mov ebx, 0x00000003          ; Set the B-register to 0x00000003.
mov ecx, 512                 ; Set the C-register to 512.