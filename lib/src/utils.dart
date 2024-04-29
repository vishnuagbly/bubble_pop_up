import 'package:bubble_pop_up/src/objects/arrow_direction.dart';
import 'package:flutter/material.dart';

abstract class Utils {
  static List<(num, num)> getArrowCoords(ArrowDirection direction) {
    final (x, y) = (direction.x, direction.y);
    return [
      ((x + 1) / 2, (y + 1) / 2),
      ((1 - x + y) / 2, (1 - x - y) / 2),
      ((1 - x - y) / 2, (1 + x - y) / 2)
    ];
  }

  ///Set end to True to get the bottom right corner's offset.
  static Offset? getGlobalOffset(
      [GlobalKey? key, bool end = false, RenderBox? box]) {
    box ??= key?.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;

    final offset = end ? Offset(box.size.width, box.size.height) : Offset.zero;
    return box.localToGlobal(offset);
  }
}
