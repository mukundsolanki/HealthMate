import 'package:flutter/material.dart';
import 'dart:async';

class Workout extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<Workout> {
  TextEditingController _workoutController = TextEditingController();
  String _workoutTitle = "Workout";
  List<Map<String, dynamic>> workoutActivities = [];
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();

    setState(() {
      if (_seconds != 0) {
        workoutActivities.add({
          'title': _workoutTitle,
          'time': _seconds,
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workout Page")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _workoutController,
                    decoration: InputDecoration(
                      labelText: "Enter Workout Title",
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _workoutTitle = _workoutController.text;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                  ),
                  child: Text("Set"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              _workoutTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Timer: ${_formatTime(_seconds)}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
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
                  child: Text("Stop"),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
  height: 60,
  child: Card(
    color: Colors.white,
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Calorie Burnt",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "300",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  ),
),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: workoutActivities.map((activity) {
                  return Card(
                    color: Colors.deepPurple,
                    elevation: 5.0,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            activity['title'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            _formatTime(activity['time']),
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "200 cal",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}