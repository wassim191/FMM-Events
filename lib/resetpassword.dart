import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:medcine/otp_screen.dart';

class BluePage extends StatefulWidget {
  const BluePage({super.key});

  @override
  _BluePageState createState() => _BluePageState();
}

class _BluePageState extends State<BluePage> {
  TextEditingController email = TextEditingController();
  EmailOTP myauth = EmailOTP();

  String em = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Image.asset('assets/bar-chart.png'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Reset Password !',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        color: Colors.white,
                        child: TextFormField(
                          controller: email,
                          onChanged: (value) {
                            em = value;
                          },
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                              hintText: 'saisir votre email ',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  myauth.setConfig(
                                      appEmail: "khalilkacem57@gmail.com",
                                      appName: "Email OTP",
                                      userEmail: email.text,
                                      otpLength: 4,
                                      otpType: OTPType.digitsOnly);
                                  if (await myauth.sendOTP() == true) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("OTP has been sent"),
                                    ));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Otp_screen(
                                                  myauth: myauth,
                                                  email: email.text,
                                                )));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Oops,OTP send failed"),
                                    ));
                                  }
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Color(0xFF8B1111),
                                ),
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
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
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
