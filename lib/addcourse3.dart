import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:medcine/.env';
import 'package:medcine/course.dart';
import 'package:medcine/locales/strings.dart';


class Addcourse_ extends StatefulWidget {
  final String profName;
  final String description;
  final double price;
  final double quantity;
  final String category;
  final List<String> imageUrls;
  final String email;
  final DateTime date;
  final TimeOfDay starttime;
  final TimeOfDay endtime;

  const Addcourse_({
    super.key,
    required this.profName,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    required this.imageUrls,
    required this.email,
    required this.date,
    required this.starttime,
    required this.endtime,
  });

  @override
  State<Addcourse_> createState() => _Addcourse_State();
}

class _Addcourse_State extends State<Addcourse_> {
  final cloudinary = CloudinaryPublic("dtcaflgkn", "ngts3mup");

  String dropdownvalue = "Data Science";

  final telEditingController = TextEditingController();

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
          'Tel': double.parse(telEditingController.text),
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

  Coursee course = Coursee('', '', 0, '', 0, '', 0, DateTime.now(),
      TimeOfDay.now(), TimeOfDay.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 55),
          child: Center(
            child: Text(
              AppLocalizations.translate(context, 'details'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  AppLocalizations.translate(context, 'phonenumber'),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 13),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "+216",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 250,
                    child: TextFormField(
                      controller: telEditingController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        try {
                          double parsedValue = double.parse(value);
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        AppLocalizations.translate(
                            context, 'choose-equipement'),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  "assets/approved.png",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () async {
                  save();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF8B1111),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      AppLocalizations.translate(context, 'add_course'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
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
