import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medcine/.env';
import 'dart:convert';

import 'package:medcine/Signin.dart';

class Update_password extends StatefulWidget {
  final String email;

  const Update_password({super.key, required this.email});
  @override
  State<Update_password> createState() => _Update_passwordState();
}

class _Update_passwordState extends State<Update_password> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordconfirmeController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;

  Future<void> save() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        if (_passwordconfirmeController.text == _passwordController.text) {
          var res = await http.put(
            Uri.parse("http://$ip:3002/reset"),
            headers: <String, String>{
              'Content-type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email': widget.email,
              'newpassword': _passwordController.text,
            }),
          );

          if (res.statusCode == 200) {
            print('Password update successful');
            print(res.body);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Signin()));
          } else {
            print('Failed to update password. Status code: ${res.statusCode}');
            print(res.body);
          }
        } else {
          print('Passwords do not match');
        }
      }
    } catch (error) {
      print('Error during password update: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Password ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                child: TextFormField(
                  controller: _passwordController,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Type something';
                    }
                    return null;
                  },
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Confirm Password',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                child: TextFormField(
                  controller: _passwordconfirmeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Type something';
                    }
                    return null;
                  },
                  obscureText: !_isPasswordVisible2,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible2
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible2 = !_isPasswordVisible2;
                        });
                      },
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {
                  save();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
