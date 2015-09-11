# fpga-vt
VT100-style terminal implemented on FPGA in VHDL

This is a project to implement a DEC VT100 style serial terminal entirely in an FPGA (aside from a few supporting components).

* VGA-style 16-colour 80x25 Text Mode display controller with 8x16 fonts on 9x16 grid (first focus of work)
* T80 soft core Z80 processor
* 16450 soft core UART
* PS/2 keyboard interface (I have a nice IBM Model M for the authentic 80s feel)
* Z80 software for terminal emulation

The target FPGA board is the ebay Altera Cyclone II EPC5 mini-board, with 5000 LEs, 113Kbits of blockram and just I/O headers, so a small protoboard is necessary to add a VGA DAC and connector, an RS232 level-shifter and DB9 serial port, and finally a PS/2 keyboard port.

A secondary aim is to end up with something that's a few pin-swaps away from Grant Searle's Multicomp, so I can play with that, too.
