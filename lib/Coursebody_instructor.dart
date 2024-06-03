import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medcine/.env';
import 'package:medcine/Register_course_instructor.dart';

import 'package:medcine/locales/strings.dart';

class Course {
  final String prof;
  final String description;
  final double price;
  final double quantity;
  final String category;
  final List<String> images;
  final String email;
  final DateTime date;
  final TimeOfDay starttime;
  final TimeOfDay endtime;
  final String status;
  final String salle;
  final String id;
  final String qr;

  Course({
    required this.prof,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    required this.images,
    required this.status,
    required this.email,
    required this.date,
    required this.starttime,
    required this.endtime,
    required this.salle,
    required this.id,
    required this.qr,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'] ?? '',
      prof: json['Prof'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] != null ? json['price'].toDouble() : 0.0,
      quantity: json['quantity'] != null ? json['quantity'].toDouble() : 0.0,
      category: json['category'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      status: json['status'] ?? '',
      email: json['email'] ?? '',
      date:
          json['Date'] != null ? DateTime.parse(json['Date']) : DateTime.now(),
      starttime: json['Timeofstart'] != null
          ? TimeOfDay.fromDateTime(DateTime.parse(json['Timeofstart']))
          : const TimeOfDay(hour: 0, minute: 0),
      endtime: json['Timeofend'] != null
          ? TimeOfDay.fromDateTime(DateTime.parse(json['Timeofend']))
          : const TimeOfDay(hour: 0, minute: 0),
      salle: json['Salle'] ?? '',
      qr: json['qrCode'] ?? '',
    );
  }
}

class Bodycourse extends StatefulWidget {
  final String email;
  final String selectedoption;

  const Bodycourse({
    super.key,
    required this.email,
    required this.selectedoption,
  });

  @override
  _BodycourseState createState() => _BodycourseState();
}

class _BodycourseState extends State<Bodycourse> {
  late Future<List<Course>> courses;

  @override
  void initState() {
    super.initState();
    courses = getCourses();
  }

  @override
  void didUpdateWidget(covariant Bodycourse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedoption != oldWidget.selectedoption) {
      setState(() {
        courses = getCourses();
      });
    }
  }

  Future<List<Course>> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse("http://$ip:3002/getcourse"),
      );
      if (response.statusCode == 200) {
        List<dynamic> coursesJson = json.decode(response.body);
        List<Course> courses =
            coursesJson.map((json) => Course.fromJson(json)).where((course) {
          if (widget.selectedoption ==
              AppLocalizations.translate(context, 'this-week')) {
            return isCourseInThisWeek(course.date);
          } else if (widget.selectedoption ==
              AppLocalizations.translate(context, 'next-week')) {
            return isCourseInNextWeek(course.date);
          }
          return true;
        }).toList();
        print(widget.selectedoption);

        return courses;
      } else {
        print('Failed to fetch courses. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to fetch courses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching courses: $e');
      throw Exception('Error fetching courses: $e');
    }
  }

  bool isCourseInThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }

  bool isCourseInNextWeek(DateTime date) {
    final now = DateTime.now();
    final startOfNextWeek = now.add(Duration(days: 8 - now.weekday));
    final endOfNextWeek = startOfNextWeek.add(const Duration(days: 6));
    print('Course Date: $date');
    print('${AppLocalizations.translate(context, 'start-of-next-week')}: $startOfNextWeek');
    print('${AppLocalizations.translate(context, 'end-of-next-week')}: $endOfNextWeek');
    return date.isAfter(startOfNextWeek) && date.isBefore(endOfNextWeek);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Course>>(
      future: courses,
      builder: (BuildContext context, AsyncSnapshot<List<Course>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No courses available.'));
        } else {
          List<Course> activeCourses = snapshot.data!
              .where((course) => course.status == "active")
              .toList();
          return Center(
            child: ListView.builder(
              itemCount: activeCourses.length,
              itemBuilder: (context, index) {
                Course course = activeCourses[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Register_course(
                                  prof: course.prof,
                                  price: course.price,
                                  images: course.images,
                                  quantity: course.quantity,
                                  description: course.description,
                                  category: course.category,
                                  email: widget.email,
                                  date: course.date,
                                  starttime: course.starttime,
                                  endtime: course.endtime,
                                  salle: course.salle,
                                  id: course.id,
                                  qr: course.qr,
                                )));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                    padding:
                        const EdgeInsets.all(15.0), // Add padding inside the card
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(course.images.first),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.category,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    course.prof,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '${course.price.toInt()} TND',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
