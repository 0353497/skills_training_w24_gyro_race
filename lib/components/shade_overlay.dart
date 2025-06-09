import 'package:flutter/material.dart';

class ShadeOverlay extends StatelessWidget {
  const ShadeOverlay({super.key, this.text, this.pauzed = false});
  final String? text;
  final bool pauzed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black38
      ),
      child: text == null ? null : Center(
        child: Text(
          text!,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 80,
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.none
        ),
        ),
      ),
    );
  }
}