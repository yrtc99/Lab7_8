library verilog;
use verilog.vl_types.all;
entity Adder is
    port(
        current_pc      : in     vl_logic_vector(31 downto 0);
        adder_out_pc    : out    vl_logic_vector(31 downto 0)
    );
end Adder;
