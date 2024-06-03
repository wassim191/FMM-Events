import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:medcine/Signin.dart';
import 'package:medcine/locales/strings.dart';

class AuthEntrance extends StatefulWidget {
  const AuthEntrance({super.key});

  @override
  _AuthEntranceState createState() => _AuthEntranceState();
}

enum SupportState {
  unknown,
  supported,
  UnSupported,
}

class _AuthEntranceState extends State<AuthEntrance> {
  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState.unknown;
  List<BiometricType>? availableBiometrics;

  @override
  void initState() {
    auth.isDeviceSupported().then((bool isSupported) {
      setState(() {
        supportState =
            isSupported ? SupportState.supported : SupportState.UnSupported;
      });
    });
    super.initState();
    checkBiometric();
    getAvailableBiometrics();
  }

  Future<void> checkBiometric() async {
    late bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
      print("biometric supported: $canCheckBiometric");
    } on PlatformException catch (e) {
      print(e);
      canCheckBiometric = false;
    }
  }

  Future<void> getAvailableBiometrics() async {
    late List<BiometricType> biometricTypes;
    try {
      biometricTypes = await auth.getAvailableBiometrics();
      print("supported biometrics $biometricTypes");
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) {
      return;
    }
    setState(() {
      availableBiometrics = biometricTypes;
    });
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Authenticate with fingerprint or Face ID',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (!mounted) {
        return;
      }
      if (authenticated) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Signin()),
        );
      }
    } on PlatformException catch (e) {
      print("Face ID authentication error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    child: Image.asset(
                      "assets/images/medcinelogo.png",
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          child: Image.asset("assets/images/face-id.png"),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          height: 100,
                          child: Image.asset("assets/images/fingerprint.png"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.translate(context, 'authorise_text'),
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  Text(
                    AppLocalizations.translate(context, 'biometrics_text'),
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  if (supportState == SupportState.supported &&
                      availableBiometrics != null &&
                      availableBiometrics!.isNotEmpty)
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: authenticateWithBiometrics,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Enable',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
