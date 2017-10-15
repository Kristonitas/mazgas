var gridAngles = [0, Math.PI / 3 * 2, Math.PI / 3 * 4];
var majorGridColors = [color(#44aa44), color(#ff4444), color(#5577dd)];
var minorGridColors = [color(#aaccaa), color(#ffaaaa), color(#aaccff)];
var gridSize = 10;
var majorLineWidth = 3;
var minorLineWidth = 2;
var canvasMargin = 10;

var all = {};

class Point {
  float x, y;

  Point() {
    this.x = 0;
    this.y = 0;
  }

  Point(x, y) {
    this.x = x;
    this.y = y;
  }

  Point(point) {
    this.x = point.x;
    this.y = point.y;
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

  Point setLength(float newLength) {
    assertNumber(newLength);
    float len = this.length();
    if (len == 0)
      return this;

    this.x *= newLength / len;
    this.y *= newLength / len;

    return this;
  }

  // Clockwise
  Point rotate(angle) {
    assertNumber(angle);
    this.x = Math.cos(angle) * this.x + Math.sin(angle) * this.y;
    this.y = Math.cos(angle) * this.y - Math.sin(angle) * this.x;
    return this;
  }
}

class WorldPoint extends Point {
  WorldPoint(x, y) {
    super(x, y);
  }

  WorldPoint (point) {
    super(point);
  }
}

class ViewPoint extends Point {
  ViewPoint(x, y) {
    super(x, y);
  }

  ViewPoint (point) {
    super(point);
  }

}

class ScreenPoint extends Point {
  ScreenPoint(x, y) {
    super(x, y);
  }

  ScreenPoint (point) {
    super(point);
  }
}

class Camera {
  WorldPoint position;
  float rotation, aspect, sizeY;
  int screenWidth, screenHeight;

  Camera(args) {
    console.assert(args != null);

    this.position = args.position || new WorldPoint;
    this.rotation = args.rotation || 0;
    this.aspect = args.aspect || width / height;
    this.sizeY = args.sizeY || 1;

    this.screenWidth = args.screenWidth || width;
    this.screenHeight = args.screenHeight || height;
  }

  void assertClass(obj, cl) {
    console.assert(obj.constructor.name == cl.name);
  }

  ViewPoint worldToView(point) {
    assertClass(point, WorldPoint);

    point = point.clone().sub(this.position).rotate(-this.rotation);
    return new ViewPoint(
      (point.x - this.position.x) / this.sizeY / this.screenWidth + 0.5,
      (point.y - this.position.y) / this.sizeY / this.screenHeight + 0.5
      );
  }

  ScreenPoint viewToScreen(point) {
    assertClass(point, ViewPoint);

    return new ScreenPoint(
      this.screenWidth * point.x,
      this.screenHeight * (1 - point.y)
      );
  }

  ScreenPoint worldToScreen(point, useOffset) {
    assertClass(point, WorldPoint);


    if (useOffset)
      return viewToScreen(worldToView(point));
    else
      return new ScreenPoint(point.x / this.sizeY, point.y / this.sizeY);
  }

  ViewPoint screenToView(point) {
    assertClass(point, ScreenPoint);

    return new ViewPoint(
      point.x / this.screenWidth,
      1 - point.y / this.screenHeight
      );
  }

  WorldPoint viewToWorld(point) {
    assertClass(point, ViewPoint);

    point = new WorldPoint(
      (point.x - 0.5) * this.screenWidth,
      (point.y - 0.5) * this.screenHeight
      );
    return point.rotate(this.rotation).add(this.position);
  }

  WorldPoint screenToWorld(point, useOffset) {
    assertClass(point, ScreenPoint);

    if (useOffset)
      return viewToWorld(screenToView(point));
    else
      return new WorldPoint(point.x * this.sizeY, point.y * this.sizeY);
  }
}

void setup() {
  size(600,400);
  smooth();
  console.log(new WorldPoint(10.5, 10.3).add(new WorldPoint(100, 200)));

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