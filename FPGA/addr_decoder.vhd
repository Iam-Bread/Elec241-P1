library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addr_decoder is

	port(
		addr		: in	std_logic_vector(2 downto 0);
		cs_out	: out	std_logic_vector(4 downto 0)
	);

end entity;

architecture rtl of addr_decoder is

begin
				
	-- Output depends solely on the current state
	process (sel)
	begin
		case sel is
			when "000" =>
				cs_out <= (others => '0');
			when others =>
				cs_out(to_integer(unsigned(sel)-1)) <= '1';
		end case;
	end process;

end rtl;

/*
0	SRC		0	1	2	3	4
1	OPER_REG	0	0	0	X	X
2	SW_REG	0	0	1	X	X
3	INTER		0	1	X	0	X
4	SUM		0	1	X	1	X
5	SPIS_RX	1	X	X	X	0
6	PC			1	X	X	X	1
*/