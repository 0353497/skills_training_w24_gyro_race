import 'package:flutter/material.dart';

class Scoretracker extends StatelessWidget {
  const Scoretracker({super.key, required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 10,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
           Positioned(
            top: 10,
            left: 25,
             child: Material(
              elevation: 8,
              color: Colors.transparent,
               child: ClipRRect(
                borderRadius: BorderRadiusGeometry.only(
                  bottomRight: Radius.elliptical(30, 100),
                  topRight: Radius.circular(8)
                  ),
                child: Container(
                  alignment: Alignment(0.5, 0),
                    width: 100,
                    height: 50,
                    color: Colors.white,
                    child: Text(
                      score.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                      ),
                    ),
                  ),
                ),
             ),
           ),
          Image.asset("assets/obstacles/star.png",
              height: 70,
              width: 70,
              ),
        ],
      ) 
      );
  }
}