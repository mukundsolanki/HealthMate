import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:heathmate/widgets/CommonScaffold.dart';
import 'package:http/http.dart' as http;

class WaterGlass extends StatefulWidget {
  @override
  _WaterGlassState createState() => _WaterGlassState();
}

class _WaterGlassState extends State<WaterGlass> {
  double _waterAmount = 0.0; // Water amount in glasses
  final double _maxCapacity = 8.0; // Max capacity of the glass in glasses
  final TextEditingController _controller = TextEditingController();
  String _selectedInterval = "1 hour"; // Default reminder interval
 
  @override
  void initState(){
    super.initState();
    getwaterconsumed(); 
    
  }

  void _updateWaterAmount() {
    savewaterconsumedtoday(_waterAmount);
    setState(() {
      _waterAmount = double.tryParse(_controller.text) ?? 0.0;
      if (_waterAmount > _maxCapacity) {
        _waterAmount = _maxCapacity;
      } else if (_waterAmount < 0) {
        _waterAmount = 0;
      }
    });
  }

  Future<void> savewaterconsumedtoday(double waterAmount) async {
    try {
      final uri = Uri.parse("http:localhost://3000/postroutes/saveuserwaterintake");
      final response = await http.post(
        uri,
        body: waterAmount,
       // body: jsonEncode({waterAmount: waterAmount}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Water amount saved successfully");
        }
      } else {
        if (kDebugMode) {
          print("Error in saving data");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }
  Future<void> getwaterconsumed() async{
    try{
      final uri=Uri.parse("http://localhost:3000/getroutes/getwaterintake");
      final response=await http.get(uri);
        if (response.statusCode == 200) {
          final water=jsonDecode(response as String);
          double wateramount=water;
          
        if (response.statusCode==200) {
          _waterAmount=wateramount;
           _updateWaterAmount();
          print("Water amount received successfully");
        }
      } else {
        if (kDebugMode) {
          print("Error in fetching data");
        }
      }
    }
    catch(e){
             print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    double fillHeight = (_waterAmount / _maxCapacity) * 250;

    return Commonscaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Manage your water intake",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 10),
                const Text(
                  "Set Reminder Interval:",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 13),
                DropdownButton<String>(
                  value: _selectedInterval,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedInterval = newValue!;
                    });
                  },
                  items: <String>['1 hour', '2 hours', '3 hours', '4 hours']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Set reminder logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Set"),
                ),
              ],
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150, // Increased width of the glass
                  height: 250,
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.blueAccent, width: 4),
                      right: BorderSide(color: Colors.blueAccent, width: 4),
                      bottom: BorderSide(color: Colors.blueAccent, width: 4),
                    ),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                    color: Colors.transparent,
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        width: 150, // Increased width of the glass
                        height: fillHeight,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(15)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 3),
                CustomPaint(
                  size: const Size(20, 250),
                  painter: ScalePainter(_maxCapacity),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter water amount (glasses)",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateWaterAmount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text("Add Water Amount"),
            ),
            const SizedBox(height: 20),
            Text(
              "Water left to drink: ${(_maxCapacity - _waterAmount).clamp(0, _maxCapacity)} glasses",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class ScalePainter extends CustomPainter {
  final double maxCapacity;

  ScalePainter(this.maxCapacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey // Changed color to grey
      ..strokeWidth = 1.0;

    for (int i = 1; i <= maxCapacity; i++) {
      double y = size.height - (i / maxCapacity) * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width / 2, y), paint);
      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.grey),
          text: '$i'); // Changed text color to grey
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(size.width / 2 + 5, y - 6));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

void main() => runApp(MaterialApp(
      home: WaterGlass(),
    ));
