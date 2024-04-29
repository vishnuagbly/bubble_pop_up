import 'package:bubble_pop_up/src/num_pair/num_pair.dart';
import 'package:bubble_pop_up/src/objects/arrow_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension NumPairExt on NumPair {
  Alignment get toAlignment {
    for (var element in values) {
      if (element > 1 || element < -1) {
        throw PlatformException(
          code: 'NOT_ALIGNMENT',
          message: 'Cannot convert to Alignment',
        );
      }
    }
    return Alignment(x.toDouble(), y.toDouble());
  }

  Offset get toOffset => Offset(x.toDouble(), y.toDouble());

  Size get toSize => Size(x.toDouble(), y.toDouble());

  (num, num) get toPair => (x, y);
}

extension AlignNumPair on Alignment {
  NumPair get np => NumPair(x, y);
}

extension OffsetNumPair on Offset {
  NumPair get np => NumPair(dx, dy);
}

extension SizeNumPair on Size {
  NumPair get np => NumPair(width, height);
}

extension PairExt on (num, num) {
  NumPair get np => NumPair($1, $2);
}

extension ArrowDirectionExt on ArrowDirection {
  NumPair get np => NumPair(x, y);
}

extension NumNumPair on num {
  NumPair get np => NumPair(this, this);
}
