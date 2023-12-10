
// QCPU 2 assembly syntax snippet

; this define would be from @include "kernel/sysc.s"
; a kext may also be from @include "kernel/kernel.s"
@define fopen 0x05
@define mmap 0x07

@section globals ; shared by threads, max. 256 bytes, fixed size

.path:      ascii "/etc/fstab" 0x00 ; ascii is just u8 with explicit encoding
.pathsz:    u8 .pathsz - .path      ; expressions
.pathptr:   u16 .path               ; path gets read as 16 bits

.longaddr:  u24 0x123456
.objext:    u16 .larger_global_obj  ; reference to a larger object

@section gextension ; extension on globals, fixed size

.larger_global_obj:
            ascii "hello world!" 0x00

@section stack ; thread local, initially max. 256 bytes

                                    ; kernel firmware may have leading bytes
.localvar0: reserve u8 24           ; reserve 24 bytes
.localvar1: reserve u16 24          ; reserve 48 bytes
.localvar2: u32 0x1234 0x5678       ; initialise 4 bytes
.offset:                            ; base stack pointer location

@section text ; readonly, executable

main:       imm  rx,    .path       ; 'main' must be a public label for linking
            imm  ry,    .path'u     ; upper byte syntax 'u, for u8 implicitly 'l
            imm  rz,    0b00000000  ; fopen mask
            sysc @fopen             ; fopen(pathl, pathh, msk) -> (,, fd)
            imm  rx,    0x00        ; size low byte
            imm  ry,    0x04        ; size high byte, 1024
            sysc @mmap              ; mmap(sizel, sizeh, fd) -> (addrl, addrh)
            msp  +2
            mstw sfb,   .offset     ; store at recently allocated stack location
.deadlock:  jmp  0,     .deadlock   ; execs should end with sysc, jmp or ret
