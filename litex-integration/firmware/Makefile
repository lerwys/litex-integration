BUILD_DIR=/build

include $(BUILD_DIR)/software/include/generated/variables.mak
include $(SOC_DIRECTORY)/software/common.mak

TARGET   = firmware
OBJECTS  = isr.o main.o
LDFLAGS += --no-relax --print-memory-usage

all: $(TARGET).bin $(TARGET).lst

# pull in dependency info for *existing* .o files
-include $(OBJECTS:.o=.d)

$(TARGET).elf: $(OBJECTS)
	$(LD) $(LDFLAGS) \
		-T linker.ld \
		-N -o $@ \
		 $(BUILD_DIR)/software/libbase/crt0-$(CPU).o \
		$(OBJECTS) \
		-L$(BUILD_DIR)/software/libbase \
		-L$(BUILD_DIR)/software/libcompiler_rt \
		-lbase-nofloat -lcompiler_rt
	chmod -x $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@
	chmod -x $@

%.lst: %.elf
	riscv32-unknown-elf-objdump -d $^ > $@

%.o: %.c
	$(compile)

%.o: %.S
	$(assemble)

clean:
	$(RM) $(OBJECTS) $(OBJECTS:.o=.d) $(TARGET).elf $(TARGET).bin $(TARGET).lst .*~ *~

.PHONY: all clean
