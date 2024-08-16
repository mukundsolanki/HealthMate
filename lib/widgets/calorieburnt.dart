import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heathmate/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';



class CalorieBurntScreen extends StatefulWidget {
  @override
  _CalorieBurntScreenState createState() => _CalorieBurntScreenState();
}

class _CalorieBurntScreenState extends State<CalorieBurntScreen> {
  List<CalorieBurntData> calorieburnt = [];

  Future<void> getCalorieBurnt() async {
    final token = await AuthService().getToken(); // Retrieve the token

    if (token == null) {
      print('User is not authenticated');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/getroutes/getcalorieburnt'),
        headers: {
          
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final Map<String, dynamic> data = responseBody['data'];

        List<CalorieBurntData> tempCalorieBurnt = data.entries.map((entry) {
          return CalorieBurntData(entry.key, entry.value);
        }).toList();

        setState(() {
          calorieburnt = tempCalorieBurnt;
        });
      } else {
        print('Failed to load data: ${response.statusCode} ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getCalorieBurnt();
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