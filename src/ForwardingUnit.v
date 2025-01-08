module ForwardingUnit(
    input  [4:0] rs1_ex,
    input  [4:0] rs2_ex,
    input  [4:0] rd_mem,
    input        wb_en_mem,
    input  [4:0] rd_wb,
    input        wb_en_wb,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);
    always @(*) begin
        // 預設值：不轉發
        forwardA = 2'b00;
        forwardB = 2'b00;

        // RS1 轉發邏輯，優先選擇MEM階段
        if(wb_en_mem && (rd_mem != 0) && (rd_mem == rs1_ex))
            forwardA = 2'b10;  // 從MEM階段轉發
        else if(wb_en_wb && (rd_wb != 0) && (rd_wb == rs1_ex))
            forwardA = 2'b01;  // 從WB階段轉發

        // RS2 轉發邏輯，優先選擇MEM階段
        if(wb_en_mem && (rd_mem != 0) && (rd_mem == rs2_ex))
            forwardB = 2'b10;  // 從MEM階段轉發
        else if(wb_en_wb && (rd_wb != 0) && (rd_wb == rs2_ex))
            forwardB = 2'b01;  // 從WB階段轉發
    end
endmodule