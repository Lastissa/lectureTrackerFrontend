import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lecture_tracker/db.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/utils.dart';
import 'package:sqflite/sqlite_api.dart';

//the timeofday should use .hour istead of .context.format
//brb
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

  void dispose() {
    super.dispose();
  }

  Future<void> toRun() async {
    //i am using widgetsbinding to avoid the issue of router.go during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
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
        List<Map> sixDaysAwayFromNowData = [];
        print(userTimeTable);
        String tommorowDate =
            ref.read(wordWeekdayToInt)[DateTime.now().weekday %
                7]; //this is to get wether the day is Monday, Tuesdat,etc
        String twoDaysFromDate = ref.read(
          wordWeekdayToInt,
        )[(DateTime.now().weekday + 1) % 7];
        String threeDaysFromDate = ref.read(
          wordWeekdayToInt,
        )[(DateTime.now().weekday + 2) % 7];
        String fourDaysFromDate = ref.read(
          wordWeekdayToInt,
        )[(DateTime.now().weekday + 3) % 7];
        String fifthDaysFromDate = ref.read(
          wordWeekdayToInt,
        )[(DateTime.now().weekday + 4) % 7];
        String sixthDaysFromDate = ref.read(
          wordWeekdayToInt,
        )[(DateTime.now().weekday + 5) % 7];

        for (Map i in userTimeTable) {
          //checking if tommorrow is seen
          if (i.containsKey('dayOfTheWeek') &&
              i['dayOfTheWeek'] == tommorowDate) {
            tommorrowData.add(i);
          }
          //Checking if next tommorrow is seen
          else if (i.containsKey('dayOfTheWeek') &&
              i['dayOfTheWeek'] == twoDaysFromDate) {
            twoDaysFromNowData.add(i);
          } else if (i.containsKey('dayOfTheWeek') &&
              i['dayOfTheWeek'] == threeDaysFromDate) {
            threeDaysFromNowData.add(i);
          } else if (i.containsKey('dayOfTheWeek') &&
              i['dayOfTheWeek'] == fourDaysFromDate) {
            fourDaysFromNowData.add(i);
          } else if (i.containsKey('dayOfTheWeek') &&
              i['dayOfTheWeek'] == fifthDaysFromDate) {
            fiveDaysAwayFromNowData.add(i);
          } else if (i.containsKey('dayOfTheWeek') &&
              i['dayOfTheWeek'] == sixthDaysFromDate) {
            sixDaysAwayFromNowData.add(i);
          }
        }
        ref.read(tommorowLectureSQLprovider.notifier).state =
            await tommorrowData;
        ref.read(twoDaysLaterLectureSQLprovider.notifier).state =
            twoDaysFromNowData;
        ref.read(threeDaysLaterLectureSQLprovider.notifier).state =
            threeDaysFromNowData;
        ref.read(fourDaysLaterLectureSQLprovider.notifier).state =
            fourDaysFromNowData;
        ref.read(fiveDaysLaterLectureSQLprovider.notifier).state =
            fiveDaysAwayFromNowData;
        ref.read(sixDaysLaterLectureSQLprovider.notifier).state =
            sixDaysAwayFromNowData;

        //end of data putting into each provider
        print('starting starting starting...');
        print('today date: ${lookForSettingBox().get('todayDate')}');
        ref.invalidate(decoyDB);
        //this is for ensuring the first time the app run on a device, it should create a new key for the lightMode and set it to true
        if (lookForSettingBox().get('lightMode') == null) {
          await Hive.box('settingDb').put('lightMode', true);
        }
        //configuring the lightmode hive db to change just before the lightmode riverpod get data from it

        final autoDarkModeSetting = lookForSettingBox().get(
          "autoDarkModeInterval",
        );
        if (autoDarkModeSetting != null) {
          String startTime = autoDarkModeSetting[0];
          int startTimeStartHour = int.parse(startTime.split(':')[0]);
          int startTimeStartMinutes = int.parse(startTime.split(':')[1]);
          String endTime = autoDarkModeSetting[1];
          int endTimeStartHour = int.parse(endTime.split(':')[0]);
          int endTimeStartMinutes = int.parse(endTime.split(':')[1]);

          int currentTimeHour = TimeOfDay.now().hour;
          int currentTimeMinutes = TimeOfDay.now().minute;

          //if the endtime is greater than the start time, meaning the user is setting the dark mode to occur to the next day
          if (endTimeStartHour > startTimeStartHour) {
            endTimeStartHour =
                endTimeStartHour +
                24; //i inreased the endtime hour value by 24 so it can catch up with the time diff
          }
          if (startTimeStartHour <= currentTimeHour &&
              currentTimeHour < endTimeStartHour) //1 , 2, 3 or 1,1, 3
          {
            print("enable dark mode");
            await Hive.box('settingDb').put('lightMode', false);
          } else if (startTimeStartHour == currentTimeHour &&
              currentTimeHour == endTimeStartHour) //1, 1, 1
          {
            if (startTimeStartMinutes <= currentTimeMinutes &&
                currentTimeMinutes <= endTimeStartMinutes) {
              print("enable dark mode");
              await Hive.box('settingDb').put('lightMode', false);
            } else {
              //damn, the current time min is greater than the end time min even though both hour are the same
              await Hive.box('settingDb').put('lightMode', true);
            }
          } else if (startTimeStartHour < currentTimeHour &&
              currentTimeHour <= endTimeStartHour) //1, 2, 2
          {
            if (currentTimeMinutes < endTimeStartMinutes) {
              print("enable dark mode");
              await Hive.box('settingDb').put('lightMode', false);
            } else {
              await Hive.box('settingDb').put('lightMode', true);
            }
          } else {
            //, the current hour min is greater than the end time hour or too low than the start time hour so dark mode cannot be auto apply
            await Hive.box('settingDb').put('lightMode', true);
          }
          // else {
          //   notifier(
          //     context: context,
          //     message:
          //         "An error occur while trying to apply your auto dark mode setting, Please, reach out to development team",
          //     bg: ref.watch(foreGroundColor),
          //     fg: ref.watch(backgroundColor),
          //   );
          // }
          print([startTime, TimeOfDay.now().format(context), endTime]);
        }

        //setting the dark mode or light mode down only if
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
            // print(todayLecture);
            ref.read(decoyDB.notifier).state =
                todayLecture; //pass the data to the provider
            //number of lecture for display on dashboard
            ref.watch(todayLectureCount.notifier).state = todayLecture.length;
            print('today lecture sql is passed');
            print('lenght of today lecture is: ${ref.read(todayLectureCount)}');

            //check if user is new, if yes, carry them go to the welcome page, if no, carry them to the dashbaord page
            bool? userHaveRegisteredCourses = await lookForSettingBox().get(
              'userHaveCreatedCourses',
            );

            if (userHaveRegisteredCourses != null) {
              router.go('/dashboard');
            } else {
              router.go("/Welcomesignup");
            }
            await Future.delayed(
              Duration(milliseconds: 500),
            ); //this is just a gimmick, to stop the transitioning from beign too fast
            //check if user is new, if yes, carry them go to the welcome page, if no, carry them to the dashbaord page

            if (userHaveRegisteredCourses != null) {
              router.go('/dashboard');
            } else {
              router.go("/Welcomesignup");
            }
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
          List<Map> newFetchForToday = await fetchAll(
            dbLocator: sqlDbLocator,
            tableName: 'todayLectures',
            limit: 1000,
          );
          ref.read(decoyDB.notifier).state = newFetchForToday;
          ref.read(todayLectureCount.notifier).state = newFetchForToday.length;
          print('main time table sql is passed');
          print('lenght of today lecture is: ${ref.read(todayLectureCount)}');

          //check if user is new, if yes, carry them go to the welcome page, if no, carry them to the dashbaord page
          bool? userHaveRegisteredCourses = await lookForSettingBox().get(
            'userHaveCreatedCourses',
          );

          if (userHaveRegisteredCourses != null) {
            router.go('/dashboard');
          } else {
            router.go("/Welcomesignup");
          }
          // print(ref.read(decoyDB));
          await lookForSettingBox().put('isDataPassedForToday', true);
        } //this print is to knoe wether data was updated today, it is meant to let us know if at least one of the table passed data
        await Future.delayed(
          Duration(milliseconds: 500),
        ); //this is just a gimmick, to stop the transitioning from beign too fast
        //check if user is new, if yes, carry them go to the welcome page, if no, carry them to the dashbaord page
        bool? userHaveRegisteredCourses = await lookForSettingBox().get(
          'userHaveCreatedCourses',
        );

        if (userHaveRegisteredCourses != null) {
          router.go('/dashboard');
        } else {
          router.go("/Welcomesignup");
        }
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
      backgroundColor: ref.read(backgroundColor),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ref.read(backgroundColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Image.asset(
                      'assets/staticImages/appicon2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            'Lecture Tracker',
            style: TextStyle(
              fontSize: 20.sp.clamp(0, 20),
              color: ref.watch(lightMode) ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ref.watch(deviceSizeY) * 0.1.h),
          SizedBox(
            child: CircularProgressIndicator(color: ref.watch(foreGroundColor)),
          ),
          SizedBox(height: ref.watch(deviceSizeY) * 0.1.h),
        ],
      ),
    );
  }
}
