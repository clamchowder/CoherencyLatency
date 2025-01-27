# Memory Latency Test

This test measures random memory access latency within increasing array sizes, and (hopefully) shows the latency and size of caches as well as memory latency. Modes, passed as the first parameter:
- (no parameter) - Uses plain C code and `current = A[current]` to measure latency
- asm - Uses `mov r15, [r15]` for x86-64 or `ldr x15, [x15]`. This can help accurately measure L1D latency, because many x86 CPUs take an extra cycle to calculate "complex" addresses. And compilers like to do that for the plain C version above. This doesn't seem to make a difference for ARM
- tlb - Accesses just one element per 4 KB region to measure virtual to physical address translation latency (so TLBs and page walkers). Cache latency is subtracted out to isolate address translation latency.

# Building

Make sure optimization is on, or L1D latencies may be quite a bit higher than expected.

## Windows
Under WSL, do `x86_64-w64-mingw32-gcc-win32 -O3 MemoryLatency.c MemoryLatency_x86.s -o MemoryLatency.exe`

Run with
`MemoryLatency.exe`
`MemoryLatency.exe asm`
`MemoryLatency.exe tlb`
## Linux, x86-64
`gcc -O3 MemoryLatency.c MemoryLatency_x86.s -o MemoryLatency`

## Linux/Android+Termux, aarch64
`gcc -O3 MemoryLatency.c MemoryLatency_arm.s -o MemoryLatency`

## Linux, riscv64
`gcc -O3 MemoryLatency.c MemoryLatency_riscv.s -o MemoryLatency`

## VS version
Open solution and build. This is only around to hit large pages on Windows. 

# Running (Linux/Cross-Compiled Version)
- `./MemoryLatency -test asm` Tests cache and memory latency with the default page size
- `./MemoryLatency -test asm -hugepages` Tests cache and memory latency with huge pages, which should minimize address translation penalties. You'll need to `echo (page count) > /proc/sys/vm/nr_hugepages` or have a kernel capable of doing transparent hugepages via madvise.
- `./MemoryLatency -test tlb` Roughly estimates address translation penalties. Currently only good for measuring L2 TLB hit latency.
- `./MemoryLatency -test stlf` An implementation of the test described at https://blog.stuffedcow.net/2014/01/x86-memory-disambiguation/ for measuring store to load forwarding latency, described under the "fast address" section
- `./MemoryLatency -test 128_stlf` Henry Wong's store to load forwarding latency test but with 128-bit vector loads and 64-bit stores with vector/FP registers. On some CPUs, this can show different behavior to the STLF test above, which uses 64-bit loads and 32-bit stores on the scalar integer side. 
