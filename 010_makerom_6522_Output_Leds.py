# Lets use the 6522 to turn on an off some leds with this code
# 00002  8000  A5 FF                 LDA $FF
# 00003  8002  8D 02 60              STA $6002
# 00004  8005  A5 55                 LDA $55
# 00005  8007  8D 00 60              STA $6000
# 00006  800A  A5 AA                 LDA $AA
# 00007  800C  8D 00 60              STA $6000
# 00008  800F  4C 05 80              JMP $8005
# 00009  8012   

code = bytearray([
    # put all bits of the 6522 as output, lets load 1111 1111
    # to register 2 the Data Direction Register of the 6522 so port B is going to be all outputs
    0xa9, 0xff,         #load ff to the accumulator
    0x8d, 0x02, 0x60,   #address 6002 is 60 to turn on the 6522 via chip enable and 02 to select data direction register
    # turn on 4 pins first one on one off
    # load register 0 Output Register B with 01010101 to turn on and off alternatively
    0xa9, 0x55,         # load 01010101
    0x8d, 0x00, 0x60,   # address 6000 is 60 to turn on the 6522 via chip enable and 0 to select output register
    # turn on 4 pins first one on one off
    # load register 0 Output Register B with  10101010 to turn on and off alternatively
    0xa9, 0xaa,         # load 10101010
    0x8d, 0x00, 0x60,   # address 6000 is 60 to turn on the 6522 via chip enable and 0 to select output register
    0x4c, 0x05, 0x80,    # create a loop with the jmp instruction where we load 0x55 again
])
rom = code + bytearray([0xea] *(32768 - len(code)) )# create an array of 32768 ea

#tell the procesor to fetch first instrucion at 8000 (0000 of the actual eprom but with A15 enabled it would look at 8000)
rom[0x7ffc] = 0x00 # low byte that will be read as FFFC
rom[0x7ffd] = 0x80 # high byte that will be read as FFFD
with open("rom010.bin","wb") as out_file:
    out_file.write(rom)
