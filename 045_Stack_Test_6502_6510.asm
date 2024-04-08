

;RAM addresses
startRAMData =$2000

  .org $8000
RESET:

  ;BEGIN Initialize stack pointer to $01FF
  ldx #$ff 
  txs   ;transfer the X register to the Stack pointer
  ;END Initialize stack pointer to $01FF

  ;BEGIN PHA, PLA test
  lda #$64  
  pha ; store to the accumulator 64
  lda #$99
  pha ; store to the accumulator 99
  pla ; retrieve 99
  pla ; retrieve 64
  ;END PHA, PLA test

  ;BEGIN PHP, PLP test
  lda #$64  
  php ; store the procesor status register no zero flag
  lda #$0 ;change the status register to have the zero flag in 
  php ; store to the procesor status register with zero flag
  plp ; retrieve to the procesor status register with zero flag
  plp ; retrieve to the procesor status register no zero flag
  ;END PHP, PLP test
  jsr test_subroutine
  lda #$0
  brk

loop:
  jmp loop

test_subroutine;
  lda #$44
  sta startRAMData+3
  rts

nmi:
irq:
  lda #$55
  sta startRAMData+5
  rti

;complete the file
  .org $fffa
  .word nmi ;a word is 16 bits or two bytes in this case $fffa and $fffb
  .org $fffc ;go to memory address $fffc of the reset vector
  .word RESET ;store in $FFFC & $FFFD the memory address of the RESET: label  00 80 ($8000 in little endian)
  .org $fffe
  .word irq ;a word is 16 bits or two bytes in this case $fffe and $ffff