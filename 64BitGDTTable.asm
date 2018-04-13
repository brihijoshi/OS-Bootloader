;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                           ;
;Brihi Joshi - 2016142                                                      ;
;Taejas Gupta - 2016204                                                     ;       
;                                                                           ;                                                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



GDT64:                               ; Global Descriptor Table (64-bit)
    .Null: equ $ - GDT64         
        dw 0xFFFF                    
        dw 0                         
        db 0                         
        db 0                        
        db 1                         
        db 0                         
    .Code: equ $ - GDT64         
        dw 0                         ; Limit - Describing where the segment ends
        dw 0                         ; Base level
        db 0                         ; Ring level
        db 10011010b                 ; Accessed - Whether this segment has already been accessed
        db 10101111b                 ; Granularity - Defining limit of the blocks (The size till which the blocks can extend)
        db 0                         ; Base - describes where the segment begins
    .Data: equ $ - GDT64           
        dw 0                        
        dw 0                         
        db 0                        
        db 10010010b                 
        db 00000000b                 
        db 0                        
    .Pointer:                        ; Pointer to the GDT Table itself
        dw $ - GDT64 - 1             ; Size of the GDT
        dq GDT64                     ; 64 bit pointer to the start of the GDT

