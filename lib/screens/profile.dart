import 'package:flutter/material.dart';
import 'package:heathmate/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _gender = 'Male';

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
  
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
   final authService = AuthService();
  final token = await authService.getToken(); 
    if (token == null) {
      print('User is not authenticated');
      return;
    }

    // Prepare data to send
    final Map<String, dynamic> updatedData = {
      'username': _nameController.text,
      'weight': int.tryParse(_weightController.text),
      'age': int.tryParse(_ageController.text),
      'gender': _gender,
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/postroutes/updateProfile'), // Your API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
        setState(() {
          _isEditing = false;
        });
      } else {
        print('Failed to update profile: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isEditing ? _saveProfile : _toggleEditing,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _weightController,
              enabled: _isEditing,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _ageController,
              enabled: _isEditing,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _gender,
              items: ['Male', 'Female', 'Other']
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
              onChanged: _isEditing
                  ? (value) {
                      setState(() {
                        _gender = value!;
                      });
                    }
                  : null,
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isEditing ? _saveProfile : null, // Only allow saving if editing
                child: Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
