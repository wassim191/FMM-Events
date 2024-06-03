import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:medcine/.env'; // Check if this import is correct
import 'package:medcine/SnackBar.dart'; // Check if this import is correct
import 'package:medcine/locales/strings.dart'; // Check if this import is correct

class ChangePass extends StatelessWidget {
  final String email;
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  ChangePass({Key? key, required this.email}) : super(key: key);

  Future<void> changePassword(BuildContext context) async {
    final Uri uri = Uri.parse('http://$ip:3002/updateformaterpassbyemail');
    final Map<String, dynamic> requestData = {
      'email': email,
      'password': newPasswordController.text,
    };

    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        print('Password changed successfully');
        CustomSnackbar.showCustomSnackbar(
          context,
          'Password Changed',
          'Your password has been changed successfully.',
          ContentType.success,
        );
      } else {
        print('Failed to change password: ${response.statusCode}');
        CustomSnackbar.showCustomSnackbar(
          context,
          'Change Password Failed',
          'Failed to change password. Please try again.',
          ContentType.failure,
        );
      }
    } catch (e) {
      print('Error changing password: $e');
      CustomSnackbar.showCustomSnackbar(
        context,
        'Error',
        'An error occurred while changing password.',
        ContentType.failure,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.translate(context, 'change_password'),
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: newPasswordController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    labelText: 'New Password', // Change to your translation key
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
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: confirmPasswordController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    labelText:
                        'Confirm New Password', // Change to your translation key
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
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final newPassword = newPasswordController.text;
                    final confirmPassword = confirmPasswordController.text;
                    if (newPassword == confirmPassword) {
                      changePassword(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Passwords do not match.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF832121),
                  ),
                  child: Text(
                    'Change Password', // Change to your translation key
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
