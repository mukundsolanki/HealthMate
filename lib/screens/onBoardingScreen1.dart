import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:heathmate/screens/dashboard.dart';
import 'package:heathmate/screens/login.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
 int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Track Your Diet',
      'description': 'Keep track of your daily food intake to maintain a balanced diet.',
      'image': 'assets/diet.png',
    },
    {
      'title': 'Monitor Your Steps',
      'description': 'Count your steps and stay active throughout the day.',
      'image': 'assets/steps.png',
    },
    {
      'title': 'Stay Hydrated',
      'description': 'Track your water intake to ensure proper hydration.',
      'image': 'assets/water.png',
    },
    {
      'title': 'Improve Your Sleep',
      'description': 'Monitor your sleep patterns and improve your sleep quality.',
      'image': 'assets/sleep.png',
    },
    // {
    //   'title': 'Heart Rate Monitoring',
    //   'description': 'Keep an eye on your heart rate and maintain your cardiovascular health.',
    //   'image': 'assets/heart_rate.png',
    // },
     {
      'title': 'Enhance Your Workout',
      'description': 'Track your workout performance and achieve your fitness goals.',
      'image': 'assets/workout.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: _pages.length,
            itemBuilder: (context, index, realIndex) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.3, 
                      child: Image.asset(
                        _pages[index]['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                         Colors.white24,
                          Colors.black,
                        ],
                        stops: [0.0, 1.0], 
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom:90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _pages[index]['title']!,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            _pages[index]['description']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              //fontWeight: FontWeight.bold,
                              // shadows: [
                              //   Shadow(
                              //     blurRadius: 10.0,
                              //     color: Colors.black.withOpacity(0.6),
                              //     offset: Offset(0, 2),
                              //   ),
                              // ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: List.generate(
                //     _pages.length,
                //     (index) => Container(
                //       margin: EdgeInsets.symmetric(horizontal: 4.0),
                //       width: _currentIndex == index ? 12.0 : 8.0,
                //       height: 8.0,
                //       decoration: BoxDecoration(
                //         color: _currentIndex == index ? Colors.purple : Colors.grey,
                //         borderRadius: BorderRadius.circular(4.0),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 20),
               if (_currentIndex == 0) // Show button only on the last page
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the main screen or the login screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        'Get Started',
                        style: TextStyle(color: Colors.purple),
                      ),
                      style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                        foregroundColor: Colors.purple,
                        elevation: 5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HealthMate Home'),
      ),
      body: Center(
        child: Text('Welcome to HealthMate!'),
      ),
    );
  }
}