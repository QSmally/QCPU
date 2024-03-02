
// kernel device (io24...)

@org 0xC000

@section globals

.intmappt:  u16 .intmap
.kvmmappt:  u16 .kvmmap

@section gextension
@region 256 ; sysc/int map

.intmap:
            u16 .syscexit ; 0

@end
@region 256 ; kvariable mmap

.kvmmap:
            u16 0x00 0x10 ; io16

@end

@section text

.kmain:     imm  rx, 0x00           ; userland offset
            imm  ry, 0x00
            mldw sid, 1             ; load entrypoint
            jmp  sid, 0x00          ; call to main

.syscexit:  jmp  rel, .syscexit     ; deadlock
