import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Stepschart extends StatefulWidget {
    final List<Map<String, dynamic>> stepsData;

  Stepschart({required this.stepsData});

  @override
  State<Stepschart> createState() => _StepschartState();
}

class _StepschartState extends State<Stepschart> {
  late List<StepsData> chartData;

  @override
  void initState() {
    super.initState();
    chartData = widget.stepsData.map((data) {
      return StepsData(data['day'], data['step'].toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SfCartesianChart(
          title: ChartTitle(text: "Total Steps"),
          primaryXAxis: CategoryAxis(),
          series: [
            ColumnSeries<StepsData, String>(
              dataSource: chartData,
              xValueMapper: (StepsData steps, _) => steps.day,
              yValueMapper: (StepsData steps, _) => steps.step,
              color: Colors.deepPurple, // Semi-transparent color
              borderColor: Colors.deepPurple, // Line color
              borderWidth: 2, // Line width
            )
          ],
        ),
      ),
    );
  }
}

class StepsData {
  final String day;
  final double step;

  StepsData(this.day, this.step);
}