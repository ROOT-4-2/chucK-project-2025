// === Master Volume Control ===
Gain master => dac;
0.2 => master.gain; // Limit global volume

// === Melody Generation ===
SinOsc osc => LPF filter => Pan2 pan => master;
filter.freq(1000);
pan.pan(-0.5);
0.2 => osc.gain; // Avoid excessive volume

// === STK Instrument (Flute) ===
Flute flute => JCRev rev1 => master;
rev1.mix(0.3);
0.4 => flute.gain; // Control STK instrument volume

fun void fluteMelody() {
    while (true) {
        Std.mtof(Math.random2(60, 84)) => flute.freq; // Higher register for flute
        flute.startBlowing(0.8);
        flute.noteOn(1.0);
        Math.random2f(0.4, 1.2)::second => now;
        flute.noteOff(0.5);
        flute.stopBlowing(0.3);
        0.2::second => now;
    }
}

// === STK Instrument (Clarinet) ===
BlowHole clarinet => JCRev rev2 => master;
rev2.mix(0.5);
0.3 => clarinet.gain; // Control STK instrument volume

fun void clarinetMelody() {
    while (true) {
        Std.mtof(Math.random2(50, 80)) => clarinet.freq;
        clarinet.startBlowing(0.8);
        clarinet.noteOn(1.0);
        Math.random2f(0.3, 1.0)::second => now;
        clarinet.noteOff(0.5);
        clarinet.stopBlowing(0.3);
        0.2::second => now;
    }
}

// === Additional STK Brass Instrument ===
Brass brass => JCRev rev3 => master;
rev3.mix(0.5);
0.3 => brass.gain;

fun void brassMelody() {
    while (true) {
        Std.mtof(Math.random2(40, 70)) => brass.freq;
        brass.startBlowing(0.7);
        brass.noteOn(1.0);
        Math.random2f(0.3, 1.2)::second => now;
        brass.noteOff(0.5);
        brass.stopBlowing(0.4);
        0.3::second => now;
    }
}

// === STK Instrument (Mandolin) ===
Mandolin mandolin => JCRev rev4 => master;
rev2.mix(0.4);
0.6 => mandolin.gain;

fun void mandolinMelody() {
    while (true) {
        Std.mtof(Math.random2(48, 72)) => mandolin.freq;
        Math.random2f(0.2, 0.8) => mandolin.pluck;
        Math.random2f(0.3, 0.8)::second => now;
    }
}

// === STK Instrument (Rhodey) ===
Rhodey rhodey => JCRev rev5 => master;
rev1.mix(0.4);
0.3 => rhodey.gain;

// Notes for a simple pentatonic scale
[60, 62, 65, 67, 69, 72, 74, 77] @=> int scale[];

fun void rhodeyMelody() {
    while (true) {
        scale[Math.random2(0, scale.cap()-1)] => int note;
        Std.mtof(note) => rhodey.freq;
        1.0 => rhodey.noteOn;
        Math.random2f(0.2, 0.4)::second => now;
        1.0 => rhodey.noteOff;
        0.1::second => now;
    }
}

// === STK Instrument (TubeBell) ===
TubeBell bell => JCRev rev6 => master;
rev2.mix(0.3);
0.2 => bell.gain;

fun void bellMelody() {
    while (true) {
        scale[Math.random2(0, scale.cap()-1)] + 12 => int note; // One octave higher
        Std.mtof(note) => bell.freq;
        1.0 => bell.noteOn;
        Math.random2f(0.3, 0.6)::second => now;
        1.0 => bell.noteOff;
        0.2::second => now;
    }
}

// Run multiple melodies in parallel

//spork ~ clarinetMelody();
spork ~ brassMelody();
//spork ~ fluteMelody();
//spork ~ mandolinMelody();
//spork ~ rhodeyMelody();
spork ~ bellMelody();

// Run for 4 minutes
4::minute => now;
