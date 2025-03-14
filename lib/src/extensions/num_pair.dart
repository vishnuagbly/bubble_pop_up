import 'package:bubble_pop_up/src/objects/arrow_direction.dart';
import 'package:flutter/material.dart';
import 'package:num_pair/extensions.dart';
import 'package:num_pair/num_pair.dart';

extension ArrowDirectionExt on ArrowDirection {
  NumPair get np => NumPair(x, y);
}

extension BorderRadiusExt on BorderRadius {
  NumPair? atCoord(NumPair coord) {
    switch (coord.toPair) {
      case (0, 0):
        return NumPair(topLeft.x, topLeft.y);
      case (1, 0):
        return NumPair(topRight.x, topRight.y);
      case (0, 1):
        return NumPair(bottomLeft.x, bottomLeft.y);
      case (1, 1):
        return NumPair(bottomRight.x, bottomRight.y);
      default:
        return null;
    }
  }

  NumPair? atCoordOrZero(NumPair coord) => atCoord(coord) ?? 0.np;
}

extension RadiusExt on Radius {
  NumPair get np => NumPair(x, y);
}
