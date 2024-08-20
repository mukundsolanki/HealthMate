// @dart=2.17
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heathmate/screens/steps.dart';
import 'package:heathmate/services/auth_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class StepsChart extends StatelessWidget {
  final List<StepsData> chartData;
 const StepsChart({super.key, required this.chartData});

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
              xValueMapper: (StepsData steps, _) => steps.key,
              yValueMapper: (StepsData steps, _) => steps.value,
              color: Colors.deepPurple,
              borderColor: Colors.deepPurple,
              borderWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}

 


class StepsData {
  final String key;
  final dynamic value;

  StepsData(this.key, this.value);
}
