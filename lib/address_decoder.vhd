library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity address_decoder is

	port(
		sel		: in	std_logic_vector(2 downto 0);
		cs_out	: out	std_logic_vector(7 downto 0)
	);

end entity;

architecture rtl of address_decoder is

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
