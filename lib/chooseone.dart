import 'package:flutter/material.dart';
import 'package:medcine/Connect_splash.dart';
import 'package:medcine/Connect_splashuser.dart';
import 'package:medcine/locales/strings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medcine/.env';

import 'package:http/http.dart' as http;
import 'dart:convert';


class Chooseone extends StatefulWidget {
  final String email;

  const Chooseone({super.key, required this.email});

  @override
  State<Chooseone> createState() => _ChooseoneState();
}

class _ChooseoneState extends State<Chooseone> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.translate(context, 'choose_acc'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SplashConnectuser(
                              email: widget.email,
                            )));

                String fCMToken = (await _firebaseMessaging.getToken())!;

                String userEmail = widget.email;

                await updateToken(fCMToken, userEmail);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF8B1111),
                ),
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    AppLocalizations.translate(context, 'learner'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SplashConnect(
                              email: widget.email,
                            )));
                String fCMToken = (await _firebaseMessaging.getToken())!;

                String userEmail = widget.email;

                await updateTokenformater(fCMToken, userEmail);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF8B1111),
                ),
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    AppLocalizations.translate(context, 'Instructor'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
