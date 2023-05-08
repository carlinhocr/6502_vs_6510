rom = bytearray([0xea] *32768) # create an array of 32768 ea

#Load memory address 0 with the vector to set i/o pins as input 00000000 = #$00
#start program at address 10 we will use address 0 and 1 for the 6510 output pins
rom[10] = 0xa9 # LDA 6502 machine instruction for LDA #$3f # for literal number and $ to encode as hexadecimal
rom[11] = 0x00 # hexadecimal number 00 00000000
rom[12] = 0x8d # STA to memory expects 3 bytes total (instruction +low address + high address)
rom[13] = 0x00 # low address
rom[14] = 0x00 # high address

#load some data on the i/o pins as output, turning all output pins on
rom[15] = 0xa5 # LDA 6502 machine instruction for LDA from the zero page memory address 01 mapped to the io ports
rom[16] = 0x01 # hexadecimal number 3f 00111111
#write what we read on the i/o port to the 0x7000 address
rom[17] = 0x8d # STA to memory expects 3 bytes total (instruction +low address + high address)
rom[18] = 0x00 # low address
rom[19] = 0x70 # high address

#tell the procesor to fetch first instrucion at 8010 (0010 of the actual eprom but with A15 enabled it would look at 8010)
rom[0x7ffc] = 0x10 # low byte that will be read as FFFC
rom[0x7ffd] = 0x80 # high byte that will be read as FFFD
with open("rom008.bin","wb") as out_file:
    out_file.write(rom)
