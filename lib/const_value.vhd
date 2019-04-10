library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity const_value is

	generic (
		V  : natural := 0;
		N  : natural := 16
	);

	port (
		Y : out std_logic_vector(N-1 downto 0)
	);

end entity;

-- ******************************************
-- DO NOT MODIFY ANYTHING ABOVE THIS LINE --
-- ******************************************

architecture v1 of const_value is
begin
		Y <= std_logic_vector(to_unsigned(V, N));
end v1;