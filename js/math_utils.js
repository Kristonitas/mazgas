class MathUtils {
  static clamp(value, min, max) {
    return value <= min ? min : (value >= max ? max : value);
  }
}