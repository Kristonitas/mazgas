var gridAngles = [0, Math.PI / 3 * 2, Math.PI / 3 * 4];
var majorGridColors = [color(#44aa44), color(#ff4444), color(#5577dd)];
var minorGridColors = [color(#aaccaa), color(#ffaaaa), color(#aaccff)];
var gridSize = 10;
var majorLineWidth = 3;
var minorLineWidth = 2;
var canvasMargin = 10;

var all = {};

void setup() {
  size(600,400);
  smooth();
  // console.log(new WorldPoint(10.5, 10.3).add(new WorldPoint(100, 200)));

  all.camera = new Camera({
    position: new WorldPoint(),
    sizeY: 40
  });
}

void draw() {
  // all.camera.sizeY = 1;
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
  WorldPoint wLineNormal = new WorldPoint(Math.sin(angle), Math.cos(angle));
  WorldPoint wLineOrigin = new WorldPoint(0, 0);

  // ScreenPoint sLineNormal = all.camera.worldToScreen(wLineNormal, false);
  ScreenPoint sLineNormal = new ScreenPoint(wLineNormal);
  ScreenPoint sLineOrigin = all.camera.worldToScreen(wLineOrigin, true);

  float maxOffset = (1 + all.camera.aspect) * all.camera.sizeY;
  int maxLines = ceil(maxOffset / gridSize);
  // debugger;
  for (int i = -maxLines; i <= maxLines; ++i) {
    float lineC = i * gridSize / all.camera.sizeY * all.camera.screenHeight + sLineNormal.dot(sLineOrigin);

    // if (lineInScreen(sLineNormal.x, sLineNormal.y, lineC)) {
      float midX = sLineNormal.x * lineC;
      float midY = sLineNormal.y * lineC;
      // Later do intersection with screen
      float x1 = midX + sLineNormal.y * maxOffset * all.camera.screenHeight;
      float y1 = midY - sLineNormal.x * maxOffset * all.camera.screenHeight;
      float x2 = midX - sLineNormal.y * maxOffset * all.camera.screenHeight;
      float y2 = midY + sLineNormal.x * maxOffset * all.camera.screenHeight;

      stroke(i == 0 ? majorGridColors[index] : minorGridColors[index]);
      strokeWeight(i == 0 ? majorLineWidth : minorLineWidth);

      // debugger;
      line(x1, y1, x2, y2);
    // }
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