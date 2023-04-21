rom = bytearray([0xea] *32768) # create an array of 32768 ea

rom[0] = 0xa9 # LDA 6502 machine instruction for LDA #$42 # for literal number and $ to encode as hexadecimal
rom[1] = 0x42 # hexadecimal number 42

rom[2] = 0x8d # STA to memory expects 3 bytes total (instruction +low address + high address)
rom[3] = 0x00 # low address
rom[4] = 0x60 # high address

#tell the procesor to fetch first instrucion at 8000 (0000 of the actual eprom but with A15 enabled it would look at 8000)
rom[0x7ffc] = 0x00 # low byte that will be read as FFFC
rom[0x7ffd] = 0x80 # high byte that will be read as FFFD
with open("rom006.bin","wb") as out_file:
    out_file.write(rom)
