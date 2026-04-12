import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lecture_tracker/db.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/backupAndrestore.dart';
import 'package:lecture_tracker/screens/editCourse.dart';

import 'package:lecture_tracker/utils.dart';
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
        onPopInvokedWithResult: (didPop, result) => router.go('/splashScreen'),
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

                                    prefix: InkWell(
                                      onTap: () async {
                                        await lookForSettingBox().put(
                                          'username',
                                          changeNameController.text
                                              .trim()
                                              .toUpperCase(),
                                        );
                                        ref.read(username.notifier).state =
                                            changeNameController.text;
                                        setState(() {
                                          isChangeUsernameActive = false;
                                        });
                                      },
                                      child: Icon(
                                        Icons.cloud_done_rounded,
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
                          ),
                          //the change theme
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
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
                          ),
                          //edit registered courses
                          InkWell(
                            onTap: () {
                              ref.invalidate(isClosePressed);

                              router.push('/Editcourse');
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
                          ),
                          //analysis widget
                          InkWell(
                            onTap: () {},
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
                                      final locator =
                                          await CustomDbClass.instance.getter;
                                      await locator.rawDelete(
                                        "DELETE FROM todayLectures",
                                      );
                                      await locator.rawDelete(
                                        "DELETE FROM userAllTimetable",
                                      );
                                      await locator.rawDelete(
                                        "DELETE FROM lectureTrackers",
                                      );
                                      await lookForSettingBox().delete(
                                        'lightMode',
                                      );
                                      await lookForSettingBox().delete(
                                        'username',
                                      );
                                      await lookForSettingBox().delete(
                                        'todayDate',
                                      );
                                      await lookForSettingBox().delete(
                                        'isDataPassedForToday',
                                      );
                                      await lookForSettingBox().delete(
                                        'userHaveCreatedCourses',
                                      );

                                      router.go('/splashScreen');
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
                                onPressed: () {},
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
                  ),
                  SizedBox(
                    height: ref.watch(deviceSizeY) * 0.04.h.clamp(0, 15),
                  ),

                  Column(
                    children: [
                      //for my own previous works
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(Icons.info_outline, color: Colors.grey[700]),
                            Text(
                              '\tDevOpe built it.Want to Connect?👇',
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
                                    "Download lecture tracker app at https://drive.google.com/file/d/1S_eQOjoUtXnpJz20ivWUjlfn-aFU0r8S/view?usp=drivesdk";
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
                      return BackupAndReset();
                    },
                  ),
                  secondChild: Center(child: SizedBox()),
                  crossFadeState: ref.watch(isBackupClicked)
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 150),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
