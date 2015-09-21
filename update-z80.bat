rem Assemble
z80asm -v -a rom1.asm

rem pad to 4K ROM size
trunc rom1.bin 4096

rem convert to intel hex format for Quartus
bin2hex rom1.bin 4k-blank.hex

rem Update the MIF files from the .hex files
c:\altera\13.0sp1\quartus\bin\quartus_cdb vt100 -c vt100 --update_mif
rem update the actual bitstream without resynthesising everything
c:\altera\13.0sp1\quartus\bin\quartus_asm vt100 
