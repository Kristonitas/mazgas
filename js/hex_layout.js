class HexLayout {
  constructor(args) {
    this.orientation = args.orientation;
    this.size = args.size;
    this.origin = args.origin;
  }

  hexToPoint(hex)
  {
      let M = this.orientation;
      let size = this.size;
      let origin = this.origin;
      let x = (M.f0 * h.q + M.f1 * h.r) * size.x;
      let y = (M.f2 * h.q + M.f3 * h.r) * size.y;
      return new Point(x + origin.x, y + origin.y);
  }

  pixelToHex(point)
  {
      let M = this.orientation;
      let size = this.size;
      let origin = this.origin;
      let pt = new Point((point.x - origin.x) / size.x, (point.y - origin.y) / size.y);
      let q = M.b0 * pt.x + M.b1 * pt.y;
      let r = M.b2 * pt.x + M.b3 * pt.y;
      return new Hex(q, r, -q - r);
  }

  hxCornerOffset(corner)
  {
      let M = this.orientation;
      let size = this.size;
      let angle = Math.PI * 2 * (corner + M.start_angle) / 6;
      return new Point(size.x * Math.cos(angle), size.y * Math.sin(angle));
  }


  polygonCorners(hex)
  {
      let corners = [];
      let center = this.hexToPoint(hex);
      for (let i = 0; i < 6; i++)
      {
          let offset = this.hexCornerOffset(i);
          corners[i] = center.clone().add(offset);
      }
      return corners;
  }
}