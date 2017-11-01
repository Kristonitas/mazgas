class Orientation {
  constructor() {
    console.assert(arguments.length == 9);
    for (var i = arguments.length - 1; i >= 0; i--) {
      assertNumber(arguments[i]);
    }

    this.f0 = arguments[0];
    this.f1 = arguments[1];
    this.f2 = arguments[2];
    this.f3 = arguments[3];

    this.b0 = arguments[4];
    this.b1 = arguments[5];
    this.b2 = arguments[6];
    this.b3 = arguments[7];
   
    this.start_angle = arguments[8];
  }
}

Orientation.kPointy = new Orientation(
  Math.sqrt(3),     Math.sqrt(3) / 2, 0, 3 / 2,
  Math.sqrt(3) / 3, -1 / 3,           0, 2 / 3,
  0.5)

Orientation.kFlat = new Orientation(
  3 / 2, 0, Math.sqrt(3) / 2, Math.sqrt(3),
  2 / 3, 0, -1 / 3,           Math.sqrt(3) / 3,
  0)