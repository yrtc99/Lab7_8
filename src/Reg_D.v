module Reg_D(
    input clk,
    input rst,
    input stall,
    input flush,

    input [31:0] inst_in,
    input [31:0] pc_in,

    output reg [31:0] inst_out,
    output reg [31:0] pc_out
);
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            inst_out <= 32'd0;
            pc_out   <= 32'd0;
        end
        else if(flush) begin
            inst_out <= 32'd0;
            pc_out   <= 32'd0;
        end
        else if(!stall) begin
            inst_out <= inst_in;
            pc_out   <= pc_in;
        end
    end
endmodule