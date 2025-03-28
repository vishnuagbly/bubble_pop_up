import 'package:bubble_pop_up/bubble_pop_up.dart';
import 'package:example/extensions/alignment.dart';
import 'package:example/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'extensions/arrow_direction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  (int, int) baseCoords = (200, 200);
  Alignment baseAnchor = Alignment.bottomLeft;
  Alignment popUpAnchor = Alignment.topRight;
  ArrowDirection arrowDirection = ArrowDirection.up;
  final focusNode = FocusNode();

  void updateBaseCoords(int x, int y) {
    setState(() => baseCoords = (x, y));
  }

  Widget get menu {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Base', style: textTheme.headlineMedium),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _CoordInputField(
                initialValue: '${baseCoords.$1}',
                label: 'X',
                onFieldSubmitted: (value) {
                  updateBaseCoords(value, baseCoords.$2);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _CoordInputField(
                initialValue: '${baseCoords.$2}',
                label: 'Y',
                onFieldSubmitted: (value) {
                  updateBaseCoords(baseCoords.$1, value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _AlignmentSelector(
          initialValue: baseAnchor,
          onSubmitted: (value) => setState(() => baseAnchor = value),
        ),
        const Divider(),
        Text('Pop-Up', style: textTheme.headlineMedium),
        const SizedBox(height: 10),
        _AlignmentSelector(
          initialValue: popUpAnchor,
          onSubmitted: (value) => setState(() => popUpAnchor = value),
        ),
        const SizedBox(height: 10),
        _ArrowDirectionSelector(
          initialValue: arrowDirection,
          onSubmitted: (value) => setState(() => arrowDirection = value),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final largeScreenMode = screenWidth >= 600;

    const popUpBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.elliptical(30, 20),
    );

    final popUpKey = GlobalKey<BubblePopUpState>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (FocusScope.of(context).focusedChild == null) {
          FocusScope.of(context).requestFocus(focusNode);
        }
        popUpKey.currentState?.addPopUpAndSelect();
      },
    );

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: KeyboardListener(
            focusNode: focusNode,
            onKeyEvent: (event) {
              if (event is KeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                  updateBaseCoords(baseCoords.$1, baseCoords.$2 + 5);
                } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                  updateBaseCoords(baseCoords.$1, baseCoords.$2 - 5);
                } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                  updateBaseCoords(baseCoords.$1 - 5, baseCoords.$2);
                } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                  updateBaseCoords(baseCoords.$1 + 5, baseCoords.$2);
                }
              }
            },
            child: Builder(
              builder: (_) {
                final board = PopupScope(
                  builder: (_) => Stack(
                    children: [
                      Positioned(
                        top: baseCoords.$2.toDouble(),
                        left: baseCoords.$1.toDouble(),
                        child: BubblePopUp(
                          key: popUpKey,
                          config: BubblePopUpConfig(
                            baseAnchor: baseAnchor,
                            popUpAnchor: popUpAnchor,
                            arrowDirection: arrowDirection,
                            popUpBorderRadius: popUpBorderRadius,
                            baseBorderRadius: BorderRadius.circular(10),
                          ),
                          popUpColor: Colors.green,
                          popUp: Container(
                            width: 200,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: popUpBorderRadius,
                            ),
                          ),
                          child: Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (!largeScreenMode) return board;
                final colorScheme = Theme.of(context).colorScheme;

                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: Globals.borderRadius,
                          border: Border.all(color: colorScheme.onSurface),
                        ),
                        child: board,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: Globals.borderRadius,
                          border: Border.all(color: colorScheme.onSurface),
                        ),
                        child: menu,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        floatingActionButton: !largeScreenMode
            ? FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: Globals.borderRadius,
                        ),
                        content: menu,
                      );
                    },
                  );
                },
                child: const Icon(Icons.menu),
              )
            : null,
      ),
    );
  }
}

class _CoordInputField extends StatelessWidget {
  const _CoordInputField({
    required this.label,
    required this.onFieldSubmitted,
    required this.initialValue,
  });

  final String initialValue;
  final String label;
  final void Function(int) onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      key: ValueKey(initialValue),
      children: [
        Text('$label: ', style: textTheme.headlineSmall),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            initialValue: initialValue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onFieldSubmitted: (text) => onFieldSubmitted(int.parse(text)),
          ),
        ),
      ],
    );
  }
}

class _AlignmentSelector extends StatelessWidget {
  const _AlignmentSelector({
    required this.initialValue,
    required this.onSubmitted,
  });

  final Alignment initialValue;
  final void Function(Alignment) onSubmitted;

  @override
  Widget build(BuildContext context) => _EnumSelector<Alignment>(
        initialValue: initialValue,
        onSubmitted: onSubmitted,
        enumLabels: AlignmentExt.alignmentLabels,
        toLabel: (alignment) => alignment.shortString,
        label: 'Alignment',
      );
}

class _ArrowDirectionSelector extends StatelessWidget {
  const _ArrowDirectionSelector({
    required this.initialValue,
    required this.onSubmitted,
  });

  final ArrowDirection initialValue;
  final void Function(ArrowDirection) onSubmitted;

  @override
  Widget build(BuildContext context) => _EnumSelector<ArrowDirection>(
        initialValue: initialValue,
        onSubmitted: onSubmitted,
        enumLabels: ArrowDirectionExt.directionLabels,
        toLabel: (direction) => direction.shortString,
        label: 'Arrow Direction',
      );
}

class _EnumSelector<T> extends StatelessWidget {
  _EnumSelector({
    super.key,
    required this.initialValue,
    required this.onSubmitted,
    required this.enumLabels,
    required this.toLabel,
    required this.label,
  }) : controller = TextEditingController(text: toLabel(initialValue));

  final T initialValue;
  final void Function(T) onSubmitted;
  final TextEditingController controller;
  final Map<T, String> enumLabels;
  final String Function(T) toLabel;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final popUpKey = GlobalKey();
    return Row(
      children: [
        Text('$label: ', style: textTheme.headlineSmall),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller,
            key: popUpKey,
            readOnly: true,
            onTap: () {
              PopupController.of(context).show(
                barrierDismissible: true,
                showBarrier: true,
                builder: (context) {
                  return Popup(
                    offset: const Offset(0, 5),
                    parentAlign: Alignment.bottomCenter,
                    childAlign: Alignment.topCenter,
                    parentKey: popUpKey,
                    child: IntrinsicWidth(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: Globals.borderRadius,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final entry in enumLabels.entries)
                              TextButton(
                                child: Text(entry.value),
                                onPressed: () {
                                  onSubmitted(entry.key);
                                  controller.text = entry.value;
                                  PopupController.of(context).remove();
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
