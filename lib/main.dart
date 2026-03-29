import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lecture_tracker/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //using this cos i have an async in my code , normally, the handshake happens in the runApp but cos we are using async and await before the runApp , we have to tell the native to ensure the handshake ahead
  if (Platform.isWindows ||
      Platform
          .isLinux) //this is for knowing the kind of platform we are working on wrt to the sqfile
  {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  await Hive.initFlutter();
  //this hold everything that have to do with settings like lightmode,etc
  await Hive.openBox(
    'settingDb',
  ); // this is for loading the settingDB into memory
  //this hold past lectures in list format
  // await Hive.openBox('pastLectures');

  //come back and do for the lecture card later
  runApp(ProviderScope(child: HomeFile()));
}

class HomeFile extends ConsumerStatefulWidget {
  const HomeFile({super.key});

  @override
  ConsumerState<HomeFile> createState() => _HomeFileState();
}

class _HomeFileState extends ConsumerState<HomeFile> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(ref.read(deviceSizeX), ref.read(deviceSizeY)),
      child: MaterialApp.router(
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          canvasColor: Colors.red,

          scaffoldBackgroundColor: ref.read(lightMode)
              ? Colors.grey[100]
              : Colors.black,
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: routerConfig,
        builder: (context, child) => child!,
      ),
    );
  }
}

Box lookForSettingBox() {
  return Hive.box('settingDb');
} //this is so as not to be repeating hive.box all the time

// Box lookForPastLecture() {
//   return Hive.box('pastLectures');
// }
