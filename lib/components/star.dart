import 'package:flutter/material.dart';

class Star extends StatefulWidget {
  const Star({super.key, required this.x, required this.y});
  final double x;
  final double y;
  @override
  State<Star> createState() => _StarState();
}

class _StarState extends State<Star> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: widget.y,
      left: widget.x,
      child: SizedBox(
        height: 50,
        width: 50,
        child: Image.asset("assets/obstacles/star.png"),
      ),
    );
  }
}