import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lecture_tracker/screens/cardOverlay.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/screens/settings.dart';
import 'package:lecture_tracker/screens/signup.dart';
import 'package:lecture_tracker/screens/splashScreen.dart';

GoRouter router = GoRouter(
  initialLocation: "/splashScreen",
  routes: [
    GoRoute(path: "/dashboard", builder: (context, state) => Dashboard()),
    GoRoute(path: "/settings", builder: (context, state) => Settings()),
    GoRoute(path: '/splashScreen', builder: (context, state) => Splashscreen()),
    GoRoute(
      path: '/overlay',
      builder: (context, state) =>
          Cardoverlay(courseName: currentCourseCode.name),
    ),
    GoRoute(path: '/signup', builder: (context, state) => Signup()),
  ],
);

GoRouter get routerConfig => router;

final deviceSizeX = Provider<double>((ref) {
  return 360;
});

final deviceSizeY = Provider<double>((ref) {
  return 766;
});

final userName = StateProvider<String>((ref) {
  return "User";
});

//Light Mode or darkmode
final lightMode = StateProvider<bool>((ref) {
  return false;
});

// //this is just a decoy, the real user data will be updated to the database
// List userCourseInfo = [
//   // {
//   //   'title': 'COS 102',
//   //   'start_time': '9:00 AM',
//   //   'end_time': '11:00 AM',
//   //   'color': Colors.teal,
//   // },
//   // {
//   //   'title': 'STA 112',
//   //   'start_time': '11:30 AM',
//   //   'end_time': '01:00 AM',
//   //   'color': Colors.indigo,
//   // },
//   // {
//   //   'title': 'PHY 102',
//   //   'start_time': '2:00 AM',
//   //   'end_time': '3:00 PM',
//   //   'color': Colors.deepOrange,
//   // },
//   {
//     'title': 'SAMPLE',
//     'start_time': 'start',
//     'end_time': 'end',
//     'color': Colors.deepOrange,
//   },
// ];

//The carrier of all the cards before the final push to the database ; did this incase the user close app while still regsitering
final lecturesCard = StateProvider<List<Map>>((ref) {
  return [];
});
//The updator of the carrier cards
final updateLectureCard = StateProvider.family((Ref ref, Map mapToAdd) {
  List<Map> formerList = ref.read(lecturesCard);
  //{'title': '', 'start_time': 'x:xx PM', 'end_time': 'x:xx PM', 'dayOfTheWeek' : 'xxxxxxxx'}
  formerList.add(mapToAdd);
  ref.read(lecturesCard.notifier).state = formerList;
});

//since the day of the week gotten from the lecturecard provider is in words e.g monday, tuesday etc but the weekday in datetime uses 1,2,etc, i need a list to do the conversion
//any chnage made directly here require the whole app to be refreshed before it will show; still do not understand why cos na riverpod i dey use, it no suppose do like that but it is what it is
final wordWeekdayToInt = StateProvider<List<String>>((ref) {
  return [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
});

//since i am done with the signup and upon create account, the lectureCard provider will pass off to the db, i need to use a decoy map to get all the dayOftheweeks
//i am going to store the data in the db like this
//index - title - start_time - end_time - day of the week
// 0    - cos   - 1:10 PM    - 2 : 10PM -  Monday

// a db store data like list(map())

List colors = [
  Colors.deepOrange,
  Colors.indigo,
  Colors.teal,
  Colors.blueAccent,
  Colors.green,
  Colors.tealAccent,
  Colors.cyanAccent,
  Colors.deepOrangeAccent,
  Colors.orangeAccent,
  Colors.lightGreen,
  Colors.indigoAccent,
  Colors.redAccent,
];
final decoyDB = StateProvider((ref) {
  return [
    {
      'title': 'MON 101',
      'start_time': '2:00 PM',
      'end_time': '3:00 PM',
      'dayOfTheWeek': 'Monday',
      'color':
          colors[0], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    },
    {
      'title': 'MON 101',
      'start_time': '3:00 PM',
      'end_time': '4:00 PM',
      'dayOfTheWeek': 'Monday',
      'color':
          colors[1], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    },
    {
      'title': 'TUES 101',
      'start_time': '2:00 PM',
      'end_time': '3:00 PM',
      'dayOfTheWeek': 'Tueday',
      'color':
          colors[2], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    },
    {
      'title': 'TUES 101',
      'start_time': '3:00 PM',
      'end_time': '4:00 PM',
      'dayOfTheWeek': 'Tuesday',
      'color':
          colors[3], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    },
    {
      'title': 'WED 101',
      'start_time': '2:00 PM',
      'end_time': '3:00 PM',
      'dayOfTheWeek': 'Wednesday',
      'color':
          colors[4], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    },
    {
      'title': 'WED 101',
      'start_time': '3:00 PM',
      'end_time': '4:00 PM',
      'dayOfTheWeek': 'Wednesday',
      'color':
          colors[5], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    },
    {
      'title': 'THURS 101',
      'start_time': '2:00 PM',
      'end_time': '3:00 PM',
      'dayOfTheWeek': 'Thursday',
      'color':
          colors[6], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    },
    {
      'title': 'THURS 101',
      'start_time': '3:00 PM',
      'end_time': '4:00 PM',
      'dayOfTheWeek': 'Thursday',
      'color':
          colors[7], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    },
    {
      'title': 'FRI COS 101',
      'start_time': '2:00 PM',
      'end_time': '3:00 PM',
      'dayOfTheWeek': 'Friday',
      'color':
          colors[8], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    },
    {
      'title': 'FRI STA 101',
      'start_time': '3:00 PM',
      'end_time': '4:00 PM',
      'dayOfTheWeek': 'Friday',
      'color':
          colors[9], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    },
    {
      'title': 'FRI PHY 101',
      'start_time': '4:30 PM',
      'end_time': '6:00 PM',
      'dayOfTheWeek': 'Friday',
      'color':
          colors[10], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    },
    {
      'title': 'FRI BIO 101',
      'start_time': '6:00 PM',
      'end_time': '7:00 PM',
      'dayOfTheWeek': 'Sunday',
      'color':
          colors[11], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    },
  ];
});

//the holder of the previous ticks by the user
final pastLectureSQLDecoy = StateProvider<List>((ref) {
  return [
    {
      'title': 'No PAST LECTURE',
      'date': DateFormat.yMMMEd().format(DateTime.now()),
      'accomplised': 1, //zero mean false, 1 mean true
    },
  ];
});

ScaffoldFeatureController? notifier({
  required BuildContext context,
  String? message,
  Color? bg,
  Color? fg,
}) {
  bg = bg ?? Colors.grey[40];
  fg = fg ?? Colors.white;
  if (ScaffoldMessenger.of(context).mounted) {
    message = message ?? "page refreshed";
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 1100),
        content: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bg,

              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: fg,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }
  return null;
}


//the db tables will be splitted into two part
//1. This one holds the real data for the user, this table hold every classes the user can have within a week 
//2. Thid one holds the decoy data(not decoy entirely) but this one holds the upcoming list for the day and it reset everyday (what diff it from the former is that it filter out already picked cards)
//3. This one holds the record of past lecture, soon as you click on the attend / miss in overlay, a row will be created here.

//the upcoming lectures will come from the decoy data tables.
