import 'package:flutter/material.dart';
import 'package:heathmate/widgets/CommonScaffold.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  final TextEditingController _sleepController = TextEditingController();
  List<double> sleepData = [6, 7, 5, 8, 6, 7, 6]; // Example data
  String message = '';

  void _updateSleepData() {
    double hours = double.tryParse(_sleepController.text) ?? 0;
    setState(() {
      sleepData.add(hours);
      if (sleepData.length > 7) {
        sleepData.removeAt(0); // Keep only the last 7 days of data
      }
      message = hours < 7 ? 'You should sleep more!' : 'Good job!';
    });
  }

  double _calculatePercentage() {
    double totalHours = sleepData.reduce((a, b) => a + b);
    double averageHours = totalHours / sleepData.length;
    return (averageHours / 8) * 100; // Assuming 8 hours is 100%
  }

  @override
  Widget build(BuildContext context) {
    double percentage = _calculatePercentage();
    return Commonscaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: 100,
                      startAngle:0,
                      endAngle: 360,
                      interval: 10,
                      showLabels: false,
                      showTicks: false,
                      ranges: <GaugeRange>[
                        GaugeRange(startValue: 0, endValue: percentage, color: Colors.deepPurple),
                      ],
                     
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Container(
                            child: Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          angle: 90,
                          positionFactor: 0.1,
                        ),
                      ],
                      // axisLabelStyle: GaugeTextStyle(
                      //   fontSize: 12,
                      //   fontWeight: FontWeight.bold,
                      // ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _sleepController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter hours slept last night',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _updateSleepData,
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(
                  color: message == 'You should sleep more!' ? Colors.red : Colors.green,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: sleepData
                            .asMap()
                            .entries
                            .map((e) => FlSpot(e.key.toDouble(), e.value))
                            .toList(),
                        isCurved: true,
                        barWidth: 4,
                        color: Colors.blue,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}