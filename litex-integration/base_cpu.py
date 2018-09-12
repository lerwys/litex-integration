#!/usr/bin/env python3
"""
    python base_cpu.py <param>

    build:
        Synthesize / compile:
    build_lib:
        Recompile C support libraries:
    config:
        Load bitfile into fpga
"""
from migen import *
from litex_contrib.boards.platforms.cmod_a7 import Platform
from litex.build.generic_platform import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.cores import dna, xadc
from sys import argv, exit


def csr_map_update(csr_map, csr_peripherals):
    csr_map.update(dict((n, v)
        for v, n in enumerate(csr_peripherals, start=max(csr_map.values()) + 1)))

# create our soc (fpga description)
class BaseSoC(SoCCore):
    # Peripherals CSR declaration
    csr_peripherals = [
        "dna",
        "xadc",
        "rgbled",
        "leds",
        # "switches",
        "buttons"
        # "adxl362",
        # "display"
    ]
    csr_map_update(SoCCore.csr_map, csr_peripherals)

    def __init__(self, platform, **kwargs):
        sys_clk_freq = int(12e6)
        # SoC init (No CPU, we controlling the SoC with UART)
        SoCCore.__init__(self, platform, sys_clk_freq,
            # cpu_type="vexriscv",
            cpu_type="picorv32",
            csr_data_width=32,
            integrated_rom_size=0x8000,
            integrated_main_ram_size=16 * 1024,
            ident="Wir trampeln durchs Getreide ...", ident_version=True
        )

        # Clock Reset Generation
        self.submodules.crg = CRG(platform.request("clk12"), platform.request("user_btn"))

        # FPGA identification
        self.submodules.dna = dna.DNA()

        # FPGA Temperature/Voltage
        self.submodules.xadc = xadc.XADC()


if __name__ == '__main__':
    platform = Platform()
    soc = BaseSoC(platform)
    if len(argv) != 2:
        print(__doc__)
        exit(-1)
    if argv[1] == "build":
        builder = Builder(soc, output_dir="build")
        builder.build()
    elif argv[1] == "build_lib":
        builder = Builder(soc, output_dir="build", compile_gateware=False, compile_software=True)
        builder.build()
    elif argv[1] == "config":
        prog = platform.create_programmer()
        prog.load_bitstream("build/gateware/top.bit")
    else:
        print(__doc__)
        exit(-1)
