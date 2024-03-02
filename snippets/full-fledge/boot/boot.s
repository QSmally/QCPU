
// 'master boot' sector regfile (io0)

@org 0xC000

@region 256

entrypoint: u16 .kmain              ; reset jump text

@end
