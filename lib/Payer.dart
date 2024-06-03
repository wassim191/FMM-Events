import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medcine/.env';
import 'package:medcine/Skippayement.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Payer extends StatefulWidget {
  final String email;
  final double price;
  final String id;
  final String qr;

  const Payer(
      {super.key,
      required this.email,
      required this.price,
      required this.id,
      required this.qr});
  @override
  _PayerState createState() => _PayerState();
}

class _PayerState extends State<Payer> {
  bool _paymentSuccessful = false;
  var idregister = "";
  var qrcode = "";

  Future<void> makePayment(BuildContext context) async {
    var url = Uri.parse('http://$ip:3002/paymentt');
    var response = await http.post(url, body: {
      'amount': '${widget.price.toInt()}000',
      'email': widget.email,
      'id': widget.id,
    });

    if (response.statusCode == 200) {
      print('Payment successful');
      Map<String, dynamic> responseBody = json.decode(response.body);
      var payUrl = responseBody['payUrl'];
      print('Pay URL: $payUrl');

      await launch(payUrl);
      setState(() {
        _paymentSuccessful = true;
      });
    } else {
      print('Payment failed');
    }
  }

  Future<void> getregister() async {
    try {
      var res = await http.post(
        Uri.parse("http://$ip:3002/getregisterbyidcourseandemail"),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'idcourse': widget.id,
          'email': widget.email,
        }),
      );

      if (res.statusCode == 200) {
        print(res.body);
        var responseBody = json.decode(res.body);

        idregister = responseBody['_id'];
        print(idregister);
      } else {
        print('Failed to fetch register. Status code: ${res.statusCode}');
        print(res.body);
      }
    } catch (error) {
      print('Error during register fetch: $error');
    }
  }

  Future<void> generateqruser(String idregister) async {
    try {
      var res = await http.post(
        Uri.parse("http://$ip:3002/generateqrcodee"),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id_register': idregister,
        }),
      );
      if (res.statusCode == 200) {
        var responseBody = json.decode(res.body);
        qrcode = responseBody['qrCode'];
        print(qrcode);
      } else {
        print('Failed to update password. Status code: ${res.statusCode}');
        print(res.body);
      }
    } catch (error) {
      print('Error during password update: $error');
    }
  }

  Future<void> save() async {
    try {
      var res = await http.post(
        Uri.parse("http://$ip:3002/generatqr/${widget.id}"),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
      );
      if (res.statusCode == 200) {
        print(res.body);
      } else {
        print('Failed to update password. Status code: ${res.statusCode}');
        print(res.body);
      }
    } catch (error) {
      print('Error during password update: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                child: Image.asset(
                  "assets/master_card.png",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Your payment details here',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'Complete payment',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => makePayment(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF832121),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(' Pay ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: InkWell(
                  onTap: () async {
                    await getregister();
                    await generateqruser(idregister);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Skippayement(qr: qrcode)));
                  },
                  child: const Text(
                    "Later",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
