import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:medcine/Signin.dart';
import 'package:http/http.dart' as http;
import 'package:medcine/SnackBar.dart';
import 'package:medcine/locales/strings.dart';
import 'formater.dart';
import 'dart:convert';
import '.env';

class Signup2 extends StatefulWidget {
  const Signup2({super.key});

  @override
  _Signup2State createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {
  bool _isPasswordVisible = false;
  String dropdownvalue = "Data Science";
  var items = ["Data Science", "Anatomy", "Computer Science"];

  final _formKey = GlobalKey<FormState>();
  Future<void> save() async {
    try {
      var res = await http.post(
        Uri.parse("http://$ip:3002/signup2"),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': formater.email,
          'password': formater.password,
          'Expertise': formater.Expertise,
          'name': formater.name,
          'Poste': formater.Poste,
        }),
      );

      print(formater.email);
      print(formater.password);
      if (res.statusCode == 200) {
        print('Signin successful');
        print(res.body);
        CustomSnackbar.showCustomSnackbar(
          context,
          'Sign-Up successful',
          'You have successfully signed Up.',
          ContentType.success,
        );
        Map<String, dynamic> responseBody = json.decode(res.body);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Signin()));
      } else {
        print('Failed to sign up. Status code: ${res.statusCode}');
        print(res.body);
        CustomSnackbar.showCustomSnackbar(
          context,
          'Sign-up Failed',
          'Failed to sign up. Please check your credentials.',
          ContentType.failure,
        );
      }
    } catch (error) {
      print('Error during sign in: $error');
    }
  }

  Formater formater = Formater('', '', '', '', '');

  @override
  void initState() {
    super.initState();
    formater.Expertise = dropdownvalue;
  }

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
        child: Positioned.fill(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                AppLocalizations.translate(context, 'name'),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13),
                              ),
                            ),
                            SizedBox(
                              height: 45,
                              child: TextFormField(
                                onChanged: (value) {
                                  formater.name = value;
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
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10)),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, right: 20),
                                      child: Text(
                                        AppLocalizations.translate(
                                            context, 'expertise'),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                  child: DropdownButton(
                                    value: dropdownvalue,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                    ),
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: const TextStyle(
                                              color: Colors.black45),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                      });
                                      formater.Expertise = dropdownvalue;
                                    },
                                    underline: Container(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                AppLocalizations.translate(context, 'poste'),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13),
                              ),
                            ),
                            SizedBox(
                              height: 45,
                              child: TextFormField(
                                onChanged: (value) {
                                  formater.Poste = value;
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
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10)),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Email:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 45,
                              child: TextFormField(
                                onChanged: (value) {
                                  formater.email = value;
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
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10)),
                              ),
                            ),
                            const SizedBox(height: 5),
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
                                onChanged: (value) {
                                  formater.password = value;
                                },
                                validator: (value) {
                                  RegExp regex = RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                  if (value == null || value.isEmpty) {
                                    return 'Type something';
                                  } else {
                                    if (!regex.hasMatch(value)) {
                                      return 'Enter valid password ';
                                    } else {
                                      return null;
                                    }
                                  }
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
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
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
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            InkWell(
                              onTap: () async {
                                if (_formKey.currentState != null &&
                                    _formKey.currentState!.validate()) {
                                  await save();
                                  print("ok");
                                } else {
                                  print('not ok');
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFF8B1111),
                                ),
                                padding: const EdgeInsets.all(5),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.translate(
                                        context, 'create_account'),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Signin()),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.translate(
                                        context, 'have_account'),
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
                                        context, 'log_in'),
                                    style: TextStyle(
                                      color: const Color(0xFF8B1111),
                                      fontWeight: FontWeight.w600,
                                      fontSize: isLargeScreen
                                          ? 18
                                          : (isMediumScreen ? 15 : 13),
                                      decoration: TextDecoration.underline,
                                      decorationColor: const Color(0xFF8B1111),
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
            ],
          ),
        ),
      ),
    );
  }
}
