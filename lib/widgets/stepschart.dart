import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:heathmate/services/auth_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class Stepschart extends StatefulWidget {
  const Stepschart({super.key});

    

  @override
  State<Stepschart> createState() => _StepschartState();
}

class _StepschartState extends State<Stepschart> {
   List<StepsData> chartData=[];

  @override
  void initState() {
    super.initState();
   getSteps();
  }
   Future<void> getSteps() async { 
   final authService = AuthService();
  final token = await authService.getToken(); 
   if (token == null) {
      print('User is not authenticated');
      return;
    }
 
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/getroutes/getstepswalked'),
    headers: {
        
        'Authorization': 'Bearer $token',
      },);

     if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final Map<String, dynamic> data = responseBody['data'];

        List<StepsData> tempsteps= data.entries.map((entry) {
          return StepsData(entry.key, entry.value);
        }).toList();

        setState(() {
          chartData = tempsteps.isNotEmpty ? tempsteps : [];
        });
      } else {
        print('Failed to load data: ${response.statusCode} ${response.body}');
        setState(() {
          chartData = [];
        });
       
      }
    } catch (e) {
      print('Error: $e');
    }
 
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
              xValueMapper: (StepsData steps, _) => steps.key,
              yValueMapper: (StepsData steps, _) => steps.value,
              color: Colors.deepPurple, 
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
   final String key;
  final dynamic value;

  StepsData(this.key, this.value);
}