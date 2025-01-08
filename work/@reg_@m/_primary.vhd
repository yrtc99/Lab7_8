library verilog;
use verilog.vl_types.all;
entity Reg_M is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        stall           : in     vl_logic;
        flush           : in     vl_logic;
        alu_out_in      : in     vl_logic_vector(31 downto 0);
        rs2_data_in     : in     vl_logic_vector(31 downto 0);
        rd_index_in     : in     vl_logic_vector(4 downto 0);
        dm_w_en_in      : in     vl_logic_vector(3 downto 0);
        wb_en_in        : in     vl_logic;
        wb_sel_in       : in     vl_logic;
        func3_in        : in     vl_logic_vector(2 downto 0);
        alu_out_out     : out    vl_logic_vector(31 downto 0);
        rs2_data_out    : out    vl_logic_vector(31 downto 0);
        rd_index_out    : out    vl_logic_vector(4 downto 0);
        dm_w_en_out     : out    vl_logic_vector(3 downto 0);
        wb_en_out       : out    vl_logic;
        wb_sel_out      : out    vl_logic;
        func3_out       : out    vl_logic_vector(2 downto 0)
    );
end Reg_M;
