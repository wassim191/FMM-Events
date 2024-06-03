import 'package:flutter/material.dart';
import 'package:medcine/Signup1.dart';
import 'package:medcine/Signup2.dart';
import 'package:http/http.dart' as http;
import 'package:medcine/locales/strings.dart';
import 'package:medcine/user.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  Future<void> save() async {
    var res = await http.post(
      Uri.parse("http://localhost:3002/signup"),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: (<String, String>{
        'email': user.email,
        'password': user.password,
        'cin': user.cin,
        'name': user.name,
      }),
    );
  }

  User user = User('', '', '', '');

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLargeScreen = screenSize.width > 1200;
    final bool isMediumScreen =
        screenSize.width <= 1200 && screenSize.width > 768;
    final bool isSmallScreen = screenSize.width <= 768;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Sign up',
              style: TextStyle(color: Colors.white, fontSize: 35),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFF8B1111),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          backgroundColor: const Color(0xFF8B1111),
          body: Column(
            children: [
              TabBar(tabs: [
                Tab(
                  child: Text(
                    AppLocalizations.translate(context, 'Learner'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    AppLocalizations.translate(context, 'Instructor'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ]),
              const Expanded(
                  child: TabBarView(
                children: [
                  Signup1(),
                  Signup2(),
                ],
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: isSmallScreen ? 82 : 95,
                  width: double.infinity,
                  color: const Color(0xFF8B1111),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: const Text(
                            '1',
                            style: TextStyle(
                                color: Color(0xFF8B1111), fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        height: 2,
                        color: Colors.white,
                        width: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                        child: const Text(
                          '2',
                          style:
                              TextStyle(color: Color(0xFF8B1111), fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
