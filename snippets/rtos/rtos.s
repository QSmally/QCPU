
@section root
@align 2

// kinit entrypoint

_:                ; enable logical and memory mapping ...
                  ; .physical_text
                  ; .physical_text'u
                  ; .physical_text'l

@if @text_len
                  ftlb                          ; flush tlb
                  jmp .text                     ; jumps to init in virtual memory
@else
                  @err "no init"
@end

// physical memory layout is always @linkinfo sequential
// virtual memory layout is determined by given addresses
// virtual memory addresses don't have to be sequential

// TODO: maybe allow overlapping virtual addresses to support multiple exec processes?

@linkinfo(origin) root, 0xC800                  ; generates .root (vm), .physical_root (pm), .root_size and @root_len
@linkinfo(expose, origin) text, 0x0000          ; generates .text (vm), .physical_text (pm). .text_size and @text_len
@linkinfo(expose, align) data, 256              ; generates .data (vm), .physical_data (pm), .data_size and @data_len
