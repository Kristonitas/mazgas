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

