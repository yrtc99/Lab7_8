module Reg_M(
    input clk,
    input rst,
    input stall,
    input flush,

    // from EX
    input [31:0] alu_out_in,
    input [31:0] rs2_data_in,
    input [4:0]  rd_index_in,
    input [3:0]  dm_w_en_in,
    input        wb_en_in,
    input        wb_sel_in,
    input [2:0]  func3_in,

    // to MEM
    output reg [31:0] alu_out_out,
    output reg [31:0] rs2_data_out,
    output reg [4:0]  rd_index_out,
    output reg [3:0]  dm_w_en_out,
    output reg        wb_en_out,
    output reg        wb_sel_out,
    output reg [2:0]  func3_out
);
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            alu_out_out<=0; rs2_data_out<=0; rd_index_out<=0;
            dm_w_en_out<=0; wb_en_out<=0; wb_sel_out<=0; func3_out<=0;
        end
        else if(flush) begin
            alu_out_out<=0; rs2_data_out<=0; rd_index_out<=0;
            dm_w_en_out<=0; wb_en_out<=0; wb_sel_out<=0; func3_out<=0;
        end
        else if(!stall) begin
            alu_out_out<=alu_out_in; rs2_data_out<=rs2_data_in; rd_index_out<=rd_index_in;
            dm_w_en_out<=dm_w_en_in; wb_en_out<=wb_en_in; wb_sel_out<=wb_sel_in; func3_out<=func3_in;
        end
    end
endmodule
