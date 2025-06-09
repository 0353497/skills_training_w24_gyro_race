import 'package:flutter/material.dart';

class Car extends StatefulWidget {
  const Car({super.key, required this.x, required this.color});
  final double x;
  final String color;
  @override
  State<Car> createState() => _CarState();
}

class _CarState extends State<Car> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: widget.x,
      child: SizedBox(
        height: 280,
        width: 70,
        child: Image.asset("assets/cars/${widget.color}_car.png"),
      ),
    );
  }
}