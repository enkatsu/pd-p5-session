import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress pdAddress;

int SOUND_NUM = 4;
int STEP_NUM = 16;
float gridWidth, gridHeight;
boolean[][] sequenceGrid;

int BPM = 60;
float measureMillis = bpmToMeasureMillis(BPM);
float sixteenthNoteMillis = measureMillis / 16;
int currentStep = 0;
int pStep = -1;

void setup() {
  size(400, 100);
  oscP5 = new OscP5(this, 12000);
  pdAddress = new NetAddress("127.0.0.1", 12000);
  gridWidth = width / STEP_NUM;
  gridHeight = height / SOUND_NUM;
  sequenceGrid = new boolean[SOUND_NUM][STEP_NUM];
  for (int y = 0; y < SOUND_NUM; y++) {
    for (int x = 0; x < STEP_NUM; x++) {
      sequenceGrid[y][x] = false;
    }
  }
}

void draw() {
  background(0);
  
  int n = int(millis() / sixteenthNoteMillis);
  currentStep = n % 16;
  if (pStep != currentStep && pStep != -1) {
    sendOscMessage();
  }
  pStep = currentStep;
  
  for (int y = 0; y < SOUND_NUM; y++) {
    for (int x = 0; x < STEP_NUM; x++) {
      if (sequenceGrid[y][x]) {
        fill(255);
        stroke(0);
      } else {
        fill(0);
        stroke(255);
      }
      if (x == currentStep) {
        stroke(255, 0, 0);
      }
      rect(x * gridWidth, y * gridHeight, gridWidth, gridHeight);
    }
  }
}

void mouseClicked() {
  int sound = (int)map(mouseY, 0, height, 0, SOUND_NUM);
  int step = (int)map(mouseX, 0, width, 0, STEP_NUM);
  sequenceGrid[sound][step] = !sequenceGrid[sound][step];
}

void sendOscMessage() {
  for (int i = 0; i < SOUND_NUM; i++) {
    if (sequenceGrid[i][currentStep]) {
      OscMessage mousePositionMessage = new OscMessage("/sound");
      mousePositionMessage.add(i);
      oscP5.send(mousePositionMessage, pdAddress);
      println("sound: ", i, ", ", "step: ", currentStep);
    }
  }
}

float bpmToMeasureMillis(int bpm) {
  float quarterNote = 60000 / bpm;
  return quarterNote * 4;
}
