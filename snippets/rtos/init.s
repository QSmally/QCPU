
// noelimination because this section isn't explicitly referenced by the kernel
// root section

@section(noelimination) text
@align 2
@entrypoint

// actual init entrypoint

_:                bkpt
