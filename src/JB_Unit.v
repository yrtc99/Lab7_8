module JB_Unit (
	input jb_op2_sel,
	input [31:0] operand1,
	input [31:0] operand2,
	output [31:0] jb_out
);
	
	assign jb_out = jb_op2_sel? ((operand1 + $signed(operand2)) & ~32'd1) : (operand1 + $signed(operand2));
	
endmodule
