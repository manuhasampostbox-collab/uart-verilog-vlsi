module uart_rx #(
    parameter CLKS_PER_BIT = 434
)(
    input        clk,
    input        rx_in,
    output reg   rx_done,
    output reg [7:0] rx_data
);

localparam IDLE  = 2'd0;
localparam START = 2'd1;
localparam DATA  = 2'd2;
localparam STOP  = 2'd3;

reg [1:0]  state   = IDLE;
reg [8:0]  clk_cnt = 0;
reg [2:0]  bit_idx = 0;
reg [7:0]  rx_shift = 0;

always @(posedge clk) begin
    rx_done <= 1'b0;

    case (state)

        IDLE: begin
            clk_cnt <= 0;
            bit_idx <= 0;
            if (rx_in == 1'b0)
                state <= START;
        end

        START: begin
            if (clk_cnt == (CLKS_PER_BIT-1)/2) begin
                if (rx_in == 1'b0) begin
                    clk_cnt <= 0;
                    state   <= DATA;
                end else
                    state <= IDLE;
            end else
                clk_cnt <= clk_cnt + 1;
        end

        DATA: begin
            if (clk_cnt < CLKS_PER_BIT - 1)
                clk_cnt <= clk_cnt + 1;
            else begin
                clk_cnt        <= 0;
                rx_shift[bit_idx] <= rx_in;
                if (bit_idx < 7)
                    bit_idx <= bit_idx + 1;
                else begin
                    bit_idx <= 0;
                    state   <= STOP;
                end
            end
        end

        STOP: begin
            if (clk_cnt < CLKS_PER_BIT - 1)
                clk_cnt <= clk_cnt + 1;
            else begin
                rx_done <= 1'b1;
                rx_data <= rx_shift;
                clk_cnt <= 0;
                state   <= IDLE;
            end
        end

        default: state <= IDLE;

    endcase
end

endmodule
