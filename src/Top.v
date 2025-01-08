module Top (
    input clk,
    input rst
);
    //--------------------------------------
    // IF Stage
    //--------------------------------------
    wire stall;
    wire flush_D, flush_E;

    wire [31:0] current_pc, next_pc;
    Reg_PC reg_pc(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .next_pc(next_pc),
        .current_pc(current_pc)
    );

    // Instruction Memory (Harvard)
    wire [15:0] im_addr = current_pc[15:0];
    wire [31:0] inst_if;
    SRAM im(  // 與 Data Memory 分開
        .clk(clk),
        .w_en(4'b0000),   // 不寫IM
        .address(im_addr),
        .write_data(32'd0),
        .read_data(inst_if)
    );

    //--------------------------------------
    // IF → ID (Reg_D)
    //--------------------------------------
    wire [31:0] inst_id, pc_id;
    Reg_D reg_d(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush_D),
        .inst_in(inst_if),
        .pc_in(current_pc),
        .inst_out(inst_id),
        .pc_out(pc_id)
    );

    //--------------------------------------
    // ID Stage
    //--------------------------------------
    wire [4:0] opcode_id, rs1_id, rs2_id, rd_id;
    wire [2:0] func3_id;
    wire       func7_id;
    Decoder decoder(
        .inst(inst_id),
        .dc_out_opcode(opcode_id),
        .dc_out_func3(func3_id),
        .dc_out_func7(func7_id),
        .dc_out_rs1_index(rs1_id),
        .dc_out_rs2_index(rs2_id),
        .dc_out_rd_index(rd_id)
    );

    wire [31:0] rs1_data_id, rs2_data_id;
    wire wb_en_wb;
    wire [31:0] wb_data_wb;
    wire [4:0]  rd_wb;
    RegFile regfile(
        .clk(clk),
        .wb_en(wb_en_wb),
        .wb_data(wb_data_wb),
        .rd_index(rd_wb),
        .rs1_index(rs1_id),
        .rs2_index(rs2_id),
        .rs1_data_out(rs1_data_id),
        .rs2_data_out(rs2_data_id)
    );

    wire [31:0] imm_id;
    Imm_Ext imm_ext(
        .inst(inst_id),
        .imm_ext_out(imm_id)
    );

    // Controller
    wire next_pc_sel;
    wire [3:0] im_w_en_id;
    wire wb_en_id;
    wire jb_op1_sel_id;
    wire alu_op1_sel_id;
    wire alu_op2_sel_id;
    wire [4:0] out_opcode_id;
    wire [2:0] out_func3_id;
    wire out_func7_id;
    wire wb_sel_id;
    wire [3:0] dm_w_en_id;
    wire jb_op2_sel_id;

    // ALU branch taken (JB) 來自 EX 階段，我們先宣告 wire JB_ex
    wire JB_ex;

    // 是否為 load 指令? 給 Hazard Detection
    wire memRead_id;
    Controller controller(
        .op(opcode_id),
        .func3(func3_id),
        .func7(func7_id),
        .JB(JB_ex),
        .next_pc_sel(next_pc_sel),
        .im_w_en(im_w_en_id),
        .wb_en(wb_en_id),
        .jb_op1_sel(jb_op1_sel_id),
        .alu_op1_sel(alu_op1_sel_id),
        .alu_op2_sel(alu_op2_sel_id),
        .out_opcode(out_opcode_id),
        .out_func3(out_func3_id),
        .out_func7(out_func7_id),
        .wb_sel(wb_sel_id),
        .dm_w_en(dm_w_en_id),
        .jb_op2_sel(jb_op2_sel_id),
        .memRead(memRead_id)
    );

    //--------------------------------------
    // ID → EX (Reg_E)
    //--------------------------------------
    wire [31:0] pc_ex, rs1_data_ex, rs2_data_ex, imm_ex;
    wire [4:0]  rs1_index_ex, rs2_index_ex, rd_index_ex;
    wire [3:0]  dm_w_en_ex, im_w_en_ex;
    wire        wb_en_ex, wb_sel_ex, jb_op1_sel_ex, jb_op2_sel_ex;
    wire        alu_op1_sel_ex, alu_op2_sel_ex;
    wire [4:0]  opcode_ex;
    wire [2:0]  func3_ex;
    wire        func7_ex;
    Reg_E reg_e(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush_E),

        .pc_in(pc_id),
        .rs1_data_in(rs1_data_id),
        .rs2_data_in(rs2_data_id),
        .imm_in(imm_id),
        .rs1_index_in(rs1_id),
        .rs2_index_in(rs2_id),
        .rd_index_in(rd_id),

        .jb_op1_sel_in(jb_op1_sel_id),
        .alu_op1_sel_in(alu_op1_sel_id),
        .alu_op2_sel_in(alu_op2_sel_id),
        .jb_op2_sel_in(jb_op2_sel_id),
        .dm_w_en_in(dm_w_en_id),
        .im_w_en_in(im_w_en_id),
        .wb_en_in(wb_en_id),
        .wb_sel_in(wb_sel_id),
        .opcode_in(out_opcode_id),
        .func3_in(out_func3_id),
        .func7_in(out_func7_id),

        .pc_out(pc_ex),
        .rs1_data_out(rs1_data_ex),
        .rs2_data_out(rs2_data_ex),
        .imm_out(imm_ex),
        .rs1_index_out(rs1_index_ex),
        .rs2_index_out(rs2_index_ex),
        .rd_index_out(rd_index_ex),

        .jb_op1_sel_out(jb_op1_sel_ex),
        .alu_op1_sel_out(alu_op1_sel_ex),
        .alu_op2_sel_out(alu_op2_sel_ex),
        .jb_op2_sel_out(jb_op2_sel_ex),
        .dm_w_en_out(dm_w_en_ex),
        .im_w_en_out(im_w_en_ex),
        .wb_en_out(wb_en_ex),
        .wb_sel_out(wb_sel_ex),
        .opcode_out(opcode_ex),
        .func3_out(func3_ex),
        .func7_out(func7_ex)
    );

    //--------------------------------------
    // Hazard Detection
    //--------------------------------------
    // 1) Load-Use hazard => stall
    // 2) Branch => flush
    wire stall_HD, flush_D_HD, flush_E_HD;

    // 假設 EX 指令為 load => opcode_ex = I2 (您自己的 decode), 這裡簡化判斷
    // 例：I2 = 5'b00000
    wire memRead_ex = (opcode_ex == 5'b00000);  

    HazardDetectionUnit hazard_unit(
        .rs1_id(rs1_id),
        .rs2_id(rs2_id),
        .rd_ex(rd_index_ex),
        .memRead_ex(memRead_ex),
        .JB_ex(JB_ex),
        .stall(stall_HD),
        .flush_D(flush_D_HD),
        .flush_E(flush_E_HD)
    );

    // 因為可能 Controller 也想 flush ID/EX，但一般做法是 HazardUnit 主導
    // 這裡我們直接把 flush_D, flush_E 設為 hazard_unit 的結果
    assign flush_D = flush_D_HD;
    assign flush_E = flush_E_HD;
    assign stall   = stall_HD;  // pipeline 整體 stall

    //--------------------------------------
    // EX Stage
    //--------------------------------------
    // Forwarding
    wire [31:0] alu_out_mem;
    wire [4:0]  rd_index_mem;
    wire        wb_en_mem;

    wire [1:0] forwardA, forwardB;
    ForwardingUnit fwd_unit(
        .rs1_ex(rs1_index_ex),
        .rs2_ex(rs2_index_ex),
        .rd_mem(rd_index_mem),
        .wb_en_mem(wb_en_mem),
        .rd_wb(rd_wb),
        .wb_en_wb(wb_en_wb),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    // 取用 forward 後的運算元
    wire [31:0] alu_in1, alu_in2, jb_in1;
    wire [31:0] forward_data_MEM, forward_data_WB;
    assign forward_data_MEM = alu_out_mem; // 來自 MEM
    assign forward_data_WB  = wb_data_wb;  // 來自 WB

    reg [31:0] real_rs1, real_rs2;
    always @(*) begin
        // forwardA
        case(forwardA)
          2'b10: real_rs1 = forward_data_MEM;
          2'b01: real_rs1 = forward_data_WB;
          default: real_rs1 = rs1_data_ex;
        endcase

        // forwardB
        case(forwardB)
          2'b10: real_rs2 = forward_data_MEM;
          2'b01: real_rs2 = forward_data_WB;
          default: real_rs2 = rs2_data_ex;
        endcase
    end

    // 將 real_rs1, real_rs2 分別帶入 ALU op1, op2 MUX
    Mux mux_alu_op1(
        .select(alu_op1_sel_ex),
        .input_0(real_rs1),
        .input_1(pc_ex),
        .o(alu_in1)
    );
    Mux mux_alu_op2(
        .select(alu_op2_sel_ex),
        .input_0(real_rs2),
        .input_1(imm_ex),
        .o(alu_in2)
    );
    Mux mux_jb_op1(
        .select(jb_op1_sel_ex),
        .input_0(real_rs1),
        .input_1(pc_ex),
        .o(jb_in1)
    );

    wire [31:0] alu_out_ex;
    ALU alu(
        .opcode(opcode_ex),
        .func3(func3_ex),
        .func7(func7_ex),
        .operand1(alu_in1),
        .operand2(alu_in2),
        .alu_out(alu_out_ex),
        .JB(JB_ex)
    );

    wire [31:0] jb_pc_ex;
    JB_Unit jb_unit(
        .jb_op2_sel(jb_op2_sel_ex),
        .operand1(jb_in1),
        .operand2(imm_ex),
        .jb_out(jb_pc_ex)
    );

    // next_pc
    wire [31:0] pc_ex_plus4;
    Adder pc_adder_ex(
        .current_pc(pc_ex),
        .adder_out_pc(pc_ex_plus4)
    );
    Mux mux_next_pc(
        .select(next_pc_sel),
        .input_0(jb_pc_ex),
        .input_1(pc_ex_plus4),
        .o(next_pc)
    );

    //--------------------------------------
    // EX → MEM (Reg_M)
    //--------------------------------------
    wire [31:0]  rs2_data_mem;
    
    wire [3:0]  dm_w_en_mem;
    wire        wb_sel_mem;
    wire [2:0]  func3_mem;
    // 要注意 store 指令用 real_rs2
    Reg_M reg_m(
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .flush(1'b0),

        .alu_out_in(alu_out_ex),
        .rs2_data_in(real_rs2),
        .rd_index_in(rd_index_ex),
        .dm_w_en_in(dm_w_en_ex),
        .wb_en_in(wb_en_ex),
        .wb_sel_in(wb_sel_ex),
        .func3_in(func3_ex),

        .alu_out_out(alu_out_mem),
        .rs2_data_out(rs2_data_mem),
        .rd_index_out(rd_index_mem),
        .dm_w_en_out(dm_w_en_mem),
        .wb_en_out(wb_en_mem),
        .wb_sel_out(wb_sel_mem),
        .func3_out(func3_mem)
    );

    //--------------------------------------
    // MEM Stage (Data Memory)
    //--------------------------------------
    wire [15:0] dm_addr = alu_out_mem[15:0];
    wire [31:0] dm_read_data;
    SRAM dm(
        .clk(clk),
        .w_en(dm_w_en_mem),
        .address(dm_addr),
        .write_data(rs2_data_mem),
        .read_data(dm_read_data)
    );

    wire [31:0] ld_data_f_mem;
    LD_Filter ld_filter(
        .func3(func3_mem),
        .ld_data(dm_read_data),
        .ld_data_f(ld_data_f_mem)
    );

    //--------------------------------------
    // MEM → WB (Reg_W)
    //--------------------------------------
    wire [31:0] alu_out_wb, ld_data_wb;
    wire [4:0]  rd_index_wb_int;
    wire        wb_en_wb_int, wb_sel_wb;
    wire [2:0]  func3_wb;
    Reg_W reg_w(
        .clk(clk),
        .rst(rst),
        .stall(1'b0),
        .flush(1'b0),

        .alu_out_in(alu_out_mem),
        .ld_data_in(ld_data_f_mem),
        .rd_index_in(rd_index_mem),
        .wb_en_in(wb_en_mem),
        .wb_sel_in(wb_sel_mem),
        .func3_in(func3_mem),

        .alu_out_out(alu_out_wb),
        .ld_data_out(ld_data_wb),
        .rd_index_out(rd_index_wb_int),
        .wb_en_out(wb_en_wb_int),
        .wb_sel_out(wb_sel_wb),
        .func3_out(func3_wb)
    );

    //--------------------------------------
    // WB Stage
    //--------------------------------------
    wire [31:0] wb_mux_out;
    Mux mux_wb(
        .select(wb_sel_wb),
        .input_0(ld_data_wb),
        .input_1(alu_out_wb),
        .o(wb_mux_out)
    );

    assign wb_data_wb = wb_mux_out;
    assign wb_en_wb   = wb_en_wb_int;
    assign rd_wb      = rd_index_wb_int;

endmodule
