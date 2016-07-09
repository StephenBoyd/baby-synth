import processing.sound.*;

final double SEMITONE_RATIO = pow(2.0, (1.0 / 12.0));

SqrOsc[] waves;
int numSaws = 1;
float frequency;
double root = 110.0;
boolean playing = false;
char lastKey = ' ';
char lastReleasedKey = ' ';
char[] keysPressed;

// The home row is white keys starting with 'a' for 'a'
String keys = new String("awsdrftghujikol;[']");

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

void keyPressed() {
  if (key == '+' || key == '=') {
    root = root * 2;
  }
  if (key == '-') {
    root = root / 2;
  }
  println("keypressed: " + key);
  if (playing && (key == lastKey)) {
    return;
  }
  if (playing) {
    for (int i = 0; i < numSaws; i++) {
      waves[i].stop();
    }
    playing = false;
  }
  println(key);
  if (keys.indexOf(key) != -1) {
    frequency = tune(root, keys.indexOf(key));
    println(frequency);
    for (int i = 0; i < numSaws; i++) {
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
    for (int i = 0; i < numSaws; i++) {
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
  waves = new SqrOsc[numSaws];

  for (int i = 0; i < numSaws; i++) {
    // Calculate the amplitude for each oscillator
    float sawVolume = (1.0 / numSaws) / (i + 1);
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
    for (int i = 0; i < numSaws; i++) {
      waves[i].stop();
    }
    playing = false;
  }
}
