library ieee;
use ieee.std_logic_1164.all;
-- use  IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity vga_textmode is
	port(	
		n_reset		: in std_logic;
		pixelClk		: in std_logic; -- pixel clock (50MHz)
		
		disp_enable : in std_logic;
		column		: in std_logic_vector(9 downto 0);
		row			: in std_logic_vector(9 downto 0);
		
		frame_start : in std_logic;
		row_start : in std_logic;
		
		videoR		: out std_logic_vector(1 downto 0);
		videoG		: out std_logic_vector(1 downto 0);
		videoB		: out std_logic_vector(1 downto 0)	
	);
end vga_textmode;

architecture vga_textmode_arch of vga_textmode is
	signal ch_row : std_logic_vector(7 downto 0) := "00000000";
	signal ch_col : std_logic_vector(6 downto 0) := "0000000";
	
	signal glyph_row : std_logic_vector(3 downto 0) := "0000";
	
	signal ch_clock : std_logic := '0';
	signal char_address : std_logic_vector(11 downto 0) := "000000000000";
	signal chardata_row : std_logic_vector(7 downto 0) := "00110011";
	
	
	-- signal shifter : std_logic_vector(8 downto 0) := "001010101";
	signal shift_load : std_logic := '0';
	
	signal flash_flag : std_logic := '0';
	signal cursor_flash_flag : std_logic := '0';
	signal jiffy_counter : integer := 0;
	
	
	signal chr : std_logic_vector(7 downto 0) := X"00";
	
	signal pix_counter : std_logic_vector(3 downto 0) := "0000";
	signal pix_clear : std_logic := '0';
	signal pix_wrap : std_logic := '0';
	
	signal displayClock : std_logic;
	
	-- signal v_row : std_logic_vector(9 downto 0);
	-- signal v_col : std_logic_vector(9 downto 0);

	signal pixel : std_logic := '0';
	
	signal attr_fg : std_logic_vector(3 downto 0) := "1111";
	signal attr_bg : std_logic_vector(3 downto 0) := "0000"; -- high bit will always be 0 (only 3 stored in display attr byte)
	signal attr_flash : std_logic := '0';
	
	begin

	font_rom_inst: entity work.font_rom
		port map(
			clock => pixelClk,
			address	=> char_address,
			q => chardata_row
		);
		
	pixcounter_inst: entity work.count9
		port map(
			clock => pixelClk,
			clear	=> pix_clear,
			wrap => pix_wrap,
			q => pix_counter
		);

	chcounter_inst: entity work.count80
		port map(
			clock => pix_wrap or row_start,
			clear	=> pix_clear,
			q => ch_col
		);
		
	shifter_inst: entity work.shiftreg
		port map(
			clock => pixelClk,
			load	=> shift_load,
			input => '0' & chardata_row,
			q => pixel
		);
	
	displayClock <= pixelClk and disp_enable;
	
	-- will be fetched from display RAM, but calculate from character column for now
	chr <= "01" & ch_col(5 downto 0);
	-- chr <= "01000001";
	
	-- fetch the relevant row of font data
	char_address <= chr & glyph_row;
	-- ch_clock <= pix_counter(2); -- clocks every 4 pixels, sort of...
	pix_clear <= frame_start or row_start;

	-- set up the row signals at the start of each row
	process (row_start)
	begin
		if (rising_edge(row_start)) then
			ch_row(5 downto 0) <= row(9 downto 4);
			glyph_row(3 downto 0) <= row(3 downto 0); 
		end if;
	end process;
	
	-- load the shifter at the start of the new character
	process (pix_counter, pixelClk, row, column)
	begin
		
		if (pix_counter = "0000") then
			shift_load <= '1';
		else
			shift_load <= '0';
		end if;
		
	end process;
	
	process(frame_start)
	begin
		if(rising_edge(frame_start)) then
			
			jiffy_counter <= jiffy_counter + 1;
			
			if (jiffy_counter mod 32 = 0) then 
				flash_flag <= not flash_flag;
			end if;

			if (jiffy_counter mod 24 = 0) then 
				cursor_flash_flag <= not cursor_flash_flag;
			end if;
			
		end if;
	end process;
	

	process (pixelClk)
	begin
		
		if(rising_edge(pixelClk)) then
			 if (disp_enable = '1') then
				videoR(1 downto 0) <= ch_col(0) & ch_col(0);	
				videoG(1 downto 0) <= pixel & pixel;
				if (flash_flag='0') then
					videoB(1 downto 0) <= ch_row(0) & ch_row(0);
				else
					videoB(1 downto 0) <= "00";
				end if;
			else 
				videoR <= "00";
				videoG <= "00";
				videoB <= "00";
			end if;
		end if;
		
	end process;
	
	--process(row, column)
	--begin
		
	--end process;
		
	-- v_col <= std_logic_vector(column);
	-- v_row <= std_logic_vector(row);	 	

end vga_textmode_arch;