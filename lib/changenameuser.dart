import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medcine/.env';
import 'package:medcine/SnackBar.dart';

import 'locales/strings.dart';

class Changenameuser extends StatefulWidget {
  const Changenameuser({super.key});

  @override
  _ChangenameuserState createState() => _ChangenameuserState();
}

class _ChangenameuserState extends State<Changenameuser> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> updateFormater() async {
    final Uri uri = Uri.parse('http://$ip:3002/updateformaterbyemail');
    final Map<String, dynamic> requestData = {
      'name': _nameController
          .text, // Use .text to get the value of the TextEditingController
    };

    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Learner updated successfully');
        CustomSnackbar.showCustomSnackbar(
          context,
          'Learner Updated',
          'Learner updated successfully.',
          ContentType.success,
        );
        Navigator.pop(context); // Go back to the previous screen
      } else {
        // Handle other status codes (e.g., 404, 500)
        print('Failed to update Learner: ${response.statusCode}');
        CustomSnackbar.showCustomSnackbar(
          context,
          'Update Failed',
          'Failed to update Learner. Please try again.',
          ContentType.failure,
        );
      }
    } catch (e) {
      // Handle network errors
      print('Error updating Learner: $e');
      CustomSnackbar.showCustomSnackbar(
        context,
        'Error',
        'An error occurred while updating Learner.',
        ContentType.failure,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.translate(context, 'change-name'),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF832121),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF832121),
                  Colors.white,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.translate(context, 'new-name'),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to save the new name
                    updateFormater(); // Call the updateFormater method when the button is pressed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF832121),
                  ),
                  child: Text(
                    AppLocalizations.translate(context, 'save'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
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
