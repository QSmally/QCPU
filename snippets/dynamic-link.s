
// the QCPU 2 arch only supports static linking, and a dynamic link library
// must be implemented in userland using dynamic jump pointers and a call to
// the kernel's mmap

// this example does lazy text linking

@section root
@align 2

_:                lui sp, .sp rsh 8       ; load stack ptr
                  lui rp, .ld rsh 8
                  ioriu rp, .ld & 0xFF
                  mldw rp, rp, @subr1     ; overwriting rp anyway
                  jmpdl rp                ; dynamic call

@linkinfo(origin) root, 0x0800
@linkinfo(align) text, 32
@linkinfo(align) data, 32
@linkinfo(align) stack, 256

@section text
@align 2

@header on_dlinker, subr, handle
                  alloc -8
                  mstw rp, sp, 6
                  mstw x1, sp, 4
                  lli x1, @subr
                  jmpr @handle
@end

.dlinker0:        @on_dlinker @subr0, .dlinker
.dlinker1:        @on_dlinker @subr1, .dlinker
.dlinker2:        @on_dlinker @subr2, .dlinker

.dlinker:         mstw x2, sp, 2
                  mstw x3, sp, 0
                  lui x2, .ld rsh 8
                  ioriu x2, .ld & 0xFF

                  lui x3, .subr0_main rsh 8     ; call kernel instead of this
                  ioriu x3, .subr0_main & 0xFF
                  mstw x3, x2, @subr0
                  lui x3, .subr1_main rsh 8     ; call kernel instead of this
                  ioriu x3, .subr1_main & 0xFF
                  mstw x3, x2, @subr1
                  lui x3, .dlink_fail rsh 8     ; call kernel instead of this
                  ioriu x3, .dlink_fail & 0xFF
                  mstw x3, x2, @subr2

                  add x2, x2, x1          ; offset ld + map
                  mldw x2, x2, 0          ; todo: fix arguments clobber
                  jmpdl x2                ; call inner
                  mldw rp, sp, 6
                  mldw x1, sp, 4
                  mldw x2, sp, 2
                  mldw x3, sp, 0
                  alloc 8
                  ret

.dlink_fail:      bkpt

@section text
@align 2

.subr0_main:      bkpt

.subr1_main:      bkpt

@section data
@align 2

@define subr0, 0
@define subr1, 2
@define subr2, 4

.ld:              u16 .dlinker0
                  u16 .dlinker1
                  u16 .dlinker2

// stack copied from the-stack.s

@section stack
@align 2
@region 512

_st:              reserve u8, 512 - 6     ; top of stack
.sp:              u16 .main               ; some stack base values
                  u16 0xDEAD
_sb:              u16 0xBEEF              ; stack bottom

@end
