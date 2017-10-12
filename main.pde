var gridAngles = [0, Math.PI / 3 * 2, Math.PI / 3 * 4];
var majorGridColors = [color(#d0985b), color(#ff4444), color(#5577dd)];
var minorGridColors = [color(#f0b87b), color(#ff8888), color(#8899ff)];
var gridSize = 40;
var majorLineWidth = 2.5;
var minorLineWidth = 2;
var canvasMargin = 10;


void setup() {
  size(600,400);
  smooth();
}

void draw() {
  background(255);
  stroke(50);
  fill(50);
  // ellipse(mouseX,mouseY, 30, 30);

  // I need to draw a hex grid
  // I will need a bunch of lines
  // The lines should go off-canvas with some margins
  // Since there are 3 angles of the lines, I will have to call function for all those angles

  for (var i = 0; i < 3; i++) {
    drawGridLines(i);
  }
}

void drawGridLines(int index) {
  float angle = gridAngles[index];
  // Later start with the nearest point in corner
  float lineA = sin(angle);
  float lineB = cos(angle);
  float maxOffset = (width + height);
  int maxLines = ceil(maxOffset / gridSize);
  for (int i = -maxLines; i <= maxLines; ++i) {
    float lineC = i * gridSize + lineA * mouseX + lineB * mouseY;
    if (lineInScreen) {
      float midX = lineA * lineC;
      float midY = lineB * lineC;
      // Later do intersection with screen
      float x1 = midX + lineB * maxOffset;
      float y1 = midY - lineA * maxOffset;
      float x2 = midX - lineB * maxOffset;
      float y2 = midY + lineA * maxOffset;

      stroke(i == 0 ? majorGridColors[index] : minorGridColors[index]);
      strokeWeight(i == 0 ? majorLineWidth : minorLineWidth);
      line(x1, y1, x2, y2);
    }
  }
}

bool lineInScreen(float a, float b, float c) {
  boolean c0 = a * -canvasMargin + b * -canvasMargin > c;
  boolean c1 = a * (width + canvasMargin) + b * -canvasMargin > c;
  boolean c2 = a * (width + canvasMargin) + b * (height + canvasMargin) > c;
  boolean c3 = a * -canvasMargin + b * (height + canvasMargin) > c;
  return (c0 + c1 + c2 + c3) % 4 == 0;
}

bool pointInScreen(float x, float y) {
  return !(x < -canvasMargin || x > width + canvasMargin || y < -canvasMargin || y > height + canvasMargin)
}