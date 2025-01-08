module HazardDetectionUnit(
    // from ID stage
    input  [4:0] rs1_id,
    input  [4:0] rs2_id,
    // from EX stage
    input  [4:0] rd_ex,
    input        memRead_ex, // EX 階段指令是 load ?
    // from EX ALU => JB_ex
    input        JB_ex,
    // pipeline control signals
    output reg stall,
    output reg flush_D,
    output reg flush_E
);
    always @(*) begin
        // 預設值
        stall   = 1'b0;
        flush_D = 1'b0;
        flush_E = 1'b0;

        // 1) load-use hazard
        //   if EX 階段是 LW，而 ID 階段下一指令馬上用 rd_ex => rs1_id or rs2_id => stall
        if(memRead_ex && ((rd_ex==rs1_id)||(rd_ex==rs2_id)) && rd_ex!=0) begin
            stall = 1'b1;
        end

        // 2) branch/jump hazard => flush
        if(JB_ex) begin
            flush_D = 1'b1;  // flush IF→ID
            flush_E = 1'b1;  // flush ID→EX
        end
    end
endmodule