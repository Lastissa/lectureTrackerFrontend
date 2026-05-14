import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lecture_tracker/db.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/backupAndrestore.dart';
import 'package:lecture_tracker/screens/change_theme.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/screens/editCourse.dart';

import 'package:lecture_tracker/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

final note = """
the setting page 
  -> Change username.
  -> update theme.
  -> Edit registered courses
  -> analysis (past lecture analysis e.g ratio of lecture missed to attended, timetable analysis e.g total lecture hours per week & AVE per day, most busiest day, etc)
  -> elevated button for backing up data to cloud; this is where i will use that password
  -> elevated button for recovering data from the online db


  very bottom ; devOpe built it , alonside about developer text .and maybesome sort of signature maybe whatsapp or twitter, use the url launcher for navigation 

""";

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  void initState() {
    super.initState();
    changeNameController.text = lookForSettingBox().get('username') ?? '';
  }

  bool confirmdeleteAccountPopup = false;
  bool isChangeUsernameActive = false;
  final changeNameController = TextEditingController();
  bool nothingShouldWork = false;
  TextEditingController adminTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ref.watch(backgroundColor),
      appBar: AppBar(
        toolbarHeight: ref.read(deviceSizeY) * 0.2.h,

        backgroundColor: ref.read(backgroundColor),
        title: Container(
          width: ref.watch(deviceSizeX).w,
          height: ref.watch(deviceSizeY) * 0.2.h,
          color: ref.watch(backgroundColor),
          child: Center(
            child: Text(
              '\nSETTINGS',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 28.sp.clamp(0, 28),
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: ref.watch(foreGroundColor),
              ),
            ),
          ),
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          ref.invalidate(isBackupClicked);
          ref.invalidate(isRestoreDataClicked);
          router.go('/splashScreen');
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ref.watch(deviceSizeX) * 0.09.w,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //the change username
                          AnimatedCrossFade(
                            firstChild: InkWell(
                              onTap: () {
                                setState(() {
                                  isChangeUsernameActive = true;
                                  changeNameController.text = ref
                                      .read(username)
                                      .toUpperCase();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: ref.watch(deviceSizeY) * 0.02.h,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        color: ref.watch(foreGroundColor),
                                      ),
                                    ),
                                    Text(
                                      'Change Username',
                                      style: TextStyle(
                                        letterSpacing: -1,
                                        fontSize: 17.sp.clamp(0, 17),
                                        fontWeight: FontWeight.w600,
                                        color: ref.watch(foreGroundColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            secondChild: Row(
                              children: [
                                Expanded(
                                  child: customTextFeild(
                                    ref: ref,
                                    controller: changeNameController,
                                    isPassword: false,
                                    suffix: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isChangeUsernameActive = false;
                                        });
                                      },
                                      child: Icon(
                                        color: Colors.red,
                                        Icons.cancel_rounded,
                                      ),
                                    ),
                                    //update the username name with the kast buttom
                                    prefix: InkWell(
                                      onLongPress: () {
                                        notifier(
                                          context: context,
                                          message: 'Save Icon',
                                          bg: ref
                                              .watch(backgroundColor)
                                              .withOpacity(0.8),
                                          fg: ref.watch(foreGroundColor),
                                        );
                                      },
                                      onTap: () async {
                                        await lookForSettingBox().put(
                                          'username',
                                          changeNameController.text
                                              .trim()
                                              .toUpperCase(),
                                        );
                                        ref.read(username.notifier).state =
                                            changeNameController.text;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).clearSnackBars;

                                        setState(() {
                                          isChangeUsernameActive = false;
                                        });
                                      },
                                      child: Icon(
                                        Icons.save_as_outlined,
                                        color: ref.watch(foreGroundColor),
                                      ),
                                    ),
                                    hint: 'Username',
                                    validator: (v) {},
                                  ),
                                ),
                              ],
                            ),
                            crossFadeState: isChangeUsernameActive
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: Duration(milliseconds: 350),
                          ).animate().slideX(
                            curve: Curves.decelerate,
                            begin: -1,
                            end: 0,
                            duration: Duration(milliseconds: 600),
                          ),
                          //the change theme
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    ref.invalidate(changeThemeSuccess);
                                    ref.invalidate(autoThemeChange);
                                    router.push('/change_theme');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: ref.watch(deviceSizeY) * 0.02.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            ref.watch(lightMode)
                                                ? Icons.sunny
                                                : Icons.nightlight_round_sharp,
                                            color: ref.watch(foreGroundColor),
                                          ),
                                        ),
                                        Text(
                                          "Change Theme",
                                          style: TextStyle(
                                            letterSpacing: -1,
                                            fontSize: 17.sp.clamp(0, 17),
                                            fontWeight: FontWeight.w600,
                                            color: ref.watch(foreGroundColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Switch(
                                trackOutlineColor: WidgetStatePropertyAll(
                                  ref.watch(foreGroundColor),
                                ),
                                thumbColor: WidgetStateProperty.all(
                                  ref.watch(lightMode)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                trackColor: WidgetStateProperty.all(
                                  ref.watch(foreGroundColor),
                                ),

                                value: !ref.watch(lightMode),
                                onChanged: (v) async {
                                  ref.watch(lightMode.notifier).state = !v;
                                  await lookForSettingBox().put(
                                    'lightMode',
                                    !v,
                                  );
                                },
                              ),
                            ],
                          ).animate().slideX(
                            curve: Curves.decelerate,
                            begin: -2,
                            end: 0,
                            duration: Duration(milliseconds: 500),
                            delay: Duration(milliseconds: 300),
                          ),
                          //edit registered courses
                          InkWell(
                            onTap: () async {
                              ref.invalidate(isClosePressed);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                try {
                                  router.push('/Editcourse');
                                } catch (e) {
                                  router.go('/error', extra: e.toString());
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: ref.watch(deviceSizeY) * 0.02.h,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.edit_document,
                                      color: ref.watch(foreGroundColor),
                                    ),
                                  ),
                                  Text(
                                    "Edit Registered Course",
                                    style: TextStyle(
                                      letterSpacing: -1,
                                      fontSize: 17.sp.clamp(0, 17),
                                      fontWeight: FontWeight.w600,
                                      color: ref.watch(foreGroundColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().slideX(
                            curve: Curves.decelerate,
                            begin: -2,
                            end: 0,
                            duration: Duration(milliseconds: 500),
                            delay: Duration(milliseconds: 500),
                          ),
                          //analysis widget
                          InkWell(
                            onTap: () {
                              router.go("/analysis");
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: ref.watch(deviceSizeY) * 0.02.h,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.analytics,
                                      color: ref.watch(foreGroundColor),
                                    ),
                                  ),
                                  Text(
                                    "Analysis",
                                    style: TextStyle(
                                      letterSpacing: -1,
                                      fontSize: 17.sp.clamp(0, 17),
                                      fontWeight: FontWeight.w600,
                                      color: ref.watch(foreGroundColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().slideX(
                            curve: Curves.decelerate,
                            begin: -2,
                            end: 0,
                            duration: Duration(milliseconds: 700),
                            delay: Duration(milliseconds: 300),
                          ),
                          //delete account confirmation
                          AnimatedCrossFade(
                            firstChild: //delete account widget
                            InkWell(
                              onTap: () async {
                                await ScaffoldMessenger.of(
                                  context,
                                ).clearSnackBars;
                                notifier(
                                  context: context,
                                  message: 'Long Press to Delete Account',
                                  bg: ref.read(lightMode)
                                      ? Colors.red
                                      : Colors.redAccent,
                                );
                              },

                              onLongPress: () {
                                setState(() {
                                  confirmdeleteAccountPopup = true;
                                });
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: ref.watch(lightMode)
                                          ? Colors.red
                                          : Colors.redAccent,
                                    ),
                                  ),
                                  Text(
                                    "DELETE ACCOUNT",
                                    style: TextStyle(
                                      letterSpacing: -1,
                                      fontSize: 17.sp.clamp(0, 17),
                                      fontWeight: FontWeight.w600,
                                      color: ref.watch(lightMode)
                                          ? Colors.red
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            secondChild: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ref.watch(
                                        foreGroundColor,
                                      ),

                                      foregroundColor: ref.watch(lightMode)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        confirmdeleteAccountPopup = false;
                                      });
                                    },
                                    child: Icon(Icons.cancel_outlined),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ref.watch(lightMode)
                                          ? Colors.red
                                          : Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () async {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible:
                                            false, // User must tap a button to close

                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: ref.watch(
                                              foreGroundColor,
                                            ),
                                            title: Text(
                                              'Confirm Account Delete',
                                              style: customButtomTextStyle
                                                  .copyWith(
                                                    color: ref.watch(
                                                      backgroundColor,
                                                    ),
                                                  ),
                                            ),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                    'Are you sure you want to delete your account?',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: ref.watch(
                                                        backgroundColor,
                                                      ),
                                                      wordSpacing: -0.1,
                                                      letterSpacing: -0.5,
                                                    ),
                                                  ),
                                                  Text(
                                                    'NOTE: This action can lead to loss of data if account is not backed up.!!!',

                                                    style: TextStyle(
                                                      color:
                                                          ref.read(lightMode) ==
                                                              true
                                                          ? const Color.fromARGB(
                                                              255,
                                                              104,
                                                              18,
                                                              12,
                                                            )
                                                          : Colors.red,

                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,

                                                      wordSpacing: -0.1,
                                                      letterSpacing: -0.5,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Hint: if you back up your data before delete, you can always retreive it later ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: ref.watch(
                                                        backgroundColor,
                                                      ),
                                                      wordSpacing: -0.1,
                                                      letterSpacing: -0.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: ref.watch(
                                                      backgroundColor,
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(
                                                    context,
                                                  ).pop(); // Just close the popup
                                                },
                                              ),

                                              TextButton(
                                                onPressed: () async {
                                                  final dbLocator =
                                                      await CustomDbClass
                                                          .instance
                                                          .getter;
                                                  final allRegisteredCourse =
                                                      await fetchAll(
                                                        dbLocator: dbLocator,
                                                        tableName:
                                                            'userAllTimetable',
                                                        limit: 1000,
                                                      );
                                                  //just before the sending
                                                  setState(() {
                                                    nothingShouldWork = true;
                                                  });

                                                  ref.invalidate(backup);
                                                  final toShow = await ref
                                                      .read(
                                                        backup({
                                                          "history": ref.read(
                                                            pastLectureSQLprovider,
                                                          ),
                                                          "currentData":
                                                              allRegisteredCourse,
                                                        }).future,
                                                      )
                                                      .timeout(
                                                        Duration(seconds: 10),
                                                        onTimeout: () {
                                                          // print("timeout");
                                                          return [
                                                            "timeout",
                                                            404,
                                                          ];
                                                        },
                                                      );
                                                  notifier(
                                                    bg: ref.watch(
                                                      foreGroundColor,
                                                    ),
                                                    fg: ref.watch(
                                                      backgroundColor,
                                                    ),
                                                    context: context,
                                                    message:
                                                        "${toShow[0]}, ${toShow[1]["message"]}",
                                                    duration: Duration(
                                                      seconds: 3,
                                                    ),
                                                  );
                                                  print(
                                                    "${toShow[0]}, ${toShow[1]["message"]}",
                                                  );
                                                  //after the sending
                                                  setState(() {
                                                    nothingShouldWork = false;
                                                  });
                                                  print("End of backup...");
                                                },
                                                child: Text(
                                                  'Backup',
                                                  style: TextStyle(
                                                    color: ref.watch(
                                                      backgroundColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  final locator =
                                                      await CustomDbClass
                                                          .instance
                                                          .getter;
                                                  await locator.rawDelete(
                                                    "DELETE FROM todayLectures",
                                                  );
                                                  await locator.rawDelete(
                                                    "DELETE FROM userAllTimetable",
                                                  );
                                                  await locator.rawDelete(
                                                    "DELETE FROM lectureTrackers",
                                                  );

                                                  //Deleting each keys in the hive box
                                                  for (String i
                                                      in lookForSettingBox()
                                                          .keys) {
                                                    lookForSettingBox().delete(
                                                      i,
                                                    );
                                                  }
                                                  router.go('/splashScreen');
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text('Yes, Delete Account'),
                                  ),
                                ],
                              ),
                            ),
                            crossFadeState: confirmdeleteAccountPopup
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: Duration(milliseconds: 200),
                          ).animate().slideX(
                            curve: Curves.decelerate,
                            begin: -2,
                            end: 0,
                            duration: Duration(milliseconds: 700),
                            delay: Duration(milliseconds: 300),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //the backup and restore container
                  Container(
                    width: ref.read(deviceSizeX).w,
                    height: 40,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: ref.read(deviceSizeX) * 0.06.w),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Instead of an ElevatedButton, try this:
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: ref.watch(foreGroundColor),

                                  foregroundColor: ref.watch(lightMode)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                onPressed: () {
                                  ref
                                          .read(isRestoreDataClicked.notifier)
                                          .state =
                                      true;
                                },
                                child: Text(
                                  "Restore Data",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: ref.watch(deviceSizeX) * 0.06.w),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: ref.watch(foreGroundColor),

                                  foregroundColor: ref.watch(lightMode)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                onPressed: () {
                                  ref.read(isBackupClicked.notifier).state =
                                      true;
                                },
                                child: Text(
                                  "Backup Data",
                                  style: TextStyle(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: ref.read(deviceSizeX) * 0.06.w),
                      ],
                    ),
                  ).animate().slideX(
                    curve: Curves.decelerate,
                    begin: 2,
                    end: 0,
                    duration: Duration(milliseconds: 500),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: InkWell(
                      onTap: () {
                        final url = Uri.parse('${domain}login/');
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      },
                      child:
                          Text(
                            maxLines: 1,
                            "visit ${domain}login/ for more features and support",
                            style: TextStyle(
                              color: ref.watch(lightMode)
                                  ? Colors.grey[700]
                                  : Colors.grey[400],
                              fontStyle: FontStyle.italic,
                            ),
                          ).animate().slideX(
                            curve: Curves.decelerate,
                            begin: 2,
                            end: 0,
                            duration: Duration(milliseconds: 500),
                            delay: Duration(milliseconds: 300),
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ref.read(deviceSizeX) * 0.06.w,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(color: ref.watch(foreGroundColor)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ref.watch(deviceSizeX) * 0.06.w,
                            vertical:
                                ref.watch(deviceSizeY) * 0.001.h.clamp(0, 10),
                          ),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              color: ref.watch(lightMode)
                                  ? Colors.black87
                                  : Colors.white70,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: ref.watch(foreGroundColor)),
                        ),
                      ],
                    ),
                  ).animate().slideX(
                    curve: Curves.decelerate,
                    begin: -2,
                    end: 0,
                    duration: Duration(milliseconds: 500),
                  ),
                  // Back to Login
                  TextButton(
                    onPressed: () {
                      router.go('/splashScreen');
                    },

                    child: Text(
                      "Back to Dashboard",
                      style: TextStyle(
                        color: ref.read(lightMode)
                            ? Colors.grey[700]
                            : Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ).animate().slideX(
                    curve: Curves.decelerate,
                    begin: -2,
                    end: 0,
                    duration: Duration(milliseconds: 500),
                  ),
                  SizedBox(
                    height: ref.watch(deviceSizeY) * 0.02.h.clamp(0, 14),
                  ),

                  Column(
                    children: [
                      //for my own previous works
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          //bring the box that accept password and after that navigate to a page where i can change the backend url
                          onLongPress: () async {
                            String confirmCode = "Allahu123";
                            await showDialog(
                              barrierColor: ref.watch(backgroundColor),
                              barrierDismissible: false,
                              context: context,
                              builder: (builder) => AlertDialog(
                                backgroundColor: ref.watch(foreGroundColor),
                                content: Container(
                                  height: ref.watch(deviceSizeY) * 0.3.h,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            adminTextEditingController.clear();
                                            Navigator.of(context).pop();
                                          },
                                        ).animate().shake(
                                          duration: Duration(seconds: 1),
                                          hz: 4,
                                        ),

                                        SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    adminTextEditingController,
                                                onChanged: (value) {
                                                  if (value == confirmCode) {
                                                    //pop the showdialog and allow backup to go on
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                textAlign: TextAlign.center,
                                                keyboardType:
                                                    TextInputType.text,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: ref.watch(
                                                    backgroundColor,
                                                  ),
                                                ),
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: ref.watch(
                                                            backgroundColor,
                                                          ),
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: ref.watch(
                                                            backgroundColor,
                                                          ),
                                                          width: 1.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                            ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15),

                                        // Text(
                                        //   "Type '${confirmCode}",
                                        //   style: TextStyle(
                                        //     color: ref.watch(backgroundColor),
                                        //     fontWeight: FontWeight.w500,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                            if (adminTextEditingController.text != "Allahu123")
                              return;

                            //open the secret admin page where i can change the backend url and also see some of my previous works and also have the ability to log out all users by changing the backend url to a non existing one for a moment
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Icon(Icons.info_outline, color: Colors.grey[700]),
                              Text(
                                '\tDevOpe built it.Want to Connect?',
                                style: TextStyle(
                                  color: ref.watch(lightMode)
                                      ? Colors.grey[700]
                                      : Colors.white70,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: ref.read(deviceSizeX) * 0.65.w.clamp(0.5, 0.75),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ref.watch(foreGroundColor),

                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                // navigate to my whatsapp link using the url launcher
                                final path = await Uri.parse(
                                  'https://wa.me/08113577875',
                                );

                                try {
                                  await launchUrl(
                                    path,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } catch (e) {
                                  router.go('/error', extra: e.toString());
                                  return;
                                }
                              },
                              child: Container(
                                width: 28, // 85.r.clamp(0, 32),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(),
                                child: SvgPicture.asset(
                                  'assets/staticImages/whatsapp.svg',
                                ),
                              ),
                            ), //for my whatsapp link ; whatsapp logo
                            SizedBox(width: 15),
                            InkWell(
                              onTap: () async {
                                final path = await Uri.parse(
                                  'https://www.github.com/lastissa',
                                );

                                try {
                                  await launchUrl(
                                    path,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } catch (e) {
                                  router.go('/error', extra: e.toString());
                                  return;
                                }
                              },
                              child: Container(
                                width: 28, //85.r.clamp(0, 30),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(),
                                child: SvgPicture.asset(
                                  'assets/staticImages/github.svg',
                                ),
                              ),
                            ), //for my twitter link ; twitter logo
                            SizedBox(width: 15),
                            InkWell(
                              onTap: () async {
                                //navigate to my twitter handle using the url launcher
                                final path = await Uri.parse(
                                  'https://x.com/lastissa',
                                );

                                try {
                                  await launchUrl(
                                    path,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } catch (e) {
                                  router.go('/error', extra: e.toString());
                                  return;
                                }
                              },
                              child: Container(
                                width: 28, //85.r.clamp(0, 30),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(),
                                child: SvgPicture.asset(
                                  'assets/staticImages/twitter_light.svg',
                                ),
                              ),
                            ), //for my github link ; github logo
                            SizedBox(width: 15),
                            InkWell(
                              onTap: () async {
                                //navigate to my email with predefined composed message of wanting to link up with me formally using the url launcher
                                final path = await Uri.parse(
                                  'https://mailto:lastissa11@gmail.com',
                                );
                                if (!await launchUrl(
                                  path,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  router.go(
                                    '/error',
                                    extra: 'could not launch whatsapp',
                                  );
                                  return;
                                }
                              },
                              child: Container(
                                width: 25, //85.r.clamp(0, 25),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(),
                                child: SvgPicture.asset(
                                  'assets/staticImages/gmail_light.svg',
                                ),
                              ),
                            ), //for my email address ; use email logo
                            SizedBox(width: 15),
                            InkWell(
                              onTap: () async {
                                // final link = await Uri.parse(
                                //   'Download lecture tracker app at https://drive.google.com/file/d/1S_eQOjoUtXnpJz20ivWUjlfn-aFU0r8S/view?usp=drivesdk',
                                // );
                                final link =
                                    "Download lecture tracker app at https://drive.google.com/drive/folders/1R4wXaL5J3ZaRIbGs0oRgzwU3slnhkEyK";
                                if (Platform.isWindows || Platform.isAndroid) {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text:
                                          'Download the lecture tracker app at $link',
                                    ),
                                  );
                                  await ScaffoldMessenger.of(
                                    context,
                                  ).clearSnackBars;
                                  // notifier(
                                  //   message: 'App Link Copied!',
                                  //   bg: ref.watch(foreGroundColor),
                                  //   context: context,
                                  // );
                                }
                                // bring up the share app - i do not know the package i will use for now

                                await SharePlus.instance.share(
                                  ShareParams(
                                    subject: 'Share Lecture Tracker!',
                                    text:
                                        "Hey there! I just wanted to share this amazing app called Lecture Tracker with you. It's a fantastic tool that helps students keep track of their lectures, manage their schedules, and stay organized. Check it out and let me know what you think!\nClick here to download: $link",
                                  ),
                                );
                              },

                              child: Container(
                                width: 24, //85.r.clamp(0, 25),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(),
                                child: SvgPicture.asset(
                                  'assets/staticImages/shareIcon.svg',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().slideY(
                        curve: Curves.decelerate,
                        begin: 2,
                        end: 0,
                        duration: Duration(milliseconds: 500),
                        delay: Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                  SizedBox(height: ref.watch(deviceSizeY) * 0.02.h.clamp(0, 8)),
                ],
              ),
              Positioned(
                child: AnimatedCrossFade(
                  firstChild: Builder(
                    builder: (context) {
                      //Check if its backup that is active or recover data that is active
                      if (ref.read(isBackupClicked)) {
                        return BackupAndReset(uniqueKey: UniqueKey());
                      } else if (ref.read(isRestoreDataClicked)) {
                        return RestoreAndReset(uniqueKey: UniqueKey());
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                  secondChild: Center(child: SizedBox()),
                  crossFadeState:
                      ref.watch(isBackupClicked) ||
                          ref.watch(isRestoreDataClicked)
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 150),
                ),
              ),
              ref.watch(successProvider)
                  ? Positioned(
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 90),
                          child: LottieBuilder.asset(
                            onLoaded: (v) async {
                              // print(v);
                              await Future.delayed(Duration(seconds: 2));
                              ref.invalidate(successProvider);
                            },
                            width: ref.watch(deviceSizeX) * 0.3.w,
                            // height: ,
                            repeat: false,
                            'assets/lottie/success.json',
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              nothingShouldWork
                  ? Positioned(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        height: ref.watch(deviceSizeY).h,
                        width: ref.watch(deviceSizeX).w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ref.watch(foreGroundColor),
                            width: 1,
                          ),
                          color: ref.watch(lightMode)
                              ? Colors.white54
                              : Colors.black54,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),

                          boxShadow: [],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                              width: double.infinity,
                              child: LinearProgressIndicator(
                                color: ref.watch(foreGroundColor),
                                backgroundColor: ref.watch(backgroundColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
