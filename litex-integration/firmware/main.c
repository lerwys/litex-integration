#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <console.h>
#include <generated/csr.h>

#define LEDS_ADDR 0x50000000

static void delay(int x)
{
    // FIXME. RiscV specific
    while(x--) {
        __asm__ volatile (
            "addi   x0, x0, 0\n\t"
        );
    }
    return 0;
}

static inline void write_led (int led)
{
	*((volatile int*)LEDS_ADDR) = led;
}

int main (void)
{
    int i;
    int leds;
    while (1) {
        for (i = 0, leds = 1; i < 2; ++i) {
            write_led (leds);
            leds <<= 1;
            // These are on avarage 4 instructions, each taking
            // 3-4 cycles to complete. So, divide the delay in
            // seconds by 16
            delay(SYSTEM_CLOCK_FREQUENCY/5/16);
            // sleep () so your eyes can see the leds moving ...
        }
    }

    return 0;
}
