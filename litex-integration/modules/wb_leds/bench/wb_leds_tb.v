module wb_leds_tb;
    localparam clk_period = 5;
    localparam clk_half_period = clk_period/2;
    localparam num_cycles_rst = 4;
    localparam rst_period = num_cycles_rst * clk_period;

    localparam MAX_ADDR = 31;
    localparam WB_AW = 32;
    localparam WB_DW = 32;
    //Word size in bytes
    localparam WSB = WB_DW/8;

    //Configuration registers
    localparam REG_LED_ADDR = 0*WSB;

    reg clk     = 1'b1;
    reg rst_n   = 1'b0;
    wire rst;

    always #clk_half_period clk <= !clk;
    initial #rst_period rst_n <= 1;
    assign rst = ~rst_n;

    vlog_tb_utils vlog_tb_utils0();
    vlog_functions utils();
    vlog_tap_generator #("wb_leds_tb.tap", 1) tap();

    //Wishbone configuration interface
    wire [WB_AW-1:0]    wb_m2s_adr;
    wire [WB_DW-1:0]    wb_m2s_dat;
    wire [WB_DW/8-1:0]  wb_m2s_sel;
    wire                wb_m2s_we;
    wire                wb_m2s_cyc;
    wire                wb_m2s_stb;
    wire [WB_DW-1:0]    wb_s2m_dat;
    wire                wb_s2m_ack;
    wire                wb_s2m_err;

    // DUT signals
    wire [31:0] leds;

    wb_bfm_master #(
    )
    wb_cfg(
        .wb_clk_i       (clk),
        .wb_rst_i       (rst),
        .wb_adr_o       (wb_m2s_adr),
        .wb_dat_o       (wb_m2s_dat),
        .wb_sel_o       (wb_m2s_sel),
        .wb_we_o        (wb_m2s_we),
        .wb_cyc_o       (wb_m2s_cyc),
        .wb_stb_o       (wb_m2s_stb),
        .wb_dat_i       (wb_s2m_dat),
        .wb_ack_i       (wb_s2m_ack),
        .wb_err_i       (wb_s2m_err),
        .wb_rty_i       (1'b0));

    wb_leds dut (
        .clk_i          (clk),
        .rst_n_i        (rst_n),

        .wb_adr_i       (wb_m2s_adr),
        .wb_dat_i       (wb_m2s_dat),
        .wb_sel_i       (wb_m2s_sel),
        .wb_we_i        (wb_m2s_we),
        .wb_cyc_i       (wb_m2s_cyc),
        .wb_stb_i       (wb_m2s_stb),
        .wb_dat_o       (wb_s2m_dat),
        .wb_ack_o       (wb_s2m_ack),
        .wb_err_o       (wb_s2m_err),

        .leds_o         (leds)
    );

    reg                VERBOSE = 2;
    initial begin
        if($test$plusargs("verbose"))
            VERBOSE = 2;

        @(negedge rst);
        @(posedge clk);

        test_main();
        tap.ok("All done");
        $finish;
    end

    reg [WB_DW-1:0] stimuli;

    task test_main;
        integer adr;
        integer idx;
        integer tmp;
        begin
            //Generate stimuli
            tmp = $urandom % MAX_ADDR;
            stimuli = tmp[WB_DW-1:0];

            // Turn LED on
            cfg_write(REG_LED_ADDR, stimuli);
            // FIXME. Wait a few clock cycles for the WB transaction to complete
            @(posedge clk);
            @(posedge clk);
            // verify that only the selected LED in turned on
            verify(leds, stimuli);

            // Turn LED on
            cfg_write(REG_LED_ADDR, 0);
            // FIXME. Wait a few clock cycles for the WB transaction to complete
            @(posedge clk);
            @(posedge clk);
            // verify that rnly the selected LED are turned off
            verify(leds, 0);
        end
    endtask

    task cfg_write;
        input [WB_AW-1:0] addr_i;
        input [WB_DW-1:0] data_i;

        reg  err;
        begin
            wb_cfg.write(addr_i, data_i, 4'hf, err);
            if(err) begin
                $display("Error writing to config interface address 0x%8x", addr_i);
                $finish;
            end
        end
    endtask

    task verify;
        input [WB_DW-1:0] expected;
        input [WB_DW-1:0] received;
        begin
            if(received !== expected) begin
                $display("Verify failed. Expected 0x%8x : Got 0x%8x",
                    expected,
                    received);
                $finish;
            end
        end
    endtask


endmodule
