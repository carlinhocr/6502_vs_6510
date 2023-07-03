  .org $8000
RESET:
  ;put all bits of the 6522 as output, lets load 1111 1111
  lda #$ff  ;load all ones
  sta $6002 ;store the accumulator in the data direction register for Port B

LOOP:
  lda #$55 ;load value 01010101
  sta $6000 ;store the accumulator in the output register for Port B

  lda #$aa ;load value 10101010
  sta $6000 ;store the accumulator in the output register for Port B

  jmp LOOP

  .org $fffc ;go to memory address of the reset vector
  .word RESET ;store in $FFFC & $FFFD the memory address of the RESET: label
  .word $0000 ;finish completing the values of the eeprom $fffe $ffff
