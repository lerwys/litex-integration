///////////////////////////////////////////////////////////////////////////////
// Title      : Wishbone LEDs
// Project    : FPGA Flow
///////////////////////////////////////////////////////////////////////////////
// File       : wb_slave_adapter.vhd
// Author     : Lucas Russo
// Company    :
// Platform   : FPGA-generics
// Standard   : Verilog-2001
///////////////////////////////////////////////////////////////////////////////
// Description:
//
//// Simple LED module with Wishbone interface
//
///////////////////////////////////////////////////////////////////////////////
// Copyright (c)
//
// This source file is free software; you can redistribute it
// and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any
// later version.
//
// This source is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE.  See the GNU Lesser General Public License for more
// details.
//
// You should have received a copy of the GNU Lesser General
// Public License along with this source; if not, download it
// from http://www.gnu.org/licenses/lgpl-2.1.html
///////////////////////////////////////////////////////////////////////////////

module wb_leds
(
    // Clock/Resets
    input               clk_i,
    input               rst_n_i,

    // Wishbone signals
    input  [31:0]       wb_adr_i,
    input  [31:0]       wb_dat_i,
    input  [3:0]        wb_sel_i,
    input               wb_we_i,
    input               wb_cyc_i,
    input               wb_stb_i,
    output [31:0]       wb_dat_o,
    output              wb_ack_o,
    output              wb_err_o,
    output              wb_rty_o,
    output              wb_stall_o,

    // LEDs
    output [31:0]       leds_o
);

wb_leds_csr wb_leds_csr (
    .rst_n_i            (rst_n_i),
    .clk_i              (clk_i),
    .wb_dat_i           (wb_dat_i),
    .wb_dat_o           (wb_dat_o),
    .wb_cyc_i           (wb_cyc_i),
    .wb_sel_i           (wb_sel_i),
    .wb_stb_i           (wb_stb_i),
    .wb_we_i            (wb_we_i),
    .wb_ack_o           (wb_ack_o),
    .wb_err_o           (wb_err_o),
    .wb_rty_o           (wb_rty_o),
    .wb_stall_o         (wb_stall_o),
    .leds_o             (leds_o)
);

endmodule
