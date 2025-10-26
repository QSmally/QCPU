
@import csr, "lib/csr.s"

@section pcb ; this memory is virtualised, so each hart has its own
@align 256

pcb:              reserve u16, 7          ; process context block
pirp:             reserve u16, 1          ; pcb interrupt return ptr
pfl:              reserve u8, 1           ; pcb flag register
                  reserve u8, 1
kctx:             reserve u16, 2          ; kernel context

@section text
@align 2

// interrupt calls don't update rp, but use csr.irp (interrupt instruction ptr)
// first save x1 to scratch to build PCB address

uinterrupt:       csrw x1, @csr.scr       ; save x1 to scratch to build PCB address
                  lui x1, .pcb rsh 8      ; x1 = pcb base address
                  mstw rp, x1, 0          ; pcb = r1
                  mstw sp, x1, 2          ; pcb+2 = r2
                  mstw x2, x1, 6          ; pcb+6 = r4
                  mstw x3, x1, 8          ; pcb+8 = r5
                  mstw t1, x1, 10         ; pcb+10 = r6
                  mstw t2, x1, 12         ; pcb+12 = r7
                  csrr x2, @csr.scr       ; x2 = scr
                  mstw x2, x1, 4          ; pcb+4 = original x1
                  csrr x2, @csr.irp       ; x2 = irp
                  mstw x2, x1, 14         ; pirp = irp
                  csrr x2, @csr.fl        ; x2 = fl
                  mst x2, x1, 16          ; pfl = fl

                  mldw rp, x1, 18         ; r1 = kctx+0
                  mldw sp, x1, 20         ; r2 = kctx+2
                  csrr x1, @csr.int       ; x1 = int

                  // ... jump to csr.int handler
