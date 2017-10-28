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
      (point.x - this.position.x) / this.sizeY / this.screenWidth + 0.5,
      (point.y - this.position.y) / this.sizeY / this.screenHeight + 0.5
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
    this.assertClass(point, WorldPoint);


    if (useOffset)
      return this.viewToScreen(this.worldToView(point));
    else
      return new ScreenPoint(point.x / this.sizeY, point.y / this.sizeY);
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
      (point.x - 0.5) * this.screenWidth,
      (point.y - 0.5) * this.screenHeight
      );
    return point.rotate(this.rotation).add(this.position);
  }

  screenToWorld(point, useOffset) {
    this.assertClass(point, ScreenPoint);

    if (useOffset)
      return this.viewToWorld(this.screenToView(point));
    else
      return new WorldPoint(point.x * this.sizeY, point.y * this.sizeY);
  }

  updateMouseWheel(delta) {
    this.sizeY = Math.exp(Math.log(this.sizeY) - delta * 0.1);
    this.sizeY = MathUtils.clamp(this.sizeY, minSizeY, maxSizeY);
  }

  sizeLimitCoef() {
    return (this.sizeY - minSizeY) / (maxSizeY - minSizeY);
  }
}

