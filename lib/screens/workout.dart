import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heathmate/services/auth_service.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:heathmate/widgets/CommonScaffold.dart';

class Workout extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<Workout> {
  final TextEditingController _workoutController = TextEditingController();
  String _workoutTitle = "Workout";
  List<Map<String, Object>> workoutActivities = [];
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  String? _selectedExercise;
  double _selectedExerciseMET = 0.0;
  double _weight = 50.0;
  double totalcalories = 0.0;

  final List<Map<String, Object>> exercises = [
    {"name": "Bench Press", "value": 6.0},
    {"name": "Incline Dumbbell Press", "value": 6.5},
    {"name": "Bar Dips", "value": 7.0},
    {"name": "Standing Cable Chest Fly", "value": 6.0},
    {"name": "Overhead Press", "value": 6.0},
    {"name": "Seated Dumbbell Shoulder Press", "value": 6.5},
    {"name": "Dumbbell Lateral Raise", "value": 5.5},
    {"name": "Reverse Dumbbell Fly", "value": 5.5},
    {"name": "Deadlift", "value": 6.5},
    {"name": "Lat Pulldown", "value": 5.5},
    {"name": "Pull-Up", "value": 7.0},
    {"name": "Barbell Row", "value": 6.0},
    {"name": "Dumbbell Row", "value": 6.0},
    {"name": "Barbell Curl", "value": 5.5},
    {"name": "Dumbbell Curl", "value": 5.5},
    {"name": "Hammer Curl", "value": 5.5},
    {"name": "Barbell Lying Triceps Extension", "value": 6.0},
    {"name": "Overhead Cable Triceps Extension", "value": 6.0},
    {"name": "Tricep Pushdown", "value": 6.0},
    {"name": "Close-Grip Bench Press", "value": 6.5},
    {"name": "Squat", "value": 6.0},
    {"name": "Hack Squats", "value": 6.0},
    {"name": "Leg Extension", "value": 5.5},
    {"name": "Bulgarian Split Squat", "value": 6.0},
    {"name": "Seated Leg Curl", "value": 5.5},
    {"name": "Lying Leg Curl", "value": 5.5},
    {"name": "Romanian Deadlift", "value": 6.0},
    {"name": "Hip Thrust", "value": 6.0},
    {"name": "Cable Crunch", "value": 5.5},
    {"name": "Hanging Leg Raise", "value": 6.0},
    {"name": "High to Low Wood Chop", "value": 6.0},
    {"name": "Crunch", "value": 5.5},
    {"name": "Standing Calf Raise", "value": 5.5},
    {"name": "Seated Calf Raise", "value": 5.5},
    {"name": "Jump Rope", "value": 12.0},
    {"name": "Running (6 mph)", "value": 9.8},
    {"name": "Jogging (5 mph)", "value": 7.0},
    {"name": "Walking (4 mph)", "value": 3.8},
    {"name": "Cycling (12-14 mph)", "value": 8.0},
    {"name": "Swimming (general)", "value": 7.0},
    {"name": "Rowing Machine (moderate)", "value": 7.0},
    {"name": "Hiking (moderate)", "value": 6.0},
    {"name": "Climbing (moderate)", "value": 9.0},
    {"name": "Elliptical Trainer (moderate)", "value": 5.5},
    {"name": "Jumping Jacks", "value": 8.0},
    {"name": "High-Intensity Interval Training (HIIT)", "value": 12.0},
    {"name": "Stair Climbing", "value": 8.0},
    {"name": "Dancing (social)", "value": 5.5},
    {"name": "Yoga", "value": 2.5},
    {"name": "Pilates", "value": 3.0},
  ];

