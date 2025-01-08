module Imm_Ext (
	input [31:0] inst,
	output [31:0] imm_ext_out
);
	wire I1, I2, T3, S, B, U1, U2, J;
	wire [4:0] op = inst[6:2];
	assign I1 = ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0];  //addi
	assign I2 = ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0]; //lb
	assign I3 = op[4] & op[3] & ~op[2] & ~op[1] & op[0]; //jalr
	assign S = ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
	assign B = op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
	assign U1 = ~op[4] & op[3] & op[2] & ~op[1] & op[0]; //lui
	assign U2 = ~op[4] & ~op[3] & op[2] & ~op[1] & op[0]; //auipc
	assign J = op[4] & op[3] & ~op[2] & op[1] & op[0];
	
	assign imm_ext_out = (I1 || I2 || I3)? {{20{inst[31]}},inst[31:20]} :
						 (S)? {{20{inst[31]}},inst[31:25],inst[11:7]} :
						 (B)? {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0} :
						 (U1 || U2)? {inst[31:12],12'b0} :
						 (J)? {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0} :
						 32'd0;
endmodule