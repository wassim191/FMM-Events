import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medcine/.env';
import 'package:medcine/AuthEntrance.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class Qrscanner extends StatefulWidget {
  final String email;

  const Qrscanner({super.key, required this.email});

  @override
  State<Qrscanner> createState() => _QrscannerState();
}

class _QrscannerState extends State<Qrscanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String _scanResult = "";
  bool _alertShown = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        _scanResult = scanData.code!;
      });

      print("Scanned Result: $_scanResult");

      await _checkQRCode(_scanResult);
    });
  }

  Future<void> _checkQRCode(String qrCode) async {
    final emaill = widget.email;
    try {
      final response = await http.post(
        Uri.parse('http://$ip:3002/scanscanscan'),
        body: jsonEncode(
            <String, dynamic>{'_id_course': qrCode, 'email': emaill}),
        headers: <String, String>{
          'Content-type': 'application/json',
        },
      );
      print(qrCode);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] != null) {
          if (responseData['success']) {
            final message = responseData['message'];
            _showAlert(message);
          } else {
            final error = responseData['error'];
            _showAlert('Error: $error');
          }
        } else {
          _showAlert('Invalid response format');
        }
      } else {
        _showAlert('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      _showAlert('Error: $e');
    }
  }

  void _showAlert(String message) {
    if (_alertShown) return;

    _alertShown = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (message == "You are confirmed") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AuthEntrance()));
                }
                _alertShown = false;
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
