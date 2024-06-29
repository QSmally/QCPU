
# Kernel example

An example in which the files reside in I/O space, assuming they're
readable/writable I/O devices.

```bash
$ qcpu -o boot boot/boot.s
$ qcpu -o kvariable --offset 0xD000 --define process:0xFFF0 kernel/kvariable/*.s
$ qcpu -o kernel --offset 0xC000 --define ulmmap:0xFFE0 kernel/*.s

# --userland adds an instance page at page 0 and populates it with a stack address
$ qcpu -o process --userland userland.s

# create a physical memory file based on the installation addresses
$ qcpub --create memory
$ qcpub memory --install boot:0x0000
$ qcpub memory --install kernel:0x1800
$ qcpub memory --install kvariable:0xFFE0
$ qcpub memory --install process:0xFFF0
```
