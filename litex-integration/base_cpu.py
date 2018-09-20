#!/usr/bin/env python3
"""
    python base_cpu.py <param>

    build:
        Synthesize / compile
    build_lib:
        Recompile C support libraries
    gen_hdl:
        Generate HDL
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

import os
import sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), 'modules', 'wb_leds', 'data')))

# Now do your import
from litex_wrap import wb_leds

def csr_map_update(csr_map, csr_peripherals):
    csr_map.update(dict((n, v)
        for v, n in enumerate(csr_peripherals, start=max(csr_map.values()) + 1)))

# create our soc (fpga description)
class BaseSoC(SoCCore):
    ## Peripherals CSR declaration
    csr_peripherals = [
        "wb_leds",
        "dna",
    ]
    csr_map_update(SoCCore.csr_map, csr_peripherals)

    mem_map = {
        "wb_leds": 0x50000000
    }
    mem_map.update(SoCCore.mem_map)

    def __init__(self, platform, **kwargs):
        sys_clk_freq = int(12e6)
        # SoC init
        SoCCore.__init__(self, platform, sys_clk_freq,
#            cpu_type="picorv32",
#            cpu_type="vexriscv",
            cpu_type="lm32",
            cpu_type="vexriscv",
            csr_data_width=32,
#            shadow_base=0x00000000,
            integrated_rom_size=32768,
            integrated_main_ram_size=16384,
#            with_uart=True,
            ident="Test Proj", ident_version=True,
#            reserve_nmi_interrupt=True,
#            with_timer=True,
#            with_ctrl=True
        )

        # Clock Reset Generation
        self.submodules.crg = CRG(platform.request("clk12"), platform.request("user_btn"))

        # FPGA identification
        self.submodules.dna = dna.DNA()

        # wb leds
        user_leds = Cat(*[platform.request("user_led") for i in range(2)])
        self.submodules.wb_leds = wb_leds.WB_LEDS(platform, user_leds)
        self.add_wb_slave(mem_decoder(self.mem_map["wb_leds"]), self.wb_leds.wishbone)

if __name__ == '__main__':
    platform = Platform(programmer="vivado")
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
    elif argv[1] == "gen_hdl":
        builder = Builder(soc, output_dir="build", compile_gateware=False, compile_software=False)
        builder.build()
    elif argv[1] == "config":
        prog = platform.create_programmer()
        prog.load_bitstream("build/gateware/top.bit")
    else:
        print(__doc__)
        exit(-1)
