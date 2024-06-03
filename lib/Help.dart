import 'package:flutter/material.dart';
import 'locales/strings.dart';

class helpPage extends StatelessWidget {
  const helpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
            height: height / 8,
            width: width,
            decoration: const BoxDecoration(
              color: Color(0xFF832121),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
            ),
            child: Center(
              child: Image.asset(
                'assets/help/help-desk.png', // Use the same image as InfoPage
                width: 150,
                height: 150,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: height / 8 + 20, left: width / 25, right: width / 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.translate(context, 'help'),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.translate(context, 'help_content'),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
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
