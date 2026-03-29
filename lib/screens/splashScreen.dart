import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    if (lookForSettingBox().get('lightMode') == null) {
      //this is for ensuring the first time the app run on a device, it should create a new key for the lightMode and set it to true
      await lookForSettingBox().put('lightMode', true);
    }
    ref.read(lightMode.notifier).state = await lookForSettingBox().get(
      'lightMode',
    ); //setting the dark mode or light mode down

    Database getRoute = await CustomDbClass.instance.getter;
    // deleteAllRowsPastLectures(dbLocator: getRoute);
    List lectureHistory = await fetchAll(
      dbLocator: getRoute,
      tableName: 'lectureTrackers',
      limit: 1000,
    );
    //if lectureHistory is empty,   just return the default value that was there before
    if (lectureHistory.isNotEmpty) {
      ref.read(pastLectureSQLDecoy.notifier).state = lectureHistory;
    }

    router.go('/dashboard');
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
