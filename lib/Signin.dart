import 'package:flutter/material.dart';
import 'package:medcine/.env';
import 'package:medcine/Connect_splash.dart';
import 'package:medcine/Connect_splashuser.dart';
import 'package:medcine/Signup.dart';
import 'package:medcine/chooseone.dart';
import 'package:medcine/locales/strings.dart';
import 'package:medcine/resetpassword.dart';
import 'package:medcine/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  Future<void> save() async {
    try {
      var res = await http.post(
        Uri.parse("http://$ip:3002/signin"),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': user.email,
          'password': user.password,
        }),
      );

      print(user.email);
      print(user.password);
      final fCMToken = await _firebaseMessaging.getToken();
      print('Token: $fCMToken');
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0, // No shadow
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.fixed,
            content: Stack(
              children: [
                Container(
                  color: Colors.transparent, // Semi-transparent grey background
                  width: double.infinity,
                  height: 140, // Adjust height as needed
                ),
                AwesomeSnackbarContent(
                  title: 'Sign-in successful',
                  message: 'You have successfully signed in.',
                  contentType: ContentType.success,
                ),
              ],
            ),
          ),
        );
        print('Signin successful');
        print(res.body);
        Map<String, dynamic> responseBody = json.decode(res.body);
        if (responseBody['conflict'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Chooseone(email: user.email),
            ),
          );
        }
        if (responseBody['authenticated'] == true) {
          String collectionType = responseBody['collection'];
          print('Email found in collection: $collectionType');

          if (collectionType == "users") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SplashConnectuser(email: user.email),
              ),
            );

            String fCMToken = (await _firebaseMessaging.getToken())!;

            String userEmail = user.email;

            await updateToken(fCMToken, userEmail);
          } else if (collectionType == "formaters") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SplashConnect(email: user.email),
              ),
            );
            String fCMToken = (await _firebaseMessaging.getToken())!;

            String userEmail = user.email;

            await updateTokenformater(fCMToken, userEmail);
          }
        } else {}
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0, // No shadow
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.fixed,
            content: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.transparent, // Semi-transparent grey background
                  width: double.infinity,
                  height: 140, // Adjust height as needed
                ),
                AwesomeSnackbarContent(
                  title: 'Sign-in failed',
                  message: 'Failed to sign in. Please check your credentials.',
                  contentType: ContentType.failure,
                ),
              ],
            ),
          ),
        );
        print('Failed to sign in. Status code: ${res.statusCode}');
        print(res.body);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0, // No shadow
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.fixed,
          content: Stack(
            children: [
              Container(
                color: Colors.transparent, // Semi-transparent grey background
                width: double.infinity,
                height: 140, // Adjust height as needed
              ),
              AwesomeSnackbarContent(
                title: 'Error',
                message: 'An error occurred during sign-in: $error',
                contentType: ContentType.warning,
              ),
            ],
          ),
        ),
      );
      print('Error during sign in: $error');
    }
  }

  Future<void> updateToken(String token, String email) async {
    try {
      var res = await http.put(
        Uri.parse("http://$ip:3002/updatetokenuser"),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'token': [token],
          'email': email,
        }),
      );

      if (res.statusCode == 200) {
        print('Token updated successfully');
        print(res.body);
      } else {
        print('Failed to update token. Status code: ${res.statusCode}');
        print(res.body);
      }
    } catch (error) {
      print('Error during token update: $error');
    }
  }

  Future<void> updateTokenformater(String token, String email) async {
    try {
      var res = await http.put(
        Uri.parse("http://$ip:3002/updatetokenformater"),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'token': [token],
          'email': email,
        }),
      );

      if (res.statusCode == 200) {
        print('Token updated successfully');
        print(res.body);
      } else {
        print('Failed to update token. Status code: ${res.statusCode}');
        print(res.body);
      }
    } catch (error) {
      print('Error during token update: $error');
    }
  }

  User user = User('', '', '', '');

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLargeScreen = screenSize.width > 1200;
    final bool isMediumScreen =
        screenSize.width <= 1200 && screenSize.width > 768;
    final bool isSmallScreen = screenSize.width <= 768;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: isSmallScreen ? 260 : 300,
                color: const Color(0xFF8B1111),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: isSmallScreen ? 100 : 150),
                    child: Text(
                      AppLocalizations.translate(context, 'Login'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            isLargeScreen ? 55 : (isMediumScreen ? 45 : 35),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.translate(context, 'welcome'),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: isSmallScreen ? 30 : 35,
                            ),
                          ),
                          Text(
                            AppLocalizations.translate(
                                context, 'enter_credentials'),
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: isSmallScreen ? 15 : 18,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 25 : 30),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Email:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),
                            ),
                          ),
                          Container(
                            child: TextFormField(
                              controller:
                                  TextEditingController(text: user.email),
                              onChanged: (value) {
                                user.email = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Type something';
                                } else if (RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return null;
                                } else {
                                  return 'enter valid email';
                                }
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10)),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              AppLocalizations.translate(context, 'password'),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),
                            ),
                          ),
                          Container(
                            child: TextFormField(
                              controller: _passwordController,
                              onChanged: (value) {
                                user.password = value;
                              },
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
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BluePage()),
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.translate(
                                        context, 'forgot_password'),
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: SizedBox(
                              width: 300,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    save();
                                    print("ok");
                                  } else {
                                    print('not ok');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 5, // Elevation
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30), // BorderRadius
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 20),
                                  backgroundColor: const Color(
                                      0xFF8B1111), // Set the background color to red

                                  // Padding
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.translate(
                                          context, 'Login'),
                                      style: const TextStyle(
                                        fontSize: 18, // Text size
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        // Text weight
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Signup()),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.translate(
                                          context, 'no_account'),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: isLargeScreen
                                            ? 18
                                            : (isMediumScreen ? 15 : 13),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.translate(
                                          context, 'register'),
                                      style: TextStyle(
                                        color: const Color(0xFF8B1111),
                                        fontWeight: FontWeight.w600,
                                        fontSize: isLargeScreen
                                            ? 18
                                            : (isMediumScreen ? 15 : 13),
                                        decoration: TextDecoration.underline,
                                        decorationColor:
                                            const Color(0xFF8B1111),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
