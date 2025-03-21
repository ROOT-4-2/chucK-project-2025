TriOsc osc => ADSR env1 => dac;
TriOsc osc2 => ADSR env2 => dac;

1::second => dur beat;
(beat /2, beat /2, 0, 1::ms) => env1.set;
(1::ms, beat / 8, 0, 1::ms) => env2.set;

0.15 => osc.gain;
0.2 => osc2.gain;

[0,4,7,12] @=> int major[];
[0,3,7,12] @=> int minor[];

48 => int offset;

// === 3 Overloading Function  ===

// default `basenote = 0`, `speed = 4`
fun void playTwoBars(int position, int chord[]) {
    playTwoBars(position, chord, 0, 4);
}

//allow float type number speed
fun void playTwoBars(int position, int chord[], int basenote, float speed) {
    for (0 => int i; i < 4; i++) {
        Std.mtof(chord[basenote] + offset + position) => osc.freq;
        1 => env1.keyOn;
        for (0 => int j; j < chord.cap(); j++) {
            Std.mtof(chord[j] + offset + position + 12) => osc2.freq;
            1 => env2.keyOn;
            beat / speed => now;
        }
    }
}

// allow gain control
fun void playTwoBars(int position, int chord[], int basenote, int speed, float gain) {
    gain => osc.gain;
    gain => osc2.gain;
    playTwoBars(position, chord, basenote, speed);
}

//main loop
while (true) {
    playTwoBars(0, minor);       // default
    playTwoBars(-4, major, 0, 3.99);  // float type number speed
    playTwoBars(-2, major, 1, 4, 0.2); // lower volume
    playTwoBars(-5, major, 0, 4, 0.25);

    playTwoBars(-7, minor, 0, 4);
    playTwoBars(-2, major, 0, 4);
    playTwoBars(3, major, 2, 4);
    playTwoBars(-5, major, 2, 4);
}
