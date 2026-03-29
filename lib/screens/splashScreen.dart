import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lecture_tracker/db.dart';
import 'package:lecture_tracker/errorpage.dart';
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
      try {
        //this is for ensuring the first time the app run on a device, it should create a new key for the lightMode and set it to true
        if (lookForSettingBox().get('lightMode') == null) {
          await Hive.box('settingDb').put('lightMode', true);
        }
        //setting the dark mode or light mode down
        ref.read(lightMode.notifier).state = await lookForSettingBox().get(
          'lightMode',
        );
        //if the userName don change already`
        Database sqlDbLocator = await CustomDbClass.instance.getter;

        if (lookForSettingBox().get('username') != null) {
          //if the user already changed their name from user, if the name is still user, just leave the provider to handle the task else change the username provider
          ref.read(username.notifier).state = lookForSettingBox().get(
            'username',
          );
        }

        //Setting the lecture history after setting the lightmode
        // deleteAllRowsPastLectures(dbLocator: getRoute);
        List lectureHistory = await fetchAll(
          dbLocator: sqlDbLocator,
          tableName: 'lectureTrackers',
          limit: 1000,
        );
        //if lectureHistory is empty,   just return the default value that was there before
        if (lectureHistory.isNotEmpty) {
          ref.read(pastLectureSQLprovider.notifier).state = lectureHistory;
        }
        await Future.delayed(
          Duration(seconds: 1),
        ); //this is just a gimmick, to stop the transitioning from beign too fast
        router.go('/dashboard');
        //i dey fear say user fit force close the app while sql process is in progress

        //this is for passing data to the lectureCard soon as user signUp or Anything involving splashscrren is called

        List<Map> userTimeTable = await fetchAll(
          dbLocator: sqlDbLocator,
          tableName: 'userAllTimetable',
          limit: 1000,
        );
        ref.read(decoyDB.notifier).state = userTimeTable;
        print(userTimeTable);
      } catch (e) {
        await Future.delayed(
          Duration(seconds: 1),
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