  Future<void> addWorkoutDetails(List<Map<String, Object>> list) async {
    final authService = AuthService();
    final token = await authService.getToken();

    if (token == null) {
      print('User is not authenticated');
      return;
    }

    try {
      final uniqueActivities = <String, Map<String, Object>>{};
      for (var activity in list) {
        final key = '${activity['title']}-${activity['time']}';
        uniqueActivities[key] = activity;
      }

      // Convert the unique map values to a list for JSON encoding
      final jsondata = jsonEncode({
        'activities': uniqueActivities.values.toList(),
        'totalCalories': totalcalories.toStringAsFixed(0),
      });

      final uri = Uri.parse(
          "http://10.0.2.2:3000/postroutes/saveworkoutdetails");
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsondata,
      );

      if (response.statusCode == 200) {
        print("Workout Data saved successfully");
        print('Response: ${response.body}');
      } else {
        print(
            'Failed to send Workout data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchWorkoutDetails() async {
    final authService = AuthService();
  final token = await authService.getToken(); 

  if (token == null) {
    print('User is not authenticated');
    return;
  }
    try {
      final uri =
          Uri.parse('http://10.0.2.2:3000/getroutes/getworkoutdetails');
      final response = await http.get(uri,
       headers: {
        'Authorization': 'Bearer $token',
      },);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, Object>> fetchedActivities = data.map((json) {
          return {
            'title': json['NameofWorkout'] as String? ?? 'Unknown',
            'time': (json['timeofworkout'] as num?)?.toInt() ?? 0,
            'calorieburnt': (json['calorieburnt'] as num?)?.toDouble() ?? 0.0,
            'MET': (json['MET'] as num?)?.toDouble() ?? 0.0,
          };
        }).toList();

        setState(() {
          workoutActivities = fetchedActivities;
          totalcalories = workoutActivities.fold(
            0.0,
            (sum, activity) => sum + (activity['calorieburnt'] as double),
          );
        });
      } else if (response.statusCode == 404) {
        // Handle 404 status code
        setState(() {
          workoutActivities = [];
          totalcalories = 0.0;
        });
        print('No workout data found for today. List cleared.');
      } else {
        print(
            'Failed to fetch Workout data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      if (_seconds != 0) {
        final calorieburnt =
            calculateCaloriesBurnt(_seconds, _selectedExerciseMET);
        final newActivity = {
          'title': _workoutTitle,
          'time': _seconds,
          'MET': _selectedExerciseMET ?? 0,
          'calorieburnt': calorieburnt,
        };

        // Check if the workout title and time already exist in the list
        final existingIndex = workoutActivities.indexWhere(
          (activity) =>
              activity['title'] == _workoutTitle &&
              activity['time'] == _seconds,
        );

        if (existingIndex >= 0) {
          // Update existing entry
          workoutActivities[existingIndex] = newActivity;
        } else {
          // Add new entry
          workoutActivities.add(newActivity);
        }

        totalcalories += calorieburnt;

        // Send updated list to the server
        addWorkoutDetails(workoutActivities);
      }
      _isRunning = false;
      _seconds = 0;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double calculateCaloriesBurnt(int seconds, double selectedExerciseMET) {
    if (selectedExerciseMET <= 0 || _weight <= 0) {
      return 0.0;
    }

    final timeInHours = seconds / 3600;
    final caloriesBurnt = selectedExerciseMET * _weight * timeInHours;

    if (caloriesBurnt.isNaN || caloriesBurnt < 0) {
      return 0.0;
    }

    return caloriesBurnt;
  }

  @override
  void initState() {
    super.initState();
    fetchWorkoutDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Commonscaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _selectedExercise,
                  hint: const Text("Select Exercise"),
                  items: exercises.map((exercise) {
                    return DropdownMenuItem<String>(
                      value: exercise['name'] as String,
                      child: Text(exercise['name'] as String),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedExercise = value!;
                      _workoutTitle = _selectedExercise!;
                      _selectedExerciseMET = exercises.firstWhere(
                        (exercise) => exercise['name'] == _selectedExercise,
                        orElse: () => {"value": 0.0},
                      )['value'] as double;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _workoutTitle = _selectedExercise ?? 'Workout';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Set"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _workoutTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Timer: ${_formatTime(_seconds)}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_isRunning ? "Pause" : "Start"),
                ),
                ElevatedButton(
                  onPressed: _stopTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Stop"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: Card(
                color: Colors.white,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Calorie Burnt",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${totalcalories.toStringAsFixed(0)} cal",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: workoutActivities.length,
                itemBuilder: (context, index) {
                  final activity = workoutActivities[index];
                  return Card(
                    color: Colors.deepPurple,
                    elevation: 5.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            activity['title'] as String,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            _formatTime(activity['time'] as int),
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "${(activity['calorieburnt'] as double).toStringAsFixed(0)} cal",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
