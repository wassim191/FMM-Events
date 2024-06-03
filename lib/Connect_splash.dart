import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import convert for JSON handling
import 'package:medcine/.env';

import 'package:medcine/instructor_home.dart';
import 'package:medcine/locales/strings.dart';

class SplashConnect extends StatefulWidget {
  final String email;

  const SplashConnect({
    super.key,
    required this.email,
  });

  @override
  _SplashConnectState createState() => _SplashConnectState();
}

class _SplashConnectState extends State<SplashConnect> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() async {
    try {
      final response = await http.get(
        Uri.parse('http://$ip:3002/getname/${widget.email}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          userName = responseData['name'];
        });
      } else {
        throw Exception('Failed to load user name');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => InstructorHome(
            email: widget.email,
            userName: userName,
          ),
        ),
      );
    });
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.red.shade700,
                Colors.white,
              ],
            )),
          ),
          Positioned(
            top: 150,
            left: 35,
            right: 35,
            child: ClipOval(
              child: Image.asset(
                'assets/images/ic_profile.png',
              ),
            ),
          ),
          Positioned(
            top: 450,
            left: 35,
            right: 35,
            child: Column(
              children: [
                Text(
                  userName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Yellowtail',
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ), // Adjust font, size, etc.
                ),
                Text(
                  userName.isNotEmpty
                      ? AppLocalizations.translate(context, 'is-now-connected')
                      : 'Loading...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ), // Adjust font, size, etc.
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
