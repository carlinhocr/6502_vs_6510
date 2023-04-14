const char ADDR[] = {22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52}; //char is one byte from -127 to 127

void setup() {
  for (int n=0;n<16;n++){
    pinMode(ADDR[n], INPUT);
  }
  Serial.begin(57600);
}

void loop() {
  for (int n=0;n<16;n++){
    int bit = digitalRead(ADDR[n]) ? 1:0; //? ternary operator if TRUE then 1 else 0
    Serial.print(bit);
  }
  Serial.println();
}
