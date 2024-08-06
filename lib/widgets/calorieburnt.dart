import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StepsData {
  StepsData(this.day, this.step);
  final String day;
  final int step;
}

class Calorieburnt extends StatelessWidget {
  final List<StepsData> chartData = [
    StepsData('Mon', 8000),
    StepsData('Tue',6000),
    StepsData('Wed', 4000),
    StepsData('Fri', 8000),
    StepsData('Sat', 6000),
    StepsData('Sun', 9000),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.maxFinite, 
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SfCartesianChart(
          title: ChartTitle(text: "Total Calorie Burnt"),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            isVisible: false, // Make Y-axis scale invisible
          ),
          series: [
            SplineAreaSeries<StepsData, String>(
              dataSource: chartData,
              xValueMapper: (StepsData steps, _) => steps.day,
              yValueMapper: (StepsData steps, _) => steps.step,
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