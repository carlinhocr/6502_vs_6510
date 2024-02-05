;VIA Ports and Constants
PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

;RAM addresses
startRAMData =$2000
;EEPROM addresses
startOsoLabs =$8500

;define LCD signals
E = %10000000 ;Enable Signal
RW = %01000000 ; Read/Write Signal
RS = %00100000 ; Register Select
  

  .org startOsoLabs
  .byte "O","s","o","L","a","b","s" ;store the OsoLabs string in memory
  .org $8000


RESET:

  ;BEGIN Initialize stack pointer to $01FF
  ldx #$ff 
  txs   ;transfer the X register to the Stack pointer
  ;END Initialize stack pointer to $01FF

loadOSO:
  ;BEGIN store the word OSOLABS en in memory starting on the position startRAMData
  ;.org startRAMData Not using this combination because the file will be too large for a 32kb memory
  ;.byte "O","s","o","L","a","b","s"

  ldx #$ff ; initialize in 255 the X register
  inx ;on the first increment X=0
  lda startOsoLabs,x ; read from eeprom use X as offset of the eeprom
  sta startRAMData,x ;use X as offset of the memory and write there
  cpx #$6 ;compare the number of letter OsoLabs 7 letters from 0 to 6 , break on 6
  bne loadOSO
  ;END store the word OSOLABS en in memory starting on the position startRAMData

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


  ;BEGIN Write all the letters
  ldx #$ff ;start on FF so when i add one it will be 0
print_message:  
  inx
  lda startRAMData,x ;load letter from memory position startRAMData + the value of register X
  jsr print_char 
  cpx #$6 ;compare the number of letter OsoLabs 7 letters from 0 to 6 , break on 6
  bne print_message
  ;END Write all the letters

loop:
  jmp loop

lcd_wait:
  ;set register select to 0 and RW to 1 to read the busy flag
  pha
  ;set PORTB to all inputs so we can read
  lda #$00000000 ;port b ins input
  sta DDRB 
  lda #RW ;set RW RW = %01000000 ; Read/Write Signal
  sta PORTA
  lda #(RW | E) ;do the enable and do not era the RW bit
  sta PORTA
  ;this will give us the info from the busy flags and the counter 01 BF AC AC AC AC AC AC AC
  ;on port B so we read it
  lda PORTB


  ;set all port B pins as output
  lda #%11111111  ;load all ones equivalent to $FF to make it output
  sta DDRB ;store the accumulator in the data direction register for Port B


lcd_send_instruction:
  pha ;push the accumulator value to the stack so we can have it back a the end of the subroutine
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
