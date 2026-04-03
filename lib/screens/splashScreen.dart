import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lecture_tracker/db.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/utils.dart';
import 'package:sqflite/sqlite_api.dart';

class Splashscreen extends ConsumerStatefulWidget {
  const Splashscreen({super.key});

  @override
  ConsumerState<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends ConsumerState<Splashscreen> {
  @override
  void initState() {
    super.initState();
    toRun();
  }

  Future<void> toRun() async {
    //i am using widgetsbinding to avoid the issue of router.go during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await lookForSettingBox().delete('userHaveCreatedCourses');
      Database sqlDbLocator = await CustomDbClass.instance.getter;

      List<Map> userTimeTable = await fetchAll(
        dbLocator: sqlDbLocator,
        tableName: 'userAllTimetable',
        limit: 1000,
      );
      //this is to get to get tommorrow data like for the next day
      List<Map> tommorrowData = [];
      List<Map> twoDaysFromNowData = [];
      List<Map> threeDaysFromNowData = [];
      List<Map> fourDaysFromNowData = [];
      List<Map> fiveDaysAwayFromNowData = [];
      List<Map> sizDaysAwayFromNowData = [];
      String tommorowDate = DateTime.now().weekday == 7
          ? ref.read(wordWeekdayToInt)[0]
          : ref.read(wordWeekdayToInt)[DateTime.now()
                .weekday]; //this is to get wether the day is Monday, Tuesdat,etc
      String twoDaysFromDate = DateTime.now().weekday == 7
          ? ref.read(wordWeekdayToInt)[1]
          : ref.read(wordWeekdayToInt)[DateTime.now().weekday + 1];

      for (Map i in userTimeTable) {
        //checking if tommorrow is seem
        if (i.containsKey('dayOfTheWeek') &&
            i['dayOfTheWeek'] == tommorowDate) {
          tommorrowData.add(i);
        }
        //Checking if next tommorrow is seem
        else if (i.containsKey('dayOfTheWeek') &&
            i['dayOfTheWeek'] == twoDaysFromDate) {
          twoDaysFromNowData.add(i);
        }
      }
      ref.read(tommorowLectureSQLprovider.notifier).state = await tommorrowData;
      ref.read(twoDaysLaterLectureSQLprovider.notifier).state =
          twoDaysFromNowData;
      print('starting starting starting...');
      // lookForSettingBox().put('todayDate', DateTime.now().day);
      print('today date: ${lookForSettingBox().get('todayDate')}');
      ref.invalidate(decoyDB);
      try {
        //this is for ensuring the first time the app run on a device, it should create a new key for the lightMode and set it to true
        if (lookForSettingBox().get('lightMode') == null) {
          await Hive.box('settingDb').put('lightMode', true);
        }
        //setting the dark mode or light mode down
        ref.read(lightMode.notifier).state = await lookForSettingBox().get(
          'lightMode',
        );

        //if the userName don change already
        if (lookForSettingBox().get('username') != null) {
          //if the user already changed their name from user, if the name is still user, just leave the provider to handle the task else change the username provider
          ref.read(username.notifier).state = lookForSettingBox().get(
            'username',
          );
        } else {
          ref.read(username.notifier).state = 'user';
        }

        //Setting the lecture history to the provider - first get the data from the past lecture table
        List lectureHistory = await fetchAll(
          dbLocator: sqlDbLocator,
          tableName: 'lectureTrackers',
          limit: 1000,
        );
        ref.read(pastLectureSQLprovider.notifier).state = lectureHistory;

        //keep tab of today's date for knowing when to reset todaysLectures
        if (lookForSettingBox().get('todayDate') == null) {
          //this mean this is the first time the user is opening the app hence do not pass any data from the db cos it will still be empty list and let all the rivepod be empty(their default, check utils) for now
          //just pass today date to the hive
          await lookForSettingBox().put(
            'todayDate',
            DateTime.now().day - 1,
          ); //draw the day back by 1 on purpose, this is to allow the app know that isDataPassedForTodaymis false when it is reloading the splashscreen and know that it need to INSERT before SELECT
        } else {
          //this mean the user have open our app before and they have made some sort of interactions
          //here, you can pass the data from the maintable to the today lecture table only if today date and what is in the history of the hive are the same, else pass from the main table to the riverpod straight
          if (lookForSettingBox().get('todayDate') == DateTime.now().day) {
            //stil the current day , so just ignore the updating of today lectuer table
            print('just before today lecture sql is passed');
            List<Map> todayLecture = await fetchAll(
              dbLocator: sqlDbLocator,
              tableName: 'todayLectures',
              limit: 1000,
            );
            print('today lecture sql is passed');
            ref.read(decoyDB.notifier).state =
                todayLecture; //pass the data to the provider
            // print(ref.read(decoyDB));
            await Future.delayed(
              Duration(milliseconds: 500),
            ); //this is just a gimmick, to stop the transitioning from beign too fast

            router.go('/dashboard');
            return; //stop all below from running
            //this mean, the user is still in the current day they open the app last.
          } else {
            //this mean the user come back the following date or some days after their last coming, record all the day they did not come as missed lectures
            //todo - record all missed days
            //do this last
            await lookForSettingBox().put('isDataPassedForToday', false);
          }
        }
        //this is to make sure the data in main table for a particular day e.g Tuesday is passed to today lecture soon as we start our day and this must happen only once a day
        if (lookForSettingBox().get('isDataPassedForToday') == false) {
          //clear the today lecture table
          await sqlDbLocator.rawDelete("DELETE FROM todayLectures");
          print('just before main time table sql is passed');
          //adding from the main table cos its a new day
          for (Map i in userTimeTable) {
            if (i.containsKey('dayOfTheWeek') &&
                i['dayOfTheWeek'] ==
                    ref.read(wordWeekdayToInt)[DateTime.now().weekday - 1]) {
              await insertIntoTodayLectures(
                dbLocator: sqlDbLocator,
                title: i['title'],
                start_time: i['start_time'],
                end_time: i['end_time'],
                dayOfTheWeek: i['dayOfTheWeek'],
                color: i['color'],
              );
            }
          }
          print('main time table sql is passed');
          ref.read(decoyDB.notifier).state = userTimeTable;
          // print(ref.read(decoyDB));
          await lookForSettingBox().put('isDataPassedForToday', true);
        }
        await Future.delayed(
          Duration(milliseconds: 500),
        ); //this is just a gimmick, to stop the transitioning from beign too fast
        //this print is to knoe wether data was updated today, it is meant to let us know if at least one of the table passed data

        router.go('/dashboard');
      } catch (e) {
        await Future.delayed(
          Duration(seconds: 2),
        ); //this is just a gimmick, to stop the transitioning from beign too fast
        router.go('/error', extra: e.toString());
      }
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ref.read(lightMode) ? Colors.grey[100] : Colors.black,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ref.read(lightMode) ? Colors.grey[100] : Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              'PLEASE WAIT...',
              style: TextStyle(
                color: ref.watch(lightMode) ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
