
@section root
@align 2

_:                jmpr .entrypoint

@section text
@align 2

.entrypoint:      bkpt

@linkinfo(origin) root, 0xC800
@linkinfo(align) text, 32
