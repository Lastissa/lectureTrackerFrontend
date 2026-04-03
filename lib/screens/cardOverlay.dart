import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lecture_tracker/db.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/utils.dart';
import 'package:sqflite/sqlite_api.dart';

class Cardoverlay extends ConsumerStatefulWidget {
  const Cardoverlay({
    super.key,
    this.courseName,
    required this.start_time,
    required this.end_time,
    required this.dayOfTheWeek,
    required this.color,
  });
  final String? courseName;
  final String start_time;
  final String end_time;
  final String dayOfTheWeek;
  final String color;

  @override
  ConsumerState<Cardoverlay> createState() => _cardOverlayState();
}

Future<void> _buttonClicked({
  required WidgetRef ref, //bcos of the invalidate i am doing
  required BuildContext context, //bcos of the notifier i am using
  required Color bg, //bcos of the notifier i am using
  required String message, //bcos of the notifier i am using
  required String title, //for the sql and pastlecture riverpod update
  required int accomplished, //for the sql and pastlecture riverpod update
  required String courseName,
  required String start_time,
  required String end_time,
  required String dayOfTheWeek,
  required String color,
}) async {
  await ScaffoldMessenger.of(context).clearSnackBars;

  notifier(context: context, message: message, bg: bg);
  ref.invalidate(
    lectureCardActive,
  ); //so that the cardOverLay will leave automatically

  //update the data into the sql table for pastLectures
  Database locator = await CustomDbClass.instance.getter;
  //for updating the lecture history - table name is lectureTrackers
  insertIntoPastLectureTrackers(
    dbLocator: locator,
    title: title,
    date: DateFormat.yMMMEd().format(
      DateTime.now(),
    ), //to add the current date Sun, Mar 29, 2026
    accomplised: accomplished,
  );
  //fetch the new updated table again so i will pass it into the provider
  List<Map> fetchDataFromDb = await fetchAll(
    dbLocator: locator,
    tableName: 'lectureTrackers',
    limit: 500,
  );
  //passing the data from the db to the provider to avoid calling the db constantly while app is running
  ref.read(pastLectureSQLprovider.notifier).state = fetchDataFromDb;

  //this is for updating the stuff in today lecture table and the decoydb riverpod
  //del the entered card from it
  locator.rawDelete(
    "DELETE FROM todayLectures WHERE title = ? AND start_time = ? AND  end_time = ? AND dayOfTheWeek = ? AND color = ?",
    [courseName, start_time, end_time, dayOfTheWeek, color],
  );
  //fetch the new updated table
  List<Map> allData = await fetchAll(
    dbLocator: locator,
    tableName: 'todayLectures',
    limit: 1000,
  );
  ref.read(decoyDB.notifier).state = allData;
  //update the today date hive box so the splashscrren knows it is supposed to load from today lectures and not main table
  await lookForSettingBox().put('todayDate', DateTime.now().day);
}

class _cardOverlayState extends ConsumerState<Cardoverlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ref.watch(lightMode)
            ? Colors.blueAccent
            : const Color.fromARGB(255, 4, 24, 59),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: ref.watch(lightMode) ? Colors.black38 : Colors.black87,
            offset: Offset(2, 2),
            blurRadius: 3,
          ),

          BoxShadow(
            color: ref.watch(lightMode) ? Colors.black38 : Colors.black87,
            offset: Offset(-2, 0),
            blurRadius: 3,
          ),
        ],
      ),
      height: 190,
      width: 200,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.courseName?.toUpperCase() ?? 'ERROR',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ref.watch(lightMode) ? Colors.black87 : Colors.white70,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onLongPress: () async {
                  await ScaffoldMessenger.of(context).clearSnackBars;
                  notifier(
                    context: context,
                    message: 'When Lecture is Attended',
                    bg: Colors.blueAccent,
                  );
                },
                onPressed: () => _buttonClicked(
                  //Click the _buttonClikced to view more info
                  ref: ref,
                  context: context,
                  bg: Colors.green,
                  message: 'Weldone 👍',
                  title: widget.courseName?.toUpperCase() ?? '',
                  accomplished: 1,
                  courseName: widget.courseName ?? '',
                  start_time: widget.start_time,
                  end_time: widget.end_time,
                  dayOfTheWeek: widget.dayOfTheWeek,
                  color: widget.color,
                ),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,

                  padding: EdgeInsets.all(15),
                  backgroundColor: ref.watch(lightMode)
                      ? Colors.green
                      : const Color.fromARGB(155, 5, 70, 43),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(6)),
                  ),
                ),
                child: Center(
                  child: Text(
                    "ATTEND",
                    style: TextStyle(
                      color: ref.watch(lightMode) ? Colors.white : Colors.white,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onLongPress: () {
                  notifier(
                    context: context,
                    message: 'When Lecture is Missed',
                    bg: Colors.blueAccent,
                  );
                },
                onPressed: () => _buttonClicked(
                  //Click the _buttonClikced to view more info
                  ref: ref,
                  context: context,
                  bg: Colors.red,
                  message: 'Do Not Miss Lecture Again!!!',
                  title: widget.courseName?.toUpperCase() ?? '',
                  accomplished: 0,
                  courseName: widget.courseName ?? '',
                  start_time: widget.start_time,
                  end_time: widget.end_time,
                  dayOfTheWeek: widget.dayOfTheWeek,
                  color: widget.color,
                ),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,

                  padding: EdgeInsets.all(15),
                  backgroundColor: ref.watch(lightMode)
                      ? Colors.black54
                      : const Color.fromARGB(179, 27, 40, 114),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(6)),
                  ),
                ),
                child: Center(
                  child: Text(
                    "MISSED",
                    style: TextStyle(
                      color: ref.watch(lightMode) ? Colors.white : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onLongPress: () async {
                    await ScaffoldMessenger.of(context).clearSnackBars;
                    notifier(
                      context: context,
                      message: 'Close the interface',
                      bg: Colors.blueAccent,
                    );
                  },
                  onPressed: () {
                    ref.invalidate(currentCourseCode);
                    ref.invalidate(lectureCardActive);
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,

                    padding: EdgeInsets.all(15),
                    backgroundColor: ref.watch(lightMode)
                        ? const Color.fromARGB(223, 202, 66, 56)
                        : const Color.fromARGB(199, 110, 38, 33),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(6),
                      ),
                    ),
                  ),
                  child: Text("X", style: TextStyle(color: Colors.white)),
                ),

                ElevatedButton(
                  onLongPress: () {
                    notifier(
                      context: context,
                      message: 'When Lecture is Nullfied',
                      bg: Colors.blueAccent,
                    );
                  },
                  onPressed: () => _buttonClicked(
                    //Click the _buttonClikced to view more info
                    ref: ref,
                    context: context,
                    bg: Colors.blueAccent,
                    message: 'ple',
                    title: widget.courseName?.toUpperCase() ?? '',
                    accomplished: 2,
                    courseName: widget.courseName ?? '',
                    start_time: widget.start_time,
                    end_time: widget.end_time,
                    dayOfTheWeek: widget.dayOfTheWeek,
                    color: widget.color,
                  ),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,

                    padding: EdgeInsets.all(15),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(6),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "NULLIFIED",
                      style: TextStyle(color: Colors.white),
                    ),
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
