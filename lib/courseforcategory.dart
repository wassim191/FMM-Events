import 'package:flutter/material.dart';
import 'package:medcine/Coursebody.dart';
import 'package:medcine/locales/strings.dart';

class CourseforCategory extends StatefulWidget {
  final String email;
  const CourseforCategory({required this.email});

  @override
  State<CourseforCategory> createState() => _CourseforCategoryState();
}

class _CourseforCategoryState extends State<CourseforCategory> {
  late String _selectedFilterOption;
  late List<Course> _filteredCourses;

  @override
  void initState() {
    super.initState();
    _selectedFilterOption = 'All'; // Default filter option
    _filteredCourses = []; // Initialize empty list of filtered courses
  }

  void _updateFilteredCourses(String filterOption) {
    setState(() {
      _selectedFilterOption = filterOption;
      _filteredCourses = _getFilteredCourses(filterOption);
    });
  }

  List<Course> _getFilteredCourses(String filterOption) {
    if (filterOption == 'This week') {
      return _filterCoursesForThisWeek();
    } else if (filterOption == 'Next week') {
      return _filterCoursesForNextWeek();
    } else {
      return _filterAllCourses();
    }
  }

  List<Course> _filterCoursesForThisWeek() {
    // Logic to filter courses for this week
    return [];
  }

  List<Course> _filterCoursesForNextWeek() {
    // Logic to filter courses for next week
    return [];
  }

  List<Course> _filterAllCourses() {
    // Logic to return all courses
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.translate(context, 'category'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Bodycourse(
                email: widget.email,
                selectedoption: _selectedFilterOption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
