
@symbols "sysc/open"
@symbols "sysc/mmap"

@define open 0
@define mmap 1

@define last_sysc 31

@section globals

imap:
.imap + @open * 2:  u16 .sysc-open
.imap + @mmap * 2:  u16 .sysc-mmap

@section text

; accumulator is populated with interrupt
; interrupts push 3 elements to the kernel stack:
;  - frame pointer
;  - return pointer
;  - accumulator
@define so 6

ientry:     bsl   1                 ; interrupt *2 because 16 bit handler addr
            prf'        .imap       ; prefetch imap table

            msp         7           ; adds 7 to stack ptr, recovers acc
            xch   ra                ; ra = interrupt identifier
            ast   rb
            mstw  sf    @so + 0
            ast   rc
            ast   rd
            mstw  sf    @so + 2

            ast   ra                ; skip rx/ry/rz if in sysc range
            addi        -@last_sysc
            brh   s     .handle

            ast   rx
            ast   ry
            mstw  sf    @so + 4
            ast   rz
            mst   sf    @so + 6

.handle:    ast   ra                ; load interrupt service routine
            mldw' n     .imap
            jmpd                    ; pipe address to jump
