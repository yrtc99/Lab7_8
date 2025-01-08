module Reg_E(
    input clk,
    input rst,
    input stall,
    input flush,

    // from ID
    input [31:0] pc_in,
    input [31:0] rs1_data_in,
    input [31:0] rs2_data_in,
    input [31:0] imm_in,
    input [4:0]  rs1_index_in,
    input [4:0]  rs2_index_in,
    input [4:0]  rd_index_in,
    // control
    input        jb_op1_sel_in,
    input        alu_op1_sel_in,
    input        alu_op2_sel_in,
    input        jb_op2_sel_in,
    input [3:0]  dm_w_en_in,
    input [3:0]  im_w_en_in,
    input        wb_en_in,
    input        wb_sel_in,
    input [4:0]  opcode_in,
    input [2:0]  func3_in,
    input        func7_in,

    // to EX
    output reg [31:0] pc_out,
    output reg [31:0] rs1_data_out,
    output reg [31:0] rs2_data_out,
    output reg [31:0] imm_out,
    output reg [4:0]  rs1_index_out,
    output reg [4:0]  rs2_index_out,
    output reg [4:0]  rd_index_out,

    // control
    output reg        jb_op1_sel_out,
    output reg        alu_op1_sel_out,
    output reg        alu_op2_sel_out,
    output reg        jb_op2_sel_out,
    output reg [3:0]  dm_w_en_out,
    output reg [3:0]  im_w_en_out,
    output reg        wb_en_out,
    output reg        wb_sel_out,
    output reg [4:0]  opcode_out,
    output reg [2:0]  func3_out,
    output reg        func7_out
);
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            pc_out <= 0; rs1_data_out<=0; rs2_data_out<=0; imm_out<=0;
            rs1_index_out<=0; rs2_index_out<=0; rd_index_out<=0;
            jb_op1_sel_out<=0; alu_op1_sel_out<=0; alu_op2_sel_out<=0; jb_op2_sel_out<=0;
            dm_w_en_out<=0; im_w_en_out<=0; wb_en_out<=0; wb_sel_out<=0;
            opcode_out<=0; func3_out<=0; func7_out<=0;
        end
        else if(flush) begin
            pc_out <= 0; rs1_data_out<=0; rs2_data_out<=0; imm_out<=0;
            rs1_index_out<=0; rs2_index_out<=0; rd_index_out<=0;
            jb_op1_sel_out<=0; alu_op1_sel_out<=0; alu_op2_sel_out<=0; jb_op2_sel_out<=0;
            dm_w_en_out<=0; im_w_en_out<=0; wb_en_out<=0; wb_sel_out<=0;
            opcode_out<=0; func3_out<=0; func7_out<=0;
        end
        else if(!stall) begin
            pc_out <= pc_in; rs1_data_out<=rs1_data_in; rs2_data_out<=rs2_data_in; imm_out<=imm_in;
            rs1_index_out<=rs1_index_in; rs2_index_out<=rs2_index_in; rd_index_out<=rd_index_in;
            jb_op1_sel_out<=jb_op1_sel_in; alu_op1_sel_out<=alu_op1_sel_in; alu_op2_sel_out<=alu_op2_sel_in; jb_op2_sel_out<=jb_op2_sel_in;
            dm_w_en_out<=dm_w_en_in; im_w_en_out<=im_w_en_in; wb_en_out<=wb_en_in; wb_sel_out<=wb_sel_in;
            opcode_out<=opcode_in; func3_out<=func3_in; func7_out<=func7_in;
        end
    end
endmodule