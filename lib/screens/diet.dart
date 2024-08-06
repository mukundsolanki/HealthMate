import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heathmate/widgets/AddMealForm.dart';
import 'package:heathmate/widgets/CommonScaffold.dart';
import 'package:heathmate/widgets/dietchart.dart';

class Diet extends StatefulWidget{
  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
 final List<Meals> meals=[];
  final TextEditingController _nameofmeal=TextEditingController();

  final TextEditingController _quantity=TextEditingController();


  @override
  Widget build(BuildContext context) {
  return Commonscaffold(
    
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 30,),
        const Center(child: Column(children: [
           Text("Daily Intake",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
           Text("You have consumed 400 cal today"),
        ],)),
        
          const Dietchart(),
          Text("Your Today's meal:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
          
          if (meals.isEmpty)Container(height: 50,)else 
         Card(
                color: Colors.deepPurple,
                elevation: 5.0,
                child: Column(
                  children:meals.map((meal) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(meal.mealconsumed,style: TextStyle(color: Colors.white),),
                          Text('${meal.quantity}',style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
         SizedBox(height: 20,),
          ElevatedButton(onPressed: (){
             
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
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
              
             
            }, child: const Text("Add")),
          ],),
      );
        }
              );
            }, child: Text("Add meal")),
          
        ],
      ),
    ),
  );
  }
}
class Meals {
  final String mealconsumed;
  final double quantity;
  Meals(this.mealconsumed,this.quantity);
}