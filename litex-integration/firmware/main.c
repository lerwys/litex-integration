#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <generated/csr.h>

#define LEDS_ADDR 0xF0000000

static int delay(volatile int x)
{
    while(x--);
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
        for (i = 0, leds = 0; i < 4; ++i) {
            write_led (leds);
            leds++;
            // These are on avarage 4 instructions, each taking
            // 3-4 cycles to complete. So, divide the delay in
            // seconds by 16
            delay(SYSTEM_CLOCK_FREQUENCY/5/16);
            // sleep () so your eyes can see the leds moving ...
        }
    }

    return 0;
}
