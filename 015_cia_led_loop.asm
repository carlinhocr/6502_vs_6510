  .org $8000
RESET:
  ;put all bits of the 6522 as output, lets load 1111 1111
  lda #$ff  ;load all ones 1111 1111
  ;store the accumulator in the data direction register for Port B
  sta $6003 ;0110 0000 0000 0011

  lda #$50 ;load value 00000101
  ;store the accumulator in the output register for Port B
  sta $6001 ;0110 0000 0000 0001
  
LOOP:
  ror ;shift values one bit to the right using the carry 00000101 => 00001010
  ;store the accumulator in the output register for Port B
  sta $6001 ;0110 0000 0000 0001

  jmp LOOP

  .org $fffc ;go to memory address of the reset vector
  .word RESET ;store in $FFFC & $FFFD the memory address of the RESET: label
  .word $0000 ;finish completing the values of the eeprom $fffe $ffff
