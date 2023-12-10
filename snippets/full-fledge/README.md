
# Kernel example

An example in which the files reside in I/O space, assuming they're
readable/writable I/O devices.

* `boot`: master boot sector [`0`]
* `kernel`: simplified kernel peripherals [`2` - `15`]
    - `ulmmap`: userland memory map [`16`]
* `userland`: a process [`17` - `23`]
