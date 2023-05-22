rom = bytearray([0xea] *32768) # create an array of 32768 ea

# 00001  0000             *=$0010
# 00002  0010  A9 00                 LDA #$00
# 00003  0012  85 00                 STA $0000
# 00004  0014  A5 01                 LDA $01
# 00005  0016  8D 00 70              STA $7000
# 00006  0019             

#Load memory address 0 with the vector to set i/o pins as input 00000000 = #$00
#start program at address 10 we will use address 0 and 1 for the 6510 output pins
rom[10] = 0xa9 # LDA 6502 machine instruction for LDA #$00 # for literal number and $ to encode as hexadecimal
rom[11] = 0x00 # hexadecimal number 00 00000000
rom[12] = 0x85 # STA to memory expects 2 bytes total (instruction +low address)
rom[13] = 0x00 # low address
rom[14] = 0xa5 # LDA 6502 machine instruction for LDA from the zero page memory address 01 mapped to the io ports
rom[15] = 0x01 # low address
#write what we read on the i/o port to the 0x7000 address
rom[16] = 0x8d # STA to memory expects 3 bytes total (instruction +low address + high address)
rom[17] = 0x00 # low address
rom[18] = 0x70 # high address

#tell the procesor to fetch first instrucion at 8010 (0010 of the actual eprom but with A15 enabled it would look at 8010)
rom[0x7ffa] = 0x0a # low byte that will be read as FFFC
rom[0x7ffb] = 0x80 # high byte that will be read as FFFD
with open("rom008.bin","wb") as out_file:
    out_file.write(rom)
