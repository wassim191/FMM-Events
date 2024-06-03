import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medcine/updatepassword.dart';

class Otp extends StatelessWidget {
  const Otp({
    super.key,
    required this.otpController,
  });
  final TextEditingController otpController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: ('0'),
        ),
        onSaved: (value) {},
      ),
    );
  }
}

class Otp_screen extends StatefulWidget {
  final String email;
  final EmailOTP myauth;

  const Otp_screen({super.key, required this.myauth, required this.email});
  @override
  _OtpscreenState createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otp_screen> {
  TextEditingController email = TextEditingController();
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  EmailOTP myauth = EmailOTP();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 190,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Check your email!",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 30),
                ),
              ],
            ),
            const SizedBox(
              height: 55,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Otp(otpController: otp1Controller)),
                Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Otp(otpController: otp2Controller)),
                Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Otp(otpController: otp3Controller)),
                Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Otp(otpController: otp4Controller)),
              ],
            ),
            const SizedBox(
              height: 55,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
              ),
              onPressed: () async {
                if (await widget.myauth.verifyOTP(
                  otp: otp1Controller.text +
                      otp2Controller.text +
                      otp3Controller.text +
                      otp4Controller.text,
                )) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("OTP is verified"),
                  ));

                  email.text = widget.email;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Update_password(email: email.text),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Invalid OTP"),
                  ));
                }
              },
              child: const Text("Confirme"),
            ),
          ],
        ),
      ),
    );
  }
}
