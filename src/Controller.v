module Controller(
    input  [4:0] op,       // opcode (inst[6:2])
    input  [2:0] func3,    // func3 (inst[14:12])
    input        func7,    // func7 (inst[30])
    input        JB,       // branch/jump taken, from ALU

    // 一般控制訊號
    output       next_pc_sel,  // 選擇 PC+4 或 branch/jump target
    output [3:0] im_w_en,      // instruction memory write enable (通常不用)
    output       wb_en,        // register file write back enable
    output       jb_op1_sel,   // jump/branch operand1 選擇 (rs1 or pc)
    output       alu_op1_sel,  // ALU operand1 選擇 (rs1 or pc)
    output       alu_op2_sel,  // ALU operand2 選擇 (rs2 or imm)
    output [4:0] out_opcode,   // 傳遞 opcode 給後續 Pipeline stage
    output [2:0] out_func3,    // 傳遞 func3
    output       out_func7,    // 傳遞 func7
    output       wb_sel,       // 選擇 ALU result 或 memory load data 寫回
    output [3:0] dm_w_en,      // data memory write enable
    output       jb_op2_sel,   // jump/branch operand2 選擇 (是否 mask bit0, e.g. jalr)
    output       memRead
);

    wire R, I1, I2, I3, S, B, U1, U2, J;
    assign R  = ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0];  // 01100 => R-type
    assign I1 = ~op[4] & ~op[3] &  op[2] & ~op[1] & ~op[0];  // 00100 => I-type (addi等)
    assign I2 = ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];  // 00000 => load (lb, lw...) 
    assign I3 =  op[4] &  op[3] & ~op[2] & ~op[1] &  op[0];  // 11001 => jalr
    assign S  = ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0];  // 01000 => store
    assign B  =  op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0];  // 11000 => branch
    assign U1 = ~op[4] &  op[3] &  op[2] & ~op[1] &  op[0];  // 01101 => lui
    assign U2 = ~op[4] & ~op[3] &  op[2] & ~op[1] &  op[0];  // 00101 => auipc
    assign J  =  op[4] &  op[3] & ~op[2] &  op[1] &  op[0];  // 11011 => jal

    //--------------------------------------------
    // 傳遞關鍵指令欄位
    //--------------------------------------------
    assign out_opcode = op;
    assign out_func3  = func3;
    assign out_func7  = func7;

    //--------------------------------------------
    // 一般控制訊號
    //--------------------------------------------
    // 修正: 當JB為1時，選擇跳轉目標
    assign next_pc_sel = JB;

    // instruction memory 通常不在 runtime 寫入
    assign im_w_en = 4'b0000;

    // wb_en：哪些指令會寫回暫存器檔
    assign wb_en = (R | I1 | I2 | I3 | U1 | U2 | J);

    // 修正: jb_op1_sel 的邏輯，除了jalr外都用pc
    assign jb_op1_sel = ~I3;

    // alu_op1_sel：ALU operand1 選擇
    assign alu_op1_sel = (U2 | I3 | J);

    // alu_op2_sel：ALU operand2 選擇
    assign alu_op2_sel = ~(R | B);

    // wb_sel：選擇寫回來源
    assign wb_sel = ~I2;  // 只有load指令要從memory讀取

    // dm_w_en：data memory write enable
    assign dm_w_en = (S & (func3==3'b000))? 4'b0001 :  // sb
                    (S & (func3==3'b001))? 4'b0011 :  // sh
                    (S & (func3==3'b010))? 4'b1111 :  // sw
                                         4'b0000;

    // jb_op2_sel：只有jalr需要mask bit0
    assign jb_op2_sel = I3;

    //--------------------------------------------
    // 給 HazardDetection 用
    //--------------------------------------------
    assign memRead = I2;

endmodule