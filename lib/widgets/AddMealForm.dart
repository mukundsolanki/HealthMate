import 'package:flutter/material.dart';

class Addmealform extends StatefulWidget{
  const Addmealform({super.key});

  @override
  State<Addmealform> createState() => _AddmealformState();
}

class _AddmealformState extends State<Addmealform> {
  static final List<Meals> meals=[];
  final TextEditingController _nameofmeal=TextEditingController();

  final TextEditingController _quantity=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Column(
        children: [
          const Text("Add Meal",textAlign: TextAlign.left,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
          
               TextFormField(
                controller: _nameofmeal,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
               TextFormField(
                controller: _quantity,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                ),
              ),
              const SizedBox(height: 20),
          ElevatedButton(onPressed: (){
            String mealName = _nameofmeal.text;
            double quantity = double.tryParse(_quantity.text) ?? 0.0;

         setState(() {
                meals.add(Meals(mealName, quantity));
              });
               _nameofmeal.clear();
              _quantity.clear();
             //  Card(
            //   child: Column(
            //     children: [
            //       Text('Meal Name: $mealName'),
            //       Text('Quantity: $quantity'),
            //     ],
            //   ),
            // );
            // Display the input in a card
           
          }, child: const Text("Add")),
        ],),
    );
  }
}

class Meals {
  final String mealconsumed;
  final double quantity;
  Meals(this.mealconsumed,this.quantity);
}