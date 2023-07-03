  .org $8000
RESET:
  lda #$ff
  sta $6002

  lda #$50
  sta $6000

LOOP:
  ror
  sta $6000

  jmp LOOP

  .org $fffc
  .word RESET
  .word $0000