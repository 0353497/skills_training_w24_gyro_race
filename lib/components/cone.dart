import 'package:flutter/material.dart';
import 'package:gyro_race/models/cone_model.dart';

class Cone extends StatefulWidget {
  const Cone({super.key, required this.coneModel,});
  final ConeModel coneModel;
  @override
  State<Cone> createState() => _ConeState();
}

class _ConeState extends State<Cone> {
  @override
  Widget build(BuildContext context) {
    return 
    widget.coneModel.showCone ?
    Positioned(
      top: widget.coneModel.top,
      left: widget.coneModel.left,
      child: SizedBox(
        height: widget.coneModel.height,
        width: widget.coneModel.width,
        child: Image.asset(
          "assets/obstacles/cone.png",
        ),
      ),
    ) : SizedBox();
  }
}