library verilog;
use verilog.vl_types.all;
entity JB_Unit is
    port(
        jb_op2_sel      : in     vl_logic;
        operand1        : in     vl_logic_vector(31 downto 0);
        operand2        : in     vl_logic_vector(31 downto 0);
        jb_out          : out    vl_logic_vector(31 downto 0)
    );
end JB_Unit;
