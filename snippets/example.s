
// QCPU 2 assembly syntax snippet

; this define would be from @import "lib/sysc.s"
@define fopen 0x05
@define mmap 0x07

@section data

.path:            ascii "/etc/fstab" 0x00 ; ascii is just u8 with explicit encoding
@align 2                                  ; u16 must be aligned to 2 bytes
.pathsz:          u16 .pathsz - .path     ; expressions
.pathptr:         u16 .path               ; path gets read as 16 bits

@section empty

.reserved:        reserve u8 256

@section text ; readonly, executable

main:             lui x1, .path'u         ; 'main' is exposed, for @linkinfo elsewhere
                  ioriu x1, .path         ; lower LSB is implicit, 'u is upper byte
                  lli x2, 0x00            ; fopen mask
                  sysc @fopen             ; fopen(pathptr, mask) -> fd
                  lui x2, 1024 lsh 8      ; mmap size
                  sysc @mmap              ; mmap(fd, size) -> ptr
                  addi sp, -2             ; or alloc -2 pseudoinstruction
                  mstw x1, sp, 0          ; store at sp
.spinlock:        jmpr .spinlock          ; execs should end with sysc @exit
