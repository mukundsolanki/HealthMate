import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Stepschart extends StatefulWidget {
  @override
  State<Stepschart> createState() => _StepschartState();
}

class _StepschartState extends State<Stepschart> {
  final List<StepsData> chartData = [
    StepsData('Mon', 3000),
    StepsData('Tue', 5000),
    StepsData('Wed', 7000),
    StepsData('Thur',4000),
    StepsData('Fri', 8000,),
    StepsData('Sat', 6000),
    StepsData('Sun', 9000),
  ];


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
