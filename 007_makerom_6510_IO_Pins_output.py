rom = bytearray([0xea] *32768) # create an array of 32768 ea

#Load memory address 0 with the vector to set i/o pins as output 00111111 = #$3f
rom[00] = 0xff # start will all I/O ports as output
rom[1]  = 0xff # start with all pins on

# 00001  0000             *=$0010
# 00002  0010  A9 3F                 LDA #$3F
# 00003  0012  85 00                 STA $0000
# 00004  0014  A9 3F                 LDA #$3F
# 00005  0016  85 01                 STA $0001
# 00006  0018  A9 07                 LDA #$7
# 00007  001A  85 01                 STA $0001
# 00008  001C  A9 00                 LDA #$0
# 00009  001E  85 01                 STA 0001
# 00010  0020             


#load some data on the i/o pins as output, turning bit 0 Off
# memory position 10 is low byte 0x0a
rom[10] = 0xa9 # LDA 6502 machine instruction for LDA #$3f # for literal number and $ to encode as hexadecimal
rom[11] = 0x3f # hexadecimal number 3f 00111111 turn off one bit
rom[12] = 0x85 # STA to memory expects 2 bytes total (instruction +low address)
rom[13] = 0x00 # low address

#load some data on the i/o pins as output, turning all output pins on
rom[14] = 0xa9 # LDA 6502 machine instruction for LDA #$3f # for literal number and $ to encode as hexadecimal
rom[15] = 0x3f # hexadecimal number 3f 00111111
rom[16] = 0x85 # STA to memory expects 3 bytes total (instruction +low address + high address)
rom[17] = 0x01 # low address

#load some data on the i/o pins as output, turning half on half off
rom[18] = 0xa9 # LDA 6502 machine instruction for LDA #$3f # for literal number and $ to encode as hexadecimal
rom[19] = 0x7 # hexadecimal number 7 00000111
rom[20] = 0x85 # STA to memory expects 3 bytes total (instruction +low address + high address)
rom[21] = 0x01 # low address

#tell the procesor to fetch first instrucion at 8010 (0010 of the actual eprom but with A15 enabled it would look at 8010)
rom[0x7ffa] = 0x0a # low byte that will be read as FFFA
rom[0x7ffb] = 0x80 # high byte that will be read as FFFB
with open("rom007.bin","wb") as out_file:
    out_file.write(rom)
