;CIA Ports and Constants
PORTB = $6001
PORTA = $6000
DDRB = $6003
DDRA = $6002

POS0 = $0055
POS1 = $01FD
POS2 = $0501
POS3 = $08d0
POS4 = $1234
POS5 = $1500
POS6 = $2010
POS7 = $2444
POS8 = $3400
POS9 = $3FFF


;VIA Ports and Constants
;PORTB = $6000
;PORTA = $6001
;DDRB = $6002
;DDRA = $6003

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
  ; END clear display instruction on port B  

  ; BEGIN send the instruction function set on port B
  lda #%00111000 ;the instruction itself is 001, data lenght 8bits(1), Number Display lines 2 (1)
            ;and Character Font 5x8 (0), last two bits are unused
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
  ; END send the instruction function set on port B

  ;BEGIN Turn on Display instruction
  lda #%00001110 ;the instruction itself is 0001, Display On(1), Cursor On (1)
            ;and Cursor Blinking Off (0)
  sta PORTB

  lda #%0  ;Clear RS,RW and E bit on Port A  
  sta PORTA ;     

  ;togle the enable bit in order to send the instruction
  lda #E ;load the enable bit
  sta PORTA ; 

  lda #%0  ;Clear RS,RW and E bit on Port A  
  sta PORTA ;  
  ; END Turn on Display instruction
 
   ;BEGIN Entry Mode Set instruction
  lda #%00000110 ;the instruction itself is 00001, Put next character to the right (1)
            ;and Scroll Display Off (0)
  sta PORTB

  lda #%0  ;Clear RS,RW and E bit on Port A  
  sta PORTA ;     

  ;togle the enable bit in order to send the instruction
  lda #E ;load the enable bit
  sta PORTA ; 

  lda #%0  ;Clear RS,RW and E bit on Port A  
  sta PORTA ;  
  ; END Entry Mode Set instruction
  ;##############################################################
  ;TEST RAM POSITIONS

  ;Write positions to memory
  lda #"0" 
  sta POS0
  lda #"1" 
  sta POS1
  lda #"2" 
  sta POS2
  lda #"3" 
  sta POS3
  lda #"4" 
  sta POS4
  lda #"5" 
  sta POS5
  lda #"6" 
  sta POS6
  lda #"7" 
  sta POS7
  lda #"8" 
  sta POS8
  lda #"9" 
  sta POS9

  ;BEGIN Write Position
  lda POS0 
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
  ;END write position

  ;BEGIN Write Position
  lda POS1 
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
  ;END write position
  
  ;BEGIN Write Position
  lda POS2 
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
  ;END write position
  
  ;BEGIN Write Position
  lda POS3 
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
  ;END write position
  
  ;BEGIN Write Position
  lda POS4 
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
  ;END write position
  
  ;BEGIN Write Position
  lda POS5 
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
  ;END write position
  
  ;BEGIN Write Position
  lda POS6 
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
  ;END write position
  
  ;BEGIN Write Position
  lda POS7 
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
  ;END write position
  
  ;BEGIN Write Position
  lda POS8 
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
  ;END write position
  
  ;BEGIN Write Position
  lda POS9 
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
  ;END write position  

loop:
  jmp loop

;complete the file
  .org $fffc ;go to memory address $fffc of the reset vector
  .word RESET ;store in $FFFC & $FFFD the memory address of the RESET: label  00 80 ($8000 in little endian)
  .word $0000 ;finish completing the values of the eeprom $fffe $ffff with values 00 00
