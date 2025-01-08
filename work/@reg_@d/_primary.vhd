library verilog;
use verilog.vl_types.all;
entity Reg_D is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        stall           : in     vl_logic;
        flush           : in     vl_logic;
        inst_in         : in     vl_logic_vector(31 downto 0);
        pc_in           : in     vl_logic_vector(31 downto 0);
        inst_out        : out    vl_logic_vector(31 downto 0);
        pc_out          : out    vl_logic_vector(31 downto 0)
    );
end Reg_D;
