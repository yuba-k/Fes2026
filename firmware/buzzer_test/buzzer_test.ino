#include "melody.h"

constexpr int BUZZER_PIN = 3;

struct NoteInfo {
  const char* name;
  int freq;
};

NoteInfo notes[] = {
  {"C0",  Note::C0},  {"CS0", Note::CS0}, {"D0",  Note::D0},  {"DS0", Note::DS0},
  {"E0",  Note::E0},  {"F0",  Note::F0},  {"FS0", Note::FS0}, {"G0",  Note::G0},
  {"GS0", Note::GS0}, {"A0",  Note::A0},  {"AS0", Note::AS0}, {"B0",  Note::B0},

  {"C1",  Note::C1},  {"CS1", Note::CS1}, {"D1",  Note::D1},  {"DS1", Note::DS1},
  {"E1",  Note::E1},  {"F1",  Note::F1},  {"FS1", Note::FS1}, {"G1",  Note::G1},
  {"GS1", Note::GS1}, {"A1",  Note::A1},  {"AS1", Note::AS1}, {"B1",  Note::B1},

  {"C2",  Note::C2},  {"CS2", Note::CS2}, {"D2",  Note::D2},  {"DS2", Note::DS2},
  {"E2",  Note::E2},  {"F2",  Note::F2},  {"FS2", Note::FS2}, {"G2",  Note::G2},
  {"GS2", Note::GS2}, {"A2",  Note::A2},  {"AS2", Note::AS2}, {"B2",  Note::B2},

  {"C3",  Note::C3},  {"CS3", Note::CS3}, {"D3",  Note::D3},  {"DS3", Note::DS3},
  {"E3",  Note::E3},  {"F3",  Note::F3},  {"FS3", Note::FS3}, {"G3",  Note::G3},
  {"GS3", Note::GS3}, {"A3",  Note::A3},  {"AS3", Note::AS3}, {"B3",  Note::B3},

  {"C4",  Note::C4},  {"CS4", Note::CS4}, {"D4",  Note::D4},  {"DS4", Note::DS4},
  {"E4",  Note::E4},  {"F4",  Note::F4},  {"FS4", Note::FS4}, {"G4",  Note::G4},
  {"GS4", Note::GS4}, {"A4",  Note::A4},  {"AS4", Note::AS4}, {"B4",  Note::B4},

  {"C5",  Note::C5},  {"CS5", Note::CS5}, {"D5",  Note::D5},  {"DS5", Note::DS5},
  {"E5",  Note::E5},  {"F5",  Note::F5},  {"FS5", Note::FS5}, {"G5",  Note::G5},
  {"GS5", Note::GS5}, {"A5",  Note::A5},  {"AS5", Note::AS5}, {"B5",  Note::B5},

  {"C6",  Note::C6},  {"CS6", Note::CS6}, {"D6",  Note::D6},  {"DS6", Note::DS6},
  {"E6",  Note::E6},  {"F6",  Note::F6},  {"FS6", Note::FS6}, {"G6",  Note::G6},
  {"GS6", Note::GS6}, {"A6",  Note::A6},  {"AS6", Note::AS6}, {"B6",  Note::B6},

  {"C7",  Note::C7},  {"CS7", Note::CS7}, {"D7",  Note::D7},  {"DS7", Note::DS7},
  {"E7",  Note::E7},  {"F7",  Note::F7},  {"FS7", Note::FS7}, {"G7",  Note::G7},
  {"GS7", Note::GS7}, {"A7",  Note::A7},  {"AS7", Note::AS7}, {"B7",  Note::B7},

  {"C8",  Note::C8},  {"CS8", Note::CS8}, {"D8",  Note::D8},  {"DS8", Note::DS8},
  {"E8",  Note::E8},  {"F8",  Note::F8},  {"FS8", Note::FS8}, {"G8",  Note::G8},
  {"GS8", Note::GS8}, {"A8",  Note::A8},  {"AS8", Note::AS8}, {"B8",  Note::B8},
};

constexpr int NUM_NOTES = sizeof(notes) / sizeof(notes[0]);

void setup() {
  Serial.begin(115200);

  Serial.println("Scale Test");
}

void loop() {
  static int idx = 0;

  Serial.print(notes[idx].name);
  Serial.print(" : ");
  Serial.print(notes[idx].freq);
  Serial.println(" Hz");

  tone(BUZZER_PIN, notes[idx].freq);
  delay(500);

  noTone(BUZZER_PIN);
  delay(100);

  idx++;

  if (idx >= NUM_NOTES) {
    idx = 0;

    Serial.println("--- repeat ---");

    delay(2000);
  }
}