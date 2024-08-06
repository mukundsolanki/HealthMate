import 'package:flutter/material.dart';
import 'dart:async';
import 'package:heathmate/widgets/CommonScaffold.dart';
import 'package:heathmate/widgets/stepschart.dart';

class Steps extends StatefulWidget {
  @override
  _StepsState createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  TextEditingController _stepsController = TextEditingController();

  int _stepsGoal = 0;
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;

  void _startTimer({bool reset = true}) {
    _timer?.cancel(); // Cancel any existing timer
    if (reset) {
      _seconds = 0; // Reset the timer
    }
    _isRunning = true;
    _isPaused = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _seconds = 0;
    });
  }

  void _pauseTimer() {
    if (_isPaused) {
      _startTimer(reset: false);
    } else {
      _timer?.cancel();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Commonscaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Timer",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: _startTimer,
                      child: const Text(
                        "Start Running",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  _formatTime(_seconds),
                  style: const TextStyle(fontSize: 30),
                ),
                if (_isRunning) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _pauseTimer,
                        child: Text(_isPaused ? "Resume" : "Pause"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: _stopTimer,
                        child: const Text("Stop"),
                      ),
                    ],
                  ),
                ],
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 50,
                  child: Card(
                    color: Colors.white,
                    elevation: 5.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Calorie Burnt:"),
                        Text("3000"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Set goal"),
                              content: TextField(
                                controller: _stepsController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: "Number of steps"),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      try {
                                        setState(() {
                                          _stepsGoal = int.parse(_stepsController.text);
                                        });
                                      } catch (e) {
                                        print('Error parsing number: $e');
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Set"))
                              ],
                            );
                          });
                    },
                    child: const Text("Set goal")),
                Text("Goal: $_stepsGoal steps"),
                SizedBox(
                  height: 30,
                ),
                Stepschart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}