import 'package:bubble_pop_up/bubble_pop_up.dart';

extension ArrowDirectionExt on ArrowDirection {
  static final directionLabels = {
    ArrowDirection.up: 'Up',
    ArrowDirection.down: 'Down',
    ArrowDirection.left: 'Left',
    ArrowDirection.right: 'Right',
  };

  String get shortString => directionLabels[this] ?? '$x $y';
}
