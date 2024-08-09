import 'package:flutter/material.dart';
import 'package:heathmate/screens/diet.dart';
import 'package:heathmate/screens/sleep.dart';
import 'package:heathmate/screens/steps.dart';
import 'package:heathmate/screens/water.dart';
import 'package:heathmate/screens/workout.dart';
import 'package:heathmate/widgets/CommonScaffold.dart';
import 'package:heathmate/widgets/calorieburnt.dart';
import 'package:heathmate/widgets/stepschart.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Commonscaffold(
      body: Column(
          children: <Widget>[
            Calorieburnt(),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [SizedBox(
                        width:405,
                        child: _buildCard(title: "Exercise", 
                        description: "Do Yoga and excercise", icon: Icons.man_2, color: Colors.deepPurpleAccent,
                         onTap: (){
                        
                         }),
                      ),]
                    ),

                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _buildCard(
                            title: "Water",
                            description: "Amount of water",
                            icon: Icons.water_rounded,
                            color: Colors.deepPurple,
                            onTap: (){
                               Navigator.push(context,MaterialPageRoute(builder: (context)=>WaterGlass()));
                              
                             }
                          ),
                        ),
                        Expanded(
                          child: _buildCard(
                            title: "Steps",
                            description: "Steps :2133",
                            icon: Icons.legend_toggle_sharp,
                            color:Colors.purple.shade400,
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Steps()));
                            }
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _buildCard(
                            title: "Workout",
                            description: "Workout plan",
                            icon: Icons.man,
                            color: const Color.fromARGB(255, 149, 125, 245),
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>Workout()));
                                }
                          ),
                        ),
                        Expanded(
                          child: _buildCard(
                            title: "Diet",
                            description: "Today's Diet plan",
                            icon: Icons.food_bank,
                            color: Colors.deepPurple.shade300,
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Diet()));
                            }
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _buildCard(
                            title: "Sleep",
                            description: "Hours Slept",
                            icon: Icons.nightlight_round,
                            color: const Color.fromARGB(255, 234, 172, 141),
                            onTap: (){
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>SleepPage()));
                         
                                }
                          ),
                        ),
                        Expanded(
                          child: _buildCard(
                            title: "Heart Rate",
                            description: "Heart Rate",
                            icon: Icons.favorite_border,
                            color: const Color.fromARGB(255, 244, 105, 140),
                            onTap: (){
                                 }
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, size: 40.0, color: Colors.white),
              const SizedBox(height: 16.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
