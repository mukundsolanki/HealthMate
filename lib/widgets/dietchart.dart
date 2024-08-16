import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Dietchart extends StatelessWidget {
  final double caloriesConsumed;
  final double maxCalories;

  const Dietchart({
    Key? key,
    required this.caloriesConsumed,
    required this.maxCalories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentConsumed = caloriesConsumed / maxCalories;
    Color progressColor = percentConsumed > 1.0 ? Colors.red : Colors.purple.withOpacity(0.6); // Change color if exceeded

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 50,
                height: 40.0, // Increased height
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.0), // Rounded corners
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentConsumed.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(20.0), // Rounded corners
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "${(percentConsumed * 100).toStringAsFixed(1)}%",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Calories Consumed Today: ${caloriesConsumed.toStringAsFixed(1)} cal",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
