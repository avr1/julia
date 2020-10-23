#include "../../src/jl_exported_funcs.inc"

// On macOS, we need to prepend underscores on symbols
#if defined(__APPLE__) && defined(__MACH__)
#define UNDERSCORE(x) _##x
#else
#define UNDERSCORE(x) x
#endif

#if defined(_WIN64)
#define EXPORT(name)        .section .drectve,"r"; \
                            .ascii " -export:"#name""; \
                            .section text
#define SEH_START1(name)    .seh_proc name
#define SEH_START2()        .seh_endprologue
#define SEH_END()           .seh_endproc
#else
#define EXPORT(name)
#define SEH_START1(name)
#define SEH_START2()
#define SEH_END()
#endif

#define XX(name) \
.global name; \
.cfi_startproc; \
SEH_START1(name); \
name##:; \
SEH_START2(); \
    endbr64; \
    mov UNDERSCORE(name##_addr)(%rip),%rax; \
    jmpq *%rax; \
    ud2; \
SEH_END(); \
.cfi_endproc; \
EXPORT(name); \

JL_EXPORTED_FUNCS(XX)
#undef XX
