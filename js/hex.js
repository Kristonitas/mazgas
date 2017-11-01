class Hex {
  constructor() {
    switch (arguments.length) {
      case 0:
        this.q = 0;
        this.r = 0;
        this.s = 0;
        break;

      case 1:
        let obj = arguments[0];
        console.assert(
          typeof obj == 'object' &&
            isNumber(obj.q) &&
            isNumber(obj.r) &&
            isNumber(obj.s));
        this.q = obj.q;
        this.r = obj.r;
        this.s = obj.s;
        break;

      case 2:
        console.assert(
          isNumber(arguments[0]) &&
          isNumber(arguments[1]));
        this.q = arguments[0];
        this.r = arguments[1];
        this.s = -this.q - this.r;
        break;

      case 3:
        console.assert(
          isNumber(arguments[0]) &&
          isNumber(arguments[1]) &&
          isNumber(arguments[2]));
        this.q = arguments[0];
        this.r = arguments[1];
        this.s = arguments[2];
        break;

      default:
        console.assert(false);
    }

    console.assert(this.q + this.r + this.s == 0);
  }

  assertSameClass(obj) {
    console.assert(this.constructor.name == obj.constructor.name);
  }

  equals (hex) {
    this.assertSameClass(hex);
    return this.q == hex.q && this.r == hex.r && this.s == hex.s;
  }

  add (hex) {
    this.assertSameClass(hex);
    this.q += hex.q;
    this.r += hex.r;
    this.s += hex.s;
    return this;
  }

  sub (hex) {
    this.assertSameClass(hex);
    this.q -= hex.q;
    this.r -= hex.r;
    this.s -= hex.s;
    return this;
  }

  set (q, r, s) {
    assertNumber(q);
    assertNumber(r);
    assertNumber(s);
    this.q = q;
    this.r = r;
    this.s = s;
    return this;
  }

  length() {
    return (Math.abs(this.q) + Math.abs(this.r) + Math.abs(this.s)) / 2;
  }

  clone() {
    return new this.constructor(this);
  }

  multiplyScalar(value) {
    assertNumber(value);

    this.q *= value;
    this.r *= value;
    this.s *= value;

    return this;
  }

  round() {
    let q = Math.round(this.q);
    let r = Math.round(this.r);
    let s = Math.round(this.s);
    let q_diff = Math.abs(q - this.q);
    let r_diff = Math.abs(r - this.r);
    let s_diff = Math.abs(s - this.s);

    if (q_diff > r_diff && q_diff > s_diff)
      q = -r - s;
    else if (r_diff > s_diff)
      r = -q - s;
    else
      s = -q - r;

    return this;
  }

  roundClone() {
    return new RoundHex(this);
  }

  getNeighbour(direction) {
    return this.clone().add(this.constructor.direction(direction));
  }

  getDiagonalNeighbour(diagonalDirection) {
    return this.clone().add(this.constructor.diagonalDirection(diagonalDirection));
  }

  static direction(direction) {
    console.assert(direction >= 0 && direction < 6);

    return this.kDirections[direction].clone();
  }

  static diagonalDirection(direction) {
    console.assert(direction >= 0 && direction < 6);

    return this.kDiagonalDirections[direction].clone();
  }

  static lerp(from, to, t) {
    return new Hex(
      from.q + (to.q - from.q) * t,
      from.r + (to.r - from.r) * t,
      from.s + (to.s - from.s) * t);
  }
}

Hex.kDirections = [
  new Hex(1, 0, -1),
  new Hex(1, -1, 0),
  new Hex(0, -1, 1),
  new Hex(-1, 0, 1),
  new Hex(-1, 1, 0),
  new Hex(0, 1, -1)];

Hex.kDiagonalDirections = [
  new Hex(2, -1, -1),
  new Hex(1, -2, 1),
  new Hex(-1, -1, 2),
  new Hex(-2, 1, 1),
  new Hex(-1, 2, -1),
  new Hex(1, 1, -2)];

class RoundHex extends Hex {
  constructor() {
    super(arguments);
    assertRound();
  }

  assertRound() {
    console.assert(
      Number.isInteger(this.q) &&
      Number.isInteger(this.r) &&
      Number.isInteger(this.s));
  }
}