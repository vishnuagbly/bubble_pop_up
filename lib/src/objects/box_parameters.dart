import 'package:bubble_pop_up/src/extensions/num_pair.dart';
import 'package:bubble_pop_up/src/num_pair/num_pair.dart';
import 'package:bubble_pop_up/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:helpful_components/helpful_components.dart';

class BoxParameters {
  final GlobalKey? key;
  final RenderBox? box;
  final NumPair topLeft;
  final NumPair size;

  const BoxParameters({
    this.key,
    this.box,
    required this.topLeft,
    required this.size,
  });

  factory BoxParameters.fromController(
      PopupController controller, MediaQueryData mediaQueryData) {
    return BoxParameters.fromKey(controller.key, mediaQueryData);
  }

  factory BoxParameters.fromKey(GlobalKey? key, MediaQueryData mediaQueryData) {
    final box = key?.currentContext?.findRenderObject() as RenderBox?;
    final topLeft = Utils.getGlobalOffset(key, false, box) ?? Offset.zero;
    final size =
        (key?.currentContext?.findRenderObject() as RenderBox?)?.size ??
            mediaQueryData.size;
    return BoxParameters(
        key: key, box: box, topLeft: topLeft.np, size: size.np);
  }

  BoxParameters copyWith({
    GlobalKey? key,
    RenderBox? box,
    NumPair? topLeft,
    NumPair? size,
  }) =>
      BoxParameters(
        key: key ?? this.key,
        box: box ?? this.box,
        topLeft: topLeft ?? this.topLeft,
        size: size ?? this.size,
      );
}
