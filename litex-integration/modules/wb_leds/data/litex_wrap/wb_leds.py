import os

from migen import *

from litex.soc.interconnect import wishbone


class WB_LEDS(Module):
    def __init__(self, platform, pads):
        self.reset = Signal()
        self.wishbone = wb = wishbone.Interface()

        self.leds = Signal(len(pads))

        # # #

        self.specials += Instance("wb_leds",
            i_clk_i=ClockSignal(),
            i_rst_n_i=~(ResetSignal() | self.reset),

            i_wb_adr_i=wb.adr,
            i_wb_dat_i=wb.dat_w,
            i_wb_sel_i=wb.sel,
            i_wb_cyc_i=wb.cyc,
            i_wb_stb_i=wb.stb,
            i_wb_we_i=wb.we,
            o_wb_dat_o=wb.dat_r,
            o_wb_ack_o=wb.ack,
            o_wb_err_o=wb.err,
            o_wb_rty_o=0,

            o_leds_o=self.leds,
        )

        # assignements
        self.comb += pads.eq(self.leds)

        # add verilog sources
        self.add_sources(platform)

    @staticmethod
    def add_sources(platform):
        vdir = os.path.join(
            os.path.abspath(os.path.dirname(__file__)), "../../rtl/verilog")
        platform.add_sources(vdir,
                "wb_leds.v",
        )
        vhddir = os.path.join(
            os.path.abspath(os.path.dirname(__file__)), "../../data")
        platform.add_sources(vhddir,
                "wb_leds_csr.vhd",
                "wb_leds_csr_wbgen.vhd",
        )
