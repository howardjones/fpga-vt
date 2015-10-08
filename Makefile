###################################################################
# Project Configuration: 
# 
# Specify the name of the design (project) and the Quartus II
# Settings File (.qsf)
###################################################################

PROJECT = vt100
TOP_LEVEL_ENTITY = vt100
ASSIGNMENT_FILES = $(PROJECT).qpf $(PROJECT).qsf

###################################################################
# Part, Family, Boardfile DE1 or DE2, or A-C8V4
FAMILY = "Cyclone II"
PART = EP2C8Q208C8
BOARDFILE = A-C8V4Pins
###################################################################

###################################################################
# Setup your sources here
SRCS = vt100.vhd vga-controller.vhd vga_textmode.vhd vga-small.vhd \
	font_rom.vhd bootrom.vhd displayram.vhd sram.vhd colour-rom.vhd \
	components/T16450.vhd \
	components/T80s.vhd components/T80_Pack.vhd components/T80.vhd components/T80_ALU.vhd components/T80_Reg.vhd components/T80_MCode.vhd

OTHER_INPUT = rom1.hex charset.hex vga-rom.hex


%.bin: %.asm
	z80asm -v -a $<
	
%.hex: %.bin
	trunc $< 4096
	bin2hex $< $@ 

SOF = output_files/$(PROJECT).sof
POF = output_files/$(PROJECT).pof
	
###################################################################
# Main Targets
#
# all: build everything
# clean: remove output files and database
# program: program your device with the compiled design
###################################################################

all: smart.log $(PROJECT).asm.rpt $(PROJECT).sta.rpt $(SOF)

rom1.bin: rom1.asm

clean:
	rm -rf *.rpt *.chg smart.log *.htm *.eqn *.pin *.sof *.pof db incremental_db

map: smart.log $(PROJECT).map.rpt
fit: smart.log $(PROJECT).fit.rpt
asm: smart.log $(PROJECT).asm.rpt
sta: smart.log $(PROJECT).sta.rpt
smart: smart.log

###################################################################
# Executable Configuration
###################################################################

MAP_ARGS = --read_settings_files=on $(addprefix --source=,$(SRCS))

FIT_ARGS = --part=$(PART) --read_settings_files=on
ASM_ARGS =
STA_ARGS =

###################################################################
# Target implementations
###################################################################

STAMP = echo done >

$(PROJECT).map.rpt: map.chg $(SOURCE_FILES) 
	quartus_map $(MAP_ARGS) $(PROJECT)
	$(STAMP) fit.chg

$(PROJECT).fit.rpt: fit.chg $(PROJECT).map.rpt
	quartus_fit $(FIT_ARGS) $(PROJECT)
	$(STAMP) asm.chg
	$(STAMP) sta.chg

$(PROJECT).asm.rpt: asm.chg $(PROJECT).fit.rpt
	quartus_asm $(ASM_ARGS) $(PROJECT)

$(PROJECT).sta.rpt: sta.chg $(PROJECT).fit.rpt
	quartus_sta $(STA_ARGS) $(PROJECT) 

smart.log: $(ASSIGNMENT_FILES)
	quartus_sh --determine_smart_action $(PROJECT) > smart.log

###################################################################
# Project initialization
###################################################################

$(ASSIGNMENT_FILES):
	quartus_sh --prepare -f $(FAMILY) -t $(TOP_LEVEL_ENTITY) $(PROJECT)
	-cat $(BOARDFILE) >> $(PROJECT).qsf
map.chg:
	$(STAMP) map.chg
fit.chg:
	$(STAMP) fit.chg
sta.chg:
	$(STAMP) sta.chg
asm.chg:
	$(STAMP) asm.chg

###################################################################
# Programming the device
###################################################################

refresh_memory: $(SOF) $(OTHER_INPUT)
	quartus_cdb $(PROJECT) -c $(PROJECT) --update_mif
	quartus_asm $(PROJECT) 

program: $(SOF) $(OTHER_INPUT)
	quartus_pgm --no_banner --mode=jtag -o "P;$(SOF)"

programflash: $(POF) $(OTHER_INPUT)
	quartus_pgm --no_banner --mode=as -o "P;$(POF)"
