`timescale 1ns/1ps

module tb_uart;

// ---- parameters (must match TX and RX) ----
parameter CLKS_PER_BIT = 434;
parameter CLK_PERIOD   = 20; // 20ns = 50MHz clock

// ---- signals ----
reg        clk      = 0;
reg        tx_start = 0;
reg  [7:0] tx_data  = 0;
wire       tx_out;
wire       tx_busy;
wire       rx_done;
wire [7:0] rx_data;

// ---- connect TX and RX together ----
uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) TX (
    .clk      (clk),
    .tx_start (tx_start),
    .tx_data  (tx_data),
    .tx_out   (tx_out),
    .tx_busy  (tx_busy)
);

uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) RX (
    .clk     (clk),
    .rx_in   (tx_out),   // TX output wire goes directly into RX input
    .rx_done (rx_done),
    .rx_data (rx_data)
);

// ---- clock generator: toggles every 10ns = 50MHz ----
always #(CLK_PERIOD/2) clk = ~clk;

// ---- task: send one byte and check the result ----
task send_and_check;
    input [7:0] byte_to_send;
    begin
        // put data on input and pulse tx_start
        @(posedge clk);
        tx_data  = byte_to_send;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        // wait for rx_done to go HIGH
        @(posedge rx_done);

        // check result
        if (rx_data === byte_to_send)
            $display("PASS: sent 0x%h, received 0x%h", byte_to_send, rx_data);
        else
            $display("FAIL: sent 0x%h, received 0x%h", byte_to_send, rx_data);
    end
endtask

// ---- main test sequence ----
initial begin
    $dumpfile("uart_wave.vcd");   // save waveform to this file
    $dumpvars(0, tb_uart);        // dump all signals

    $display("-----------------------------");
    $display("  UART Testbench Starting");
    $display("-----------------------------");

    // wait a few clocks before starting
    repeat(5) @(posedge clk);

    // send 3 different bytes
    send_and_check(8'h41);   // 'A'
    send_and_check(8'hFF);   // all 1s
    send_and_check(8'h55);   // alternating 01010101

    $display("-----------------------------");
    $display("  Simulation complete");
    $display("-----------------------------");

    $finish;
end

endmodule
