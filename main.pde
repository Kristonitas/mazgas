var gridAngles = [0, Math.PI / 3 * 2, Math.PI / 3 * 4];
var majorGridColors = [color(#44aa44), color(#ff4444), color(#5577dd)];
var minorGridColors = [color(#88bb88), color(#ff8888), color(#8899ff)];
var gridSize = 100;
var majorLineWidth = 3;
var minorLineWidth = 2.5;
var canvasMargin = 10;

class Point {
  float x, y;

  Point(x, y) {
    this.x = x;
    this.y = y;
  }

  void assertSameClass(obj) {
    // looked what happens when using debugger
    // this becomes something else, so to get the javascript this, need to call this.$self
    console.assert(this.$self.constructor.name == obj.constructor.name);
  }

  void assertNumber(obj) {
    console.assert(typeof obj == "number");
  }

  Point add (point) {
    assertSameClass(point);
    this.x += point.x;
    this.y += point.y;
    return this;
  }

  Point sub (point) {
    assertSameClass(point);
    this.x -= point.x;
    this.y -= point.y;
    return this;
  }

  Point set (x, y) {
    assertNumber(x);
    assertNumber(y);
    this.x = x;
    this.y = y;
    return this;
  }

  Point clone() {
    return new this.$self.constructor(this.x, this.y);
  }

  Point dot (point) {
    assertSameClass(point);
    return this.x * point.x + this.y * point.y;
  }

  float length() {
    return Math.sqrt(this.x * this.x + this.y * this.y);
  }

  void setLength(float newLength) {
    assertNumber(newLength);
    float len = this.length();
    if (len == 0)
      return this;

    this.x *= newLength / len;
    this.y *= newLength / len;

    return this;
  }
}

class WorldPoint extends Point {
  WorldPoint(x, y) {
    super(x, y);
  }
}

class ScreenPoint extends Point {
  ScreenPoint(x, y) {
    super(x, y);
  }
}

void setup() {
  size(600,400);
  smooth();
  console.log(new WorldPoint(10.5, 10.3).add(new WorldPoint(100, 200)));
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
  float angle = gridAngles[index] + millis() / 10000;
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