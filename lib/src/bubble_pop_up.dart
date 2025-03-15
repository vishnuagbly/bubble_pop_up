import 'package:advanced_polygons/advanced_polygons.dart';
import 'package:bubble_pop_up/src/engine.dart';
import 'package:bubble_pop_up/src/objects/arrow_direction.dart';
import 'package:bubble_pop_up/src/objects/config.dart';
import 'package:bubble_pop_up/src/utils.dart';
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
  ///Provide [popUpBorderRadius] as the border radius for the child, as this will
  ///wrap the child around with an InkWell, therefore need to provide the
  ///border radius for the splash.
  ///
  ///Provide [baseBorderRadius] as the border radius for the base widget, i.e
  ///the widget around which the pop-up will be shown. This will be used to
  ///move around the pop-up arrow according to the base border radius, so that
  ///pop-up is in contact with base widget always, even in case base border
  ///radius present.
  ///
  ///Set [onHover] and [onTap] to set, if to show pop up on hover and tap
  ///respectively on the [child] widget.
  const BubblePopUp({
    super.key,
    required this.child,
    this.config = const BubblePopUpConfig(),
    this.popUp = const SizedBox(),
    this.popUpColor,
    this.onHover = true,
    this.onTap = true,
  });

  final Widget child;
  final Widget popUp;
  final Color? popUpColor;
  final bool onHover;
  final bool onTap;
  final BubblePopUpConfig config;

  @override
  State<BubblePopUp> createState() => BubblePopUpState();
}

class BubblePopUpState extends State<BubblePopUp> {
  late BubblePopUpConfig config;
  PopupController? controller;
  bool isSelected = false;

  @override
  void initState() {
    _updateConfig();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BubblePopUp oldWidget) {
    if (oldWidget.config != widget.config) {
      _updateConfig();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _updateConfig() {
    config = widget.config.copyWith(
      popUpParentKey:
          (widget.config.popUpParentKey == null) ? GlobalKey() : null,
    );
  }

  Widget? _generatePopup(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final controller = PopupController.of(context);

    final popUpColor = widget.popUpColor ?? scheme.background;
    final popupContent = widget.popUp;

    final triangleSize = config.arrowSize;

    Widget genArrow(ArrowDirection direction) => ClipPath(
          clipper: PolygonClipper(
            PolygonArgs(
              coords: Utils.getArrowCoords(direction),
              radius: config.arrowCornerRadius,
              useInCircle: false,
            ),
          ),
          child: Material(
            color: popUpColor,
            child: SizedBox.fromSize(size: triangleSize),
          ),
        );

    return LazyBuilder(
      builder: (_, content, __) {
        final engine = BubblePopUpEngine(
          config,
          controller,
          MediaQuery.of(context),
          content,
        );

        final params = engine.popUpParams;
        final triangle = genArrow(params.arrowDirection);

        //Final widget to Show
        return Popup(
          offset: params.offset,
          childSize: params.fullSize,
          child: Stack(
            children: [
              Positioned(
                top: params.arrowOffset.dy,
                left: params.arrowOffset.dx,
                child: triangle,
              ),
              Positioned(
                top: params.contentOffset.dy,
                left: params.contentOffset.dx,
                child: popupContent,
              ),
              SizedBox.fromSize(size: params.fullSize),
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

  bool _isInsideBounds(Offset offset) {
    final box = context.findRenderObject()! as RenderBox;
    final boxOffset = box.localToGlobal(Offset.zero);
    final size = box.size;
    return !((offset.dx < boxOffset.dx ||
            offset.dx > (boxOffset.dx + size.width)) ||
        (offset.dy < boxOffset.dy || offset.dy > (boxOffset.dy + size.height)));
  }

  void addPopup() {
    if (this.controller != null) return;
    final popup = _generatePopup(context);
    if (popup == null) return;
    final controller = PopupController.of(context).show(
      builder: (context) => popup,
      showBarrier: true,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      onHoverInBarrier: (event) async {
        if (isSelected) return;
        final position = event.position;
        if (!_isInsideBounds(position)) {
          await this.controller?.remove();
        }
      },
      dismissCondition: (details) {
        bool isInBounds = _isInsideBounds(details.globalPosition);
        if (isInBounds && !isSelected) {
          isSelected = true;
          return false;
        } else {
          return true;
        }
      },
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

  void addPopUpAndSelect() {
    addPopup();
    isSelected = true;
  }

  @override
  Widget build(BuildContext context) {
    var body = widget.config.popUpParentKey == null
        ? Container(
            key: config.popUpParentKey,
            child: widget.child,
          )
        : widget.child;

    if (widget.onTap) {
      body = InkWell(
        borderRadius: config.popUpBorderRadius,
        onTap: addPopUpAndSelect,
        child: body,
      );
    }

    if (widget.onHover) {
      body = MouseRegion(
        cursor: widget.onTap ? MouseCursor.uncontrolled : MouseCursor.defer,
        onEnter: (event) {
          if (widget.onHover) addPopup();
        },
        child: body,
      );
    }

    return body;
  }
}
