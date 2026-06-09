`timescale 1ns/1ps
module tb_uart;
parameter CLKS_PER_BIT=10;
reg clk=0,tx_start=0;reg[7:0]tx_data=0;
wire tx_out,tx_busy,rx_done;wire[7:0]rx_data;
uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) TX(.clk(clk),.tx_start(tx_start),.tx_data(tx_data),.tx_out(tx_out),.tx_busy(tx_busy));
uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) RX(.clk(clk),.rx_in(tx_out),.rx_done(rx_done),.rx_data(rx_data));
always #1 clk=~clk;
initial begin
repeat(5)@(posedge clk);
tx_data=8'h41;tx_start=1;@(posedge clk);tx_start=0;
@(posedge rx_done);repeat(5)@(posedge clk);
$display("byte1: 0x%h expected 0x41 -> %s",rx_data,(rx_data==8'h41)?"PASS":"FAIL");
tx_data=8'hFF;tx_start=1;@(posedge clk);tx_start=0;
@(posedge rx_done);repeat(5)@(posedge clk);
$display("byte2: 0x%h expected 0xff -> %s",rx_data,(rx_data==8'hFF)?"PASS":"FAIL");
tx_data=8'h55;tx_start=1;@(posedge clk);tx_start=0;
@(posedge rx_done);repeat(5)@(posedge clk);
$display("byte3: 0x%h expected 0x55 -> %s",rx_data,(rx_data==8'h55)?"PASS":"FAIL");
$display("ALL DONE");$finish;
end
endmodule
