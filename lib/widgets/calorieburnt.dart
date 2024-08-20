// @dart=2.17
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CalorieBurntScreen extends StatelessWidget {
  final List<CalorieBurntData> calorieburnt;

  // Constructor to accept calorie data
   CalorieBurntScreen({super.key, required this.calorieburnt});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SfCartesianChart(
          title: ChartTitle(text: "Total Calorie Burnt"),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            isVisible: false, // Hide Y-axis scale
          ),
          series: [
            SplineAreaSeries<CalorieBurntData, String>(
              dataSource: calorieburnt,
              xValueMapper: (CalorieBurntData data, _) => data.key,
              yValueMapper: (CalorieBurntData data, _) => data.value,
              color: Colors.deepPurple.withOpacity(0.5), // Semi-transparent color
              borderColor: Colors.deepPurple, // Line color
              borderWidth: 2, // Line width
              dataLabelSettings: DataLabelSettings(isVisible: true), // Show values on hover
            ),
          ],
          tooltipBehavior: TooltipBehavior(enable: true), // Enable tooltip on hover
        ),
      ),
    );
  }
}

class CalorieBurntData {
  final String key;
  final dynamic value;

  CalorieBurntData(this.key, this.value);
}
