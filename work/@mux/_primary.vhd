library verilog;
use verilog.vl_types.all;
entity Mux is
    port(
        \select\        : in     vl_logic;
        input_1         : in     vl_logic_vector(31 downto 0);
        input_0         : in     vl_logic_vector(31 downto 0);
        o               : out    vl_logic_vector(31 downto 0)
    );
end Mux;
