bits 16
org 0x7c00

boot:
	cli
	lgdt [gdt_pointer]
	mov eax, cr0
	or eax,0x1
	mov cr0, eax
	jmp CODE_SEG:boot2
gdt_start:
	dq 0x0
gdt_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0
gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
gdt_end:
gdt_pointer:
	dw gdt_end - gdt_start
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32
boot2:
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

.SetEntry:
	mov DWORD [edi], ebx         ; Set the uint32_t at the destination index to the B-register.
	add ebx, 0x1000              ; Add 0x1000 to the B-register.
	add edi, 8                   ; Add eight to the destination index.
	loop .SetEntry               ; Set the next entry.

	mov eax, cr4                 ; Set the A-register to control register 4.
	or eax, 1 << 5               ; Set the PAE-bit, which is the 6th bit (bit 5).
	mov cr4, eax                 ; Set control register 4 to the A-register.

	mov ecx, 0xC0000080          ; Set the C-register to 0xC0000080, which is the EFER MSR.
	rdmsr                        ; Read from the model-specific register.
	or eax, 1 << 8               ; Set the LM-bit which is the 9th bit (bit 8).
	wrmsr                        ; Write to the model-specific register.

	mov eax, cr0                 ; Set the A-register to control register 0.
	or eax, 1 << 31              ; Set the PG-bit, which is the 32nd bit (bit 31).
	mov cr0, eax                 ; Set control register 0 to the A-register.

	lgdt [GDT64.Pointer]         ; Load the 64-bit global descriptor table.
	jmp GDT64.Code:Realm64       ; Set the code segment and enter 64-bit long mode.

GDT64:                           ; Global Descriptor Table (64-bit).
    .Null: equ $ - GDT64         ; The null descriptor.
    dw 0xFFFF                    ; Limit (low).
    dw 0                         ; Base (low).
    db 0                         ; Base (middle)
    db 0                         ; Access.
    db 1                         ; Granularity.
    db 0                         ; Base (high).
    .Code: equ $ - GDT64         ; The code descriptor.
    dw 0                         ; Limit (low).
    dw 0                         ; Base (low).
    db 0                         ; Base (middle)
    db 10011010b                 ; Access (exec/read).
    db 10101111b                 ; Granularity, 64 bits flag, limit19:16.
    db 0                         ; Base (high).
    .Data: equ $ - GDT64         ; The data descriptor.
    dw 0                         ; Limit (low).
    dw 0                         ; Base (low).
    db 0                         ; Base (middle)
    db 10010010b                 ; Access (read/write).
    db 00000000b                 ; Granularity.
    db 0                         ; Base (high).
    .Pointer:                    ; The GDT-pointer.
    dw $ - GDT64 - 1             ; Limit.
    dq GDT64                     ; Base.



[BITS 64]
Realm64:
	
	cli                           ; Clear the interrupt flag.
    mov ax, GDT64.Data            ; Set the A-register to the data descriptor.
    mov ds, ax                    ; Set the data segment to the A-register.
    mov es, ax                    ; Set the extra segment to the A-register.
    mov fs, ax                    ; Set the F-segment to the A-register.
    mov gs, ax                    ; Set the G-segment to the A-register.
    mov ss, ax                    ; Set the stack segment to the A-register.
    mov edi, 0xB8000              ; Set the destination index to 0xB8000.
    mov rax, 0x000000  ; Set the A-register to 0x1F201F201F201F20.
    mov ecx, 500                  ; Set the C-register to 500.
    rep stosq                     ; Clear the screen.

    ; Display "Hello World!"
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

    ; Printing CR3 value, right shift by x values and AND with 1 to get the bit value and then print it.
	mov rdi, 0xb8000 + 22
	mov rdx, 0x3f
	xor rcx, rcx
	printcr3:
		cmp rdx, 0
		je end
		mov rax, cr3
		mov rbx, 0

		shift_rax:
			cmp rbx, rdx
			je next
			add rbx, 1
			shr rax, 1
			jmp shift_rax
		next:
			and rax, 1
			add rcx, 2
			cmp rax, 0
			je rax_zero
				mov rax, 0x5f31
				mov [rdi+rcx], rax
				jmp end_if
			rax_zero:
				mov rax, 0x5f30
				mov [rdi+rcx], rax
			end_if:
			sub rdx, 1
			jmp printcr3

	end:


	finish:

    hlt                           ; Halt the processor.



times 510 - ($-$$) db 0
dw 0xaa55
