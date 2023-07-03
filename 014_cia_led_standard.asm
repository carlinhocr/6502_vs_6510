  .org $8000
RESET:
  lda #$ff
  sta $6002

LOOP:
  lda #$55
  sta $6000

  lda #$aa
  sta $6000

  jmp LOOP

  .org $fffc
  .word RESET
  .word $0000