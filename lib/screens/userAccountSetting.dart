import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lecture_tracker/db.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/backupAndrestore.dart';
import 'package:http/http.dart' as http;

import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/screens/editCourse.dart';
import 'package:lecture_tracker/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';

class Useraccountsetting extends ConsumerStatefulWidget {
  const Useraccountsetting({super.key});

  @override
  ConsumerState<Useraccountsetting> createState() => _UseraccountsettingState();
}

class _UseraccountsettingState extends ConsumerState<Useraccountsetting> {
  void initState() {
    super.initState();
    changeNameController.text = lookForSettingBox().get('username') ?? '';
  }

  final changeNameController = TextEditingController();
  int _firstHour = lookForSettingBox().get("autoDarkModeInterval") == null
      ? 0
      : int.parse(
          lookForSettingBox().get("autoDarkModeInterval")[0].split(":")[0],
        ); //this check the hive for the list holding the data
  int _firstMinuteFirst =
      lookForSettingBox().get("autoDarkModeInterval") == null
      ? 0
      : int.parse(
          (lookForSettingBox().get("autoDarkModeInterval")[0].split(":")[1])
              .toString()
              .split("")[0],
        ); //the first part of first minute
  int _firstMinuteSecond =
      lookForSettingBox().get("autoDarkModeInterval") == null
      ? 0
      : int.parse(
          (lookForSettingBox().get("autoDarkModeInterval")[0].split(":")[1])
              .toString()
              .split("")[1],
        ); //the second part of the first minute
  int _secondHour = lookForSettingBox().get("autoDarkModeInterval") == null
      ? 0
      : int.parse(
          lookForSettingBox().get("autoDarkModeInterval")[1].split(":")[0],
        );
  int _secondMinuteFirst =
      lookForSettingBox().get("autoDarkModeInterval") == null
      ? 0
      : int.parse(
          (lookForSettingBox().get("autoDarkModeInterval")[1].split(":")[1])
              .toString()
              .split("")[0],
        ); //the first part of second minute
  int _secondMinuteSecond =
      lookForSettingBox().get("autoDarkModeInterval") == null
      ? 0
      : int.parse(
          (lookForSettingBox().get("autoDarkModeInterval")[1].split(":")[1])
              .toString()
              .split("")[1],
        ); //the second part of the second minute
  UniqueKey customUniqueKeyOffline = UniqueKey();
  UniqueKey customUniqueKeyOnline = UniqueKey();
  UniqueKey viewBackupHistoryUniqueKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ref.watch(backgroundColor),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          router.pop();
        },
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ref.watch(deviceSizeX) * 0.009.r,
              ),
              width: ref.watch(deviceSizeX).w,
              height: ref.watch(deviceSizeY).h,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(color: ref.watch(backgroundColor)),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          router.pop();
                        },
                        icon: Icon(
                          Icons.chevron_left,
                          color: ref.watch(foreGroundColor),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // AnimatedTextKit(
                              //   repeatForever: false,
                              //   totalRepeatCount: 1,
                              //   animatedTexts: [
                              //     WavyAnimatedText(
                              //       textAlign: TextAlign.end,
                              //       speed: Duration(milliseconds: 200),
                              //       "Manage Account",
                              //       textStyle: TextStyle(
                              //         color: ref.watch(foreGroundColor),
                              //         fontWeight: FontWeight.bold,
                              //         letterSpacing: -1,
                              //         wordSpacing: 1,
                              //         fontSize: 25.sp.clamp(0, 30),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              Text(
                                "Manage Account",
                                style: TextStyle(
                                  color: ref.watch(foreGroundColor),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1,
                                  wordSpacing: 1,
                                  fontSize: 25.sp.clamp(0, 30),
                                ),
                              ),
                              Text(
                                "manage account and their configuration",
                                style: TextStyle(
                                  color: ref.watch(lightMode)
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12.sp.clamp(0, 14),
                                  wordSpacing: -0.5,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  //the header for switching mode
                  Container(
                    margin: EdgeInsets.all(20),
                    width: ref.watch(deviceSizeX).w,
                    clipBehavior: Clip.hardEdge,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: ref.watch(lightMode) ? Colors.white : Colors.black,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(1, 1),
                          color: ref.watch(foreGroundColor).withAlpha(30),
                        ),
                      ],
                      border: BoxBorder.all(
                        color: ref.watch(foreGroundColor).withAlpha(30),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: ref.watch(offlineConfig) ? 10 : 8,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ref.watch(offlineConfig)
                                  ? ref.watch(foreGroundColor)
                                  : ref.watch(lightMode)
                                  ? Colors.white
                                  : Colors.black,
                              foregroundColor: ref.watch(offlineConfig)
                                  ? ref.watch(backgroundColor)
                                  : ref.watch(foreGroundColor),
                              shadowColor: ref.watch(offlineConfig)
                                  ? ref.watch(foreGroundColor).withAlpha(180)
                                  : Colors.transparent,
                              elevation: 2,
                              side: ref.watch(offlineConfig)
                                  ? BorderSide(
                                      color: ref
                                          .watch(foreGroundColor)
                                          .withAlpha(30),
                                      width: 2,
                                    )
                                  : BorderSide.none,
                            ),
                            onPressed: () {
                              if (ref.read(offlineConfig)) return;
                              ref.read(offlineConfig.notifier).state = true;
                              customUniqueKeyOffline = UniqueKey();
                            },
                            child: Text("Offline Config"),
                          ),
                        ),
                        Expanded(
                          flex: !ref.watch(offlineConfig) ? 10 : 8,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !ref.watch(offlineConfig)
                                  ? ref.watch(foreGroundColor)
                                  : ref.watch(lightMode)
                                  ? Colors.white
                                  : Colors.black,
                              foregroundColor: !ref.watch(offlineConfig)
                                  ? ref.watch(backgroundColor)
                                  : ref.watch(foreGroundColor),
                              shadowColor: !ref.watch(offlineConfig)
                                  ? ref.watch(foreGroundColor).withAlpha(180)
                                  : Colors.transparent,
                              elevation: 2,
                              side: !ref.watch(offlineConfig)
                                  ? BorderSide(
                                      color: ref
                                          .watch(foreGroundColor)
                                          .withAlpha(30),
                                      width: 2,
                                    )
                                  : BorderSide.none,
                            ),
                            onPressed: () {
                              if (ref.read(offlineConfig) == false) return;
                              ref.read(offlineConfig.notifier).state = false;
                              customUniqueKeyOnline = UniqueKey();
                            },
                            child: Text("Online Config"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //desc
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: ref.watch(deviceSizeX).w,
                    clipBehavior: Clip.hardEdge,
                    padding: EdgeInsets.all(10),
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: ref.watch(lightMode) ? Colors.white : Colors.black,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(1, 1),
                          color: ref.watch(foreGroundColor).withAlpha(30),
                        ),
                      ],
                      border: BoxBorder.all(
                        color: ref.watch(foreGroundColor).withAlpha(30),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: AnimatedCrossFade(
                        key: customUniqueKeyOffline,
                        firstChild: AnimatedTextKit(
                          repeatForever: false,
                          totalRepeatCount: 1,
                          animatedTexts: [
                            TypewriterAnimatedText(
                              cursor: "",
                              "Configuring and managing data on local storage that will not require internet connection to configure",
                              textStyle: TextStyle(
                                color: ref.watch(foreGroundColor),
                                wordSpacing: 2,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                        secondChild: AnimatedTextKit(
                          key: customUniqueKeyOnline,
                          repeatForever: false,
                          totalRepeatCount: 1,
                          animatedTexts: [
                            TypewriterAnimatedText(
                              cursor: "",
                              "Configuring and managing your data on our server, please note that this mode require internet connection.\nHint: Swipe to view other features avalaible",
                              textStyle: TextStyle(
                                color: ref.watch(foreGroundColor),
                                wordSpacing: 2,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                        crossFadeState: ref.watch(offlineConfig)
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: Duration(milliseconds: 400),
                      ),
                    ),
                  ),
                  //the middle for all function itself like change username or reset password etc
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: ref.watch(deviceSizeX).w,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: ref.watch(lightMode)
                                  ? Colors.white
                                  : Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: BoxBorder.all(
                                color: ref.watch(foreGroundColor).withAlpha(45),
                              ),
                            ),
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: ref.watch(offlineConfig) == true
                                  ? Column(
                                      //the one that handles what to show to user - for offline own
                                      children: [
                                        //Change Username
                                        AnimatedCrossFade(
                                          firstChild: InkWell(
                                            onTap: () {
                                              ref
                                                      .read(
                                                        isChangeUsernameActive
                                                            .notifier,
                                                      )
                                                      .state =
                                                  true;
                                              changeNameController.text = ref
                                                  .read(username)
                                                  .toUpperCase();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical:
                                                    ref.watch(deviceSizeY) *
                                                    0.02.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    child: Icon(
                                                      Icons.person,
                                                      color: ref.watch(
                                                        foreGroundColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Change Username',
                                                    style: TextStyle(
                                                      letterSpacing: -1,
                                                      wordSpacing: 1.4,
                                                      fontSize: 17.sp.clamp(
                                                        0,
                                                        17,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ref.watch(
                                                        foreGroundColor,
                                                      ),
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
                                                  controller:
                                                      changeNameController,
                                                  isPassword: false,
                                                  suffix: InkWell(
                                                    onTap: () {
                                                      ref
                                                              .read(
                                                                isChangeUsernameActive
                                                                    .notifier,
                                                              )
                                                              .state =
                                                          false;
                                                    },
                                                    child: Icon(
                                                      color: Colors.red,
                                                      Icons.cancel_rounded,
                                                    ),
                                                  ),
                                                  //update the username name with the kast buttom
                                                  prefix: InkWell(
                                                    onTap: () async {
                                                      if (ref
                                                              .read(username)
                                                              .toUpperCase() ==
                                                          changeNameController
                                                              .text
                                                              .toUpperCase()) {
                                                        ElegantNotification.info(
                                                          background: ref.watch(
                                                            backgroundColor,
                                                          ),
                                                          dismissDirection:
                                                              DismissDirection
                                                                  .up,
                                                          description: Text(
                                                            "No change in username dectected",
                                                          ),
                                                        ).show(context);
                                                        return;
                                                      }
                                                      await lookForSettingBox()
                                                          .put(
                                                            'username',
                                                            changeNameController
                                                                .text
                                                                .trim()
                                                                .toUpperCase(),
                                                          );
                                                      ref
                                                              .read(
                                                                username
                                                                    .notifier,
                                                              )
                                                              .state =
                                                          changeNameController
                                                              .text;

                                                      ref
                                                              .read(
                                                                isChangeUsernameActive
                                                                    .notifier,
                                                              )
                                                              .state =
                                                          false;
                                                      ElegantNotification.success(
                                                        background: ref.watch(
                                                          backgroundColor,
                                                        ),
                                                        dismissDirection:
                                                            DismissDirection.up,
                                                        description: Text(
                                                          "Hi, ${ref.read(username)}",
                                                        ),
                                                      ).show(context);
                                                    },
                                                    child: Icon(
                                                      Icons.save_as_outlined,
                                                      color: ref.watch(
                                                        foreGroundColor,
                                                      ),
                                                    ),
                                                  ),
                                                  hint: 'Username',
                                                  validator: (v) {},
                                                  onchanged: null,
                                                ),
                                              ),
                                            ],
                                          ),
                                          crossFadeState:
                                              ref.watch(isChangeUsernameActive)
                                              ? CrossFadeState.showSecond
                                              : CrossFadeState.showFirst,
                                          duration: Duration(milliseconds: 350),
                                        ).animate().slideX(
                                          curve: Curves.decelerate,
                                          begin: -1,
                                          end: 0,
                                          duration: Duration(milliseconds: 600),
                                        ),

                                        //auto dark mode
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              onPressed: null,
                                              icon: Icon(Icons.auto_awesome),
                                              color: ref.watch(foreGroundColor),
                                              disabledColor: ref.watch(
                                                foreGroundColor,
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                "Auto Dark Mode",
                                                style: TextStyle(
                                                  letterSpacing: -1,
                                                  wordSpacing: 1.4,
                                                  fontSize: 17.sp.clamp(0, 17),
                                                  fontWeight: FontWeight.w600,
                                                  color: ref.watch(
                                                    foreGroundColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(child: SizedBox()),
                                            InkWell(
                                              onTap: () {
                                                //changing it to false
                                                if (ref.read(autoThemeChange)) {
                                                  ref
                                                          .read(
                                                            autoThemeChange
                                                                .notifier,
                                                          )
                                                          .state =
                                                      false;
                                                  lookForSettingBox().delete(
                                                    "autoDarkModeInterval",
                                                  );
                                                  _firstHour = 0;
                                                  _firstMinuteFirst = 0;
                                                  _firstMinuteSecond = 0;
                                                  _secondHour = 0;
                                                  _secondMinuteFirst = 0;
                                                  _secondMinuteSecond = 0;
                                                }
                                                //changing it to true
                                                else {
                                                  ref
                                                          .read(
                                                            autoThemeChange
                                                                .notifier,
                                                          )
                                                          .state =
                                                      true;
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 5,
                                                ),
                                                margin: EdgeInsets.all(10),

                                                decoration: BoxDecoration(
                                                  color: ref
                                                      .watch(foreGroundColor)
                                                      .withAlpha(100),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                ),
                                                child: Text(
                                                  ref.watch(autoThemeChange)
                                                      ? " Active  "
                                                      : "Inactive",
                                                  style: TextStyle(
                                                    color: ref.watch(lightMode)
                                                        ? ref.watch(
                                                            foreGroundColor,
                                                          )
                                                        : Colors.white54,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ).animate().slideX(
                                          curve: Curves.decelerate,
                                          begin: -2,
                                          end: 0,
                                          delay: Duration(milliseconds: 600),
                                          duration: Duration(milliseconds: 700),
                                        ),
                                        //the prompt for confirmation of auto dark mode
                                        AnimatedCrossFade(
                                          firstChild: SizedBox(
                                            width:
                                                ref.watch(deviceSizeX) * 0.8.w,
                                          ),
                                          secondChild: Container(
                                            padding: EdgeInsets.only(
                                              top: 15,
                                              bottom: 15,
                                            ),
                                            color: ref.watch(lightMode)
                                                ? const Color.fromARGB(
                                                    29,
                                                    33,
                                                    149,
                                                    243,
                                                  )
                                                : Colors.white12,
                                            width:
                                                ref.watch(deviceSizeX) * 0.8.w,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    //first Hour
                                                    timeWidget(
                                                      ontap: () {
                                                        setState(() {
                                                          _firstHour =
                                                              _firstHour + 1;
                                                          _firstHour > 23
                                                              ? _firstHour = 0
                                                              : _firstHour =
                                                                    _firstHour;
                                                        });
                                                      },
                                                      //this is for the first_hour text
                                                      text: _firstHour
                                                          .toString(),
                                                      ref: ref,
                                                    ),
                                                    Text(
                                                      ':',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            ref.watch(lightMode)
                                                            ? Colors.black
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                    //First Minutes
                                                    timeWidget(
                                                      ontap: () {
                                                        _firstMinuteFirst =
                                                            _firstMinuteFirst +
                                                            1;
                                                        _firstMinuteFirst > 5
                                                            ? _firstMinuteFirst =
                                                                  0
                                                            : _firstMinuteFirst =
                                                                  _firstMinuteFirst;
                                                        setState(() {});
                                                      },
                                                      text: _firstMinuteFirst,
                                                      ref: ref,
                                                    ),

                                                    //Second part of first minutes buttom
                                                    timeWidget(
                                                      ontap: () {
                                                        _firstMinuteSecond =
                                                            _firstMinuteSecond +
                                                            1;
                                                        _firstMinuteSecond > 9
                                                            ? _firstMinuteSecond =
                                                                  0
                                                            : _firstMinuteSecond =
                                                                  _firstMinuteSecond;
                                                        setState(() {});
                                                      },
                                                      text: _firstMinuteSecond,
                                                      ref: ref,
                                                    ),
                                                    Text(
                                                      'to',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            ref.watch(lightMode)
                                                            ? Colors.black
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                    //second hour
                                                    timeWidget(
                                                      ontap: () {
                                                        _secondHour =
                                                            _secondHour + 1;
                                                        _secondHour > 23
                                                            ? _secondHour = 0
                                                            : _secondHour =
                                                                  _secondHour;
                                                        setState(() {});
                                                      },
                                                      text: _secondHour,
                                                      ref: ref,
                                                    ),

                                                    Text(
                                                      ':',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            ref.watch(lightMode)
                                                            ? Colors.black
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                    //second minute
                                                    timeWidget(
                                                      ontap: () {
                                                        _secondMinuteFirst =
                                                            _secondMinuteFirst +
                                                            1;
                                                        _secondMinuteFirst > 5
                                                            ? _secondMinuteFirst =
                                                                  0
                                                            : _secondMinuteFirst =
                                                                  _secondMinuteFirst;
                                                        setState(() {});
                                                      },
                                                      text: _secondMinuteFirst,
                                                      ref: ref,
                                                    ),
                                                    //second meridien - AM or PM
                                                    timeWidget(
                                                      ontap: () {
                                                        _secondMinuteSecond =
                                                            _secondMinuteSecond +
                                                            1;
                                                        _secondMinuteSecond > 9
                                                            ? _secondMinuteSecond =
                                                                  0
                                                            : _secondMinuteSecond =
                                                                  _secondMinuteSecond;
                                                        setState(() {});
                                                      },
                                                      text: _secondMinuteSecond,
                                                      ref: ref,
                                                    ),
                                                  ],
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    return showDialog(
                                                      context: context,
                                                      builder: (builder) => AlertDialog(
                                                        backgroundColor: ref
                                                            .watch(
                                                              foreGroundColor,
                                                            ),
                                                        title: Center(
                                                          child: Text(
                                                            'Hint',
                                                            style: customButtomTextStyle
                                                                .copyWith(
                                                                  color: ref.watch(
                                                                    backgroundColor,
                                                                  ),
                                                                ),
                                                          ),
                                                        ),
                                                        content: SingleChildScrollView(
                                                          child: ListBody(
                                                            children: <Widget>[
                                                              Text(
                                                                'Tapping on each box inside above the \'Click Me \' is used to update the time with the format beign \nH : MM to H : MM',
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: ref.watch(
                                                                    backgroundColor,
                                                                  ),
                                                                  wordSpacing:
                                                                      -0.1,
                                                                  letterSpacing:
                                                                      -0.5,
                                                                ),
                                                              ),
                                                              Text(""),
                                                              Text(
                                                                "Reset - return the value to their default\nUpdate - Update the db with the new configuration",
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: ref.watch(
                                                                    backgroundColor,
                                                                  ),
                                                                  wordSpacing:
                                                                      -0.1,
                                                                  letterSpacing:
                                                                      -0.5,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              _firstHour =
                                                                  lookForSettingBox()
                                                                          .get(
                                                                            "autoDarkModeInterval",
                                                                          ) ==
                                                                      null
                                                                  ? 0
                                                                  : int.parse(
                                                                      lookForSettingBox()
                                                                          .get(
                                                                            "autoDarkModeInterval",
                                                                          )[0]
                                                                          .split(
                                                                            ":",
                                                                          )[0],
                                                                    ); //this check the hive for the list holding the data
                                                              _firstMinuteFirst =
                                                                  lookForSettingBox()
                                                                          .get(
                                                                            "autoDarkModeInterval",
                                                                          ) ==
                                                                      null
                                                                  ? 0
                                                                  : int.parse(
                                                                      (lookForSettingBox()
                                                                              .get(
                                                                                "autoDarkModeInterval",
                                                                              )[0]
                                                                              .split(
                                                                                ":",
                                                                              )[1])
                                                                          .toString()
                                                                          .split(
                                                                            "",
                                                                          )[0],
                                                                    ); //the first part of first minute
                                                              _firstMinuteSecond =
                                                                  lookForSettingBox()
                                                                          .get(
                                                                            "autoDarkModeInterval",
                                                                          ) ==
                                                                      null
                                                                  ? 0
                                                                  : int.parse(
                                                                      (lookForSettingBox()
                                                                              .get(
                                                                                "autoDarkModeInterval",
                                                                              )[0]
                                                                              .split(
                                                                                ":",
                                                                              )[1])
                                                                          .toString()
                                                                          .split(
                                                                            "",
                                                                          )[1],
                                                                    ); //the second part of the first minute
                                                              _secondHour =
                                                                  lookForSettingBox()
                                                                          .get(
                                                                            "autoDarkModeInterval",
                                                                          ) ==
                                                                      null
                                                                  ? 0
                                                                  : int.parse(
                                                                      lookForSettingBox()
                                                                          .get(
                                                                            "autoDarkModeInterval",
                                                                          )[1]
                                                                          .split(
                                                                            ":",
                                                                          )[0],
                                                                    );
                                                              _secondMinuteFirst =
                                                                  lookForSettingBox()
                                                                          .get(
                                                                            "autoDarkModeInterval",
                                                                          ) ==
                                                                      null
                                                                  ? 0
                                                                  : int.parse(
                                                                      (lookForSettingBox()
                                                                              .get(
                                                                                "autoDarkModeInterval",
                                                                              )[1]
                                                                              .split(
                                                                                ":",
                                                                              )[1])
                                                                          .toString()
                                                                          .split(
                                                                            "",
                                                                          )[0],
                                                                    ); //the first part of second minute
                                                              _secondMinuteSecond =
                                                                  lookForSettingBox()
                                                                          .get(
                                                                            "autoDarkModeInterval",
                                                                          ) ==
                                                                      null
                                                                  ? 0
                                                                  : int.parse(
                                                                      (lookForSettingBox()
                                                                              .get(
                                                                                "autoDarkModeInterval",
                                                                              )[1]
                                                                              .split(
                                                                                ":",
                                                                              )[1])
                                                                          .toString()
                                                                          .split(
                                                                            "",
                                                                          )[1],
                                                                    ); //the second part of the second minute
                                                              setState(() {});
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                            },
                                                            child: Text(
                                                              "Reset",
                                                              style: TextStyle(
                                                                color: ref.watch(
                                                                  backgroundColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () async {
                                                              final autoDarkModeStart =
                                                                  "${_firstHour < 10 ? "0$_firstHour" : "$_firstHour"}:$_firstMinuteFirst$_firstMinuteSecond";

                                                              final autoDarkModeEnd =
                                                                  "${_secondHour < 10 ? "0$_secondHour" : "$_secondHour"}:$_secondMinuteFirst$_secondMinuteSecond";
                                                              lookForSettingBox().put(
                                                                "autoDarkModeInterval",
                                                                [
                                                                  autoDarkModeStart,
                                                                  autoDarkModeEnd,
                                                                ],
                                                              );

                                                              //update too should make sure the rivepod is updated instantly as the db cannot be called until the splshcreen appear
                                                              autoDarkModeUpdate(
                                                                ref: ref,
                                                                context:
                                                                    context,
                                                              );
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                            },
                                                            child: Text(
                                                              "update",
                                                              style: TextStyle(
                                                                color: ref.watch(
                                                                  backgroundColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                      top: 5,
                                                    ),
                                                    child: Text(
                                                      "Click Me",
                                                      style:
                                                          customButtomTextStyle
                                                              .copyWith(
                                                                fontSize: 12.sp
                                                                    .clamp(
                                                                      0,
                                                                      12,
                                                                    ),
                                                                wordSpacing: 2,
                                                                letterSpacing:
                                                                    2,
                                                                color:
                                                                    ref.watch(
                                                                      lightMode,
                                                                    )
                                                                    ? Colors
                                                                          .black
                                                                    : Colors
                                                                          .white,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          crossFadeState:
                                              ref.watch(autoThemeChange)
                                              ? CrossFadeState.showSecond
                                              : CrossFadeState.showFirst,
                                          duration: Duration(milliseconds: 200),
                                          sizeCurve: Curves.easeIn,
                                        ).animate().slideX(
                                          curve: Curves.decelerate,
                                          begin: -2,
                                          end: 0,
                                          delay: Duration(milliseconds: 400),
                                          duration: Duration(milliseconds: 700),
                                        ),

                                        //for the offline log of backups and retreival
                                        AnimatedCrossFade(
                                          firstChild: InkWell(
                                            onTap: () {
                                              if (ref.read(
                                                isChangeTimeLogActive,
                                              )) {
                                                ref.invalidate(
                                                  isChangeTimeLogActive,
                                                );
                                              } else {
                                                ref
                                                        .read(
                                                          isChangeTimeLogActive
                                                              .notifier,
                                                        )
                                                        .state =
                                                    true;
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical:
                                                    ref.watch(deviceSizeY) *
                                                    0.02.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    child: Icon(
                                                      Icons
                                                          .manage_history_rounded,
                                                      color: ref.watch(
                                                        foreGroundColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Retreive/Backup Time Logs',
                                                    style: TextStyle(
                                                      letterSpacing: -1,
                                                      wordSpacing: 1.4,
                                                      fontSize: 17.sp.clamp(
                                                        0,
                                                        17,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ref.watch(
                                                        foreGroundColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          secondChild: Container(
                                            width: ref.watch(deviceSizeX).w,
                                            height:
                                                ref.watch(deviceSizeY) * 0.2.h,
                                            child: PageView(
                                              children: [
                                                //for the backup logs only
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: SingleChildScrollView(
                                                    physics:
                                                        AlwaysScrollableScrollPhysics(),
                                                    child: Column(
                                                      children: [
                                                        //header
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {
                                                                if (ref.read(
                                                                  isChangeTimeLogActive,
                                                                )) {
                                                                  ref.invalidate(
                                                                    isChangeTimeLogActive,
                                                                  );
                                                                } else {
                                                                  ref
                                                                          .read(
                                                                            isChangeTimeLogActive.notifier,
                                                                          )
                                                                          .state =
                                                                      true;
                                                                }
                                                              },
                                                              icon: Icon(
                                                                color: ref.watch(
                                                                  foreGroundColor,
                                                                ),
                                                                Icons.close,
                                                              ),
                                                            ),
                                                            Text(
                                                              "swipe",
                                                              style: TextStyle(
                                                                color: ref.watch(
                                                                  foreGroundColor,
                                                                ),
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                            Icon(
                                                              color: ref.watch(
                                                                foreGroundColor,
                                                              ),

                                                              Icons
                                                                  .chevron_right,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Backup Logs",
                                                              style: TextStyle(
                                                                color: ref.watch(
                                                                  foreGroundColor,
                                                                ),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12.sp
                                                                    .clamp(
                                                                      0,
                                                                      14,
                                                                    ),
                                                                wordSpacing:
                                                                    -0.5,

                                                                letterSpacing:
                                                                    -0.5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        ...lookForSettingBox().get(
                                                                  "retreiveBackupLocalLog",
                                                                ) !=
                                                                null
                                                            ? List.generate(
                                                                (lookForSettingBox().get(
                                                                          "retreiveBackupLocalLog",
                                                                        )?["backup"]
                                                                        as List)
                                                                    .length,
                                                                (
                                                                  index,
                                                                ) => Container(
                                                                  margin:
                                                                      EdgeInsets.all(
                                                                        5,
                                                                      ),
                                                                  padding:
                                                                      EdgeInsets.all(
                                                                        8.0,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color: ref
                                                                        .watch(
                                                                          backgroundColor,
                                                                        ),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                          Radius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                  ),
                                                                  child: Text(
                                                                    "${lookForSettingBox().get("retreiveBackupLocalLog")["backup"][index]}",
                                                                    style: TextStyle(
                                                                      color: ref
                                                                          .watch(
                                                                            foreGroundColor,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : [Text("No Logs")],
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                //for the retreive logs only
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    10,
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        //header
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                              onPressed: null,
                                                              icon: Icon(
                                                                Icons
                                                                    .chevron_left,
                                                                color: ref.watch(
                                                                  foreGroundColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              "swipe",
                                                              style: TextStyle(
                                                                color: ref.watch(
                                                                  foreGroundColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Retreive Logs",
                                                              style: TextStyle(
                                                                color: ref.watch(
                                                                  foreGroundColor,
                                                                ),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12.sp
                                                                    .clamp(
                                                                      0,
                                                                      14,
                                                                    ),
                                                                wordSpacing:
                                                                    -0.5,

                                                                letterSpacing:
                                                                    -0.5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        ...lookForSettingBox().get(
                                                                  "retreiveBackupLocalLog",
                                                                ) !=
                                                                null
                                                            ? List.generate(
                                                                (lookForSettingBox().get(
                                                                          "retreiveBackupLocalLog",
                                                                        )?["retreive"]
                                                                        as List)
                                                                    .length,
                                                                (
                                                                  index,
                                                                ) => Container(
                                                                  margin:
                                                                      EdgeInsets.all(
                                                                        5,
                                                                      ),
                                                                  padding:
                                                                      EdgeInsets.all(
                                                                        8.0,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color: ref
                                                                        .watch(
                                                                          backgroundColor,
                                                                        ),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                          Radius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                  ),
                                                                  child: Text(
                                                                    "${lookForSettingBox().get("retreiveBackupLocalLog")?["retreive"][index]}",
                                                                    style: TextStyle(
                                                                      color: ref
                                                                          .watch(
                                                                            foreGroundColor,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : [Text("No Logs")],
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          crossFadeState:
                                              ref.watch(isChangeTimeLogActive)
                                              ? CrossFadeState.showSecond
                                              : CrossFadeState.showFirst,
                                          duration: Duration(milliseconds: 350),
                                        ).animate().slideX(
                                          curve: Curves.decelerate,
                                          begin: -2,
                                          end: 0,
                                          delay: Duration(
                                            seconds: 1,
                                            milliseconds: 200,
                                          ),
                                          duration: Duration(milliseconds: 650),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await showDialog(
                                              context: context,
                                              builder: (builder) {
                                                return AlertDialog(
                                                  backgroundColor: ref.watch(
                                                    foreGroundColor,
                                                  ),
                                                  title: Text(
                                                    "Warning!",
                                                    style: TextStyle(
                                                      color: ref.watch(
                                                        backgroundColor,
                                                      ),
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "This will wipe away the local history on this device!!!, to retreive it later, you need to restore backup from a previous one containing the data, do you still want to proceed or cancel",
                                                    style: TextStyle(
                                                      color: ref.watch(
                                                        backgroundColor,
                                                      ),
                                                      wordSpacing: 1.5,
                                                      letterSpacing: -1,
                                                    ),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      child: Text("Proceed"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      child: Text("Cancel"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical:
                                                  ref.watch(deviceSizeY) *
                                                  0.02.h,
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  child: Icon(
                                                    Icons.delete_sweep_sharp,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                Text(
                                                  'Clear Past lectures',
                                                  style: TextStyle(
                                                    letterSpacing: -1,
                                                    wordSpacing: 1.4,
                                                    fontSize: 17.sp.clamp(
                                                      0,
                                                      17,
                                                    ),
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        LottieBuilder.asset(
                                          "assets/lottie/morning.json",
                                        ),
                                      ],
                                    )
                                  //online config page
                                  : Container(
                                      width: ref.watch(deviceSizeX).w,
                                      height: 400.h,
                                      child: PageView(
                                        children: [
                                          //view backup history
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              columnData(
                                                text: "View Backup History",
                                                ref: ref,
                                                iconData: Icons.history,
                                                onTap: () {},
                                                iconOnTap: () {},
                                              ),
                                              Expanded(
                                                child: FutureBuilder(
                                                  future: Future(() async {
                                                    List dataToUse = [];
                                                    if (ref.watch(
                                                      viewBackupHistoryPassed,
                                                    )) {
                                                      dataToUse = await ref
                                                          .read(
                                                            viewBackupHistory
                                                                .future,
                                                          );
                                                    } else {
                                                      ref
                                                              .read(
                                                                viewBackupHistoryPassed
                                                                    .notifier,
                                                              )
                                                              .state =
                                                          true;
                                                      ;
                                                      ref.invalidate(
                                                        viewBackupHistory,
                                                      );
                                                      dataToUse = await ref
                                                          .read(
                                                            viewBackupHistory
                                                                .future,
                                                          )
                                                          .timeout(
                                                            Duration(
                                                              seconds: 5,
                                                            ),
                                                            onTimeout: () => [
                                                              404,
                                                              {
                                                                "message":
                                                                    "Network Timeout",
                                                              },
                                                            ],
                                                          );
                                                    }

                                                    return dataToUse;
                                                  }),
                                                  builder:
                                                      (
                                                        BuildContext builder,
                                                        AsyncSnapshot snapshot,
                                                      ) {
                                                        print(snapshot.data);
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Center(
                                                            child: CircularProgressIndicator(
                                                              color: ref.watch(
                                                                foreGroundColor,
                                                              ),
                                                            ),
                                                          );
                                                        } else if (snapshot
                                                            .hasData) {
                                                          //for when the status is not 200
                                                          if (snapshot
                                                                  .data[0] !=
                                                              200) {
                                                            return SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  IconButton(
                                                                    onPressed: () {
                                                                      ref.invalidate(
                                                                        viewBackupHistoryPassed,
                                                                      );
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .refresh,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                          //the message is definety 200, format a response and return it
                                                          return SingleChildScrollView(
                                                            child: Column(
                                                              children: [
                                                                ...List.generate(
                                                                  (snapshot.data?[1]["message"]
                                                                          as List)
                                                                      .length,
                                                                  (index) {
                                                                    return Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                            10,
                                                                          ),
                                                                      margin:
                                                                          EdgeInsets.all(
                                                                            4,
                                                                          ),
                                                                      width: ref
                                                                          .watch(
                                                                            deviceSizeX,
                                                                          )
                                                                          .w,
                                                                      decoration: BoxDecoration(
                                                                        color:
                                                                            ref.watch(
                                                                              lightMode,
                                                                            )
                                                                            ? Colors.transparent
                                                                            : Colors.transparent,
                                                                        border: BoxBorder.all(
                                                                          width:
                                                                              0.5,
                                                                          color: ref
                                                                              .watch(
                                                                                foreGroundColor,
                                                                              )
                                                                              .withAlpha(
                                                                                90,
                                                                              ),
                                                                        ),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                ref.watch(
                                                                                  lightMode,
                                                                                )
                                                                                ? ref
                                                                                      .watch(
                                                                                        foreGroundColor,
                                                                                      )
                                                                                      .withAlpha(
                                                                                        15,
                                                                                      )
                                                                                : Colors.white12,
                                                                            offset: Offset(
                                                                              1,
                                                                              1,
                                                                            ),
                                                                            blurRadius:
                                                                                2,
                                                                          ),
                                                                        ],
                                                                        borderRadius: BorderRadius.all(
                                                                          Radius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            // "${snapshot.data}",
                                                                            DateFormat(
                                                                              "dd MMM yyyy, hh:mm a",
                                                                            ).format(
                                                                              DateTime.parse(
                                                                                snapshot.data?[1]["message"][index]["time"],
                                                                              ),
                                                                            ),
                                                                            style: TextStyle(
                                                                              color: ref.watch(
                                                                                foreGroundColor,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                              backgroundColor: ref.watch(
                                                                                foreGroundColor,
                                                                              ),
                                                                              foregroundColor: ref.watch(
                                                                                backgroundColor,
                                                                              ),
                                                                              shadowColor: ref
                                                                                  .watch(
                                                                                    foreGroundColor,
                                                                                  )
                                                                                  .withAlpha(
                                                                                    180,
                                                                                  ),
                                                                              elevation: 2,
                                                                              shape: RoundedRectangleBorder(),
                                                                              side: BorderSide(
                                                                                color: ref
                                                                                    .watch(
                                                                                      foreGroundColor,
                                                                                    )
                                                                                    .withAlpha(
                                                                                      30,
                                                                                    ),
                                                                                width: 2,
                                                                              ),
                                                                            ),
                                                                            onPressed: () async {
                                                                              //showdialog for confirmation
                                                                              await showDialog(
                                                                                context: context,
                                                                                builder:
                                                                                    (
                                                                                      builder,
                                                                                    ) {
                                                                                      return AlertDialog(
                                                                                        backgroundColor: ref.watch(
                                                                                          foreGroundColor,
                                                                                        ),

                                                                                        title: Text(
                                                                                          "Retreive Data",
                                                                                          style: TextStyle(
                                                                                            color: ref.watch(
                                                                                              backgroundColor,
                                                                                            ),
                                                                                            fontWeight: FontWeight.bold,
                                                                                            letterSpacing: -1,
                                                                                            wordSpacing: 1.2,
                                                                                          ),
                                                                                        ),
                                                                                        content: Container(
                                                                                          height:
                                                                                              ref
                                                                                                  .watch(
                                                                                                    deviceSizeY,
                                                                                                  )
                                                                                                  .w *
                                                                                              0.25,
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                            children: [
                                                                                              Text(
                                                                                                "are you sure you want to overide your current data to this selected data?",
                                                                                                style: TextStyle(
                                                                                                  color: ref.watch(
                                                                                                    backgroundColor,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                "you can always overide data from any time in your backup history",
                                                                                                style: TextStyle(
                                                                                                  color: ref.watch(
                                                                                                    backgroundColor,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        actions: [
                                                                                          ElevatedButton(
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: ref.watch(
                                                                                                foreGroundColor,
                                                                                              ),

                                                                                              foregroundColor: ref.watch(
                                                                                                backgroundColor,
                                                                                              ),
                                                                                            ),
                                                                                            onPressed: () async {
                                                                                              ref
                                                                                                      .read(
                                                                                                        _nothingShouldWorkConfirmer.notifier,
                                                                                                      )
                                                                                                      .state =
                                                                                                  true;
                                                                                              await Future.delayed(
                                                                                                Duration(
                                                                                                  milliseconds: 300,
                                                                                                ),
                                                                                              );
                                                                                              ;
                                                                                              Navigator.of(
                                                                                                context,
                                                                                              ).pop();
                                                                                            },
                                                                                            child: Text(
                                                                                              "Confirm",
                                                                                            ),
                                                                                          ),
                                                                                          ElevatedButton(
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: Colors.red,

                                                                                              foregroundColor: Colors.white,
                                                                                            ),
                                                                                            onPressed: () {
                                                                                              Navigator.of(
                                                                                                context,
                                                                                              ).pop();
                                                                                            },
                                                                                            child: Text(
                                                                                              "Cancel",
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                              );
                                                                              if (ref.read(
                                                                                    _nothingShouldWorkConfirmer,
                                                                                  ) ==
                                                                                  false)
                                                                                return;
                                                                              //i am allowed to perfom retreival now
                                                                              ref
                                                                                      .read(
                                                                                        _nothingShouldWork.notifier,
                                                                                      )
                                                                                      .state =
                                                                                  true;
                                                                              int
                                                                              id = snapshot.data?[1]["message"][index]["id"];
                                                                              final url = await Uri.parse(
                                                                                "${ref.read(domain)}alltimeHistory/",
                                                                              );
                                                                              final request = await http.post(
                                                                                url,
                                                                                headers: {
                                                                                  "Content-Type": "application/json",
                                                                                },
                                                                                body: jsonEncode(
                                                                                  {
                                                                                    "email": lookForSettingBox().get(
                                                                                      "backupEmail",
                                                                                    ),
                                                                                    "password": lookForSettingBox().get(
                                                                                      "backupPassword",
                                                                                    ),
                                                                                    "id": id,
                                                                                  },
                                                                                ),
                                                                              );
                                                                              final response = await jsonDecode(
                                                                                request.body,
                                                                              );
                                                                              List
                                                                              data = [
                                                                                request.statusCode,
                                                                                response,
                                                                              ];

                                                                              if (data[0] ==
                                                                                  200) {
                                                                                final locator = await CustomDbClass.instance.getter;

                                                                                await locator.rawDelete(
                                                                                  "DELETE FROM todayLectures",
                                                                                );
                                                                                await locator.rawDelete(
                                                                                  "DELETE FROM userAllTimetable",
                                                                                );
                                                                                await locator.rawDelete(
                                                                                  "DELETE FROM lectureTrackers",
                                                                                );

                                                                                //draw the date back by one so the splashscreen can go pick data from the main table
                                                                                lookForSettingBox().put(
                                                                                  "todayDate",
                                                                                  DateTime.now().day -
                                                                                      1,
                                                                                );
                                                                                //Now update it
                                                                                //update the past lectures
                                                                                for (Map i in data[1]["message"]["history"]) {
                                                                                  insertIntoPastLectureTrackers(
                                                                                    dbLocator: locator,
                                                                                    title: i["title"],
                                                                                    date: i["date"],
                                                                                    accomplised: i["accomplised"],
                                                                                  );
                                                                                  ref
                                                                                      .read(
                                                                                        pastLectureSQLprovider.notifier,
                                                                                      )
                                                                                      .update(
                                                                                        (
                                                                                          State,
                                                                                        ) {
                                                                                          return [
                                                                                            ...State,
                                                                                            i,
                                                                                          ];
                                                                                        },
                                                                                      );
                                                                                }

                                                                                //update the main table
                                                                                for (Map i in data[1]["message"]["currentData"])
                                                                                  insertIntoMainLectures(
                                                                                    dbLocator: locator,
                                                                                    title: i["title"],
                                                                                    start_time: i["start_time"],
                                                                                    end_time: i["end_time"],
                                                                                    dayOfTheWeek: i["dayOfTheWeek"],
                                                                                    color: i["color"],
                                                                                  );

                                                                                //update success, now show the lottie
                                                                                ref
                                                                                        .read(
                                                                                          successAnimation.notifier,
                                                                                        )
                                                                                        .state =
                                                                                    true;
                                                                              }
                                                                              ref.invalidate(
                                                                                _nothingShouldWork,
                                                                              );
                                                                              ref.invalidate(
                                                                                _nothingShouldWorkConfirmer,
                                                                              );
                                                                              print(
                                                                                data,
                                                                              );
                                                                            },
                                                                            child: Text(
                                                                              "Retreive",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                    // .animate().slideX(
                                                                    //   begin: -2,
                                                                    //   end: 0,
                                                                    //   curve: Curves
                                                                    //       .bounceInOut,
                                                                    //   duration: Duration(
                                                                    //     seconds:
                                                                    //         1,
                                                                    //   ),
                                                                    //   delay: Duration(
                                                                    //     milliseconds:
                                                                    //         index *
                                                                    //         350,
                                                                    //   ),
                                                                    // );
                                                                  },
                                                                ).reversed,
                                                                IconButton(
                                                                  color: ref.watch(
                                                                    foreGroundColor,
                                                                  ),

                                                                  onPressed: () {
                                                                    ref.invalidate(
                                                                      viewBackupHistoryPassed,
                                                                    );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .refresh,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        } else {
                                                          return Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Error, Hit the retry button.",
                                                                ),
                                                                IconButton(
                                                                  color: Colors
                                                                      .red,
                                                                  onPressed: () {
                                                                    ref.invalidate(
                                                                      viewBackupHistoryPassed,
                                                                    );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .refresh,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                      },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: ref.watch(foreGroundColor).withAlpha(43),
                              ),
                              shape: RoundedRectangleBorder(),
                              backgroundColor: ref.watch(foreGroundColor),
                              foregroundColor: ref.watch(backgroundColor),
                            ),
                            onPressed: () async {
                              await lookForSettingBox().delete("auth_key");
                              await lookForSettingBox().delete(
                                "backupPassword",
                              );
                              await lookForSettingBox().delete("backupEmail");
                              ref.read(successAnimation.notifier).state = true;
                            },
                            child: Text(
                              "Sign Out",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              child: Container(
                // margin: EdgeInsets.only(top: ref.watch(deviceSizeY) * 0.5.h),
                child: Center(
                  child: ref.watch(successAnimation)
                      ? LottieBuilder.asset(
                          onLoaded: (v) async {
                            // print(v);
                            await Future.delayed(Duration(seconds: 2));
                            ref.invalidate(successAnimation);
                            await Future.delayed(Duration(milliseconds: 500));
                            router.pop();
                          },
                          width: ref.watch(deviceSizeX) * 0.3.w,
                          // height: ,
                          repeat: false,
                          ref.read(lightMode)
                              ? "assets/lottie/success_blue.json"
                              : 'assets/lottie/success.json',
                        )
                      : SizedBox(),
                ),
              ),
            ),
            Positioned(
              child: ref.watch(_nothingShouldWork)
                  ? Container(
                      width: ref.watch(deviceSizeX).w,
                      height: ref.watch(deviceSizeY).h,
                      color: Colors.white54,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ref.read(deviceSizeX).w * 0.35,
                                vertical: 20,
                              ),
                              child: LinearProgressIndicator(
                                color: ref.watch(foreGroundColor),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () {
                                ref.invalidate(_nothingShouldWork);
                              },
                              child: Text("Cancel"),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

final offlineConfig = StateProvider((ref) {
  return true;
});

final isChangeUsernameActive = StateProvider((ref) {
  return false;
});

final successAnimation = StateProvider((ref) {
  return false;
});
//come here to edit the input like ontap and co etc //brb
Widget columnData({
  required WidgetRef ref,
  required IconData iconData,
  required void Function() onTap,
  required void Function() iconOnTap,
  required String text,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: ref.watch(deviceSizeY) * 0.02.h),
    child: InkWell(
      onTap: onTap,
      child: Row(
        children: [
          IconButton(
            onPressed: iconOnTap,
            icon: Icon(iconData, color: ref.watch(foreGroundColor)),
          ),
          Text(
            text,
            style: TextStyle(
              letterSpacing: -1,
              wordSpacing: 1.4,
              fontSize: 17.sp.clamp(0, 17),
              fontWeight: FontWeight.w600,
              color: ref.watch(foreGroundColor),
            ),
          ),
        ],
      ),
    ),
  );
}

void autoDarkModeUpdate({
  required WidgetRef ref,
  required BuildContext context,
}) {
  final autoDarkModeSetting = lookForSettingBox().get("autoDarkModeInterval");
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
    if (endTimeStartHour < startTimeStartHour) {
      endTimeStartHour =
          endTimeStartHour +
          24; //i inreased the endtime hour value by 24 so it can catch up with the time diff
    }

    if (startTimeStartHour <= currentTimeHour &&
        currentTimeHour < endTimeStartHour) //1 , 2, 3 or 1,1, 3
    {
      print("enable dark mode");
      ref.read(lightMode.notifier).state = false;
    } else if (startTimeStartHour == currentTimeHour &&
        currentTimeHour == endTimeStartHour) //1, 1, 1
    {
      if (startTimeStartMinutes <= currentTimeMinutes &&
          currentTimeMinutes <= endTimeStartMinutes) {
        print("enable dark mode");
        ref.read(lightMode.notifier).state = false;
      } else {
        //damn, the current time min is greater than the end time min even though both the hour are the same
        ref.read(lightMode.notifier).state = true;
      }
    } else if (startTimeStartHour < currentTimeHour &&
        currentTimeHour <= endTimeStartHour) //1, 2, 2
    {
      if (currentTimeMinutes < endTimeStartMinutes) {
        print("enable dark mode");
        ref.read(lightMode.notifier).state = false;
      } else {
        ref.read(lightMode.notifier).state = true;
      }
    } else {
      //, the current hour min is greater than the end time hour or too low than the start time hour so dark mode cannot be auto apply
      ref.read(lightMode.notifier).state = true;
    }
    print([startTime, TimeOfDay.now().format(context), endTime]);
  }
}

final autoThemeChange = StateProvider<bool>((ref) {
  if (lookForSettingBox().get("autoDarkModeInterval") == null) {
    return false;
  } else {
    return true;
  }
});

final isChangeTimeLogActive = StateProvider((ref) {
  return false;
});

final viewBackupHistory = FutureProvider<List>((ref) async {
  print("starting");
  final url = await Uri.parse("${ref.read(domain)}alltimeHistory/");
  //sending request
  final request = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": lookForSettingBox().get("backupEmail"),
      "password": lookForSettingBox().get("backupPassword"),
    }),
  );
  ref.read(viewBackupHistoryPassed.notifier).state = true;
  final response = await jsonDecode(request.body);
  return [request.statusCode, response];
});
final viewBackupHistoryPassed = StateProvider<bool>((ref) {
  return false;
});

final _nothingShouldWork = StateProvider<bool>((ref) {
  return false;
});

final _nothingShouldWorkConfirmer = StateProvider((ref) {
  return false;
});
