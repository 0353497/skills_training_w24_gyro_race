import 'package:flutter/material.dart';

class PauzeButton extends StatelessWidget {
  const PauzeButton({super.key, required this.onPressed, required this.icon});
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 20,
      child: IconButton.filled(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.black),
          backgroundColor: WidgetStatePropertyAll(Colors.white)
        ),
        icon: Icon(icon)
        )
      );
  }
}