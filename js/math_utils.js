isNumber = function(obj) {
  return typeof obj == "number";
}

assertNumber = function(obj) {
  console.assert(isNumber(obj));
}

class MathUtils {
  static clamp(value, min, max) {
    return value <= min ? min : (value >= max ? max : value);
  }
}