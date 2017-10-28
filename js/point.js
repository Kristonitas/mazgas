class Point {
  constructor(xObj, y) {
    if (xObj == null) {
      this.x = 0;
      this.y = 0;

    } else if (y == null) {
      this.x = xObj.x;
      this.y = xObj.y;

    } else {
      this.x = xObj;
      this.y = y;

    }
  }

  assertSameClass(obj) {
    console.assert(this.constructor.name == obj.constructor.name);
  }

  assertNumber(obj) {
    console.assert(typeof obj == "number");
  }

  add (point) {
    this.assertSameClass(point);
    this.x += point.x;
    this.y += point.y;
    return this;
  }

  sub (point) {
    this.assertSameClass(point);
    this.x -= point.x;
    this.y -= point.y;
    return this;
  }

  set (x, y) {
    this.assertNumber(x);
    this.assertNumber(y);
    this.x = x;
    this.y = y;
    return this;
  }

  clone() {
    return new this.constructor(this.x, this.y);
  }

  dot (point) {
    this.assertSameClass(point);
    return this.x * point.x + this.y * point.y;
  }

  length() {
    return Math.sqrt(this.x * this.x + this.y * this.y);
  }

  setLength(newLength) {
    this.assertNumber(newLength);
    let len = this.length();
    if (len == 0)
      return this;

    this.x *= newLength / len;
    this.y *= newLength / len;

    return this;
  }

  multiplyScalar(value) {
    this.x *= value;
    this.y *= value;

    return this;
  }

  // Clockwise
  rotate(angle) {
    this.assertNumber(angle);
    this.x = Math.cos(angle) * this.x + Math.sin(angle) * this.y;
    this.y = Math.cos(angle) * this.y - Math.sin(angle) * this.x;
    return this;
  }
}

class WorldPoint extends Point {
  constructor(x, y) {
    super(x, y);
  }
}

class ViewPoint extends Point {
  constructor(x, y) {
    super(x, y);
  }

}

class ScreenPoint extends Point {
  constructor(x, y) {
    super(x, y);
  }
}

