
// QCPU 2 assembly syntax snippet

; this define would be from @symbols "kernel/sysc.s"
; a kext may also be from @symbols "kernel/kernel.s"
@define fopen 0x05
@define mmap 0x07

@section global ; shared by threads, fixed size

.path:      ascii "/etc/fstab" 0x00 ; ascii is just u8 with explicit encoding
.pathsz:    u8 .pathsz - .path      ; expressions
.pathptr:   u16 .path               ; path gets read as 16 bits

@section empty ; shared by threads, empty, fixed size

.reserved:  reserve u16 128

@section local ; thread local, fixed size

.localvar0: reserve u8 24           ; reserve 24 bytes
.localvar1: reserve u16 24          ; reserve 48 bytes
.localvar2: u32 0x1234 0x5678       ; initialise 4 bytes

@section text ; readonly, executable

main:       imm   rx    .path       ; 'main' must be a public label for linking
            imm   ry    .path'u     ; upper byte syntax 'u, for u8 implicitly 'l
            imm   rz    0b00000000  ; fopen mask
            sysc  @fopen            ; fopen(pathl, pathh, msk) -> (,, fd)
            imm   rx    0x00        ; size low byte
            imm   ry    0x04        ; size high byte, 1024
            sysc  @mmap             ; mmap(sizel, sizeh, fd) -> (addrl, addrh)
            msp         0x0002
            ast   rx
            ast   ry
            mstw  sp    -2          ; store at recently allocated stack location
.spinlock:  jmpr        .spinlock   ; execs should end with sysc @exit, not lock
