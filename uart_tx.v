module uart_tx #(
    parameter CLKS_PER_BIT = 434
)(
    input        clk,
    input        tx_start,
    input  [7:0] tx_data,
    output reg   tx_out,
    output reg   tx_busy
);

localparam IDLE  = 2'd0;
localparam START = 2'd1;
localparam DATA  = 2'd2;
localparam STOP  = 2'd3;

reg [1:0]  state    = IDLE;
reg [8:0]  clk_cnt  = 0;
reg [2:0]  bit_idx  = 0;
reg [7:0]  tx_shift = 0;

always @(posedge clk) begin
    case (state)

        IDLE: begin
            tx_out  <= 1'b1;
            tx_busy <= 1'b0;
            clk_cnt <= 0;
            bit_idx <= 0;
            if (tx_start) begin
                tx_shift <= tx_data;
                state    <= START;
            end
        end

        START: begin
            tx_out  <= 1'b0;
            tx_busy <= 1'b1;
            if (clk_cnt < CLKS_PER_BIT - 1)
                clk_cnt <= clk_cnt + 1;
            else begin
                clk_cnt <= 0;
                state   <= DATA;
            end
        end

        DATA: begin
            tx_out <= tx_shift[bit_idx];
            if (clk_cnt < CLKS_PER_BIT - 1)
                clk_cnt <= clk_cnt + 1;
            else begin
                clk_cnt <= 0;
                if (bit_idx < 7)
                    bit_idx <= bit_idx + 1;
                else begin
                    bit_idx <= 0;
                    state   <= STOP;
                end
            end
        end

        STOP: begin
            tx_out <= 1'b1;
            if (clk_cnt < CLKS_PER_BIT - 1)
                clk_cnt <= clk_cnt + 1;
            else begin
                clk_cnt <= 0;
                state   <= IDLE;
            end
        end

        default: state <= IDLE;

    endcase
end

endmodule
