import 'package:flutter/widgets.dart';

class CarModel {
  double left;
  late final String color;
  final double top = 580;
  final double height = 150;
  final double width = 70;
  double? rotation;
  CarModel(this.left, this.color,{this.rotation});

  Rect get bounds {
    return Rect.fromLTWH(left, top, width, height);
  }
}
