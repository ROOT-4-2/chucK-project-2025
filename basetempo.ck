// **EffectProcessor Class (Effect Processing)**
class EffectProcessor {
    NRev rev => dac;
    Delay delay => dac;
    delay => delay; // Feedback delay

    // Constructor
    fun void init(float revMix, dur delayTime) {
        revMix => rev.mix;
        delayTime => delay.max;
        delayTime / 4 => delay.delay;
        0.5 => delay.gain;
    }
}

// **BassSynth Class (Bass Synthesizer)**
class BassSynth {
    string oscType;
    dur beat;
    ADSR env;
    Osc @ osc;
    
    // **Constructor**
    fun void init(string type, dur b, EffectProcessor fx) {
        type => oscType;
        b => beat;

        // Select different Oscillator types
        if (oscType == "sine") {
            SinOsc s => env => fx.rev;
            env => fx.delay;
            s @=> osc;
            0.25 => s.gain;
        } else if (oscType == "square") {
            SqrOsc s => env => fx.rev;
            env => fx.delay;
            s @=> osc;
            0.03 => s.gain;
        } else {
            <<< "Invalid oscillator type!" >>>;
        }
        (1::ms, beat / 8, 0, 1::ms) => env.set;
    }

    // **Play Bass**
    fun void play(int chord[]) {
        while (true) {
            for (0 => int i; i < 4; i++) {
                for (0 => int j; j < chord.cap(); j++) {
                    Std.mtof(chord[j] + 60) => osc.freq;
                    1 => env.keyOn;
                    beat => now;
                }
            }
        }
    }
}

// **Subclass 1: SynthBass**
class SynthBass extends BassSynth {
    fun void slapBass() {
        <<< "Slap Bass Activated!" >>>;
    }
}

// **Subclass 2: LeadSynth**
class LeadSynth extends BassSynth {
    fun void init(string type, dur b, EffectProcessor fx) {
        type => oscType;
        b => beat;
        
        // Use triangle wave as main timbre
        TriOsc t => env => fx.rev;
        env => fx.delay;
        t @=> osc;
        0.15 => t.gain;
        
        (1::ms, beat/4, 0.5, beat/8) => env.set;
    }
    
    fun void playLead(int note) {
        Std.mtof(note + 72) => osc.freq;
        1 => env.keyOn;
        beat => now;
        1 => env.keyOff;
    }
}

// **Create Effect Processing**
EffectProcessor fx;
fx.init(0.2, 0.5::second);

// **Create Bass Synthesizers**
SynthBass sinBass, sqrBass;
sinBass.init("sine", 0.5::second, fx);
sqrBass.init("square", 0.5::second, fx);

// Create and initialize LeadSynth
LeadSynth lead;
lead.init("tri", 0.5::second, fx);

// **Store Chords & Melody**
[0, 4, 7] @=> int major[];
[0, 3, 7] @=> int minor[];

// Add main melody voice
fun void playMelody() {
    while(true) {
        lead.playLead(60); // C4
        lead.playLead(64); // E4
        lead.playLead(67); // G4
        lead.playLead(72); // C5
    }
}

// **Spork Multithreading**
spork ~ sinBass.play(minor);
spork ~ playMelody(); // Add melody voice
3::second => now; // Wait 4 beats before adding SqrOsc
spork ~ sqrBass.play(major);

// **Test Subclass Function**
sinBass.slapBass();

// **Keep Running**
4::minute => now;
