import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heathmate/widgets/dietchart.dart';
import 'package:http/http.dart' as http;
import 'package:heathmate/widgets/CommonScaffold.dart';

class Diet extends StatefulWidget {
  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
  final List<Meals> meals = [];
  final TextEditingController _nameofmeal = TextEditingController();
  final TextEditingController _quantity = TextEditingController();

  @override
  void initState() {
    super.initState();
    getMealCardDetails(); // Fetch meal details when the widget is initialized
  }

  Future<void> postMeal(String mealName, double quantity) async {
    try {
      final uri = Uri.parse("http://10.0.2.2:3000/postroutes/savemeal");
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mealName': mealName,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        print("Meal added successfully");
        print('Response: ${response.body}');
        // Optionally fetch updated meal data after adding a new meal
        getMealCardDetails();
      } else {
        print('Failed to send meal data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getMealCardDetails() async {
    try {
      final uri = Uri.parse('http://10.0.2.2:3000/getroutes/getmealdata');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
       
        final List<dynamic> data = jsonDecode(response.body);
        
        final List<Meals> fetchedMeals = data.map((json) {
          return Meals(
            json['NameofFood'] as String,
            (json['quantity'] as num).toDouble(), 
            (json['calorieconsumed'] as num).toDouble(), 
          );
        }).toList();

        setState(() {
          meals.clear();
          meals.addAll(fetchedMeals);
        });
      } else {
        print('Failed to fetch meal data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Commonscaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            const Center(
              child: Column(
                children: [
                  Text(
                    "Daily Intake",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text("You have consumed 400 cal today"),
                ],
              ),
            ),
            Dietchart(), // Assume this is a custom widget
            SizedBox(height: 20), // Add space between the chart and the list
            Text(
              "Your Today's meal:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3.0), // Space between cards
                    child: Card(
                      color: Colors.deepPurple,
                      elevation: 5.0,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              meal.mealconsumed,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${meal.quantity}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${meal.calorieburnt}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Show dialog instead of bottom sheet
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Add Meal'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _nameofmeal,
                            decoration: InputDecoration(
                              labelText: 'Name',
                            ),
                          ),
                          TextFormField(
                            controller: _quantity,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                             _nameofmeal.clear();
                              _quantity.clear();
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            String mealName = _nameofmeal.text;
                            double quantity =
                                double.tryParse(_quantity.text) ?? 0.0;
                            postMeal(mealName, quantity);
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  });
              },
              child: Text("Add meal"),
            ),
          ],
        ),
      ),
    );
  }
}

class Meals {
  final String mealconsumed;
  final double quantity;
  double calorieburnt;

  Meals(this.mealconsumed, this.quantity, this.calorieburnt);
}
