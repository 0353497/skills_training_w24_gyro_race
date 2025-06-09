import 'package:flutter/material.dart';
import 'package:gyro_race/views/game.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final List<String> carColors = ["red", "blue", "pink", "yellow"];
  String selectedColor = "red"; // Default selected color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Pick your car",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  fontStyle: FontStyle.italic
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  for (String color in carColors)
                  GridCarTile(
                    color: color,
                    isSelected: selectedColor == color,
                    onSelected: (colorName) {
                      setState(() {
                        selectedColor = colorName;
                      });
                    },
                  ) 
                ],
              ),
              SizedBox(
                width: 300,
                height: 70,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (_) => Game(carColor: selectedColor)));
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green),
                    foregroundColor: WidgetStatePropertyAll(Colors.white)
                  ),
                  child: Text(
                  "start Race",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    fontStyle: FontStyle.italic
                  ),
                )),
              ),
            ],
          ),
        )
      )
    );
  }
}

class GridCarTile extends StatelessWidget {
  const GridCarTile({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onSelected,
  });

  final String color;
  final bool isSelected;
  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.transparent,
          width: 8,
          strokeAlign: BorderSide.strokeAlignOutside
        ),
      ),
      color: Colors.grey.shade300,
      child: InkWell(
        onTap: () => onSelected(color),
        child: SizedBox(
          height: 200,
          width: 200,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Transform.rotate(
              angle: 3.14159,
              child: Image.asset(
                "assets/cars/${color}_car.png",
                height: 180,
                width: 180,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ),
      ),
    );
  }
}