import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lecture_tracker/errorpage.dart';
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
      path: '/error',
      builder: (context, state) {
        String messageToSend =
            state.extra
                as String; // the state.extra is for getting param from the context,go()
        return Errorpage(errorMessage: messageToSend);
      },
    ),
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

final username = StateProvider<String>((ref) {
  return "User";
});

//Light Mode or darkmode
final lightMode = StateProvider<bool>((ref) {
  return false;
});

final lecturesCard = StateProvider<List<Map>>((ref) {
  return [];
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

List<String> colors = [
  'deepOrange',
  'indigo',
  'teal',
  'blueAccent',
  'red',
  'green',
  'tealAccent',
  'cyanAccent',
  'deepOrangeAccent',
  'orangeAccent',
  'lightGreen',
  'indigoAccent',
  'redAccent',
];
//the color coming from the db only carries this
final ColorMapper = {
  'deepOrange': Colors.deepOrange,
  'indigo': Colors.indigo,
  'teal': Colors.teal,
  'blueAccent': Colors.blueAccent,
  'red': Colors.red,
  'green': Colors.green,
  'tealAccent': Colors.tealAccent,
  'cyanAccent': Colors.cyanAccent,
  'deepOrangeAccent': Colors.deepOrangeAccent,
  'orangeAccent': Colors.orangeAccent,
  'lightGreen': Colors.lightGreen,
  'indigoAccent': Colors.indigoAccent,
  'redAccent': Colors.redAccent,
};
//The carrier of all the cards before the final push to the database ; did this incase the user close app while still regsitering
final decoyDB = StateProvider<List<Map>>((ref) {
  return [
    // {
    //   'title': 'MON 101',
    //   'start_time': '2:00 PM',
    //   'end_time': '3:00 PM',
    //   'dayOfTheWeek': 'Monday',
    //   'color':
    //       colors[0], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    // },
    // {
    //   'title': 'MON 101',
    //   'start_time': '3:00 PM',
    //   'end_time': '4:00 PM',
    //   'dayOfTheWeek': 'Monday',
    //   'color':
    //       colors[1], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    // },
    // {
    //   'title': 'TUES 101',
    //   'start_time': '2:00 PM',
    //   'end_time': '3:00 PM',
    //   'dayOfTheWeek': 'Tueday',
    //   'color':
    //       colors[2], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    // },
    // {
    //   'title': 'TUES 101',
    //   'start_time': '3:00 PM',
    //   'end_time': '4:00 PM',
    //   'dayOfTheWeek': 'Tuesday',
    //   'color':
    //       colors[3], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    // },
    // {
    //   'title': 'WED 101',
    //   'start_time': '2:00 PM',
    //   'end_time': '3:00 PM',
    //   'dayOfTheWeek': 'Wednesday',
    //   'color':
    //       colors[4], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    // },
    // {
    //   'title': 'WED 101',
    //   'start_time': '3:00 PM',
    //   'end_time': '4:00 PM',
    //   'dayOfTheWeek': 'Wednesday',
    //   'color':
    //       colors[5], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    // },
    // {
    //   'title': 'THURS 101',
    //   'start_time': '2:00 PM',
    //   'end_time': '3:00 PM',
    //   'dayOfTheWeek': 'Thursday',
    //   'color':
    //       colors[6], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    // },
    // {
    //   'title': 'THURS 101',
    //   'start_time': '3:00 PM',
    //   'end_time': '4:00 PM',
    //   'dayOfTheWeek': 'Thursday',
    //   'color':
    //       colors[7], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    // },
    // {
    //   'title': 'FRI COS 101',
    //   'start_time': '2:00 PM',
    //   'end_time': '3:00 PM',
    //   'dayOfTheWeek': 'Friday',
    //   'color':
    //       colors[8], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    // },
    // {
    //   'title': 'FRI STA 101',
    //   'start_time': '3:00 PM',
    //   'end_time': '4:00 PM',
    //   'dayOfTheWeek': 'Sunday',
    //   'color':
    //       colors[9], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    // },
    // {
    //   'title': 'FRI PHY 101',
    //   'start_time': '4:30 PM',
    //   'end_time': '6:00 PM',
    //   'dayOfTheWeek': 'Sunday',
    //   'color':
    //       colors[10], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    // },
    // {
    //   'title': 'FRI BIO 101',
    //   'start_time': '6:00 PM',
    //   'end_time': '7:00 PM',
    //   'dayOfTheWeek': 'Sunday',
    //   'color':
    //       colors[11], //this will be chosen at random from a list using the course name as refrence as it is about to enter db and then onwards take a permanent value
    // },
  ];
});

//The updator of the carrier cards
final updateDecoyDb = StateProvider.family((Ref ref, Map mapToAdd) {
  List<Map> formerList = ref.read(decoyDB);
  //{'title': '', 'start_time': 'x:xx PM', 'end_time': 'x:xx PM', 'dayOfTheWeek' : 'xxxxxxxx'}
  formerList.add(mapToAdd);
  ref.read(decoyDB.notifier).state = formerList;
});

//it is used for faster access to past lectures since calling SELECT * FROM  can kinda get slow so i use this one to mask it up as user won't even notice
final pastLectureSQLprovider = StateProvider<List>((ref) {
  return [
    {
      'title': 'No PAST LECTURE',
      'date': DateFormat.yMMMEd().format(DateTime.now()),
      'accomplised': 1, //zero mean false, 1 mean true
    },
  ];
});
//today's remaining lecture
final remainingLectureroviderForToday = StateProvider((ref) {
  return []; //pass the main list here and upon every attend or miss, remove the lecture from the list and update the provider, this will make sure the list is always up to date and also make it easier to access the remaining lectures for today without having to filter through the main list every time
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
