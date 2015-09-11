LIBRARY ieee  ; 
LIBRARY std  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_arith.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.STD_LOGIC_UNSIGNED.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE std.textio.all  ; 
ENTITY testbench  IS 
END ; 
 
ARCHITECTURE testbench_arch OF testbench IS
  SIGNAL n_reset   :  STD_LOGIC  ; 
  SIGNAL hSync   :  STD_LOGIC  ; 
  SIGNAL videoB   :  std_logic_vector (1 downto 0)  ; 
  SIGNAL videoR   :  std_logic_vector (1 downto 0)  ; 
  SIGNAL videoG   :  std_logic_vector (1 downto 0)  ; 
  SIGNAL clk   :  STD_LOGIC  ; 
  SIGNAL vSync   :  STD_LOGIC  ; 
  COMPONENT vt100  
    PORT ( 
      n_reset  : in STD_LOGIC ; 
      hSync  : out STD_LOGIC ; 
      videoB  : out std_logic_vector (1 downto 0) ; 
      videoR  : out std_logic_vector (1 downto 0) ; 
      videoG  : out std_logic_vector (1 downto 0) ; 
      clk  : in STD_LOGIC ; 
      vSync  : out STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : vt100  
    PORT MAP ( 
      n_reset   => n_reset  ,
      hSync   => hSync  ,
      videoB   => videoB  ,
      videoR   => videoR  ,
      videoG   => videoG  ,
      clk   => clk  ,
      vSync   => vSync   ) ; 



-- "Clock Pattern" : dutyCycle = 50
-- Start Time = 0 ns, End Time = 1 us, Period = 20 ns
  Process
	Begin
	 clk  <= '0'  ;
	wait for 10 ns ;
-- 10 ns, single loop till start period.
-- this is 18ms (one frame)
	for Z in 1 to 1800000
	loop
	    clk  <= '1'  ;
	   wait for 10 ns ;
	    clk  <= '0'  ;
	   wait for 10 ns ;
-- 990 ns, repeat pattern in loop.
	end  loop;
	 clk  <= '1'  ;
	wait for 10 ns ;
-- dumped values till 1 us
	wait;
 End Process;
 
 -- hold reset low for a few clocks to make sure the counters get reset
 Process
 Begin
	n_reset <= '0';
	wait for 100 ns;
	n_reset <= '1';
	wait;
 End Process;
 
END;
