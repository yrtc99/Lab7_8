module LD_Filter (
	input [2:0] func3,
	input [31:0] ld_data,
	output [31:0] ld_data_f
);
	assign ld_data_f = (func3 == 3'b000)? {{24{ld_data[7]}},ld_data[7:0]} :	//lb
					   (func3 == 3'b100)? {24'd0,ld_data[7:0]} : //lbu
					   (func3 == 3'b001)? {{16{ld_data[15]}},ld_data[15:0]} : //lh
					   (func3 == 3'b101)? {16'd0,ld_data[15:0]} : //lhu
					   (func3 == 3'b010)? ld_data : //lw
					   32'd0;
					   
endmodule