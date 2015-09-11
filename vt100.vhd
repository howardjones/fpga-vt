library ieee;
use ieee.std_logic_1164.all;
-- use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity vt100 is
     port(
		n_reset		: in std_logic;
		clk			: in std_logic;
		
	--	rxd1			: in std_logic;
	--	txd1			: out std_logic;
	--	rts1			: out std_logic;

		videoR		: out std_logic_vector(1 downto 0);
		videoG		: out std_logic_vector(1 downto 0);
		videoB		: out std_logic_vector(1 downto 0);	
		hSync			: out std_logic;
		vSync			: out std_logic

	--	ps2Clk		: inout std_logic;
	--	ps2Data		: inout std_logic;
	);
end vt100;


architecture struct of vt100 is 
	signal pixelClk : std_logic;
	SIGNAL row : unsigned(9 downto 0);
	SIGNAL col : unsigned(9 downto 0);
	SIGNAL display_enable : std_LOGIC;
	signal frame_start : std_logic;
begin

	pixelClk <= clk;
	
	vgactrl1: entity work.vga_controller
		port map(
			n_reset => n_reset,
			pixelClk => pixelClk,
			hSync => hSync,
			vSync => vSync,
			frame_start => frame_start,
			disp_enable => display_enable,
			row => row,
			column => col
		);
		
	vgagfx1: entity work.vga_textmode
		port map(
			n_reset => n_reset,
			pixelClk => pixelClk,
			row => row,
			column => col,
			disp_enable => display_enable,
			frame_start => frame_start,
			videoR => videoR,
			videoG => videoG,
			videoB => videoB
		);
	
end; 