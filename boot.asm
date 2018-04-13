;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;																			;
;Brihi Joshi - 2016142														;
;Taejas Gupta - 2016204														;		
;																			;																		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bits 16							; Start with 16 Bits of the Real Mode
org 0x7c00						; org tells the program where (location) to load the boot file to

boot:
	cli                         ; cli disables all the interrupts in order to prevent race conditions with interrupt handler
	lgdt [.Pointer]				; Load pointer to the GDT Table. Here, initial pointer is to the 32 Bit GDT Table
	mov eax, cr0				; Moves the CR0 register to EAX(32 Bit)
	or eax,0x1					; Make the first bit of EAX as 1 (The first bit represents the Protected Mode Bit)
	mov cr0, eax				; Write the changes of EAX back to CR0
	jmp CODE_SEG:boot32         ; Long jump to the code segment of 32 Bits


%include "32BitGDTTable.asm"	; Include the file which contains the 32 Bit GDT Table

CODE_SEG equ .Code - .Start		; Address of the code segment is address of code wrt address of start
DATA_SEG equ .Data - .Start     ; Address of the data segment is address of data wrt address of start

bits 32							; Now we have entered the 32 bit protected mode
boot32:
	%include "32BitDataSeg.asm"	; Setting the Data Segment Registers in the 32 Bit environment
	

%include "EnablePaging.asm"		; Prepare to enter the 64 bit mode by enabling paging

.SetEntry:
	mov DWORD [edi], ebx        ; Set the uint32_t at the destination index to the EBX
	add ebx, 0x1000             ; Add 0x1000 to the EBX
	add edi, 8                  ; Add eight to the destination index
	loop .SetEntry              ; Set the next entry

	%include "SwitchToProtected.asm"

	lgdt [GDT64.Pointer]        ; Load pointer to the GDT Table. Here, initial pointer is to the 64 Bit GDT Table
	jmp GDT64.Code:boot64       ; Long jump to the code segment of 64 Bits

%include "64BitGDTTable.asm"    ; Include the file which contains the 64 Bit GDT Table

[BITS 64]
boot64:
	
	cli                         ; Clear the interrupt flag
    mov ax, GDT64.Data            
    mov ds, ax                    
    mov es, ax                   
    mov fs, ax                    
    mov gs, ax                    
    mov ss, ax                    
    mov edi, 0xB8000            ; Add destination of the Video Buffer (VGA Buffer) to EDI
    mov rax, 0x000000  			; Make the Screen black
    mov ecx, 500                ; Set the C-register to 500.
    rep stosq                   ; Clear the screen.

    

    ; Display "hello-world"
    ; Move individual ASCII values of 'hello-world' into the VGA Buffer
    mov rdi, 0x00b8000              
 
    mov rax, 0x5f68   
    mov [rdi],rax
 
    mov rax, 0x5f65
    mov [rdi + 2], rax
 
    mov rax, 0x5f6c
    mov [rdi + 4], rax

    mov rax, 0x5f6c
    mov [rdi + 6], rax

    mov rax, 0x5f6f
    mov [rdi + 8], rax

    mov rax, 0x5f2d
    mov [rdi + 10], rax

    mov rax, 0x5f77
    mov [rdi + 12], rax

    mov rax, 0x5f6f
    mov [rdi + 14], rax

    mov rax, 0x5f72
    mov [rdi + 16], rax

    mov rax, 0x5f6c
    mov [rdi + 18], rax

    mov rax, 0x5f64
    mov [rdi + 20], rax

    ; Printing CR3 value

	mov rdi, 0xb8000 + 22		; Setting the VGA Buffer
	mov rdx, 0x3f				; Setting RDX to 63, for the index of the MSB in CR3 (it is 64 bits in size)
	xor rcx, rcx				; Initialising RCX as 0
	printcr3:
		cmp rdx, 0				; Comparing if our counter RDX is 0
		je end                  ; If RDX is 0, our printing has finished and we move to the end
		mov rax, cr3			; Move value of CR3 to RAX
		mov rbx, 0				; Initialise our counter RBX to 0

		shift_rax:
			cmp rbx, rdx		; If RBX equals RDX
			je next             ; Jump to the next stage
			add rbx, 1			; Increment our counter
			shr rax, 1			; Right shift by 1 position
			jmp shift_rax
		next:
			and rax, 1			; AND one particular index of RAX with 1
			add rcx, 2			; Increment RCX with 2
			cmp rax, 0			; If our print bit is 0
			je rax_zero
				mov rax, 0x5f31	; Print it on the VGA as 0
				mov [rdi+rcx], rax
				jmp end_if
			rax_zero:
				mov rax, 0x5f30	; Else print it on VGA as 1
				mov [rdi+rcx], rax
			end_if:
			sub rdx, 1			; Subtract our Index counter by 1
			jmp printcr3

	end:
	finish:

	    hlt                     ; Halt the processor.



times 510 - ($-$$) db 0
dw 0xaa55
