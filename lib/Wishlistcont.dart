import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medcine/.env';

class Course {
  final String prof;
  final double price;
  final String category;
  final List<String> images;
  final String id;

  Course({
    required this.prof,
    required this.price,
    required this.category,
    required this.images,
    required this.id,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'] ?? '',
      prof: json['Prof'] ?? '',
      price: json['price'] != null ? json['price'].toDouble() : 0.0,
      category: json['category'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

class Wishlistcont extends StatefulWidget {
  final Function onContentChange;

  const Wishlistcont({super.key, required this.onContentChange});

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

  Future<void> deleteWishlist(String courseId) async {
    try {
      final response = await http.delete(
        Uri.parse("http://$ip:3002/deletewishlist"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          '_id': courseId,
        }),
      );

      if (response.statusCode == 200) {
        print("Course deleted successfully!");
        widget.onContentChange(); // Trigger the callback function
      } else {
        print("Failed to delete course. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error deleting course: $e");
    }
  }

  Future<void> removeCourse(int index) async {
    setState(() {
      courses = courses.then((courseList) {
        courseList.removeAt(index);
        return Future.value(courseList);
      });
    });
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
          return Center(
            child: Text(
              'Your Wishlist is currently Empty',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          );
        } else {
          List<Course> activeCourses = snapshot.data!.toList();
          return ListView.builder(
            itemCount: activeCourses.length,
            itemBuilder: (context, index) {
              Course course = activeCourses[index];
              return GestureDetector(
                onLongPress: () {
                  removeCourse(index).then((_) {
                    deleteWishlist(course.id);
                  });
                },
                child: ListTile(
                  title: Text(
                    course.category,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    '${course.price.toInt()} TND',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  leading: Container(
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
                  trailing: InkWell(
                    onTap: () {
                      removeCourse(index).then((_) {
                        deleteWishlist(course.id);
                      });
                    },
                    child: const Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
