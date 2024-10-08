import 'dart:convert';  // For encoding and decoding JSON data
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // For sending HTTP requests
import 'package:shared_preferences/shared_preferences.dart';  // For storing data locally

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers to get user input (email and password)
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Function to handle login request
  Future<void> _login() async {
    // API endpoint for login (replace with your backend URL)
    final url = Uri.parse('http://your-backend-api.com/api/auth/login');
    
    // Data to be sent to the server (from user input)
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},  // Specify data format
      body: jsonEncode({  // Convert data to JSON format
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    // If the login was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the response (extract the token)
      final data = jsonDecode(response.body);
      String token = data['token'];

      // Store the token locally using SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      // Navigate to the next screen (dashboard, issues list, etc.)
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // If login fails, show an error message
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid email or password.'),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Okay'))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,  // Hides the password for security
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,  // Call _login function on button press
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
