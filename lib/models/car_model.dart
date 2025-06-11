import 'package:flutter/widgets.dart';

class CarModel {
  final double left;
  late final String color;
  final double top = 500;
  final double height = 150;
  final double width = 70;
  CarModel(this.left, this.color);

  Rect get bounds {
    return Rect.fromLTWH(left, top, width, height);
  }
}
