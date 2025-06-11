import 'package:flutter/material.dart';
import 'package:gyro_race/models/star_model.dart';

class Star extends StatefulWidget {
  const Star({super.key, required this.starModel,});
  final StarModel starModel;
  @override
  State<Star> createState() => _StarState();
}

class _StarState extends State<Star> {
  @override
  Widget build(BuildContext context) {
    return 
    widget.starModel.showStar ?
    Positioned(
      top: widget.starModel.top,
      left: widget.starModel.left,
      child: SizedBox(
        height: widget.starModel.height,
        width: widget.starModel.width,
        child: Image.asset("assets/obstacles/star.png"),
      ),
    ) : SizedBox(); 
  }
}