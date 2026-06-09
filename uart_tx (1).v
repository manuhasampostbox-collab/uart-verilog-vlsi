module uart_tx #(parameter CLKS_PER_BIT=10)(
input clk,input tx_start,input[7:0]tx_data,
output reg tx_out=1,output reg tx_busy=0);
localparam IDLE=0,START=1,DATA=2,STOP=3;
reg[1:0]state=IDLE;reg[4:0]cnt=0;reg[2:0]idx=0;reg[7:0]shift=0;
always@(posedge clk)case(state)
IDLE:begin tx_out<=1;tx_busy<=0;cnt<=0;idx<=0;
  if(tx_start)begin shift<=tx_data;state<=START;end end
START:begin tx_out<=0;tx_busy<=1;
  if(cnt==CLKS_PER_BIT-1)begin cnt<=0;state<=DATA;end else cnt<=cnt+1;end
DATA:begin tx_out<=shift[idx];
  if(cnt==CLKS_PER_BIT-1)begin cnt<=0;
    if(idx==7)begin idx<=0;state<=STOP;end else idx<=idx+1;
  end else cnt<=cnt+1;end
STOP:begin tx_out<=1;tx_busy<=0;
  if(cnt==CLKS_PER_BIT-1)begin cnt<=0;state<=IDLE;end else cnt<=cnt+1;end
endcase
endmodule
