import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For DateFormat
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:medcine/.env';
import 'package:medcine/locales/strings.dart';

import 'Myqrcodecourse.dart';

class CourseDetailsPage extends StatefulWidget {
  final String prof;
  final double price;
  final List<String> images;
  final DateTime date;
  final TimeOfDay starttime;
  final TimeOfDay endtime;
  final String status;
  final String courseId;
  final String qr;

  const CourseDetailsPage({
    super.key,
    required this.prof,
    required this.status,
    required this.price,
    required this.images,
    required this.date,
    required this.starttime,
    required this.endtime,
    required this.courseId,
    required this.qr,
  });

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  bool showDetails = false;

  Future<void> deleteCourse() async {
    try {
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete',
                style: TextStyle(color: Color(0xFF8B1111))),
            content: const Text('Are you sure you want to delete this course?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF8B1111)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child:
                    const Text('Delete', style: TextStyle(color: Color(0xFF8B1111))),
              ),
            ],
          );
        },
      );

      if (confirmDelete) {
        final response = await http.delete(
          Uri.parse("http://$ip:3002/deletecourse"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            '_id': widget.courseId,
          }),
        );

        if (response.statusCode == 200) {
          print("Course deleted successfully!");
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Course deleted successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          print("Failed to delete course. Status code: ${response.statusCode}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to delete course. Status code: ${response.statusCode}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print("Error deleting course: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting course: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
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
        title: Text(AppLocalizations.translate(context, 'coursedetails'),
            style: const TextStyle(color: Colors.white)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  widget.images[0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Status: ${widget.status}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: height / 3,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showDetails = !showDetails;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 3, // Elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // BorderRadius
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    backgroundColor:
                        const Color(0xFF8B1111), // Set the background color to red

                    // Padding
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.translate(context, 'Details'),
                        style: const TextStyle(
                          fontSize: 18, // Text size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          // Text weight
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (showDetails)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Instructor: ${widget.prof}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${AppLocalizations.translate(context, 'price')}: ${widget.price.toInt()} TND',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Date : ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          DateFormat('dd-MM-yyyy').format(widget.date),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.translate(context, 'time'),
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          widget.starttime.format(context),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '->',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.endtime.format(context),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (widget.status == "active")
                      Center(
                        child: SizedBox(
                          width: height / 3,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Myqrcodecourse(qr: widget.qr)));
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 3, // Elevation
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // BorderRadius
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              backgroundColor: const Color(0xFF8B1111),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.translate(
                                      context, 'myqrcode'),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Center(
                      child: SizedBox(
                        width: height / 3,
                        child: ElevatedButton(
                          onPressed: () {
                            deleteCourse();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 3, // Elevation
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // BorderRadius
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            backgroundColor: const Color(
                                0xFF8B1111), // Set the background color to red

                            // Padding
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.translate(
                                    context, 'deletecourse'),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
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
      ),
    );
  }
}
