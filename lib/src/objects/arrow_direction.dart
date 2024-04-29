class ArrowDirection {
  const ArrowDirection._(this.x, this.y);

  final double x, y;

  static const ArrowDirection up = ArrowDirection._(0, -1);
  static const ArrowDirection down = ArrowDirection._(0, 1);
  static const ArrowDirection left = ArrowDirection._(-1, 0);
  static const ArrowDirection right = ArrowDirection._(1, 0);

  ArrowDirection crossAxisFlip() => ArrowDirection._(-x, -y);

  ArrowDirection flip() => ArrowDirection._(y, x);

  @override
  bool operator ==(Object other) {
    return other is ArrowDirection && x == other.x && y == other.y;
  }

  @override
  int get hashCode => Object.hash(x, y);
}
