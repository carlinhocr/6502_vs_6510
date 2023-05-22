rom = bytearray([0xea] *32768) # create an array of 32768 ea

#Load eeprom memory address 0 with 11111111 to see if it differs from the default on the processor
rom[00] = 0xff # start will all I/O ports as output
rom[1]  = 0xff # start with all pins on

#load the default value of registers 0x00 and 0x01
# memory position 10 is low byte 0x0a
# 00002  0010  A5 00                 LDA $00
# 00003  0012  A6 01                 LDX $01
# 00004  0014  8D 00 60              STA $6000
# 00005  0017  8E 01 60              STX $6001

rom[10] = 0xa5 # LDA 6502 machine instruction to load the accumulator from zero page
rom[11] = 0x00 # register 00 the DATA direction register
rom[12] = 0xa6 # LDA 6502 machine instruction to load the X register from zero page
rom[13] = 0x01 # register 01 the DATA register
rom[14] = 0x8d # STA to memory expects 3 bytes total (instruction +low address + high address)
rom[15] = 0x00 # low byte address
rom[16] = 0x60 # high byte address
rom[17] = 0x8e # STX to memory expects 3 bytes total (instruction +low address + high address)
rom[18] = 0x01 # low byte address
rom[19] = 0x60 # high byte address

#tell the procesor to fetch first instrucion at 8010 (0010 of the actual eprom but with A15 enabled it would look at 8010)
rom[0x7ffa] = 0x0a # low byte that will be read as FFFA
rom[0x7ffb] = 0x80 # high byte that will be read as FFFB
with open("rom009.bin","wb") as out_file:
    out_file.write(rom)
