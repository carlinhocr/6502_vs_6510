;VIA Ports and Constants
PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

;RAM addresses
startRAMData =$2000

;define LCD signals
E = %10000000 ;Enable Signal
RW = %01000000 ; Read/Write Signal
RS = %00100000 ; Register Select
  ;.org $2000
  ;.byte "O","s","o","L","a","b","s"

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

  ;BEGIN Write letters to memory
  ;BEGIN store letter "O"
  lda #"O" ;O in ascii
  sta startRAMData

  ;BEGIN store letter "s"
  lda #"s" ;s in ascii
  sta startRAMData + 1
  ;END Write letters to memory

  ;BEGIN Write letter "O"
  lda startRAMData ;O in ascii
  jsr print_char 
  ;END Write letter "O"

  ;BEGIN Write letter "s"
  lda startRAMData + 1;s in ascii
  jsr print_char 
  ;END Write letter "s"

  ;BEGIN Write letter "o"
  lda #"o" ;o in ascii
  jsr print_char 
  ;END Write letter "o"

  ;BEGIN Write letter "L"
  lda #"L" ;L in ascii
  jsr print_char 
  ;END Write letter "L"

  ;BEGIN Write letter "a"
  lda #"a" ;a in ascii
  jsr print_char 
  ;END Write letter "a"

    ;BEGIN Write letter "b"
  lda #"b" ;b in ascii
  jsr print_char  
  ;END Write letter "b"

  ;BEGIN Write letter "s"
  lda #"s" ;s in ascii
  jsr print_char 

loop:
  jmp loop


lcd_send_instruction:
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
  rts ; return from the subroutine

print_char:
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
  rts
  
;complete the file
  .org $fffc ;go to memory address $fffc of the reset vector
  .word RESET ;store in $FFFC & $FFFD the memory address of the RESET: label  00 80 ($8000 in little endian)
  .word $0000 ;finish completing the values of the eeprom $fffe $ffff with values 00 00
