;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;																			;
;Brihi Joshi - 2016142														;
;Taejas Gupta - 2016204														;		
;																			;																		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



mov eax, cr0                                   ; Moves the CR0 register to EAX(32 Bit)
and eax, 01111111111111111111111111111111b     ; Disable the previous paging by disabling the 31st bit - the PG bit
mov cr0, eax                                   ; Write the changes of EAX back to CR0

mov edi, 0x1000    							   ; Set the EDI register to 0x1000. This is where our PML4 points
mov cr3, edi       							   ; Set control register 3 to the destination index.
xor eax, eax      							   ; Nullify the A-register.
mov ecx, 4096     							   ; Set the C-register to 4096.
rep stosd          							   ; Clear the memory.
mov edi, cr3      							   ; Set the destination index to control register 3.

mov DWORD [edi], 0x2003      ; 0x2003 is where the PDPT points
add edi, 0x1000              ; Add 0x1000 to the destination index.
mov DWORD [edi], 0x3003      ; 0x3003 is where the PDT points
add edi, 0x1000              ; Add 0x1000 to the destination index.
mov DWORD [edi], 0x4003      ; 0x4003 is where the PT points
add edi, 0x1000              ; Add 0x1000 to the destination index.


mov ebx, 0x00000003          ; Set the B-register to 0x00000003.
mov ecx, 512                 ; Set the C-register to 512.