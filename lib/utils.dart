import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:go_router/go_router.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/screens/settings.dart';
import 'package:lecture_tracker/splahscreen.dart';

GoRouter router = GoRouter(
  initialLocation: "/dashboard",
  routes: [
    GoRoute(path: "/dashboard", builder: (context, state) => Dashboard()),
    GoRoute(path: "/splashscreen", builder: (context, state) => Splahscreen()),
    GoRoute(path: "/settings", builder: (context, state) => Settings()),
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

List dayTracker = [];

//user interface configuration
//Light Mode
final lightMode = StateProvider<bool>((ref) {
  return true;
});

//Dark Mode

// final userLectureInfo = StateProvider<List<Map<String, dynamic>>>((ref) {
//   return [
//     {
//       'title': 'COS 102',
//       'start_time': '9:00 AM',
//       'end_time': '11:00 AM',
//       'color': Colors.teal,
//     },
//     {
//       'title': 'STA 112',
//       'start_time': '11:30 AM',
//       'end_time': '01:00 AM',
//       'color': Colors.indigo,
//     },
//     {
//       'title': 'PHY 102',
//       'start_time': '2:00 AM',
//       'end_time': '3:00 PM',
//       'color': Colors.deepOrange,
//     },
//   ];
// });

//this is just a decoy, the real user data will be updated to the database
List userCourseInfo = [
  {
    'title': 'COS 102',
    'start_time': '9:00 AM',
    'end_time': '11:00 AM',
    'color': Colors.teal,
  },
  {
    'title': 'STA 112',
    'start_time': '11:30 AM',
    'end_time': '01:00 AM',
    'color': Colors.indigo,
  },
  {
    'title': 'PHY 102',
    'start_time': '2:00 AM',
    'end_time': '3:00 PM',
    'color': Colors.deepOrange,
  },
];
