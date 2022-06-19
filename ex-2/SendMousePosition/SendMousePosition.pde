import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress pdAddress;

void setup() {
  size(640, 480);
  oscP5 = new OscP5(this, 12000);
  pdAddress = new NetAddress("127.0.0.1", 12000);
  colorMode(HSB, 360, 100, 100);
}

void draw() {
}

void mouseMoved() {
  float x = map(mouseX, 0, width, 0, 1);
  float y = map(mouseY, 0, height, 0, 1);
  OscMessage mousePositionMessage = new OscMessage("/mouse/position");
  mousePositionMessage.add(x);
  mousePositionMessage.add(y);
  oscP5.send(mousePositionMessage, pdAddress);
  background(y * 360, x * 100, 100);
}
