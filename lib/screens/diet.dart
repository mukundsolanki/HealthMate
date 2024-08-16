import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:heathmate/widgets/dietchart.dart';
import 'package:heathmate/widgets/CommonScaffold.dart';

class Diet extends StatefulWidget {
  const Diet({super.key});

  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
  final List<Meals> meals = [];
  final TextEditingController _quantity = TextEditingController();
  Map<String, dynamic> foodData = {};
  List<String> foodNames = [];
  String? selectedFoodName;
  double maxCalorieLimit = 3000;

  @override
  void initState() {
    super.initState();
    loadFoodData().then((data) {
      setState(() {
        foodData = data;
        foodNames = getFoodNames(data);
      });
    });
    getMealCardDetails();
  }

  Future<Map<String, dynamic>> loadFoodData() async {
    final jsonString = await rootBundle.loadString('assets/food_data.json');
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    return jsonData;
  }

  List<String> getFoodNames(Map<String, dynamic> data) {
    List<String> names = [];
    for (var item in data['foods']) {
      names.add(item['name']);
    }
    return names;
  }

  Future<Map<String, dynamic>> fetchNutritionData(String mealName) async {
    for (var item in foodData['foods']) {
      if (item['name'].toLowerCase() == mealName.toLowerCase()) {
        return {
          'calories': item['energy_kcal'] as double,
        };
      }
    }
    return {};
  }

  Future<void> postMeal(String mealName, double quantity) async {
    try {
      final nutritionData = await fetchNutritionData(mealName);

      if (nutritionData.isNotEmpty) {
        final caloriesPer100g = nutritionData['calories'] as double;
        final calorieconsumed = (caloriesPer100g * quantity) / 100;

        final uri = Uri.parse("http://10.0.2.2:3000/postroutes/savemeal");
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'mealName': mealName,
            'quantity': quantity,
            'calorieconsumed': calorieconsumed,
            'totalcaloriesconsumed': getTotalCaloriesConsumed() + calorieconsumed, 
          }),
        );

        if (response.statusCode == 200) {
          print("Meal added successfully");
          print('Response: ${response.body}');
          
          setState(() {
            meals.add(Meals(mealName, quantity, calorieconsumed));
          });
        } else {
          print('Failed to send meal data. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
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
            // Total calorie consumed for each meal is no longer needed in this context
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

  double getTotalCaloriesConsumed() {
    return meals.fold(0, (sum, meal) => sum + meal.calorieburnt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Tracker'),
      ),
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
                  SizedBox(height: 10),
                ],
              ),
            ),
            Dietchart(
              caloriesConsumed: getTotalCaloriesConsumed(), 
              maxCalories: maxCalorieLimit
            ),
            SizedBox(height: 40),
            Text(
              "Your Today's meal:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
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
                              '${meal.quantity}g',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${meal.calorieburnt} cal',
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add Meal'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<String>(
                            value: selectedFoodName,
                            hint: Text('Select food'),
                            items: foodNames.map((foodName) {
                              return DropdownMenuItem<String>(
                                value: foodName,
                                child: Text(foodName),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedFoodName = value;
                              });
                            },
                          ),
                          TextField(
                            controller: _quantity,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Quantity (g)'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (selectedFoodName != null && _quantity.text.isNotEmpty) {
                              final quantity = double.tryParse(_quantity.text) ?? 0;
                              postMeal(selectedFoodName!, quantity);
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Add Meal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Meal'),
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
  final double calorieburnt;

  Meals(this.mealconsumed, this.quantity, this.calorieburnt);
}
