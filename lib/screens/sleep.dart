import 'package:flutter/material.dart';
import 'package:heathmate/services/auth_service.dart';
import 'package:heathmate/widgets/CommonScaffold.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  final TextEditingController _sleepController = TextEditingController();
  List<SleepData> sleepData = [];
  String message = '';
 

  @override
  void initState() {
    super.initState();
    _fetchSleepData();
  }
Future<void> _fetchSleepData() async {
    final token = await AuthService().getToken();

    if (token == null) {
        print('User is not authenticated');
        return;
    }

    try {
        final response = await http.get(
            Uri.parse('http://10.0.2.2:3000/getroutes/getsleepdata'),
            headers: {
                'Authorization': 'Bearer $token',
            },
        );

        if (response.statusCode == 200) {
            final Map<String, dynamic> responseBody = jsonDecode(response.body);
            final Map<String, dynamic> data = responseBody['data'];

            List<SleepData> tempsleepdata = data.entries.map((entry) {
                return SleepData(entry.key, entry.value.toDouble());
            }).toList();

            setState(() {
                sleepData = tempsleepdata;
            });
        } else {
            print('Failed to load data: ${response.statusCode} ${response.body}');
        }
    } catch (e) {
        print('Error: $e');
    }
}

 Future<void> _updateSleepData() async {
    final token = await AuthService().getToken();

    if (token == null) {
        print('User is not authenticated');
        return;
    }

    double hours = double.tryParse(_sleepController.text) ?? 0;
    String currentDay = DateFormat('EEEE').format(DateTime.now());

    try {
        final response = await http.post(
            Uri.parse('http://10.0.2.2:3000/postroutes/savesleepdata'),
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
            },
            body: json.encode({ 'hours': hours }),
        );

        if (response.statusCode == 200) {
            setState(() {
                sleepData.add(SleepData(currentDay, hours));
                if (sleepData.length > 7) {
                    sleepData.removeAt(0); // Keep only the last 7 days of data
                }
                message = hours < 7 ? 'You should sleep more!' : 'Good job!';
            });
        } else {
            print('Failed to save data: ${response.statusCode}');
        }
    } catch (e) {
        print('Error: $e');
    }
}

  double _calculateAverageSleep() {
    if (sleepData.isEmpty) return 0;
    double totalHours = sleepData.fold(0, (sum, item) => sum + item.value);
    return totalHours / sleepData.length;
  }

  double _calculatePercentage() {
    double averageHours = _calculateAverageSleep();
    return (averageHours / 8) * 100; // Assuming 8 hours is 100%
  }

  @override
  Widget build(BuildContext context) {
    double percentage = _calculatePercentage();

    return Commonscaffold(body:   
         SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircularPercentIndicator(
                          radius: 85.0,
                          lineWidth: 16.0,
                          animation: true,
                          percent: percentage / 100,
                          center: Text(
                            '${percentage.toStringAsFixed(0)}%',
                            style: TextStyle(fontSize: 20),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: percentage < 100 ? Colors.deepPurple : Colors.green,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Average sleep this week"
                        
                        ),
                      ],
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
                      height: 250,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: SfCartesianChart(
                          title: ChartTitle(text: "Sleep Hours This Week"),
                          primaryXAxis: CategoryAxis(),
                          primaryYAxis: NumericAxis(
                            isVisible: false, // Hide Y-axis scale
                          ),
                          series: [
                            SplineAreaSeries<SleepData, String>(
                              dataSource: sleepData,
                              xValueMapper: (SleepData data, _) => data.key,
                              yValueMapper: (SleepData data, _) => data.value,
                              color: Colors.deepPurple.withOpacity(0.5), // Semi-transparent color
                              borderColor: Colors.deepPurple, // Line color
                              borderWidth: 2, // Line width
                              dataLabelSettings: DataLabelSettings(isVisible: true), // Show values on hover
                            ),
                          ],
                          tooltipBehavior: TooltipBehavior(enable: true), // Enable tooltip on hover
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

class SleepData {
  final String key;
  final double value;

  SleepData(this.key, this.value);
}
