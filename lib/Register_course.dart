import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medcine/.env';
import 'package:medcine/Payer.dart';
import 'package:intl/intl.dart';
import 'package:medcine/locales/strings.dart';

class Register_course extends StatefulWidget {
  final String prof;
  final double price;
  final List<String> images;
  final double quantity;
  final String description;
  final String category;
  final String email;
  final DateTime date;
  final TimeOfDay starttime;
  final TimeOfDay endtime;
  final String salle;
  final String id;
  final String qr;

  const Register_course({
    super.key,
    required this.prof,
    required this.price,
    required this.images,
    required this.quantity,
    required this.description,
    required this.category,
    required this.email,
    required this.date,
    required this.starttime,
    required this.endtime,
    required this.salle,
    required this.id,
    required this.qr,
  });

  @override
  State<Register_course> createState() => _Register_courseState();
}

class _Register_courseState extends State<Register_course> {
  bool isAddedToWishlist = false;

  Future<void> save() async {
    try {
      var res = await http.post(
        Uri.parse("http://$ip:3002/register"),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': widget.email,
          'Profname': widget.prof,
          'category': widget.category,
          'idcourse': widget.id,
          'qrCode': widget.qr,
        }),
      );

      print(res.body);

      if (res.statusCode == 200) {
        print("Course saved successfully!");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Payer(
                      email: widget.email,
                      id: widget.id,
                      price: widget.price,
                      qr: widget.qr,
                    )));
      } else {
        print("Failed to save course. Status code: ${res.statusCode}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addwishlist() async {
    if (!isAddedToWishlist) {
      try {
        var res = await http.post(
          Uri.parse("http://$ip:3002/addwishlist"),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'email': widget.email,
            'Prof': widget.prof,
            'category': widget.category,
            'price': widget.price,
            'images': widget.images,
          }),
        );

        print(res.body);

        if (res.statusCode == 200) {
          setState(() {
            isAddedToWishlist = true;
          });
          print("course added to wishlist successfully");
        } else {
          print(
              "Failed to add course to wishlist. Status code: ${res.statusCode}");
        }
      } catch (e) {
        print(e.toString());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('This course is already in your wishlist.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Details",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes the position of the shadow
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          widget.images[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.category,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Prof. ${widget.prof}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'Description ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.description,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            AppLocalizations.translate(context, 'lecturehall'),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.salle,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            AppLocalizations.translate(context, 'Time'),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            DateFormat('dd-MM-yyyy').format(widget.date),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                widget.starttime.format(context),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                '->',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.endtime.format(context),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.price.toInt()} TND",
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                ),
                InkWell(
                  onTap: () async {
                    addwishlist();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: isAddedToWishlist ? Colors.red : const Color(0xFF8B1111),
                      size: 30,
                    ),
                  ),
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
                    child: const Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
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
