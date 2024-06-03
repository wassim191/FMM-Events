import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medcine/Category.dart';
import 'package:medcine/Coursebody.dart';
import 'package:medcine/GetStarted.dart';
import 'package:medcine/Signin.dart';
import 'package:medcine/Wishlistcont.dart';
import 'package:medcine/changenameuser.dart';
import 'package:medcine/changepasswordpage.dart';
import 'package:medcine/courseforcategory.dart';
import 'package:medcine/latermonthcourse.dart';
import 'package:medcine/locales/strings.dart';
import 'package:medcine/qrcodescanner.dart';
import 'package:medcine/studenthome.dart';
import 'ChangePhotoPage.dart';
import 'package:medcine/.env';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Help.dart';

import 'infoPage.dart';
import 'main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class Course {
  final String thumbnailUrl;
  final String name;
  final String instructor;
  final double price;

  Course({
    required this.thumbnailUrl,
    required this.name,
    required this.instructor,
    required this.price,
  });
}

class Home extends StatefulWidget {
  final String email;
  final String userName;
  const Home({
    super.key,
    required this.email,
    required this.userName,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  late final List<Course> _wishlist = [
    Course(
      thumbnailUrl: 'thumbnail_url_1',
      name: 'Course 1',
      instructor: 'Salem',
      price: 49.99,
    ),
    Course(
      thumbnailUrl: 'thumbnail_url_2',
      name: 'Course 2',
      instructor: 'Mohsen',
      price: 29.99,
    ),
  ];

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      _HomeBody(
        email: widget.email,
        userName: widget.userName,
      ),
      _LearnBody(email: widget.email),
      WishlistPage(wishlist: _wishlist),
      _AccountBody(email: widget.email),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: const Color(0xFF832121),
        activeColor: Colors.white,
        color: const Color(0xFFA49494),
        style: TabStyle.flip,
        elevation: 2.0,
        top: -25.0, // Adjust the top padding if needed
        curveSize: 100.0, // Set the size of the curve
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.book, title: 'Learn'),
          TabItem(icon: Icons.favorite, title: 'Wishlist'),
          TabItem(icon: Icons.account_circle, title: 'Account'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CategoryBox extends StatelessWidget {
  final String title;
  final String ImagePath;

  const CategoryBox({Key? key, required this.title, required this.ImagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Container(
          height: 85,
          width: 85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImagePath, // Use AssetImage for icon image
                width: 50,
                height: 50,
              ),
              SizedBox(
                height: 10,
                width: 20,
              ),
              Text(title,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final String email;
  final String userName;

  const _HomeBody({required this.email, required this.userName});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final Size screenSize = MediaQuery.of(context).size;
    var height = size.height;
    final bool isSmallScreen = screenSize.width <= 768;
    var width = size.width;
    return Scaffold(
      body: Column(
        children: [
          CustomTopBar(userName: userName),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.22, // Adjust the height as needed
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.translate(context, 'category'),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Category(email: email)),
                                  );
                                }, // Call the callback function here
                                child: Text(
                                  AppLocalizations.translate(context, 'seeall'),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFA49494)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            // Adjust the height as needed
                            child: SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal, // Allow horizontal scrolling
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CourseforCategory(
                                                  email: email,
                                                )),
                                      );
                                    },
                                    child: CategoryBox(
                                        title: 'Anatomy',
                                        ImagePath:
                                            'assets/Category/anatomy.png'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CourseforCategory(
                                                    email: email)),
                                      );
                                    }, //
                                    child: CategoryBox(
                                        title: 'UI/UX',
                                        ImagePath: 'assets/Category/ui-ux.png'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CourseforCategory(
                                                    email: email)),
                                      );
                                    }, //
                                    child: CategoryBox(
                                        title: 'Mobile Dev',
                                        ImagePath:
                                            'assets/Category/icons8-mobile-development-100.png'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CourseforCategory(
                                                    email: email)),
                                      );
                                    }, //
                                    child: CategoryBox(
                                        title: 'Data Science',
                                        ImagePath:
                                            'assets/Category/icons8-data-science-100.png'),
                                  ),
                                  // Add more CategoryBox widgets for additional categories
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.345, // Adjust the height as needed
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.translate(
                                    context, 'this-week'),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            _LearnBody(email: email)),
                                  );
                                }, // Call the callback function here
                                child: Text(
                                  AppLocalizations.translate(context, 'seeall'),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFA49494)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height / 4,
                            child: Expanded(
                                child: CourseListScreen(emaill: email)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.38,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.translate(
                                    context, 'later-next-week'),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            _LearnBody(email: email)),
                                  );
                                }, // Call the callback function here
                                child: Text(
                                  AppLocalizations.translate(context, 'seeall'),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFA49494)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height / 4,
                            child:
                                Expanded(child: Laterthismonth(emaill: email)),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTopBar extends StatelessWidget {
  final String userName;

  const CustomTopBar({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        right: 10,
        left: 10,
      ),
      height: MediaQuery.of(context).size.height * 0.18,
      decoration: const BoxDecoration(
        color: Color(0xFF832121),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.translate(context, 'welcome_back_txt')} $userName,',
                    style: const TextStyle(
                        color: Color(0xFFA49494),
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.translate(context, 'Search_t1'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 15),
                  // Add spacing between welcome message and search bar
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    bool hasNotifications =
        false; // Replace with your logic to check if there are notifications

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            height: height / 4,
            width: width,
            decoration: const BoxDecoration(
              color: Color(0xFF832121),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
            ),
            child: Positioned(
              top: 1, // Adjust position based on logo size
              left: 3,
              right: 3, // Center horizontally
              child: Image.asset(
                'assets/defaultProfilePic/ic_profile.png', // Replace with your image path
                height: 200,
                width: 200, // Ensure full image coverage
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: height / 4 + 20, left: 35, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Add some space to the left
                const Text(
                  'Notification',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // Add some space to the right
              ],
            ),
          ),
          if (hasNotifications)
            Container(
              padding: EdgeInsets.only(top: height / 2, left: 20, right: 20),
              child: ListView.builder(
                itemCount: 3, // Replace with the actual number of notifications
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Notification $index'),
                    subtitle: Text('Notification message $index'),
                  );
                },
              ),
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height / 4,
                  ),
                  const Icon(
                    Icons.notifications_off,
                    size: 200,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.translate(context, 'notif-t1'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.translate(context, 'notif-t2'),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
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

class _LearnBody extends StatefulWidget {
  final String email;

  const _LearnBody({required this.email});

  @override
  _LearnBodyState createState() => _LearnBodyState();
}

class _LearnBodyState extends State<_LearnBody> {
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
        backgroundColor: const Color(0xFF832121),
        title: Text(
          AppLocalizations.translate(context, 'All-courses'),
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Filter:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFilterOption,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 8,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                        onChanged: (String? value) {
                          if (value != null) {
                            _updateFilteredCourses(value);
                          }
                        },
                        items: [
                          DropdownMenuItem(
                            value: 'All',
                            child: Text(
                                AppLocalizations.translate(context, 'all')),
                          ),
                          DropdownMenuItem(
                            value: 'This week',
                            child: Text(AppLocalizations.translate(
                                context, 'this-week')),
                          ),
                          DropdownMenuItem(
                            value: 'Next week',
                            child: Text(AppLocalizations.translate(
                                context, 'later-next-week')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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

class WishlistPage extends StatefulWidget {
  final List<Course> wishlist;

  const WishlistPage({super.key, required this.wishlist});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  void _removeCourse(int index) {
    setState(() {
      widget.wishlist.removeAt(index); // Remove course from the wishlist
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF832121),
        centerTitle: true,
      ),
      body: _WishlistBody(),
    );
  }
}

class _WishlistBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: _WishlistContListener(),
          ),
        ],
      ),
    );
  }
}

class _WishlistContListener extends StatefulWidget {
  @override
  _WishlistContListenerState createState() => _WishlistContListenerState();
}

class _WishlistContListenerState extends State<_WishlistContListener> {
  final _valueNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _valueNotifier,
      builder: (context, hasChanged, child) {
        if (hasChanged) {}
        return Wishlistcont(
          onContentChange: () {
            _valueNotifier.value = true;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }
}

class _AccountBody extends StatelessWidget {
  final String email;
  const _AccountBody({required this.email});
  @override
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  Future<void> deleteToken(String token, String email) async {
    try {
      var response = await http.put(
        Uri.parse("http://$ip:3002/deletetokenuser"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'token': token,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        print('Token deleted successfully');

        // Handle successful token deletion
      } else if (response.statusCode == 404) {
        print('User not found');
        // Handle user not found
      } else {
        print('Failed to delete token. Status code: ${response.statusCode}');
        // Handle other errors
      }
    } catch (error) {
      print('Error deleting token: $error');
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 58, right: 10, left: 10),
                height: height / 4,
                width: width,
                decoration: const BoxDecoration(
                  color: Color(0xFF832121),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(0)),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: height / 4 + 20, left: 35, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Add some space to the left
                    Text(
                      AppLocalizations.translate(context, 'Account'),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Add some space to the right
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding:
                    EdgeInsets.only(top: height / 4 + 80, left: 14, right: 15),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            ChangeDataPage(email: email),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 280),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.edit_document,
                        color: Colors.black,
                        size: 25,
                      ),
                      const SizedBox(width: 10), // Adjust as needed
                      Expanded(
                        child: Text(
                          AppLocalizations.translate(
                              context, 'Change_personl_data'),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.navigate_next,
                        color: Colors.black,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: height / 4 + 140, left: 14, right: 15),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const InfoPage(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 280),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.info,
                        color: Colors.black,
                        size: 25,
                      ),
                      const SizedBox(width: 10), // Adjust as needed
                      Expanded(
                        child: Text(
                          AppLocalizations.translate(
                              context, 'App Information'),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.navigate_next,
                        color: Colors.black,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: height / 4 + 200, left: 14, right: 15),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => Qrscanner(email: email),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 280),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.qr_code,
                        color: Colors.black,
                        size: 25,
                      ),
                      const SizedBox(width: 10), // Adjust as needed
                      Expanded(
                        child: Text(
                          AppLocalizations.translate(context, 'qrcode'),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.navigate_next,
                        color: Colors.black,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: height / 4 + 260, left: 14, right: 15),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const ChangeLanguagePage(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 280),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.language,
                        color: Colors.black,
                        size: 25,
                      ),
                      const SizedBox(width: 10), // Adjust as needed
                      Expanded(
                        child: Text(
                          AppLocalizations.translate(context, 'change_lang'),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.navigate_next,
                        color: Colors.black,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding:
                    EdgeInsets.only(top: height / 4 + 320, left: 14, right: 15),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const helpPage(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 280),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.help,
                        color: Colors.black,
                        size: 25,
                      ),
                      const SizedBox(width: 10), // Adjust as needed
                      Expanded(
                        child: Text(
                          AppLocalizations.translate(context, 'help'),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.navigate_next,
                        color: Colors.black,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: InkWell(
              onTap: () async {
                String fCMToken = (await _firebaseMessaging.getToken())!;
                String userEmail = email;
                try {
                  var response = await http.put(
                    Uri.parse("http://$ip:3002/deletetokenuser"),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, String>{
                      'token': fCMToken,
                      'email': email,
                    }),
                  );

                  if (response.statusCode == 200) {
                    print('Token deleted successfully');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Signin(),
                      ),
                    );
                    // Handle successful token deletion
                  } else if (response.statusCode == 404) {
                    print('User not found');
                    // Handle user not found
                  } else {
                    print(
                        'Failed to delete token. Status code: ${response.statusCode}');
                    // Handle other errors
                  }
                } catch (error) {
                  print('Error deleting token: $error');
                  // Handle errors
                }
              },
              child: Container(
                child: Text(
                  AppLocalizations.translate(context, 'log_out'),
                  style: const TextStyle(
                    color: Color(0xFFFF0000),
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChangeDataPage extends StatelessWidget {
  final String email;
  const ChangeDataPage({super.key, required this.email});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            height: height / 4,
            width: width,
            decoration: const BoxDecoration(
              color: Color(0xFF832121),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
            ),
            child: Center(
              child: Image.asset(
                'assets/changedata/personal-data.png',
                width: 200, // Set a fixed width for the image
                height: 200,
                // Set a fixed height for the image
                // Ensure full image coverage
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: height / 4 + 20, left: width / 25, right: width / 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Add some space to the left
                Text(
                  AppLocalizations.translate(context, 'Change_personl_data'),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // Add some space to the right
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: height / 4 + 80, left: 14, right: 15),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const Changenameuser(),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 280),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.drive_file_rename_outline,
                    color: Colors.black,
                    size: 25,
                  ),
                  const SizedBox(width: 10), // Adjust as needed
                  Expanded(
                    child: Text(
                      AppLocalizations.translate(context, 'change_name'),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.navigate_next,
                    color: Colors.black,
                    size: 35,
                  ),
                ],
              ),
            ),
          ),
          /*Container(
            padding:
                EdgeInsets.only(top: height / 4 + 140, left: 14, right: 15),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const ChangePhotoPage(),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 280),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.black,
                    size: 25,
                  ),
                  const SizedBox(width: 10), // Adjust as needed
                  Expanded(
                    child: Text(
                      AppLocalizations.translate(context, 'Profile_pic'),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.navigate_next,
                    color: Colors.black,
                    size: 35,
                  ),
                ],
              ),
            ),
          ),*/
          Container(
            padding:
                EdgeInsets.only(top: height / 4 + 140, left: 14, right: 15),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ChangePass(email: email),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 280),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.security,
                    color: Colors.black,
                    size: 25,
                  ),
                  const SizedBox(width: 10), // Adjust as needed
                  Expanded(
                    child: Text(
                      AppLocalizations.translate(context, 'change_password'),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.navigate_next,
                    color: Colors.black,
                    size: 35,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChangeLanguagePage extends StatefulWidget {
  const ChangeLanguagePage({super.key});

  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  late Locale _selectedLocale;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLocale = Localizations.localeOf(context);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            height: height / 4,
            width: width,
            decoration: const BoxDecoration(
              color: Color(0xFF832121),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
            ),
            child: Center(
              child: Image.asset(
                'assets/langimg/communication.png',
                width: 200, // Set a fixed width for the image
                height: 200,
                // Set a fixed height for the image
                // Ensure full image coverage
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: height / 4 + 20, left: width / 30, right: width / 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.translate(context, 'change_lang'),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height / 4 + 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (Locale locale in AppLocalizations.supportedLocales)
                    Column(
                      children: [
                        FlagButton(
                          locale: locale,
                          onPressed: (selectedLocale) {
                            setState(() {
                              _selectedLocale = selectedLocale;
                            });
                            MyApp.setLocale(context, selectedLocale);
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(
                            height: 30), // Add some space between buttons
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FlagButton extends StatelessWidget {
  final Locale locale;
  final Function onPressed;

  const FlagButton({super.key, required this.locale, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: ClipOval(
          clipBehavior: Clip.antiAlias,
          child: ElevatedButton(
            onPressed: () => onPressed(locale),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: const Color(0xFFFFD2B9).withOpacity(1),
              elevation: 0,
              minimumSize: const Size(160, 160),
            ),
            child: Image.asset(
              "assets/flags/${locale.languageCode}.png",
              width: 120,
              height: 120,
            ),
          ),
        ),
      ),
    );
  }
}

double calculateSpacing(double screenWidth, double iconSize) {
  // Subtracting icon size and some additional padding for the space between icon and text
  return screenWidth - iconSize - 180;
}
