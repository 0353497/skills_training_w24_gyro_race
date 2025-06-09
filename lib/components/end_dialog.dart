import 'package:flutter/material.dart';
import 'package:gyro_race/views/start_screen.dart';

class EndDialog extends StatelessWidget {
  const EndDialog({super.key, required this.onAgain, required this.title});
  final Widget title;
  final VoidCallback onAgain;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => StartScreen()));
            }, icon: Icon(Icons.close)),
          ),
          title,
          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(Colors.green)
              ),
              onPressed: () {
                Navigator.pop(context);
                onAgain();
              },
              child: Text("Again"),
              ),
          ),
        ],
      )
    );
  }
}