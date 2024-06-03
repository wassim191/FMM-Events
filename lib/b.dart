import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medcine/.env';

class Course {
  final String prof;
  final double price;
  final String category;
  final List<String> images;

  Course({
    required this.prof,
    required this.price,
    required this.category,
    required this.images,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      prof: json['Prof'] ?? '',
      price: json['price'] != null ? json['price'].toDouble() : 0.0,
      category: json['category'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

class Wishlistcont extends StatefulWidget {
  const Wishlistcont({
    super.key,
  });

  @override
  _WishlistcontState createState() => _WishlistcontState();
}

class _WishlistcontState extends State<Wishlistcont> {
  late Future<List<Course>> courses;

  @override
  void initState() {
    super.initState();
    courses = getCourses();
  }

  @override
  void didUpdateWidget(covariant Wishlistcont oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future<List<Course>> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse("http://$ip:3002/getwishlist"),
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
          List<Course> activeCourses = snapshot.data!.toList();
          return Center(
            child: ListView.builder(
              itemCount: activeCourses.length,
              itemBuilder: (context, index) {
                Course course = activeCourses[index];

                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image
                        Container(
                          height: 60,
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
