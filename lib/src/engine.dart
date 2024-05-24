import 'dart:math' as math;

import 'package:bubble_pop_up/src/extensions/num_pair.dart';
import 'package:bubble_pop_up/src/objects/config.dart';
import 'package:bubble_pop_up/src/objects/pop_up_params.dart';
import 'package:flutter/material.dart';
import 'package:helpful_components/helpful_components.dart';
import 'package:num_pair/extensions.dart';
import 'package:num_pair/num_pair.dart';

import 'objects/box_parameters.dart';

class BubblePopUpEngine {
  BubblePopUpConfig _config;

  /// Getting Scope Parameters:-
  ///
  /// Here in case of NO 'PopupScope', our scope will be the WHOLE screen and all
  /// parameters will be accordingly.
  final BoxParameters scope;

  /// Here "base" refers to the pop-up parent.
  final BoxParameters base;

  final RenderBox content;

  bool crossAxisFlipped = false;

  ///This contains the borderRadius values for the pop-up according to the
  ///arrowDirection and then, for [0, 1, 2], for [start, end] of the
  ///side.
  ///
  ///For example to get the top-left border radius value for the "up" arrow
  ///direction, will do:
  ///```
  ///final radius = borderRadiusIndex[(0, -1)][-1];
  ///```
  ///Similarly for top-right border and "up" arrow direction will do:
  ///```
  ///final radius = borderRadiusIndex[(0, -1)][1];
  ///```
  final Map<NumPair, Map<num, num>> borderRadiusIndex;

  static const arrowHeightCorrection = 1;

  ///This is the size of the arrow, with [arrowHeightCorrection] in
  ///consideration.
  late NumPair arrowSize;

  ///This is the size of the whole pop-up including the "arrow" (triangle)
  late NumPair fullSize;

  ///This is the offset, which will be the Point-Of-Contact of the arrow and the
  ///base config.
  late NumPair arrowPoc;

  ///This is the offset, at which the whole pop-up will start, i.e the top-left
  ///corner of the whole pop-up.
  late NumPair popUpTopLeft;

  ///This is the offset, at which the triangle inside the pop-up will start, i.e
  ///the top-left corner of the triangle.
  late final NumPair arrowTopLeft;

  ///This is the offset, at which the content inside the pop-up will start, i.e
  ///the top-left corner of the content widget.
  late final NumPair contentTopLeft;

  BubblePopUpConfig get config => _config;

  BubblePopUpEngine(
    BubblePopUpConfig config,
    PopupController controller,
    MediaQueryData mediaQueryData,
    this.content,
  )   : _config = config,
        scope = BoxParameters.fromController(controller, mediaQueryData),
        base = BoxParameters.fromKey(config.popUpParentKey, mediaQueryData),
        borderRadiusIndex = _genBorderRadiusConfig(config) {
    initParams();
  }

  static Map<NumPair, Map<double, double>> _genBorderRadiusConfig(
      BubblePopUpConfig config) {
    final res = <NumPair, Map<double, double>>{
      (0, -1).np: {
        -1: config.childBorderRadius.topLeft.x,
        1: config.childBorderRadius.topRight.x,
      },
      (1, 0).np: {
        -1: config.childBorderRadius.topRight.y,
        1: config.childBorderRadius.bottomRight.y,
      },
      (0, 1).np: {
        -1: config.childBorderRadius.bottomLeft.x,
        1: config.childBorderRadius.bottomRight.y,
      },
      (-1, 0).np: {
        -1: config.childBorderRadius.topLeft.y,
        1: config.childBorderRadius.bottomLeft.y,
      }
    };

    for (final key in res.keys) {
      res[key]![0] = 0;
    }

    return res;
  }

  void initParams() {
    arrowSize = _getTriangleSize();
    fullSize = _getTotalSize(content.size.np);
    arrowPoc = _calculatePointOfContactOffset(base.topLeft - scope.topLeft);
    popUpTopLeft = _getPopUpTopLeft();
    if (_hasCrossAxisOverflow()) {
      _handleCrossAxisOverflow();

      /* In case of cross-axis overflow, we would need to do the whole process
      again, now with the cross-axis flipped [config]. */
      return initParams();
    }

    arrowTopLeft = _getArrowTopLeft();
    contentTopLeft = _getContentTopLeft();
  }

  NumPair _getTriangleSize() {
    return config.arrowSize.np -
        (config.axis.flip() * arrowHeightCorrection.np);
  }

  ///This function can be used to get the total size of our pop-up and arrow
  ///together.
  NumPair _getTotalSize(NumPair boxSize) {
    /* Here this works as follows, for arrow direction, vertical [axis] becomes
      [0, 1] and vice-versa for horizontal. */
    final axis = config.arrowDirection.np.abs();
    return Np.elementWiseMax(boxSize, (axis.flip() * arrowSize)) +
        (axis * arrowSize);
  }

  ///This calculates the Point-of-Contact of the "arrow" with the "base".
  NumPair _calculatePointOfContactOffset(NumPair baseTopLeft) {
    final baseAnchor = (config.baseAnchor.np / 2) + 0.5.np;
    return baseTopLeft + (baseAnchor * base.size);
  }

