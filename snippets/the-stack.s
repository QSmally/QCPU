
@section root
@region 256
@align 2

_:                u16 .main         // entrypoint
                  reserve u16, 3
                  u16 .frame        // sf
                  u16 .ptr          // sp

@end

@linkinfo(origin) root, 0
@linkinfo(align) text, 256
@linkinfo(align) stack, 256

@section text
.main:            bkpt

@section stack
@region 512

.frame:           u16 .main         // some stack base values
                  u16 0xDEAD
                  u16 0xBEEF
.ptr:             reserve u8, 0     // pointer head

@end
