#include <Arduino.h>
#include "melody.h"

constexpr int BUZZER_PIN = 3;

const NoteData* currentMelody = nullptr;
int melodyLength = 0;
int noteIndex = 0;

unsigned long noteStart = 0;

void playMelody(
    const NoteData* melody,
    int length)
{
    currentMelody = melody;
    melodyLength = length;
    noteIndex = 0;
    noteStart = 0;
}

bool isPlaying()
{
    return currentMelody != nullptr;
}

void updateBuzzer()
{
    if(currentMelody == nullptr)
        return;

    unsigned long now = millis();

    if(noteStart == 0)
    {
        const auto& n =
            currentMelody[noteIndex];

        if(n.freq > 0)
            tone(BUZZER_PIN, n.freq);

        noteStart = now;
        return;
    }

    const auto& n =
        currentMelody[noteIndex];

    if(now - noteStart >= n.duration)
    {
        noTone(BUZZER_PIN);

        noteIndex++;
        noteStart = 0;

        if(noteIndex >= melodyLength)
        {
            currentMelody = nullptr;
        }
    }
}