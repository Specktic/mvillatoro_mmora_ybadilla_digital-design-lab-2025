#include <SPI.h>

// Define Slave Select (SS) pin — must match FPGA wiring
const int SS_PIN = 10;

// Simulate buttons for testing
const int BTN_LEFT  = 2;
const int BTN_RIGHT = 3;
const int BTN_DROP  = 4;

// Keeps track of selected column (0–6)
int currentColumn = 3; // Start in middle

void setup() {
  pinMode(SS_PIN, OUTPUT);
  pinMode(BTN_LEFT, INPUT_PULLUP);
  pinMode(BTN_RIGHT, INPUT_PULLUP);
  pinMode(BTN_DROP, INPUT_PULLUP);

  SPI.begin();
  SPI.beginTransaction(SPISettings(1000000, MSBFIRST, SPI_MODE0));
  digitalWrite(SS_PIN, HIGH); // Deselect slave by default
}

void loop() {
  // Move selection
  if (digitalRead(BTN_LEFT) == LOW && currentColumn > 0) {
    currentColumn--;
    delay(200);
  } else if (digitalRead(BTN_RIGHT) == LOW && currentColumn < 6) {
    currentColumn++;
    delay(200);
  }

  // Drop piece (send to FPGA)
  if (digitalRead(BTN_DROP) == LOW) {
    sendMove(currentColumn);
    delay(200);
  }
}

void sendMove(byte col) {
  if (col > 6) return; // Sanity check

  byte command = col & 0b00000111; // Only use lowest 3 bits

  digitalWrite(SS_PIN, LOW);       // Start SPI transmission
  SPI.transfer(command);           // Send byte
  digitalWrite(SS_PIN, HIGH);      // End SPI transmission
}
