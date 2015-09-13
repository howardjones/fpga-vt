library ieee;
use ieee.std_logic_1164.all;
-- use  IEEE.STD_LOGIC_UNSIGNED.all;
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
            tmp <= std_logic_vector(unsigned(tmp) + 1);
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
-- use  IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;


entity count80 is
    Port (
		q : out std_logic_vector(6 downto 0);
		wrap: out std_logic;
      clear: in std_logic;
      clock : in std_logic);
end count80;

architecture Behav of count80 is
  signal tmp: std_logic_vector(6 downto 0) := "0000000"; 
begin
  process(clock, clear) 
  begin
    if (rising_edge(clock)) then
		if (clear='1') then
			tmp <= (others => '0');
		else
			if tmp = "1010000" then         -- binary 80
            tmp <= (others => '0');  -- equivalent to "0000000"
				wrap <= '1';
         else
            tmp <= std_logic_vector(unsigned(tmp) + 1);
				wrap <= '0';
         end if;
		end if;
	 end if;
	 	 
 end process;  

 q <= tmp;

end Behav;

---------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
-- use  IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity shiftreg is
    Port (
		q : out std_logic;
		load: in std_logic;
		input : in std_logic_vector(8 downto 0);
      clock : in std_logic);
end shiftreg;

architecture Behavioral of shiftreg is
	signal latch : std_logic_vector(8 downto 0) := "001100110";
	signal tmp_out : std_logic;
begin

	process (clock, input, load)
	begin
		if (rising_edge(clock)) then
			if(load = '1') then
				latch <= input;
			else
				latch(8 downto 0) <= latch(7 downto 0) & '0';	
			end if;
		end if;			
		
	end process;
		
	q <= latch(8);
	
end Behavioral;

---------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
-- use  IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity attr_selector is
    Port (
		input : in std_logic;
		outR : out std_logic_vector(1 downto 0);
		outG : out std_logic_vector(1 downto 0);
		outB : out std_logic_vector(1 downto 0);
		load: in std_logic;
		fg : in std_logic_vector(5 downto 0);
      bg : in std_logic_vector(5 downto 0);
		flashing : in std_logic;
		flash : in std_logic;
		clock : in std_logic
		);
end attr_selector;


architecture Behavioral of attr_selector is
	signal fg_latch : std_logic_vector(5 downto 0);
	signal bg_latch : std_logic_vector(5 downto 0);
	signal result : std_logic_vector(5 downto 0);
begin

	process (clock, input, load)
	begin
		if (rising_edge(clock)) then
			if(load = '1') then
				fg_latch <= fg;
				bg_latch <= bg;
			else
				if (input='0' or (flash and flashing) = '1') then
					result <= bg_latch;
				else
					result <= fg_latch;
				end if;
			end if;
		end if;			
		
	end process;	
	
	outR <= result(5 downto 4);
	outG <= result(3 downto 2);
	outB <= result(1 downto 0);
	
end Behavioral;
