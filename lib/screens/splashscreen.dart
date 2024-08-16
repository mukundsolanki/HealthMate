import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heathmate/screens/dashboard.dart';
import 'package:heathmate/screens/onBoardingScreen1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget{
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
   @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Delay for the splash screen
    await Future.delayed(Duration(seconds: 3));

    // Navigate based on login status
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }
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