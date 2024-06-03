import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '.env';
import 'addcourse.dart';
import 'locales/strings.dart';

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
          ? parseTimeOfDay(json['Timeofstart'])
          : TimeOfDay.now(),
      endtime: json['Timeofend'] != null
          ? parseTimeOfDay(json['Timeofend'])
          : TimeOfDay.now(),
      salle: json['Salle'] ?? '',
      qr: json['qrCode'] ?? '',
    );
  }
}

TimeOfDay parseTimeOfDay(String time) {
  final dateTime = DateTime.parse(time);
  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}

class AddCourseCalendar extends StatefulWidget {
  final String email;
  const AddCourseCalendar({super.key, required this.email});

  @override
  _AddCourseCalendarState createState() => _AddCourseCalendarState();
}

class _AddCourseCalendarState extends State<AddCourseCalendar> {
  late DateTime selectedDate;
  late TimeOfDay selectedStartTime;
  late TimeOfDay selectedEndTime;
  late Map<DateTime, List<Course>> events;

  DateTime initialDate = DateTime.now();
  DateTime firstDay = DateTime.utc(2024, 1, 1);
  DateTime lastDay = DateTime.utc(2030, 12, 31);

  @override
  void initState() {
    super.initState();
    selectedDate = initialDate;
    selectedStartTime = TimeOfDay.now();
    selectedEndTime = TimeOfDay.now();
    events = {};
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B1111),
        title: const Text(
          'Choose Time & Date',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: screenHeight * 0.6, // Adjust the height as needed
              child: SfCalendar(
                view: CalendarView.month,
                initialSelectedDate: DateTime.now(),
                showNavigationArrow: true,
                selectionDecoration: BoxDecoration(
                  color: const Color(0xFF8B1111)
                      .withOpacity(0.3), // Use transparent color
                  shape: BoxShape.rectangle,
                ),
                todayHighlightColor: const Color(0xFF8B1111), // Use transparent color
                headerStyle: const CalendarHeaderStyle(
                  textStyle: TextStyle(color: Colors.white),
                  backgroundColor: Color(0xFF8B1111),
                ),
                dataSource: _getCalendarDataSource(),
                viewHeaderStyle:
                    const ViewHeaderStyle(backgroundColor: Colors.transparent),
                monthViewSettings: const MonthViewSettings(
                  navigationDirection: MonthNavigationDirection.horizontal,
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                ),
                onTap: (CalendarTapDetails details) {
                  if (details.targetElement == CalendarElement.calendarCell) {
                    setState(() {
                      selectedDate = details.date!;
                    });
                    _showTimelineModal(context);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? pickedStartTime = await showTimePicker(
                        context: context,
                        initialTime: selectedStartTime,
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF8B1111),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedStartTime != null) {
                        if (!_checkTimeOverlap(
                            selectedDate, pickedStartTime, selectedEndTime)) {
                          setState(() {
                            selectedStartTime = pickedStartTime;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(AppLocalizations.translate(
                                context, 'overlaptext1')),
                          ));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF8B1111), // Text color
                      elevation: 5, // Elevation
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // BorderRadius
                      ),
                    ),
                    child: Text(AppLocalizations.translate(
                        context, 'select-start-time')),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? pickedEndTime = await showTimePicker(
                        context: context,
                        initialTime: selectedEndTime,
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF8B1111),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedEndTime != null) {
                        if (!_checkTimeOverlap(
                            selectedDate, selectedStartTime, pickedEndTime)) {
                          setState(() {
                            selectedEndTime = pickedEndTime;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(AppLocalizations.translate(
                                context, 'overlaptext2')),
                          ));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF8B1111), // Text color
                      elevation: 5, // Elevation
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // BorderRadius
                      ),
                    ),
                    child: Text(
                        AppLocalizations.translate(context, 'select-end-time')),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  print('${AppLocalizations.translate(context, 'selected-date')}: $selectedDate');
                  print('${AppLocalizations.translate(context, 'start-time')}: $selectedStartTime');
                  print('${AppLocalizations.translate(context, 'end-time')}: $selectedEndTime');
                  if (!_checkTimeOverlap(
                      selectedDate, selectedStartTime, selectedEndTime)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Formater_screen(
                            email: widget.email,
                            date: selectedDate,
                            starttime: selectedStartTime,
                            endtime: selectedEndTime),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          AppLocalizations.translate(context, 'overlaptext3')),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF8B1111), // Text color
                  elevation: 5, // Elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // BorderRadius
                  ),
                ),
                child:
                    Text(AppLocalizations.translate(context, 'save-date-time')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _checkTimeOverlap(
      DateTime date, TimeOfDay startTime, TimeOfDay endTime) {
    List<Course>? courses = events[date];
    if (courses != null) {
      for (Course course in courses) {
        DateTime courseStartTime = DateTime(date.year, date.month, date.day,
            course.starttime.hour, course.starttime.minute);
        DateTime courseEndTime = DateTime(date.year, date.month, date.day,
            course.endtime.hour, course.endtime.minute);
        DateTime selectedStartDateTime = DateTime(
            date.year, date.month, date.day, startTime.hour, startTime.minute);
        DateTime selectedEndDateTime = DateTime(
            date.year, date.month, date.day, endTime.hour, endTime.minute);

        if ((selectedStartDateTime.isAfter(courseStartTime) &&
                selectedStartDateTime.isBefore(courseEndTime)) ||
            (selectedEndDateTime.isAfter(courseStartTime) &&
                selectedEndDateTime.isBefore(courseEndTime))) {
          return true;
        }

        if ((courseStartTime.isAfter(selectedStartDateTime) &&
                courseStartTime.isBefore(selectedEndDateTime)) ||
            (courseEndTime.isAfter(selectedStartDateTime) &&
                courseEndTime.isBefore(selectedEndDateTime))) {
          return true;
        }
      }
    }
    return false;
  }

  void _fetchCourses() async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedDate = formatter.format(selectedDate);
      final response = await http
          .get(Uri.parse('http://$ip:3002/courses?Date=$formattedDate'));
      print(formattedDate);
      if (response.statusCode == 200) {
        List<Course> courses = (json.decode(response.body) as List)
            .map((data) => Course.fromJson(data))
            .where((course) => course.status == 'active')
            .toList();

        setState(() {
          events[selectedDate] = courses;
        });

        _showTimelineModal(context);
      } else {
        throw Exception('Failed to fetch courses bro');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to fetch courses'),
      ));
    }
  }

  void _showTimelineModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        List<Course>? courses = events[selectedDate];
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Text(
                'Courses for ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: courses?.length ?? 0,
                  itemBuilder: (context, index) {
                    final course = courses![index];
                    final startTime = course.starttime;
                    final endTime = course.endtime;
                    return ListTile(
                      title: Row(
                        children: [
                          Text(
                              '${startTime.format(context)} - ${endTime.format(context)}'),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(course.prof),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(course.salle),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  CalendarDataSource _getCalendarDataSource() {
    List<Course> eventsList = events.values.expand((x) => x).toList();

    List<Meeting> appointments = eventsList
        .map((event) => Meeting(
              eventName: event.prof,
              from: _convertDateTimeToDateTime(event.date, event.starttime),
              to: _convertDateTimeToDateTime(event.date, event.endtime),
              background: Colors.green,
              isAllDay: false,
            ))
        .toList();

    return MeetingDataSource(appointments);
  }

  DateTime _convertDateTimeToDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}

class Meeting {
  Meeting({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
  });

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments?[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments?[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments?[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments?[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments?[index].isAllDay;
  }
}
