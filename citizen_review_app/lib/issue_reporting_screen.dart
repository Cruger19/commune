import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IssueReportingScreen extends StatefulWidget {
  const IssueReportingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IssueReportingScreenState createState() => _IssueReportingScreenState();
}

class _IssueReportingScreenState extends State<IssueReportingScreen> {
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  Future<void> _reportIssue() async {
    // Get the stored JWT token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      // If the token is not found, prompt the user to log in again
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('You need to log in first.'),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(ctx), child: const Text('Okay'))
          ],
        ),
      );
      return;
    }

    final url = Uri.parse('http://your-backend-api.com/api/issue');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Send the token for authentication
      },
      body: jsonEncode({
        'description': _descriptionController.text,
        'location': _locationController.text,
      }),
    );

    if (response.statusCode == 201) {
      // Successfully reported the issue
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Issue reported successfully!')),
      );
    } else {
      // Handle error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to report the issue')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report an Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Issue Description'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reportIssue,
              child: const Text('Report Issue'),
            ),
          ],
        ),
      ),
    );
  }
}
