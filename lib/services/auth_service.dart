// @dart=2.17
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://192.168.242.67:4000/auth';

  Future<bool> signup(String username, String email, String password, String age, String weight, String gender) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'email': email, 'password': password, 'age': age, 'weight':weight,'gender':gender}),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to sign up. Status code: ${response.statusCode}, Response: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error during signup: $error');
      return false;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data['token']);
        return data['token'];
      } else {
        print('Failed to login. Status code: ${response.statusCode}, Response: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error during login: $error');
      return null;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
