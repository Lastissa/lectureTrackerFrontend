import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:lecture_tracker/errorpage.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/screens/editCourse.dart';
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

    GoRoute(path: '/signup', builder: (context, state) => Signup()),
    GoRoute(path: '/Editcourse', builder: (context, state) => Editcourse()),
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
//The carrier of all the cards before the final push to the database ; did this incase the user close app while still regsitering
final decoyDB = StateProvider<List<Map>>((ref) {
  return [];
});
//The updator of the carrier cards
final updateDecoyDb = StateProvider.family((Ref ref, Map mapToAdd) {
  List<Map> formerList = ref.read(decoyDB);
  //{'title': '', 'start_time': '0:00 PM', 'end_time': '0:00 PM', 'dayOfTheWeek' : 'xxxxxxxx'}
  formerList.add(mapToAdd);
  ref.read(decoyDB.notifier).state = formerList;
});
//it is used for faster access to past lectures since calling SELECT * FROM  can kinda get slow so i use this one to mask it up as user won't even notice
final pastLectureSQLprovider = StateProvider<List>((ref) {
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
//in the signup, i have set the maximum allowed colors to be twelve by resetting 'index' to zero when it get to 12, edit that if i wanna add more colour
List<String> prefixColors = [
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
            decoration: BoxDecoration(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 71, vertical: 10),
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    clipBehavior: Clip.hardEdge,
                    child: CircleAvatar(
                      radius: 10,
                      child: Image.asset(
                        fit: BoxFit.fill,
                        'assets/staticImages/appicon2.png',
                        colorBlendMode: BlendMode.overlay,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: fg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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

//tommorow lectures
final tommorowLectureSQLprovider = StateProvider<List>((ref) {
  return [];
});
//2 days later lectures
final twoDaysLaterLectureSQLprovider = StateProvider<List>((ref) {
  return [];
});
//3 days later lectures
final threeDaysLaterLectureSQLprovider = StateProvider<List>((ref) {
  return [];
});
//4 days later lectures
final fourDaysLaterLectureSQLprovider = StateProvider<List>((ref) {
  return [];
});
//5 days later lectures
final fiveDaysLaterLectureSQLprovider = StateProvider<List>((ref) {
  return [];
});
//6 days later lectures
final sixDaysLaterLectureSQLprovider = StateProvider<List>((ref) {
  return [];
});

//colours
final foreGroundColor = StateProvider<Color>((ref) {
  Color toReturn = ref.watch(lightMode)
      ? Colors.blueAccent
      : Colors.greenAccent;
  return toReturn;
});
final backgroundColor = StateProvider<Color>((ref) {
  Color? toReturn = ref.watch(lightMode)
      ? (Colors.grey[100] ?? Colors.white)
      : Colors.black;
  return toReturn;
});
final lectureMissedIcon = StateProvider<IconData>((ref) {
  return Icons.thumb_down_alt;
});
final lectureAttendedIcon = StateProvider<IconData>((ref) {
  return Icons.thumb_up_alt;
});
final lectureCancelledIcon = StateProvider<IconData>((ref) {
  return Icons.multiple_stop_sharp;
});

//for faster re-usage
Widget customTextFeild({
  required WidgetRef ref,
  required TextEditingController controller,
  required bool isPassword,
  required Widget suffix,
  required Widget? prefix,
  required String? hint,
  required FormFieldValidator validator,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: ref.watch(lightMode)
              ? const Color.fromARGB(40, 0, 0, 0)
              : const Color.fromARGB(61, 0, 0, 0),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: ref.watch(foreGroundColor)),
      decoration: InputDecoration(
        suffixIcon: suffix,
        prefixIcon:
            prefix ?? Icon(Icons.people, color: ref.watch(foreGroundColor)),
        hintText: hint ?? 'empty',
        hintStyle: TextStyle(
          color: ref.watch(lightMode) ? Colors.grey[400] : Colors.grey[600],
        ),
        filled: true,
        fillColor: ref.watch(lightMode)
            ? Colors.white
            : const Color(0xFF1E1E1E),

        // Your OutlineInputBorder preferences
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: ref.watch(lightMode) ? Colors.blueAccent : Colors.tealAccent,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
      ),
      validator: validator,
    ),
  );
}
