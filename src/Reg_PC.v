module Reg_PC (
    input clk,
    input rst,
    input stall,
    input [31:0] next_pc,
    output reg [31:0] current_pc
);
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            current_pc <= 32'd0;
        end
        else if(!stall) begin
            current_pc <= next_pc;
        end
        // stall=1 => 保持
    end
endmodule