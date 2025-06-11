import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gyro_race/models/car_model.dart';

class Car extends StatefulWidget {
  const Car({super.key, required this.car});
  final CarModel car;
  @override
  State<Car> createState() => _CarState();
}

class _CarState extends State<Car> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.car.top,
      left: widget.car.left,
      child: SizedBox(
        height: widget.car.height,
        width: widget.car.width,
        child: Transform.rotate(
          angle: widget.car.rotation ?? (pi *2),
          child: Image.asset("assets/cars/${widget.car.color}_car.png",
            height: widget.car.height,
            width: widget.car.width,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}