import 'package:flutter/widgets.dart';

class ConeModel {
  double left;
  double top;
  final double height = 70;
  final double width = 70;
  bool showCone;
  ConeModel(this.left, this.top, {this.showCone = true});

  Rect get bounds {
    return Rect.fromLTWH(left, top, width, height);
  }
}
