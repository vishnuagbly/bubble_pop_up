import 'package:bubble_pop_up/src/extensions/num_pair.dart';
import 'package:flutter/material.dart';
import 'package:num_pair/extensions.dart';
import 'package:num_pair/num_pair.dart';

import 'arrow_direction.dart';

class BubblePopUpConfig {
  final GlobalKey? popUpParentKey;
  final num arrowCornerRadius;
  final Size arrowParams;
  final BorderRadius popUpBorderRadius;
  final BorderRadius baseBorderRadius;
  final Alignment baseAnchor;

  ///This will be the position on the pop-up where it will have the arrow, i.e
  ///where it will touch the base widget.
  final Alignment popUpAnchor;

  ///Direction in which the arrow will be pointing, this is to determine which
  ///side of the base widget will the pop-up appear.
  final ArrowDirection arrowDirection;

  ///For [arrowParams] provide Size(width, height) of the triangle.
  ///Note:- Use [arrowSize] for getting the actual width and height of the
  ///triangle widget.
  const BubblePopUpConfig({
    this.popUpParentKey,
    this.arrowCornerRadius = 0,
    this.arrowDirection = ArrowDirection.up,
    this.arrowParams = kDefaultArrowParams,
    this.popUpBorderRadius = BorderRadius.zero,
    this.baseBorderRadius = BorderRadius.zero,
    this.baseAnchor = Alignment.bottomCenter,
    this.popUpAnchor = Alignment.topCenter,
  });

  static const kDefaultArrowParams = Size(12, (1.732 / 2) * 12);

  ///Horizontal: (1, 0)
  ///Vertical:   (0, 1)
  NumPair get axis => arrowDirection.np.abs().flip();

  BubblePopUpConfig crossAxisFlip() => copyWith(
        baseAnchor: flipCrossAxisAlignment(baseAnchor, axis),
        popUpAnchor: flipCrossAxisAlignment(popUpAnchor, axis),
        arrowDirection: arrowDirection.crossAxisFlip(),
      );

  static Alignment flipCrossAxisAlignment(Alignment alignment, NumPair axis) {
    final crossAxis = axis.flip();
    return (((-1.np * crossAxis) + (axis * 1.np)) * alignment.np).toAlignment;
  }

  Size get arrowSize {
    final params = arrowParams.np;
    final ax = axis;
    return Size(
      (ax * params).sum().toDouble(),
      (ax.flip() * params).sum().toDouble(),
    );
  }

  BubblePopUpConfig copyWith({
    GlobalKey? popUpParentKey,
    num? arrowCornerRadius,
    Size? triangleParams,
    BorderRadius? childBorderRadius,
    BorderRadius? baseBorderRadius,
    Alignment? baseAnchor,
    Alignment? popUpAnchor,
    ArrowDirection? arrowDirection,
  }) =>
      BubblePopUpConfig(
        popUpParentKey: popUpParentKey ?? this.popUpParentKey,
        arrowCornerRadius: arrowCornerRadius ?? this.arrowCornerRadius,
        arrowParams: triangleParams ?? this.arrowParams,
        popUpBorderRadius: childBorderRadius ?? this.popUpBorderRadius,
        baseBorderRadius: baseBorderRadius ?? this.baseBorderRadius,
        baseAnchor: baseAnchor ?? this.baseAnchor,
        popUpAnchor: popUpAnchor ?? this.popUpAnchor,
        arrowDirection: arrowDirection ?? this.arrowDirection,
      );

  @override
  bool operator ==(Object other) {
    return other is BubblePopUpConfig &&
        popUpParentKey == other.popUpParentKey &&
        arrowCornerRadius == other.arrowCornerRadius &&
        arrowParams == other.arrowParams &&
        popUpBorderRadius == other.popUpBorderRadius &&
        baseBorderRadius == other.baseBorderRadius &&
        baseAnchor == other.baseAnchor &&
        popUpAnchor == other.popUpAnchor &&
        arrowDirection == other.arrowDirection;
  }

  @override
  int get hashCode => Object.hash(
        popUpParentKey,
        arrowCornerRadius,
        arrowParams,
        popUpBorderRadius,
        baseBorderRadius,
        baseAnchor,
        popUpAnchor,
        arrowDirection,
      );
}
