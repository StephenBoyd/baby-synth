import processing.sound.*;

SawOsc[] sawWaves;
float[] sawFreq;
int numSaws = 4;

double semitoneRatio = pow(2.0, (1.0 / 12.0));
double root = 110.0;
boolean playing = false;

// The home row is white keys starting with 'a' for 'a'
String keys = new String("awsdrftghujikol;[']");

float interval(double frequency, int semitones) {
  double result = frequency;
  for (int i = 0; i < semitones; i++) {
    result = result * semitoneRatio;
  }
  if (semitones < 0) {
    semitones = semitones * -1;
    for (int i = 0; i < semitones; i++) {
      result = result / semitoneRatio;
    }
  }
  return (float) result;
}

float frequency = interval(root, 0);

void setup() {
  size(640, 360);
  background(0);
  println(interval(440, -12));
  
  sawWaves = new SawOsc[numSaws];
  sawFreq = new float[numSaws];
  
  for (int i = 0; i < numSaws; i++) {
    // Calculate the amplitude for each oscillator
    float sawVolume = (1.0 / numSaws) / (i + 1);
    // Create the oscillators
    sawWaves[i] = new SawOsc(this);
    // Set the amplitudes for all oscillators
    sawWaves[i].amp(sawVolume);
  }
}

char lastKey = ' ';
void draw() {
  if (keyPressed && !playing) {
    println(key);
    if (keys.indexOf(key) != -1) {
      frequency = interval(root, keys.indexOf(key));
      println(frequency);
      for (int i = 0; i < numSaws; i++) {
        sawWaves[i].play();
        sawWaves[i].freq(frequency);
      }
      playing = true;
      lastKey = key;
    }
  }
  if (!keyPressed && playing) {
    for (int i = 0; i < numSaws; i++) {
      sawWaves[i].stop();
    }
    playing = false;
  }
}
