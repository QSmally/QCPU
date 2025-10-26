
@section mmio
@align 8

rtdebug:          reserve u8, 256
uart0:            reserve u8, 8           ; 16550a interface
uart1:            reserve u8, 8
uart2:            reserve u8, 8
uart3:            reserve u8, 8

@section root
@align 2

_:                jmpr .entrypoint

@section text
@align 2

.entrypoint:      bkpt

@linkinfo(origin) mmio, 0xC000
@linkinfo(origin) root, 0xC800
@linkinfo(align) text, 32
