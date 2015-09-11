library ieee;
use ieee.std_logic_1164.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity count9 is
    Port (
		q : out std_logic_vector(3 downto 0);
		wrap: out std_logic;
      clear: in std_logic;
      clock : in std_logic);
end count9;

architecture Behavioral of count9 is
  signal tmp: std_logic_vector(3 downto 0) := "0000"; 
begin
  process(clock, clear) 
  begin
    if (rising_edge(clock)) then
		if (clear='1') then
			tmp <= (others => '0');
		else
			if tmp = "1000" then         -- binary 8
            tmp <= (others => '0');  -- equivalent to "0000"
				wrap <= '1';
         else
            tmp <= tmp + 1;
				wrap <= '0';
         end if;
		end if;
	 end if;
	 	 
 end process;  

 q <= tmp;

end Behavioral;

---------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity shiftreg is
    Port (
		q : out std_logic;
		load: in std_logic;
		input : in std_logic_vector(8 downto 0);
      clock : in std_logic);
end shiftreg;

architecture Behavioral of shiftreg is
	signal latch : std_logic_vector(8 downto 0);
	signal tmp_out : std_logic;
begin

	process (clock, input, load)
	begin
		if (rising_edge(clock)) then
			if(load = '1') then
				latch <= input;
			else
				latch(8 downto 0) <= latch(7 downto 0) & latch(8);	
			end if;
		end if;
			
		
	end process;
		
	q <= latch(0);
	
end Behavioral;