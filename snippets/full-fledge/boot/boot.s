
// 'master boot' sector regfile (io0)

@symbols "kernel/kernel.s"
@symbols "kernel/sysc.s"

@region 256

entrypoint: u16 .kmain              ; main entrypoint
interrupt:  u16 .ientry             ; interrupt entrypoint
kstack:     u16 -1
kvariable:  u16 .kvmmap             ; kvariable memory map

@end
