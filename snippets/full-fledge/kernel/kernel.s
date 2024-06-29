
// kernel device (io24 ... io216)

@section globals

@region 32 ; kvariable mmap

kvmmap:
            u16 @/ulmmap
            reserve u16 15

@end

@section text

kmain:      mldw  n     0x00 0x00   ; load entrypoint, byte 0 of instance
            jmpd                    ; call to main
