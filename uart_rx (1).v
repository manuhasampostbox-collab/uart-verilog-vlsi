module uart_rx #(parameter CLKS_PER_BIT=10)(
input clk,input rx_in,
output reg rx_done=0,output reg[7:0]rx_data=0);
localparam IDLE=0,START=1,DATA=2,STOP=3;
reg[1:0]state=IDLE;reg[4:0]cnt=0;reg[2:0]idx=0;reg[7:0]shift=0;
always@(posedge clk)begin
rx_done<=0;
case(state)
IDLE:begin cnt<=0;idx<=0;
  if(rx_in==0)begin state<=START;cnt<=0;end end
START:begin cnt<=cnt+1;
  if(cnt==CLKS_PER_BIT-1)begin cnt<=0;state<=DATA;end end
DATA:begin cnt<=cnt+1;
  if(cnt==CLKS_PER_BIT-1)begin cnt<=0;
    shift[idx]<=rx_in;
    if(idx==7)begin idx<=0;state<=STOP;end else idx<=idx+1;
  end end
STOP:begin cnt<=cnt+1;
  if(cnt==CLKS_PER_BIT-1)begin
    rx_done<=1;rx_data<=shift;cnt<=0;state<=IDLE;end end
endcase
end
endmodule
