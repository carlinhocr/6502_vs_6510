rom = bytearray([0xea] *32768) # create an array of 32768 ea

#tell the procesor to fetch first instrucion at 8000 (0000 of the actual eprom but with A15 enabled it would look at 8000)
# 7ffc will be read as FFFC by the procesor because we are using A15 as chip enable but he room has only up to A14 
rom[0x7ffc] = 0x00 # high byte that will be read as 8000 for the procesor but wil be zero ar the rom
# 0x7ffd that will be read as FFFD by the procesor because we are using A15 as chip enable but he room has only up to A14 
rom[0x7ffd] = 0x80 # high byte that will be read as 8000 for the procesor but wil be zero ar the rom
with open("rom005.bin","wb") as out_file:
    out_file.write(rom)
