import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:medcine/.env';

class EquipmentsSelectionPage extends StatefulWidget {
  final String profName;
  final String description;
  final double price;
  final double quantity;
  final String category;
  final List<String> imageUrls;
  final String email;
  final String phone;

  final DateTime date;
  final TimeOfDay starttime;
  final TimeOfDay endtime;

  const EquipmentsSelectionPage({
    super.key,
    required this.profName,
    required this.description,
    required this.price,
    required this.phone,
    required this.quantity,
    required this.category,
    required this.imageUrls,
    required this.email,
    required this.date,
    required this.starttime,
    required this.endtime,
  });

  @override
  _EquipmentsSelectionPageState createState() =>
      _EquipmentsSelectionPageState();
}

class _EquipmentsSelectionPageState extends State<EquipmentsSelectionPage> {
  final cloudinary = CloudinaryPublic("dtcaflgkn", "ngts3mup");
  List<String> equipmentItems = [
    'datashow',
    'microphone',
    'speaker',
    'extension-cord',
    'hdmi-cable',
    'rg45',
  ];

  final Map<String, int> _selectedQuantities = {
    'datashow': 0,
    'microphone': 0,
    'speaker': 0,
    'extension-cord': 0,
    'hdmi-cable': 0,
    'rg45': 0,
  };

  final StreamController<Map<String, int>> _counterStreamController =
      StreamController<Map<String, int>>.broadcast();
  Stream<Map<String, int>> get counterStream => _counterStreamController.stream;

  void _incrementCounter(String item) {
    setState(() {
      if ((_selectedQuantities[item] ?? 0) < 10) {
        _selectedQuantities[item] = (_selectedQuantities[item] ?? 0) + 1;
        _counterStreamController.add(Map.from(_selectedQuantities));
      }
    });
  }

  void _decrementCounter(String item) {
    setState(() {
      if ((_selectedQuantities[item] ?? 0) > 0) {
        _selectedQuantities[item] = (_selectedQuantities[item] ?? 0) - 1;
        _counterStreamController.add(Map.from(_selectedQuantities));
      }
    });
  }

  void _confirmSelection(BuildContext context) {
    Navigator.pop(context, _selectedQuantities); // Return selected quantities
  }

  Future<void> save() async {
    try {
      List<String> imageUrlList = [];
      for (int i = 0; i < widget.imageUrls.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(widget.imageUrls[i]),
        );
        imageUrlList.add(res.secureUrl);
      }
      DateTime startTime = DateTime(widget.date.year, widget.date.month,
          widget.date.day, widget.starttime.hour, widget.starttime.minute);
      DateTime endTime = DateTime(widget.date.year, widget.date.month,
          widget.date.day, widget.endtime.hour, widget.endtime.minute);

      var res = await http.post(
        Uri.parse("http://$ip:3002/addcourse"),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'Prof': widget.profName,
          'description': widget.description,
          'price': widget.price,
          'quantity': widget.quantity,
          'category': widget.category,
          'images': imageUrlList,
          'Tel': widget.phone,
          'email': widget.email,
          'Date': widget.date.toIso8601String(),
          'Timeofstart': startTime.toIso8601String(),
          'Timeofend': endTime.toIso8601String(),
        }),
      );

      print(res.body);

      if (res.statusCode == 200) {
        print("Course saved successfully!");
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        print("Failed to save course. Status code: ${res.statusCode}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final Size screenSize = MediaQuery.of(context).size;
    var height = size.height;
    final bool isSmallScreen = screenSize.width <= 768;
    var width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Equipment',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF832121),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size.width < 600 ? 2 : 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: equipmentItems.length,
                  itemBuilder: (context, index) {
                    String item = equipmentItems[index];
                    return GestureDetector(
                      onTap: () {
                        // Show dialog to select quantity
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Select Quantity for $item:'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          _decrementCounter(item);
                                        },
                                      ),
                                      StreamBuilder<Map<String, int>>(
                                        stream: counterStream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              '${snapshot.data?[item] ?? 0}',
                                              style: const TextStyle(fontSize: 24.0),
                                            );
                                          } else {
                                            return Text(
                                                '${snapshot.data?[item] ?? 0}');
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          _incrementCounter(item);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _confirmSelection(
                                        context); // Confirm selection
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.width < 600 ? 100 : 150,
                            width: size.width < 600 ? 100 : 150,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF832121),
                                border:
                                    Border.all(color: Colors.black, width: 2),
                              ),
                              child: ClipOval(
                                child: Transform.scale(
                                  scale: 0.7,
                                  child: Image.asset(
                                    'assets/equipement/${equipmentItems[index]}.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            equipmentItems[index],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: isSmallScreen ? 40 : 80),
                child: SizedBox(
                  width: width * 0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      _confirmSelection(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF8B1111),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
