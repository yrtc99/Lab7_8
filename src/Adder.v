module Adder(
	input [31:0] current_pc,
	output [31:0] adder_out_pc
);
	assign adder_out_pc = current_pc + 32'd4;
endmodule