library verilog;
use verilog.vl_types.all;
entity HazardDetectionUnit is
    port(
        rs1_id          : in     vl_logic_vector(4 downto 0);
        rs2_id          : in     vl_logic_vector(4 downto 0);
        rd_ex           : in     vl_logic_vector(4 downto 0);
        memRead_ex      : in     vl_logic;
        JB_ex           : in     vl_logic;
        stall           : out    vl_logic;
        flush_D         : out    vl_logic;
        flush_E         : out    vl_logic
    );
end HazardDetectionUnit;
