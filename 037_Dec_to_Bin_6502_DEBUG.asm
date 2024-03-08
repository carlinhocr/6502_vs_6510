
message = $0204

*=$0300
  lda #0
  sta message
  lda #9
  adc #"0" ;by adding zero to the a register we will have the ascii number of its value
  jsr push_char ;and now we store our character in the string
  lda #2
  adc #"0" ;by adding zero to the a register we will have the ascii number of its value
  jsr push_char ;and now we store our character in the string
  lda #7
  adc #"0" ;by adding zero to the a register we will have the ascii number of its value
  jsr push_char ;and now we store our character in the string
  lda #1
  adc #"0" ;by adding zero to the a register we will have the ascii number of its value
  jsr push_char ;and now we store our character in the string

loop
  jmp loop
push_char
  pha ;push new character into the stack first 
  ldy #0
;
char_loop
  lda message,y ;get char on string and put into x
  tax
  pla
  sta message,y ; we replaced the old first character with the new one
  iny ; lets go to the next character
  txa
  pha ; we have the character that used to be on the beginning of the message on the stack
  ;if a is zero we are at the end of the string
  bne char_loop
  pla
  sta message,y ; store the null terminator again
  rts
;
number 
  word 1729 ;the number we will convert
;==========================================================================================