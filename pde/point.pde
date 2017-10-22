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

