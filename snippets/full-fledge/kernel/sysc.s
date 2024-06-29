
@define exit 0

@section globals

@section 256

imap:
.imap + @exit * 2:  u16 .sysc-exit

@end

@section text

ientry:     bsl   1                 ; interrupt *2 because 16 bit handler addr
            mldw' n     .imap       ; load address from interrupt map
            jmpd                    ; pipe address to jump

.sysc-exit: jmpr        .sysc-exit  ; spinlock
