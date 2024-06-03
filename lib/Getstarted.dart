import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medcine/Signin.dart';
import 'package:medcine/locales/strings.dart';
import 'package:medcine/main.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      body: Stack(
        children: [
          // Your existing code for the image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 2.1, // Adjust the size of the eclipse
                  colors: [
                    const Color(0xFFFFD2B9).withOpacity(1),
                    Colors.white
                  ],
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: width * 0.8, // Use a percentage of the screen width
                  height: height * 0.6, // Use a percentage of the screen height
                  child: ClipOval(
                    child: Padding(
                      padding: EdgeInsets.all(width *
                          0.05), // Use a percentage of the screen width for padding
                      child: SvgPicture.asset(
                        'assets/undraw_teaching_re_g7e3.svg', // Adjust image path as needed
                        alignment: Alignment.topCenter, // Adjust alignment
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Adjusted position for the language selection dropdown
          Positioned(
            top: height * 0.05, // Use a percentage of the screen height
            right: width * 0.05, // Use a percentage of the screen width
            child: DropdownButton<Locale>(
              value: Localizations.localeOf(context),
              onChanged: (Locale? newLocale) {
                MyApp.setLocale(context, newLocale!);
              },
              items: <Locale>[
                const Locale('en', 'US'),
                const Locale('fr', 'FR'),
              ].map((Locale locale) {
                return DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text(
                      locale.languageCode == 'en' ? 'English' : 'Français'),
                );
              }).toList(),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.9, // Use a percentage of the screen width
                  height: height * 0.1, // Use a percentage of the screen height
                  child: const Center(),
                ),
                const SizedBox(height: 25.0),
                Padding(
                  padding: EdgeInsets.only(top: height * 0.2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.15,
                            left: width * 0.02,
                            right: width * 0.02,
                            bottom: width * 0.02),
                        child: Text(
                          AppLocalizations.translate(context, 'get_started_t1'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B1111),
                          ),
                        ),
                      ),
                      const SizedBox(height: 1.0),
                      Padding(
                        padding: EdgeInsets.only(
                            top: width * 0.02,
                            left: width * 0.02,
                            right: width * 0.02,
                            bottom: width * 0.05),
                        child: Container(
                          child: Text(
                            AppLocalizations.translate(
                                context, 'get_started_t2'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width:
                            width * 0.6, // Use a percentage of the screen width
                        child: ElevatedButton(
                          onPressed: () {
                            // Add navigation logic here
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Signin(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color(0xFF8B1111), // Text color
                            elevation: 5, // Elevation
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // BorderRadius
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: width * 0.04,
                                horizontal: width * 0.05), // Padding
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.translate(
                                    context, 'get_started_btn'),
                                style: const TextStyle(
                                  fontSize: 18, // Text size
                                  fontWeight: FontWeight.bold, // Text weight
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.arrow_forward), // Suffix icon
                            ],
                          ),
                        ),
                      )
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
