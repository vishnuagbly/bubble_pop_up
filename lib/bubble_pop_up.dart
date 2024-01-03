library bubble_pop_up;

import 'dart:math' as math;

import 'package:advanced_polygons/advanced_polygons.dart';
import 'package:flutter/material.dart';
import 'package:helpful_components/helpful_components.dart';

class BubblePopUp extends StatefulWidget {
  ///If [popUpParentKey] is specified manually, then it will be used to get the widget
  ///around which to display the [popUp]. This can be useful in case we want to
  ///show [popUp] around a sub-widget maybe deep inside [child] and want to show
  ///[popUp] even in case of hovering over whole [child]
  ///If it is not specified, or left null, then the [child] only will be used
  ///instead.
  ///
  ///Note:- Hover will always work around [child], instead of the widget with
  ///[popUpParentKey].
  ///
  ///For [popUpPosition] currently only bottom alignments are supported.
  ///
  ///Provide [childBorderRadius] as the border radius for the child, as this will
  ///wrap the child around with an InkWell, therefore need to provide the
  ///border radius for the splash.
  ///
  ///Set [onHover] and [onTap] to set, if to show pop up on hover and tap
  ///respectively on the [child] widget.
  const BubblePopUp({
    super.key,
    required this.child,
    this.popUp = const SizedBox(),
    this.popUpPosition = Alignment.bottomCenter,
    this.popUpColor,
    this.popUpParentKey,
    this.triangleCornerRadius = 0,
    this.triangleSize = kDefaultTriangleSize,
    this.childBorderRadius = BorderRadius.zero,
    this.onHover = true,
    this.onTap = true,
  });

  final Widget child;
  final Widget popUp;
  final GlobalKey? popUpParentKey;
  final Color? popUpColor;
  final double triangleCornerRadius;
  final Size triangleSize;
  final BorderRadius childBorderRadius;
  final bool onHover;
  final bool onTap;

  ///Currently only bottom alignments are supported, while support for top
  ///alignments is next. Currently there are no plans for side alignments'
  ///support.
  final Alignment popUpPosition;

  ///Set end to True to get the bottom right corner's offset.
  static Offset? getGlobalOffset(
      [GlobalKey? key, bool end = false, RenderBox? box]) {
    box ??= key?.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;

    final offset = end ? Offset(box.size.width, box.size.height) : Offset.zero;
    return box.localToGlobal(offset);
  }

  static const kDefaultTriangleSize = Size(12, (1.732 / 2) * 12);

  @override
  State<BubblePopUp> createState() => _BubblePopUpState();
}

class _BubblePopUpState extends State<BubblePopUp> {
  late final GlobalKey popUpParentKey;
  PopupController? controller;
  bool isSelected = false;

  @override
  void initState() {
    popUpParentKey = widget.popUpParentKey ?? GlobalKey();
    super.initState();
  }

  Offset calculatePointOfContactOffset(
      Offset bottomRightOffset, Size popUpSize) {
    var offset = bottomRightOffset;
    if (widget.popUpPosition == Alignment.bottomCenter) {
      offset = offset.translate(-(popUpSize.width / 2), 0);
    } else if (widget.popUpPosition == Alignment.bottomLeft) {
      offset = offset.translate(-popUpSize.width, 0);
    }
    return offset;
  }

