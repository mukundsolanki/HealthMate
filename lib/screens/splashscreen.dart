import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heathmate/screens/onBoardingScreen1.dart';

class Splashscreen extends StatefulWidget{
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  void initState() { 
    super.initState(); 
    Timer(Duration(seconds: 3), 
          ()=>Navigator.pushReplacement(context, 
                                        MaterialPageRoute(builder: 
                                                          (context) =>  
                                                          OnboardingScreen(), 
                                                         ) 
                                       ) 
         ); 
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Container(
          
          child: Text("HealthMate",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.purple),),
        ),
      ),
    );
  }
}