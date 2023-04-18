rom = bytearray([0xea] *32768) # create an array of 32768 ea
with open("rom.bin","wb") as out_file:
    out_file.write(rom)
