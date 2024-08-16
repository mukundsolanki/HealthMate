import 'package:flutter/material.dart';
import 'package:heathmate/screens/login.dart';
import 'package:heathmate/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _genController = TextEditingController();
      final TextEditingController _weightController = TextEditingController();
        final TextEditingController _ageController = TextEditingController();
  final AuthService _authService = AuthService();

  void _signup() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final age=_ageController.text;
    final weight=_weightController.text;
    final gender=_genController.text;

    final success = await _authService.signup(username, email, password,age,weight,gender);
    if (success) {
      print('User saved successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      print('Failed to save user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
              TextField(
              controller: _genController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
              TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight'),
            ),
              TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
