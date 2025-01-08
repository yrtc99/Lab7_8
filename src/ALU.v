module ALU (
    input [4:0]  opcode,
    input [2:0]  func3,
    input        func7,
    input [31:0] operand1,
    input [31:0] operand2,
    output [31:0] alu_out,
    output       JB
);
    wire R, I1, I2, I3, S, B, U1, U2, J;
    wire [4:0] op = opcode;
    wire [31:0] sub_result;
    assign sub_result = $signed(operand1) - $signed(operand2);

    assign R  = ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0];
    assign I1 = ~op[4] & ~op[3] &  op[2] & ~op[1] & ~op[0];
    assign I2 = ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];
    assign I3 =  op[4] &  op[3] & ~op[2] & ~op[1] &  op[0];
    assign S  = ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0];
    assign B  =  op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0];
    assign U1 = ~op[4] &  op[3] &  op[2] & ~op[1] &  op[0];
    assign U2 = ~op[4] & ~op[3] &  op[2] & ~op[1] &  op[0];
    assign J  =  op[4] &  op[3] & ~op[2] &  op[1] &  op[0];

    wire add  = (R & (func3==3'b000) & ~func7) |
                (I1 & (func3==3'b000)) |
                I2 | S;
    wire sub  = (R & (func3==3'b000) &  func7) |
                (B & (func3!=3'b110) & (func3!=3'b111));
    wire subu =  B & ((func3==3'b110)|(func3==3'b111));
    wire slt  = ((I1|R) & (func3==3'b010));
    wire sltu = ((I1|R) & (func3==3'b011));

    // 修正: ALU 運算邏輯
    assign alu_out = U1 ? operand2 :
                     U2 ? (operand1 + operand2) :
                     (J|I3) ? (operand1 + operand2) :
                     add ? ($signed(operand1) + $signed(operand2)) :
                     sub ? sub_result :
                     subu ? (operand1 - operand2) :
                     slt ? {{31{1'b0}}, sub_result[31]} :
                     sltu ? {{31{1'b0}}, (operand1 < operand2)} :
                     (R & (func3==3'b001)) ? (operand1 << operand2[4:0]) :
                     (R & (func3==3'b101) & ~func7) ? (operand1 >> operand2[4:0]) :
                     (R & (func3==3'b101) &  func7) ? ($signed(operand1) >>> operand2[4:0]) :
                     (I1 & (func3==3'b001)) ? (operand1 << operand2[4:0]) :
                     (I1 & (func3==3'b101) & ~func7) ? (operand1 >> operand2[4:0]) :
                     (I1 & (func3==3'b101) &  func7) ? ($signed(operand1) >>> operand2[4:0]) :
                     ((R|I1) & (func3==3'b100)) ? (operand1 ^ operand2) :
                     ((R|I1) & (func3==3'b110)) ? (operand1 | operand2) :
                     ((R|I1) & (func3==3'b111)) ? (operand1 & operand2) :
                     32'd0;

    // 修正: Branch/Jump 條件判斷
    assign JB = J | I3 |
                (B & (func3==3'b000) & (operand1 == operand2)) |
                (B & (func3==3'b001) & (operand1 != operand2)) |
                (B & (func3==3'b100) & (sub_result[31])) |
                (B & (func3==3'b101) & ~(sub_result[31])) |
                (B & (func3==3'b110) & (operand1 < operand2)) |
                (B & (func3==3'b111) & ~(operand1 < operand2));
endmodule