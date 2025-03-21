// AudioPlayer class: plays an audio file and adjusts volume/reverb each time it loops
public class AudioPlayer {
    // Signal chain: audio → filter → reverb → gain → output
    SndBuf audio => LPF filter => JCRev reverb => Gain master => dac;
    
    float baseGain;    // initial volume
    float baseReverb;  // initial reverb mix
    int playCount;     // number of times the audio has played

    // Initialize audio and effect parameters
    fun void init(string filename, float gain, float rate, float filterFreq, float reverbMix) {
        filename => audio.read;
        rate => audio.rate;
        gain => master.gain;
        gain => baseGain;
        reverbMix => baseReverb;
        filterFreq => filter.freq;
        reverbMix => reverb.mix;
        0 => playCount;
    }

    // Loop playback with evolving effect parameters
    fun void play() {
        while (true) {
            // Adjust gain and reverb over time
            baseGain * Math.pow(0.65, playCount) => float newGain;
            baseReverb + 0.15 * playCount => float newReverb;

            // Clamp reverb and gain values
            newReverb > 0.6 ? 0.6 : newReverb => reverb.mix;
            newGain > 0.01 ? newGain : 0.01 => master.gain;

            // Play the audio
            audio.play();
            audio.length() => now;
            0 => audio.pos;

            playCount++;
        }
    }
}

// Create and configure the audio player
AudioPlayer player1;
player1.init(me.dir() + "audio_file.wav", 1.0, 1.0, 1100.0, 0.1);

// Spork concurrent playback
spork ~ player1.play();

// Run the program for 4 minutes
4::minute => now;
