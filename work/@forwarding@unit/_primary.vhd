library verilog;
use verilog.vl_types.all;
entity ForwardingUnit is
    port(
        rs1_ex          : in     vl_logic_vector(4 downto 0);
        rs2_ex          : in     vl_logic_vector(4 downto 0);
        rd_mem          : in     vl_logic_vector(4 downto 0);
        wb_en_mem       : in     vl_logic;
        rd_wb           : in     vl_logic_vector(4 downto 0);
        wb_en_wb        : in     vl_logic;
        forwardA        : out    vl_logic_vector(1 downto 0);
        forwardB        : out    vl_logic_vector(1 downto 0)
    );
end ForwardingUnit;
