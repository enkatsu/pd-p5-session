import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress pdAddress;

void setup() {
  size(640, 480);
  oscP5 = new OscP5(this, 12000);
  pdAddress = new NetAddress("127.0.0.1", 12000);
}

void draw() {
}

void mouseMoved() {
  OscMessage mousePositionMessage = new OscMessage("/mouse/position");
  mousePositionMessage.add(mouseX);
  mousePositionMessage.add(mouseY);
  oscP5.send(mousePositionMessage, pdAddress);
}
