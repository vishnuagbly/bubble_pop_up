import 'package:bubble_pop_up/src/objects/arrow_direction.dart';
import 'package:flutter/material.dart';

class PopUpParams {
  final Offset offset;
  final Size fullSize;
  final Offset arrowOffset;
  final Offset contentOffset;
  final ArrowDirection arrowDirection;

  const PopUpParams({
    required this.offset,
    required this.fullSize,
    required this.arrowOffset,
    required this.contentOffset,
    required this.arrowDirection,
  });
}
