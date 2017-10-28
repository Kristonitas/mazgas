const minSizeY = 20;
const maxSizeY = 200;

class Camera {
  constructor(args) {
    console.assert(args != null);

    this.position = args.position || new WorldPoint;
    this.rotation = args.rotation || 0;
    this.aspect = args.screenWidth / args.screenHeight;
    this.sizeY = args.sizeY || 1;

    this.screenWidth = args.screenWidth;
    this.screenHeight = args.screenHeight;
  }

  assertClass(obj, cl) {
    console.assert(obj.constructor.name == cl.name);
  }

  worldToView(point) {
    this.assertClass(point, WorldPoint);

    point = point.clone().sub(this.position).rotate(-this.rotation);
    return new ViewPoint(
      point.x / this.sizeY / this.aspect  + 0.5,
      point.y / this.sizeY + 0.5
      );
  }

  viewToScreen(point) {
    this.assertClass(point, ViewPoint);

    return new ScreenPoint(
      this.screenWidth * point.x,
      this.screenHeight * (1 - point.y)
      );
  }

  worldToScreen(point, useOffset) {
    console.assert(useOffset != null);
    this.assertClass(point, WorldPoint);

    if (useOffset)
      return this.viewToScreen(this.worldToView(point));
    else
      return new ScreenPoint(point.x / this.sizeY * this.screenHeight , point.y / this.sizeY * this.screenHeight );
  }

  screenToView(point) {
    this.assertClass(point, ScreenPoint);

    return new ViewPoint(
      point.x / this.screenWidth,
      1 - point.y / this.screenHeight
      );
  }

  viewToWorld(point) {
    this.assertClass(point, ViewPoint);

    point = new WorldPoint(
      (point.x - 0.5) * this.sizeY * this.aspect,
      (point.y - 0.5) * this.sizeY
      );
    return point.rotate(this.rotation).add(this.position);
  }

  screenToWorld(point, useOffset) {
    console.assert(useOffset != null);
    this.assertClass(point, ScreenPoint);

    if (useOffset)
      return this.viewToWorld(this.screenToView(point));
    else
      return new WorldPoint(point.x / this.screenHeight * this.sizeY, point.y / this.screenHeight  * this.sizeY);
  }

  updateMouseWheel(screenPoint, delta) {
    let worldStart = this.screenToWorld(screenPoint, true);

    this.sizeY = Math.exp(Math.log(this.sizeY) - delta * 0.05);
    this.sizeY = MathUtils.clamp(this.sizeY, minSizeY, maxSizeY);

    let worldEnd = this.screenToWorld(screenPoint, true);

    this.position.add(worldStart.sub(worldEnd));
  }

  sizeLimitCoef() {
    return (this.sizeY - minSizeY) / (maxSizeY - minSizeY);
  }

  updateMousePos(currentPos, previousPos) {
    let worldStart = this.screenToWorld(previousPos, true);
    let worldEnd = this.screenToWorld(currentPos, true);

    this.position.add(worldStart.sub(worldEnd));
  }
}

