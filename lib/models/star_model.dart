import 'package:flutter/widgets.dart';

class StarModel {
  double left;
  double top;
  final double height = 70;
  final double width = 70;
  StarModel(this.left, this.top, {this.showStar = true});
  bool showStar;

  Rect get bounds {
    return Rect.fromLTWH(left, top, width, height);
  }
}
