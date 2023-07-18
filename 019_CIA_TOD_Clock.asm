  .org $8000
RESET:
  ;turn on led lights if they are some
  ;put all bits of the 6522 as output, lets load 1111 1111 

  lda #$ff  ;load all ones
  sta $6003 ;store the accumulator in the data direction register for Port B

  lda #$a0 ;load value 1010 0000
  sta $6001 ;store the accumulator in the output register for Port B

;start the CIA clock configuration
;put the CIA clock to accept 60 mhz on the TOD pin load the E register 600E
;and it to put a zero
  lda $600e ;load all bits from control register A
  and $7F  ;AND $7F 01111111 the accumulator turning off  bit 7 and leaving the others intact
  sta $600e ; save the changed register to the CIA

;configure Time of Day instead of Alarm
  lda $600f ; load all the bits on the control register B
  and $7F   ; turn off 7 bit 0111111
  sta $600f ; save the cahnged register to the CIA

;write initial hour in bcd format
; 12 pm is 1001 0010 the first 1 is to signal pm $92 in hexa
  lda #$92
  sta $600b ; store it in the hour Register
; load 30 minutes 0011 0000 in hexa $30 
  lda #$30
  sta $600a
  ;load 5 seconds 0000 0101 in hexa $05
  lda #$05
  sta $6009
  ;load 4 tenth of seconds 0000 0100 in hexa $04 with this the clock starts again 
  lda #$04
  sta $6008

;loop some time before reading gain all 20 times we will execute the loop
  ldx #$00

WAITLOOP
  inx
  cpx #$40 ;wait 16x4 = 64 loops
  bcc WAITLOOP

;read the clock now start with the hour to latch the value and end with the tenth of seconds to stop the latching
;read initial hour in bcd format
  lda $600b ; we will not store it for now, just watch it on the Arduino
; read minutes
  lda $600a
  ;read seconds
  lda $6009
  ;read  tenth of seconds  with this the clock starts again 
  lda $6008


;load another LED combination when the read is finished
  lda #$05 ;load value 00000101
  sta $6001 ;store the accumulator in the output register for Port B

; brk end the program
  brk
;complete the file
  .org $fffc ;go to memory address $fffc of the reset vector
  .word RESET ;store in $FFFC & $FFFD the memory address of the RESET: label  00 80 ($8000 in little endian)
  .word $0000 ;finish completing the values of the eeprom $fffe $ffff with values 00 00
