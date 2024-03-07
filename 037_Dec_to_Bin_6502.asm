;CIA Ports and Constants
;PORTB = $6001
;PORTA = $6000
;DDRB = $6003
;DDRA = $6002

;VIA Ports and Constants
PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

value =$0200 ;2 bytes, Low 16 bit half
mod10 =$0202 ;2 bytes, high 16 bit half and as it has the remainder of dividing by 10
             ;it is the mod 10 of the division (the remainder)

;RAM addresses
startRAMData =$2000

;define LCD signals
E = %10000000 ;Enable Signal
RW = %01000000 ; Read/Write Signal
RS = %00100000 ; Register Select

  .org $8000


RESET:

  ;BEGIN Initialize LCD Display
  ;set all port B pins as output
  lda #%11111111  ;load all ones equivalent to $FF
  sta DDRB ;store the accumulator in the data direction register for Port B

  lda #%11100000  ;set the last 3 pins as output
  sta DDRA ;store the accumulator in the data direction register for Port A
  ;END Initialize LCD Display
  
  ; BEGIN clear display instruction  on port B
  lda #%00000001 ;the instruction itself is 00000001
  jsr lcd_send_instruction
  ; END clear display instruction on port B  

  ; BEGIN send the instruction function set on port B
  lda #%00111000 ;the instruction itself is 001, data lenght 8bits(1), Number Display lines 2 (1)
            ;and Character Font 5x8 (0), last two bits are unused
  jsr lcd_send_instruction
  ; END send the instruction function set on port B

  ;BEGIN Turn on Display instruction
  lda #%00001110 ;the instruction itself is 0001, Display On(1), Cursor On (1)
            ;and Cursor Blinking Off (0)
  jsr lcd_send_instruction 
  ; END Turn on Display instruction
 
   ;BEGIN Entry Mode Set instruction
  lda #%00000110 ;the instruction itself is 00001, Put next character to the right (1)
            ;and Scroll Display Off (0)
  jsr lcd_send_instruction
  ; END Entry Mode Set instruction

  ;BEGIN Initialization of the 4 bytes
  ; initializae value to be the number to convert
  lda number
  sta value 
  lda number + 1
  sta value + 1
  ;initialize the remainder to be 0
  lda #0
  sta mod10
  sta mod10 + 1
  ;END Initialization of the 4 bytes


  ldx #16
divloop:
  ;rotate the quotient and the remainder
  rol value
  rol value + 1
  rol mod10
  rol mod10 + 1
  
  ;substract 1010, we will do it 8 bits at a time
  sec ; set the carry bit
  lda mod10
  sbc #10 ;substract with carry from 10
  tay ; save the low part of the 16 bits of the remainder to register y
  lda mod10 + 1
  sbc #0 ;substract with carry zero as the 8 high bits are all zeroes from 10 division
  ; the answer is on the combination of the a register and the y register
  ; a,y = dividend - divisor
  ; if the carry is clear for a then the dividend was less that the divisor and we will
  ; discard the result and do a shift left
  bcc ignore_result ; we will branch if the carry bit is clear (the carry of the last operation)
  ; if we do not ignore the result we want to store the intermediate result a,y
  ; in mod10+1 for a register and mod10 for the y register
  sty mod10
  sta mod10 + 1

  ; and then we will keep with the division if we did less than 16 left shifts


ignore_result:
  dex ; decrement the X time that we shifted left
      ; dex affects the Z flag is the content is zero
  bne divloop ;if what is on the X register
  




loop:
  jmp loop

number: .word 1729 ;the number we will convert

lcd_wait:
  pha ; push to preserve the contents of the acummulator register
  ;set PORTB to all inputs so we can read the busy flag
  lda #$00000000 ;port b ins input
  sta DDRB 
lcd_busy:
  ;set register select to 0 and RW to 1 to read the busy flag
  lda #RW ;set RW RW = %01000000 ; Read/Write Signal
  sta PORTA
  lda #(RW | E) ;do the enable and do not era the RW bit
  sta PORTA
  ;this will give us the info from the busy flags and the counter 01 BF AC AC AC AC AC AC AC
  ;on port B so we read it
  lda PORTB
  and #%10000000 ;and the accumulator to loose all bits but the 7 bit (from 7 to 0)
                ; on the acummulator I will now have only the Busy Flag result
  bne lcd_busy ; branch if the zero flag is not set
  ;turn off the enable bit
  lda #RW ;set RW RW = %01000000 ; Read/Write Signal
  sta PORTA
  ;set all port B pins as output
  lda #%11111111  ;load all ones equivalent to $FF to make it output
  sta DDRB ;store the accumulator in the data direction register for Port B
  pla ; pull to restablish the contents of the acummulator register
  rts


lcd_send_instruction:
  pha ;push the accumulator value to the stack so we can have it back a the end of the subroutine
  jsr lcd_wait
  sta PORTB
            
  lda #%0  ;Clear RS,RW and E bit on Port A  
  sta PORTA ;     

  ;togle the enable bit in order to send the instruction
  ;RS is zero so we are sending instructions
  ;RW is zero so we are writing
  lda #E ;enable bit is 1 , so we turn on the chip and execute the instruction.
  sta PORTA ; 

  lda #%0  ;Clear RS,RW and E bit on Port A  
  sta PORTA ;  
  pla ;pull the accumulator value to the stack so we can have it back a the end of the subroutine
  rts ; return from the subroutine

print_char:
  pha ;push the accumulator value to the stack so we can have it back a the end of the subroutine
  jsr lcd_wait
  sta PORTB

  ;RS is one so we are sending data
  ;RW is zero so we are writing
  lda #RS  ;Set RS, and clear RW and E bit on Port A  
  sta PORTA ;     

  ;togle the enable bit in order to send the instruction
  lda #(RS | E );RS and enable bit are 1 , we OR them and send the data
  sta PORTA ; 

  lda #RS  ;Set RS, and clear RW and E bit on Port A  
  sta PORTA ; 
  pla ;pull the accumulator value to the stack so we can have it back a the end of the subroutine
  rts

;complete the file
  .org $fffc ;go to memory address $fffc of the reset vector
  .word RESET ;store in $FFFC & $FFFD the memory address of the RESET: label  00 80 ($8000 in little endian)
  .word $0000 ;finish completing the values of the eeprom $fffe $ffff with values 00 00
