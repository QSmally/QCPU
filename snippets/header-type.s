
@header Queue, type, len
                  u16 0x0000        // head
                  u16 0x0000        // tail
                  reserve @type, @len
@end

@define queuelen, 16

@section data
queue:            @Queue u8, @queuelen
