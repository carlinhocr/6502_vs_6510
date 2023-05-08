rom = bytearray([0xea] *32768) # create an array of 32768 ea

#Load memory address 0 with the vector to set i/o pins as output 00111111 = #$3f
#start program at address 10 we will use address 0 and 1 for the 6510 output pins
rom[10] = 0xa9 # LDA 6502 machine instruction for LDA #$3f # for literal number and $ to encode as hexadecimal
rom[11] = 0x3f # hexadecimal number 3f 00111111
rom[12] = 0x8d # STA to memory expects 3 bytes total (instruction +low address + high address)
rom[13] = 0x00 # low address
rom[14] = 0x00 # high address

#load some data on the i/o pins as output, turning all output pins on
rom[15] = 0xa9 # LDA 6502 machine instruction for LDA #$3f # for literal number and $ to encode as hexadecimal
rom[16] = 0x3f # hexadecimal number 3f 00111111
rom[17] = 0x8d # STA to memory expects 3 bytes total (instruction +low address + high address)
rom[18] = 0x01 # low address
rom[19] = 0x00 # high address

#load some data on the i/o pins as output, turning half on half off
rom[20] = 0xa9 # LDA 6502 machine instruction for LDA #$3f # for literal number and $ to encode as hexadecimal
rom[21] = 0x7 # hexadecimal number 3f 00000111
rom[22] = 0x8d # STA to memory expects 3 bytes total (instruction +low address + high address)
rom[23] = 0x01 # low address
rom[24] = 0x00 # high address

#load some data on the i/o pins as output, turning all off
rom[25] = 0xa9 # LDA 6502 machine instruction for LDA #$3f # for literal number and $ to encode as hexadecimal
rom[26] = 0x0 # hexadecimal number 3f 00000111
rom[27] = 0x8d # STA to memory expects 3 bytes total (instruction +low address + high address)
rom[28] = 0x01 # low address
rom[29] = 0x00 # high address

#tell the procesor to fetch first instrucion at 8010 (0010 of the actual eprom but with A15 enabled it would look at 8010)
rom[0x7ffc] = 0x10 # low byte that will be read as FFFC
rom[0x7ffd] = 0x80 # high byte that will be read as FFFD
with open("rom007.bin","wb") as out_file:
    out_file.write(rom)
