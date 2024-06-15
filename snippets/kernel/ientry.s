
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

ientry:     bsl 1                   ; interrupt *2 because 16 bit handler addr
            prf i d,    .imap

            msp,        7           ; adds 7 to stack ptr, recovers acc
            xch ra                  ; ra = interrupt identifier
            mst sf,     @so + 0
            ast rb
            mst sf,     @so + 1
            ast rc
            mst sf,     @so + 2
            ast rd
            mst sf,     @so + 3

            addi,       -@last_sysc ; skip rx/ry/rz if in sysc range
            brh s,      .iload

            ast rx
            mst sf,     @so + 4
            ast ry
            mst sf,     @so + 5
            ast rz
            mst sf,     @so + 6

.iload:     ast ra                  ; load interrupt service routine
            mld n',     .imap

            jmp,        0x0000      ; pipe address to jump
