import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medcine/home.dart';
import 'package:medcine/locales/strings.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeCourses extends StatelessWidget {
  const HomeCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(
                AppLocalizations.translate(context, 'this-week')),
            GestureDetector(
              onTap: () {},
              child: Text(
                AppLocalizations.translate(context, 'seeall'),
                style: const TextStyle(
                  color: Color(0xFF525252),
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        _buildCourseSlider(context, [
          Course(
            thumbnailUrl:
                'https://res.cloudinary.com/dtcaflgkn/image/upload/v1708603840/pzyzrwrqsxwxhzawyjoi.jpg',
            name: 'Course 1',
            instructor: 'Instructor A',
            price: 49.99,
          ),
          Course(
            thumbnailUrl: 'assets/fr.png',
            name: 'Course 2',
            instructor: 'Instructor B',
            price: 29.99,
          ),
          Course(
            thumbnailUrl: 'assets/py/py.png',
            name: 'Course 3',
            instructor: 'Instructor C',
            price: 19.99,
          ),
          Course(
            thumbnailUrl: 'thumbnail_url_4',
            name: 'Course 4',
            instructor: 'Instructor D',
            price: 39.99,
          ),
          Course(
            thumbnailUrl: 'thumbnail_url_5',
            name: 'Course 5',
            instructor: 'Instructor E',
            price: 59.99,
          ),
        ]),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(
                AppLocalizations.translate(context, 'next-week')),
            GestureDetector(
              onTap: () {
                // Navigate to the full list of courses for the month
              },
              child: Text(
                AppLocalizations.translate(context, 'seeall'),
                style: const TextStyle(
                  color: Color(0xFF525252),
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        _buildCourseSlider(context, [
          Course(
            thumbnailUrl:
                'https://res.cloudinary.com/dtcaflgkn/image/upload/v1708704200/p6dcvouuny5htczdisb5.png',
            name: 'Course A',
            instructor: 'Instructor X',
            price: 0,
          ),
          Course(
            thumbnailUrl: 'assets/py/py.png',
            name: 'Course B',
            instructor: 'Instructor Y',
            price: 19.99,
          ),
          Course(
            thumbnailUrl: 'thumbnail_url_C',
            name: 'Course C',
            instructor: 'Instructor Z',
            price: 29.99,
          ),
          Course(
            thumbnailUrl: 'thumbnail_url_D',
            name: 'Course D',
            instructor: 'Instructor W',
            price: 0,
          ),
          Course(
            thumbnailUrl: 'thumbnail_url_E',
            name: 'Course E',
            instructor: 'Instructor V',
            price: 39.99,
          ),
        ]),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCourseSlider(BuildContext context, List<Course> courses) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.6,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return FutureBuilder<Size>(
            future: _getImageSize(course.thumbnailUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildPlaceholderContainer(context);
              } else if (snapshot.hasError) {
                return _buildErrorContainer(context);
              } else {
                final imageSize = snapshot.data!;
                final aspectRatio = imageSize.width / imageSize.height;
                final containerHeight =
                    MediaQuery.of(context).size.width * 0.8 / aspectRatio;

                // Adjust the margin for the first container
                final margin = index == 0
                    ? const EdgeInsets.only(left: 0.0)
                    : const EdgeInsets.symmetric(horizontal: 8.0);

                return Container(
                  margin: margin,
                  child:
                      _buildCourseContainer(context, course, containerHeight),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildPlaceholderContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.6,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildErrorContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.6,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: const Text('Error loading image'),
    );
  }

  Widget _buildCourseContainer(
      BuildContext context, Course course, double containerHeight) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: MediaQuery.of(context).size.width * 0.6 * 0.5, // 50% scale
      height: containerHeight,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6 * 0.5, // 50% scale
            height: containerHeight * 0.5, // 50% scale
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: course.thumbnailUrl,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(height: 8.0), // Added space between image and text
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0), // Adjusted padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      // Wrap instructor text with Expanded
                      child: Text(
                        course.instructor,
                        style: const TextStyle(
                          color: Color(0xFF525252),
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    Text(
                      course.price == 0
                          ? 'Free'
                          : '\$${course.price.toString()}',
                      style: const TextStyle(
                        color: Color(0xFF525252),
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Size> _getImageSize(String imageUrl) async {
    final image = NetworkImage(imageUrl);
    final completer = Completer<ImageInfo>();
    image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
              (ImageInfo info, bool _) => completer.complete(info)),
        );
    final info = await completer.future;
    return Size(info.image.width.toDouble(), info.image.height.toDouble());
  }
}
