import 'dart:math';

typedef Np = NumPair;

class NumPair {
  final num x, y;

  const NumPair(this.x, this.y);

  NumPair.fromPair((int, int) values) : this(values.$1, values.$2);

  List<num> get values => [x, y];

  NumPair operator *(Object? second) {
    if (second is NumPair) {
      return NumPair(x * second.x, y * second.y);
    } else if (second is num) {
      return NumPair(x * second, y * second);
    }
    throw UnimplementedError(
      'NumPair * ${second.runtimeType} is not implemented.',
    );
  }

  NumPair operator +(NumPair second) {
    return NumPair(x + second.x, y + second.y);
  }

  NumPair operator -() {
    return NumPair(-x, -y);
  }

  NumPair operator -(NumPair second) {
    return NumPair(x - second.x, y - second.y);
  }

  NumPair operator /(Object? second) {
    if (second is NumPair) {
      return NumPair(x / second.x, y / second.y);
    } else if (second is num) {
      return NumPair(x / second, y / second);
    }
    throw UnimplementedError(
      'NumPair / ${second.runtimeType} is not implemented.',
    );
  }

  num operator [](int index) => values[index];

  NumPair flip() => NumPair(y, x);

  NumPair round() => NumPair(x.round(), y.round());

  NumPair abs() => NumPair(x.abs(), y.abs());

  num sum() => x + y;

  static NumPair elementWiseMax(NumPair first, NumPair second) {
    return NumPair(max(first.x, second.x), max(first.y, second.y));
  }

  static NumPair elementWiseMin(NumPair first, NumPair second) {
    return NumPair(min(first.x, second.x), min(first.y, second.y));
  }

  @override
  bool operator ==(Object? other) {
    return other is NumPair && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);
}