  Widget? generatePopup(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final controller = PopupController.of(context);
    final mainKey = controller.key;
    final mainBox = mainKey?.currentContext?.findRenderObject() as RenderBox?;
    final mainOffset =
        BubblePopUp.getGlobalOffset(mainKey, false, mainBox) ?? Offset.zero;

    final stackSize =
        (mainKey?.currentContext?.findRenderObject() as RenderBox?)?.size ??
            MediaQuery.of(context).size;

    final childBox =
        popUpParentKey.currentContext?.findRenderObject() as RenderBox?;
    if (childBox == null) return null;

    final childHeight = childBox.size.height;
    final popUpColor = widget.popUpColor ?? scheme.background;
    final popupContent = widget.popUp;

    final childBottomRightOffset =
        BubblePopUp.getGlobalOffset(widget.popUpParentKey, true, childBox);
    if (childBottomRightOffset == null) return null;

    //Calculating offset for the point where the triangle will start.
    final offset = calculatePointOfContactOffset(
        childBottomRightOffset - mainOffset, childBox.size);

    final triangleSize = widget.triangleSize;

    final triangle = ClipPath(
      clipper: PolygonClipper(
        PolygonArgs(
          coords: [(0, 1), (0.5, 0), (1, 1)],
          radius: widget.triangleCornerRadius,
          useInCircle: false,
        ),
      ),
      child: Material(
        color: popUpColor,
        child: SizedBox.fromSize(size: triangleSize),
      ),
    );

    // debugPrint('offset: $offset, stackSize: $stackSize');

    return LazyBuilder(
      builder: (_, box, popup) {
        final size = Size(math.max(box.size.width, triangleSize.width),
            box.size.height + triangleSize.height);
        const triangleHeightCorrection = 1;

        //Defining Offsets
        var popUpOffset = Offset(offset.dx - (size.width / 2), offset.dy);
        var quarterTurns = 0;
        var triangleOffset =
            Offset((box.size.width - triangleSize.width) / 2, 0);
        var popUpContentOffset =
            Offset(0, triangleSize.height - triangleHeightCorrection);

        // log('box: ${box.size}', name: '$this');
        // log('size: $size, stack size: $stackSize', name: '$this');
        // log('offset: $offset, popUp: $popUpOffset', name: '$this');
        // log('triangle: $triangleOffset, child: $popUpContentOffset',
        //     name: '$this');

        // Updating Offsets according to situations

        //Bottom Overflow
        if (size.height + offset.dy > stackSize.height) {
          popUpOffset = popUpOffset.translate(0, -(size.height + childHeight));
          quarterTurns = 2;
          triangleOffset = triangleOffset.translate(0, box.size.height);
          popUpContentOffset = popUpContentOffset.translate(
              0, -triangleSize.height + (2 * triangleHeightCorrection));
        }

        //Right Overflow
        final rightCoord = popUpOffset.dx + size.width;
        if (rightCoord > stackSize.width) {
          final shiftWidth = rightCoord - stackSize.width;
          popUpOffset = popUpOffset.translate(-shiftWidth, 0);
          triangleOffset = Offset(
              math.min(size.width * 0.8, triangleOffset.dx + shiftWidth),
              triangleOffset.dy);
        }

        //Left Overflow
        if (popUpOffset.dx < 0) {
          final shiftWidth = -popUpOffset.dx;
          popUpOffset = popUpOffset.translate(shiftWidth, 0);
          triangleOffset = Offset(
              math.max(size.width * 0.2, triangleOffset.dx - shiftWidth),
              triangleOffset.dy);
        }

        //Final widget to Show
        return Popup(
          offset: popUpOffset,
          childSize: size,
          child: Stack(
            children: [
              Positioned(
                top: triangleOffset.dy,
                left: triangleOffset.dx,
                child: RotatedBox(
                  quarterTurns: quarterTurns,
                  child: triangle,
                ),
              ),
              Positioned(
                top: popUpContentOffset.dy,
                left: popUpContentOffset.dx,
                child: popupContent,
              ),
              SizedBox.fromSize(size: size),
            ],
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: popupContent,
      ),
    );
  }

  void addPopup() {
    if (this.controller != null) return;
    final popup = generatePopup(context);
    if (popup == null) return;
    final controller = PopupController.of(context).show(
      builder: (context) => popup,
      showBarrier: true,
      barrierColor: Colors.transparent,
      onDismiss: () {
        isSelected = false;
        this.controller = null;
      },
    );
    this.controller = controller;
  }

  @override
  void dispose() {
    controller?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var body = widget.popUpParentKey == null
        ? Container(
            key: popUpParentKey,
            child: widget.child,
          )
        : widget.child;

    if (widget.onHover) {
      body = MouseRegion(
        onEnter: (event) {
          // debugPrint('Entered MouseRegion');
          if (widget.onHover) addPopup();
        },
        onExit: (event) async {
          // debugPrint('Exited MouseRegion');

          //Do not remove the pop up if, the pop up is selected from [onTap].
          if (isSelected) return;

          await controller?.remove();
        },
        child: body,
      );
    }

    if (widget.onTap) {
      body = InkWell(
        borderRadius: widget.childBorderRadius,
        onTap: () {
          if (widget.onTap && !widget.onHover) addPopup();
          isSelected = true;
        },
        child: body,
      );
    }

    return body;
  }
}
