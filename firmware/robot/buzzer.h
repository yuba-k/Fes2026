#pragma once
#include "melody.h"

void playMelody(
    const NoteData* melody,
    int length
);

void updateBuzzer();
bool isPlaying();