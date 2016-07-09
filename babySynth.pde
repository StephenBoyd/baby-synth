import processing.sound.*;

final double SEMITONE_RATIO = pow(2.0, (1.0 / 12.0));

int waveform = 3;
int numWaves = 1;
float frequency;
double root = 110.0;
boolean playing = false;
char lastKey = ' ';
char lastReleasedKey = ' ';
char[] keysPressed;
SqrOsc[] waves;

// The home row is the white keys, with a = A, d = D, r = C#.
// String keys = new String("awsdrftghujikol;[']");

// Two rows of white and black keys, z = A, c = C, f = C#.
String keys = new String("zsxcfvgbnjmk,l./'q2we4r5t6yu8i9op");

// Chromatic
// String keys = new String("zxcvbnm,./asdfghjkl;'qwertyuiop[]1234567890");

String[] notes = {"A", "A\u266F", "B", "C", "C\u266F", "D", "D\u266F", "E", "F", "F\u266F", "G", "G\u266F"};

float tune(double currentFrequency, int intervalSemitones) {
  double newFrequency = currentFrequency;
  for (int i = 0; i < intervalSemitones; i++) {
    newFrequency = newFrequency * SEMITONE_RATIO;
  }
  if (intervalSemitones < 0) {
    intervalSemitones = intervalSemitones * -1;
    for (int i = 0; i < intervalSemitones; i++) {
      newFrequency = newFrequency / SEMITONE_RATIO;
    }
  }
  return (float) newFrequency;
}

void switchWaveforms() {
  if (keyCode == ALT) {
    switch (key) {
      case '1':
        waveform = 1;
      case '2':
        waveform = 2;
      case '3':
        waveform = 3;
      case '4':
        waveform = 4;
      case '5':
        waveform = 5;
    }
  }
}

void keyPressed() {
  println("keypressed: " + key);
  if (key == '+' || key == '=') {
    root = root * 2;
  }
  if (key == '-') {
    root = root / 2;
  }
  if (key == CODED) {
    switchWaveforms();
  }
  if (playing && (key == lastKey)) {
    return;
  }
  if (playing) {
    for (int i = 0; i < numWaves; i++) {
      waves[i].stop();
    }
    playing = false;
  }
  if (keys.indexOf(key) != -1) {
    int keyInterval = keys.indexOf(key);
    frequency = tune(root, keyInterval);
    String note = notes[keyInterval % 12];
    println(note + " : " + frequency);
    for (int i = 0; i < numWaves; i++) {
      waves[i].play();
      waves[i].freq(frequency);
    }
    playing = true;
  }
  lastKey = key;
}

void keyReleased() {
  if (!keyPressed) {
    println("stopping: " + key);
    for (int i = 0; i < numWaves; i++) {
      waves[i].stop();
    }
    playing = false;
    lastReleasedKey = key;
  }
}

void setup() {
  println(SEMITONE_RATIO);
  size(640, 360);
  background(0);
  waves = new SqrOsc[numWaves];

  for (int i = 0; i < numWaves; i++) {
    // Calculate the amplitude for each oscillator
    float sawVolume = (1.0 / numWaves) / (i + 1);
    // Create the oscillators
    waves[i] = new SqrOsc(this);
    // Set the amplitudes for all oscillators
    waves[i].amp(sawVolume);
  }
  frequency = tune(root, 0);
}

void draw() {
  if (!keyPressed && playing) {
    println("stopping");
    for (int i = 0; i < numWaves; i++) {
      waves[i].stop();
    }
    playing = false;
  }
}
