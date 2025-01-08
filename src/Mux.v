module Mux (
    input select,
    input [31:0] input_1,
    input [31:0] input_0,
    output [31:0] o
);
    assign o = select ? input_1 : input_0;
endmodule