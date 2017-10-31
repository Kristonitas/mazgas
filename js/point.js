class Point {
  constructor() {
    switch (arguments.length) {
      case 0:
        this.x = 0;
        this.y = 0;
        break;

      case 1:
        let obj = arguments[0];
        console.assert(
          typeof obj == 'object' &&
          isNumber(obj.x) &&
          isNumber(obj.y));
        this.x = obj.x;
        this.y = obj.y;
        break;

      case 2:
        console.assert(
          isNumber(arguments[0]) &&
          isNumber(arguments[1]));
        this.x = arguments[0];
        this.y = arguments[1];
        break;

      default:
        console.assert(false);
    }
  }

  assertSameClass(obj) {
    console.assert(this.constructor.name == obj.constructor.name);
  }

  equals (point) {
    this.assertSameClass(point);
    return this.x == point.x && this.y == point.y;
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
    assertNumber(x);
    assertNumber(y);
    this.x = x;
    this.y = y;
    return this;
  }

  clone() {
    return new this.constructor(this);
  }

  dot (point) {
    this.assertSameClass(point);
    return this.x * point.x + this.y * point.y;
  }

  length() {
    return Math.sqrt(this.x * this.x + this.y * this.y);
  }

  setLength(newLength) {
    assertNumber(newLength);
    let len = this.length();
    if (len == 0)
      return this;

    this.x *= newLength / len;
    this.y *= newLength / len;

    return this;
  }

  multiplyScalar(value) {
    assertNumber(value);
    this.x *= value;
    this.y *= value;

    return this;
  }

  // Clockwise
  rotate(angle) {
    assertNumber(angle);
    this.x = Math.cos(angle) * this.x + Math.sin(angle) * this.y;
    this.y = Math.cos(angle) * this.y - Math.sin(angle) * this.x;
    return this;
  }
}

class WorldPoint extends Point {

}

class ViewPoint extends Point {

}

class ScreenPoint extends Point {

}