  ///This will return the top-left offset of the pop-up, i.e where the pop-up
  ///will start
  NumPair _getPopUpTopLeft() {
    ///This is basically the normalized vector to travel from popUpAnchor to the
    ///topLeft of the pop-up.
    final index = -0.5.np - (config.popUpAnchor.np / 2);
    var res = arrowPoc + (fullSize * index);

    /* In corner cases, we would need to shift pop-up either half the
      arrowSize.width or arrowSize.height, this is because,
      arrowPointOfContactWithBase will be either at the middle of width or
      height of the arrow. */

    ///This is config.arrowDirection
    final r = config.arrowDirection.np;

    ///This is config.popUpAnchor
    final pos = config.popUpAnchor.np;

    res = res + (r.flip().abs() * pos * (arrowSize * 0.5));

    /* We also need to adjust for the popup's border radius */
    final borderRadius =
        (borderRadiusIndex[r]![pos.x]!, borderRadiusIndex[r]![pos.y]!).np;

    res = res + (r.flip().abs() * pos * borderRadius);

    // For handling same axis overflows with scope
    res = handleSameAxisOverflow(
      BoxParameters(topLeft: res, size: fullSize),
      scope,
      config.axis,
    ).topLeft;

    /* Note:- We are handling the cross-axis overflow in the initParams() method
    only */

    return res;
  }

  ///This will return the offset at which the arrow should start, relative to
  ///the whole pop-up block. i.e it will be between (0, 0) to (popUpWidth,
  ///popUpHeight)
  NumPair _getArrowTopLeft() {
    /*
    Here, we are using [config.triangleSize], because in case of right and
    down arrow direction, our pop-up will need to get the correct height and
    width of the triangle, instead of the "reduced" one given by [triangleSize]
     */
    final arrowSize = config.arrowSize.np;

    ///This is the offset of the point of the arrow, where it touches the
    ///base, but relative to the pop-up block.
    final arrowPointOffset = arrowPoc - popUpTopLeft;

    ///Rotation Index (i.e config.arrowDirection)
    final rI = config.arrowDirection.np;

    /*
      Let,
      the rotation index (arrowDirection) = (rx, ry),
      arrowPointOfContactOffset (where the arrow touches the base) = (x, y),
      arrow size = (w, h)
      Then, if we want top-left coord of arrow, for different (rx, ry):
      (0, -1): (x - 0.5w, y       ) //Top
      (1, 0) : (x - 1w  , y - 0.5h) //Right
      (0, 1) : (x - 0.5w, y - 1h )  //Bottom
      (-1, 0): (x       , y - 0.5h) //Left

      So basically, we want (-1, 0, 1) mapped to (0, -0.5, -1), which can be
      done with the formula: `-0.5(rI + 1)`,
      where rI is rx or ry.
      */
    final arrowPocAnchor = (rI + 1.np) / 2;
    final res = arrowPointOffset - (arrowPocAnchor * arrowSize);

    /* Handling Overflows */

    ///Limits for the arrow offset, for different rotations, this also consider
    ///for border radius.
    NumPair getLimits(NumPair rotationIndex) {
      ///To determine if it is horizontal(0) or vertical(1).
      final axis = rotationIndex.x.abs().toInt();
      return (
        borderRadiusIndex[rotationIndex]![-1]!,
        [fullSize.x, fullSize.y][axis] -
            borderRadiusIndex[rotationIndex]![1]! -
            [arrowSize.x, arrowSize.y][axis],
      ).np;
    }

    final limit = getLimits(rI);

    return NumPair(
      (rI.x == 0) ? math.max(limit.x, math.min(res.x, limit.y)) : res.x,
      (rI.y == 0) ? math.max(limit.x, math.min(res.y, limit.y)) : res.y,
    );
  }

  ///Get the top-left offset for the content box, inside the pop-up.
  NumPair _getContentTopLeft() {
    /* Content Top-Left will be (0, 0) for right and bottom arrowDirections.
    But will need to adjust in case of top or left. Therefore we only need to
    check for cases of (0, -1) and (-1, 0) directions. */
    final index = Np.elementWiseMin(config.arrowDirection.np, 0.np);
    return 0.np - (index * arrowSize);
  }

  ///Here [axis] will be defined as (1, 0) for horizontal, (0, 1) for
  ///vertical, (1, 1) for both, and (0, 0) for neither.
  ///
  ///Note:- Here we need topLeft offset for the box, inside the scope, instead
  ///of the global offset.
  static BoxParameters handleSameAxisOverflow(
      BoxParameters box, BoxParameters scope, NumPair axis) {
    const max = Np.elementWiseMax;
    const min = Np.elementWiseMin;

    // This will give us the point under the boundation along both axis.
    var res = max(0.np, min(scope.size - box.size, box.topLeft));

    // Converting for boundation along only the given axis.
    res = (axis * res) + ((1.np - axis) * box.topLeft);

    return box.copyWith(topLeft: res);
  }

  bool _hasCrossAxisOverflow() {
    final updatedTopLeft = handleSameAxisOverflow(
      BoxParameters(topLeft: popUpTopLeft, size: fullSize),
      scope,
      config.axis.flip(),
    ).topLeft;

    return updatedTopLeft != popUpTopLeft && !crossAxisFlipped;
  }

  /* This function is only for code readability purpose only, we can directly
  call [_flipCrossAxisConfig] as well. */
  void _handleCrossAxisOverflow() => _flipCrossAxisConfig();

  void _flipCrossAxisConfig() {
    _config = config.crossAxisFlip();
    crossAxisFlipped = true;
  }

  PopUpParams get popUpParams => PopUpParams(
        offset: popUpTopLeft.toOffset,
        fullSize: fullSize.toSize,
        arrowOffset: arrowTopLeft.toOffset,
        contentOffset: contentTopLeft.toOffset,
        arrowDirection: config.arrowDirection,
      );
}
