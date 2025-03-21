Machine.add(me.dir() + "audio1.1.ck");
Machine.add(me.dir() + "basetempo.ck");
Machine.add(me.dir() + "keyboard.ck");

12::second=> now;
Machine.add(me.dir() + "chord1.1.ck");

16::second=> now;
Machine.add(me.dir() + "panning.ck");

9::second =>now;
Machine.add(me.dir() + "stktest.ck");

while (true) {
    1::second => now;
}
