import processing.sound.*;

SawOsc[] sawWaves;
int numSaws = 1;

final double SEMITONE_RATIO = pow(2.0, (1.0 / 12.0));
double root = 110.0;
boolean playing = false;
char lastKey = ' ';
char lastReleasedKey = ' ';
char[] keysPressed;
// The home row is white keys starting with 'a' for 'a'
String keys = new String("awsdrftghujikol;[']");

float interval(double frequency, int semitones) {
  double result = frequency;
  for (int i = 0; i < semitones; i++) {
    result = result * SEMITONE_RATIO;
  }
  if (semitones < 0) {
    semitones = semitones * -1;
    for (int i = 0; i < semitones; i++) {
      result = result / SEMITONE_RATIO;
    }
  }
  return (float) result;
}

float frequency = interval(root, 0);

void setup() {
  println(SEMITONE_RATIO);
  size(640, 360);
  background(0);
  sawWaves = new SawOsc[numSaws];
  
  for (int i = 0; i < numSaws; i++) {
    // Calculate the amplitude for each oscillator
    float sawVolume = (1.0 / numSaws) / (i + 1);
    // Create the oscillators
    sawWaves[i] = new SawOsc(this);
    // Set the amplitudes for all oscillators
    sawWaves[i].amp(sawVolume);
  }
}

void keyPressed() {
  if (key == '+') {
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
      sawWaves[i].stop();
    }
    playing = false;
  }
  println(key);
  if (keys.indexOf(key) != -1) {
    frequency = interval(root, keys.indexOf(key));
    println(frequency);
    for (int i = 0; i < numSaws; i++) {
      sawWaves[i].play();
      sawWaves[i].freq(frequency);
    }
    playing = true;
  }
  lastKey = key;
}

void keyReleased() {
  println("stopping: " + key);
  for (int i = 0; i < numSaws; i++) {
    sawWaves[i].stop();
  }
  playing = false;
  lastReleasedKey = key;
}

void draw() {
  if (!keyPressed && playing) {
    println("stopping");
    for (int i = 0; i < numSaws; i++) {
      sawWaves[i].stop();
    }
    playing = false;
  }
}
