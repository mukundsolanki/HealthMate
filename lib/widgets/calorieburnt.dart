import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalorieBurntData {
  CalorieBurntData(this.day, this.calorieBurnt);
  final String day;
  final int calorieBurnt;
}


class Calorieburnt extends StatefulWidget {
  @override
  State<Calorieburnt> createState() => _CalorieburntState();
}

class _CalorieburntState extends State<Calorieburnt> {
  List<CalorieBurntData> calorieburnt = [];
  Future<void> FetchCalorieburnt() async {
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/getcalorieburnt?Uid=66b0de54585458f27d9b7e22'));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final List<dynamic> data = responseBody['data'];
      
      List<CalorieBurntData> tempCalorieBurnt = data.map((element) {
        return CalorieBurntData(element['day'], element['calorieburnt']);
      }).toList();
      
      setState(() {
        calorieburnt = tempCalorieBurnt;
      });
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
  }
}


 @override
void initState(){
  super.initState();
  FetchCalorieburnt();
}

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
            isVisible: false, // Make Y-axis scale invisible
          ),
          series: [
            SplineAreaSeries<CalorieBurntData, String>(
              dataSource: calorieburnt,
              xValueMapper: (CalorieBurntData data, _) => data.day,
              yValueMapper: (CalorieBurntData data, _) => data.calorieBurnt,
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
