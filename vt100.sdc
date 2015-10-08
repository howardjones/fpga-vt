create_clock -name clk -period 20.000
create_generated_clock -name cpuClock -source clk 
create_generated_clock -name row_start -source clk 
create_generated_clock -name frame_start -source clk 

