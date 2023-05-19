rom = bytearray([0xea] *32768) # create an array of 32768 ea

#Load memory address 0 with the vector to set i/o pins as output 00111111 = #$3f
rom[00] = 0xff # start will all I/O ports as output
rom[1]  = 0xff # start with all pins on

#load some data on the i/o pins as output, turning bit 0 Off
# memory position 10 is low byte 0x0a
rom[10] = 0xa9 # LDA 6502 machine instruction for LDA #$3f # for literal number and $ to encode as hexadecimal
rom[11] = 0x3f # hexadecimal number 3e 00111110 turn off one bit
rom[12] = 0x85 # STA to memory expects 3 bytes total (instruction +low address + high address)
rom[13] = 0x00 # low address

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
rom[27] = 0x85 # STA to zero page  memory expects 2 bytes total (instruction +low address as zero page is 256 bytes)
rom[28] = 0x01 # low address

#tell the procesor to fetch first instrucion at 8010 (0010 of the actual eprom but with A15 enabled it would look at 8010)
rom[0x7ffa] = 0x0a # low byte that will be read as FFFA
rom[0x7ffb] = 0x80 # high byte that will be read as FFFB
with open("rom007.bin","wb") as out_file:
    out_file.write(rom)
