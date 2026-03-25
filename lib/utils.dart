import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lecture_tracker/screens/cardOverlay.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/screens/settings.dart';
import 'package:lecture_tracker/screens/signup.dart';
import 'package:lecture_tracker/splahscreen.dart';

GoRouter router = GoRouter(
  initialLocation: "/dashboard",

  routes: [
    GoRoute(path: "/dashboard", builder: (context, state) => Dashboard()),
    GoRoute(path: "/splashscreen", builder: (context, state) => Splahscreen()),
    GoRoute(path: "/settings", builder: (context, state) => Settings()),
    GoRoute(
      path: '/overlay',
      builder: (context, state) =>
          cardOverlay(courseName: currentCourseCode.name),
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

List dayTracker = [];

//user interface configuration
//Light Mode
final lightMode = StateProvider<bool>((ref) {
  return true;
});

//Dark Mode

//this is just a decoy, the real user data will be updated to the database
List userCourseInfo = [
  // {
  //   'title': 'COS 102',
  //   'start_time': '9:00 AM',
  //   'end_time': '11:00 AM',
  //   'color': Colors.teal,
  // },
  // {
  //   'title': 'STA 112',
  //   'start_time': '11:30 AM',
  //   'end_time': '01:00 AM',
  //   'color': Colors.indigo,
  // },
  // {
  //   'title': 'PHY 102',
  //   'start_time': '2:00 AM',
  //   'end_time': '3:00 PM',
  //   'color': Colors.deepOrange,
  // },
  {
    'title': 'SAMPLE',
    'start_time': 'start',
    'end_time': 'end',
    'color': Colors.deepOrange,
  },
];
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
// final deleteLectureCard = StateProvider((ref) {
//    List<Map> formerList = ref.read(lecturesCard);
//    formerList = formerList.
// });//delete the last entry in the provider
final currentCourseCode = StateProvider((ref) {
  return 'NULL';
});

List pastLectureSQLDecoy = [
  {
    'title': 'TESTING',
    'date': DateFormat.yMMMEd().format(DateTime.now()),
    'accomplised': false,
  },
];

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
