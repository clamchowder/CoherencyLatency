include ../Common/arch_detect.mk

CFLAGS = -O3
LDFLAGS = -lm

all: $(TARGET)

amd64:
	$(CC) $(CFLAGS) MemoryLatency.c MemoryLatency_x86.s -o MemoryLatency_amd64 $(LDFLAGS)

amd64-numa:
	$(CC) $(CFLAGS) -DNUMA MemoryLatency.c MemoryLatency_x86.s -o MemoryLatency_numa_amd64 $(LDFLAGS) -lnuma

aarch64:
	$(CC) $(CFLAGS) MemoryLatency.c MemoryLatency_arm.s -o MemoryLatency_aarch64 $(LDFLAGS)

aarch64-numa:
	$(CC) $(CFLAGS) -DNUMA MemoryLatency.c MemoryLatency_arm.s -o MemoryLatency_aarch64 $(LDFLAGS) -lnuma

riscv64:
	$(CC) $(CFLAGS) MemoryLatency.c MemoryLatency_riscv.s -o MemoryLatency_riscv64 $(LDFLAGS)

riscv64-numa:
	$(CC) $(CFLAGS) -DNUMA MemoryLatency.c MemoryLatency_riscv.s -o MemoryLatency_riscv64 $(LDFLAGS) -lnuma

w64:
	$(CC) $(CFLAGS) MemoryLatency.cpp MemoryLatency_x86.s -o MemoryLatency_w64.exe $(LDFLAGS)

# w64 can build with mingw 11, which isn't available on jammy

ci: amd64 amd64-numa aarch64 riscv64 w64

clean:
	rm -f *.o && find . -type f -executable -delete

.PHONY: all ci clean
