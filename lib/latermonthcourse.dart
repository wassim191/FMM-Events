import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:medcine/.env';
import 'package:medcine/Register_course.dart';
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

  bool isNextWeek(DateTime date) {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    DateTime nextMonday =
        now.add(Duration(days: (DateTime.daysPerWeek - currentWeekday) + 1));
    DateTime nextSunday = nextMonday.add(const Duration(days: 6));
    return date.isAfter(nextMonday) && date.isBefore(nextSunday);
  }
}

class Laterthismonth extends StatefulWidget {
  final String emaill;
  const Laterthismonth({super.key, required this.emaill});

  @override
  _LaterthismonthState createState() => _LaterthismonthState();
}

class _LaterthismonthState extends State<Laterthismonth> {
  late Future<List<Course>> courses;

  @override
  void initState() {
    super.initState();
    courses = getCourses();
  }

  Future<List<Course>> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse("http://$ip:3002/getcourse"),
      );
      if (response.statusCode == 200) {
        List<dynamic> coursesJson = json.decode(response.body);
        List<Course> courses =
            coursesJson.map((json) => Course.fromJson(json)).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Course>>(
        future: courses,
        builder: (BuildContext context, AsyncSnapshot<List<Course>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No courses available.'));
          } else {
            List<Course> nextWeekCourses = snapshot.data!
                .where((course) =>
                    course.status == "active" && course.isNextWeek(course.date))
                .toList();

            return CarouselSlider.builder(
              key: UniqueKey(),
              itemCount: nextWeekCourses.length,
              itemBuilder: (context, index, realIndex) {
                Course course = nextWeekCourses[index];

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
                          email: widget.emaill,
                          salle: course.salle,
                          date: course.date,
                          starttime: course.starttime,
                          endtime: course.endtime,
                          id: course.id,
                          qr: course.qr,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (String imageUrl in course.images)
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.fill,
                              ),
                            ),
                          Text(
                            course.category,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    AppLocalizations.translate(context, 'by'),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    course.prof,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    course.price.toInt().toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Text(
                                    " TND",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Display additional information
                        ],
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
                height: 180,
                viewportFraction: 0.85,
                initialPage: 0,
                enableInfiniteScroll: false,
                enlargeFactor: 0.1,
                reverse: false,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  // Handle page change
                },
              ),
            );
          }
        },
      ),
    );
  }
}
