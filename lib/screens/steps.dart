// @dart=2.17
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pedometer/pedometer.dart';
import 'package:heathmate/widgets/CommonScaffold.dart';
import 'package:heathmate/widgets/stepschart.dart';
import 'package:heathmate/services/auth_service.dart';

class Steps extends StatefulWidget {
  const Steps({super.key});

  @override
  _StepsState createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  int _stepsGoal = 0;
  int _steps = 0;
  StreamSubscription<StepCount>? _subscription;
  List<StepsData> chartData = [];

  @override
  void initState() {
    super.initState();
    _startListening();
    getSteps();
  }

  void _startListening() {
    _subscription = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      onDone: _onStepCountDone,
      cancelOnError: true,
    );
  }

  void _onStepCount(StepCount stepCount) {
    setState(() {
      _steps = stepCount.steps;
    });
    _updateStepsOnServer(stepCount.steps);
  }

  void _onStepCountError(error) {
    print('Step Count Error: $error');
    setState(() {
      _steps = 0;
    });
  }

  void _onStepCountDone() {
    print('Step Count Stream Closed');
  }

  Future<void> getSteps() async {
    final authService = AuthService();
    final token = await authService.getToken();
    if (token == null) {
      print('User is not authenticated');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.29.112:4000/getroutes/getstepswalked'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final Map<String, dynamic> data = responseBody['data'];

        List<StepsData> tempSteps = data.entries.map((entry) {
          return StepsData(entry.key, entry.value);
        }).toList();

        setState(() {
          chartData = tempSteps.isNotEmpty ? tempSteps : [];
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

  Future<void> _updateStepsOnServer(int steps) async {
    try {
      final authService = AuthService();
      final token = await authService.getToken();
      if (token == null) {
        print('User is not authenticated');
        return;
      }

      final response = await http.post(
        Uri.parse('http://192.168.29.112:4000/postroutes/saveuserstepswalked'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'steps': _steps}),
      );

      if (response.statusCode == 200) {
        print('Steps updated successfully');
      } else {
        print('Failed to update steps: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating steps: $e');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Commonscaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Card(
                  color: Colors.white,
                  elevation: 5.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("Steps walked"),
                      Text(
                        _steps.toString(),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Set goal"),
                            content: TextField(
                              
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Number of steps",
                              ),
                              onChanged: (value) {
                                _stepsGoal = int.tryParse(value) ?? 0;
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Set"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("Set goal"),
                  ),
                  const SizedBox(width: 120),
                  Text("Goal: $_stepsGoal steps"),
                ],
              ),
              const SizedBox(height: 50),
              StepsChart(chartData: chartData),
            ],
          ),
        ),
      ),
    );
  }
}



