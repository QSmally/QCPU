
// QCPU 2 assembly syntax snippet

@define fopen 0x05

@section globals ; shared by threads, max. 256 bytes, fixed size

.path:      ascii "/etc/file" 0x00  ; ascii is just u8 with explicit encoding
.pathl:     u8 .pathl - .path       ; expressions
.pathptr:   u16 .path               ; path gets read as 16 bits
.longaddr:  u24 0x123456
.gobject:   u16 .global_object      ; reference to thread-local global object

@section locals ; thread local, fixed size

.global_object:
            ascii "hello world!" 0x00

@section stack ; thread local, initially max. 256 bytes

                                    ; kernel firmware may have leading bytes
.offset0:   reserve u8 24           ; reserve 24 bytes
.offset1:   reserve u16 24          ; reserve 48 bytes
.offset2:   u32 0x1234 0x5678       ; initialise 4 bytes
                                    ; base stack pointer location

@section text ; readonly

main:       imm  rx,    .path       ; 'main' must be a public label for linking
            imm  ry,    .path'u     ; upper byte syntax 'u, for u8 implicitly 'l
            sysc @fopen             ; fopen returns u8 file descriptor in rx
            msp  +1
            ast  rx
            mst  ssb,   .offset1 + 1
.deadlock:  jmp  0,     .deadlock   ; execs should end with sysc, jmp or ret
