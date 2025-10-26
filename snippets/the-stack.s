
@section root
@align 2

_:                lui sp, (.top + @slen) rsh 8
                  jmpr .entrypoint

@end

@linkinfo(origin) root, 0xC800
@linkinfo(align) text, 32
@linkinfo(align) stack, 256

@section text
@align 2

.entrypoint:      bkpt

@section stack
@align 2
@region 512
@define slen, 512

top:              reserve u8, @slen       ; top of stack

@end
