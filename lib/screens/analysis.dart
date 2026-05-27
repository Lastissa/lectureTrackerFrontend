import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/aichat.dart';
import 'package:lecture_tracker/screens/backupAndrestore.dart';
import 'package:lecture_tracker/utils.dart';
import 'package:http/http.dart' as http;

class Analysis extends ConsumerStatefulWidget {
  const Analysis({super.key});

  @override
  ConsumerState<Analysis> createState() => AnalysisState();
}

class AnalysisState extends ConsumerState<Analysis> {
  late final ScrollController aiScrollController;

  @override
  void initState() {
    super.initState();
    aiScrollController = ScrollController();
  }

  @override
  void dispose() {
    aiScrollController.dispose();
    super.dispose();
  }

  bool toggleButtonValue = false;
  UniqueKey refreshAiProvider = UniqueKey();
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
          router.go("/settings");
        },
        child: Container(
          width: ref.watch(deviceSizeX).w,
          height: ref.watch(deviceSizeY).h,
          color: ref.watch(backgroundColor),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      size: 30.sp,
                      color: ref.watch(foreGroundColor),
                    ),
                    onPressed: () {
                      router.go("/settings");
                    },
                  ),
                  Switch(
                    trackOutlineColor: WidgetStatePropertyAll(
                      ref.watch(foreGroundColor),
                    ),
                    thumbColor: WidgetStateProperty.all(
                      ref.watch(lightMode) ? Colors.white : Colors.black,
                    ),
                    trackColor: WidgetStateProperty.all(
                      ref.watch(foreGroundColor),
                    ),

                    value: ref.watch(lightMode),
                    onChanged: (v) {
                      ref.read(lightMode.notifier).state = v;
                    },
                  ),
                ],
              ),

              // everything about current lecture analysis -under maybe will i do this.
              Row(),

              //everything about past record analysis
              FutureBuilder(
                future: Future(() async {
                  // await Future.delayed(Duration(seconds: 2)); // testing what the connectionstate will show
                  final pastLecture = ref.read(pastLectureSQLprovider);

                  ///this is if pastlecture is empty
                  if (pastLecture.length == 0) {
                    return [0, 0, 0, []];
                  }
                  int missedLectureCounter = 0;
                  int attendlectureCounter = 0;
                  int nullLectureCounter = 0;

                  //it mean past lecture is not empty and proceed
                  for (var i in pastLecture) {
                    if (i["accomplised"] == 0) {
                      missedLectureCounter += 1;
                    }
                    if (i["accomplised"] == 1) {
                      attendlectureCounter += 1;
                    }
                    if (i["accomplised"] == 2) {
                      nullLectureCounter += 1;
                    }
                  }
                  //for each day, missed, attended and nullified
                  double sun0 = 0;
                  double sun1 = 0;
                  double sun2 = 0;
                  double mon0 = 0;
                  double mon1 = 0;
                  double mon2 = 0;
                  double tue0 = 0;
                  double tue1 = 0;
                  double tue2 = 0;
                  double wed0 = 0;
                  double wed1 = 0;
                  double wed2 = 0;
                  double thu0 = 0;
                  double thu1 = 0;
                  double thu2 = 0;
                  double fri0 = 0;
                  double fri1 = 0;
                  double fri2 = 0;
                  double sat0 = 0;
                  double sat1 = 0;
                  double sat2 = 0;
                  //data per week for line trend - brb

                  List<List> dataPerDayOfThWeek = [
                    [0.0, 0.0, 0.0], //sunday [missed, attend, null]
                    [0.0, 0.0, 0.0], //monday
                    [0.0, 0.0, 0.0], //tuesday
                    [0.0, 0.0, 0.0], //wednesday
                    [0.0, 0.0, 0.0], //thursday
                    [0.0, 0.0, 0.0], //friday
                    [0.0, 0.0, 0.0], //saturday
                  ];

                  for (var i in pastLecture) {
                    if ((i["date"]).toString().toUpperCase().contains("SUN")) {
                      if (i["accomplised"] == 0) {
                        sun0 = sun0 + 1;
                      }
                      if (i["accomplised"] == 1) {
                        sun1 = sun1 + 1;
                      }
                      if (i["accomplised"] == 2) {
                        sun2 = sun2 + 1;
                      }
                    }
                    if ((i["date"]).toString().toUpperCase().contains("MON")) {
                      if (i["accomplised"] == 0) {
                        mon0 = mon0 + 1;
                      }
                      if (i["accomplised"] == 1) {
                        mon1 = mon1 + 1;
                      }
                      if (i["accomplised"] == 2) {
                        mon2 = mon2 + 1;
                      }
                    }
                    if ((i["date"]).toString().toUpperCase().contains("TUE")) {
                      if (i["accomplised"] == 0) {
                        tue0 = tue0 + 1;
                      }
                      if (i["accomplised"] == 1) {
                        tue1 = tue1 + 1;
                      }
                      if (i["accomplised"] == 2) {
                        tue2 = tue2 + 1;
                      }
                    }
                    if ((i["date"]).toString().toUpperCase().contains("WED")) {
                      if (i["accomplised"] == 0) {
                        wed0 = wed0 + 1;
                      }
                      if (i["accomplised"] == 1) {
                        wed1 = wed1 + 1;
                      }
                      if (i["accomplised"] == 2) {
                        wed2 = wed2 + 1;
                      }
                    }
                    if ((i["date"]).toString().toUpperCase().contains("THU")) {
                      if (i["accomplised"] == 0) {
                        thu0 = thu0 + 1;
                      }
                      if (i["accomplised"] == 1) {
                        thu1 = thu1 + 1;
                      }
                      if (i["accomplised"] == 2) {
                        thu2 = thu2 + 1;
                      }
                    }
                    if ((i["date"]).toString().toUpperCase().contains("FRI")) {
                      if (i["accomplised"] == 0) {
                        fri0 = fri0 + 1;
                      }
                      if (i["accomplised"] == 1) {
                        fri1 = fri1 + 1;
                      }
                      if (i["accomplised"] == 2) {
                        fri2 = fri2 + 1;
                      }
                    }
                    if ((i["date"]).toString().toUpperCase().contains("SAT")) {
                      if (i["accomplised"] == 0) {
                        sat0 = sat0 + 1;
                      }
                      if (i["accomplised"] == 1) {
                        sat1 = sat1 + 1;
                      }
                      if (i["accomplised"] == 2) {
                        sat2 = sat2 + 1;
                      }
                    }
                  }
                  //updating the dataPerDayOfThWeek to contains the result of the loop
                  dataPerDayOfThWeek.removeAt(0); //sunday
                  dataPerDayOfThWeek.insert(0, [sun0, sun1, sun2]);
                  dataPerDayOfThWeek.removeAt(1); //monday
                  dataPerDayOfThWeek.insert(1, [mon0, mon1, mon2]);
                  dataPerDayOfThWeek.removeAt(2); //tuesday
                  dataPerDayOfThWeek.insert(2, [tue0, tue1, tue2]);
                  dataPerDayOfThWeek.removeAt(3); //wednesday
                  dataPerDayOfThWeek.insert(3, [wed0, wed1, wed2]);
                  dataPerDayOfThWeek.removeAt(4); //thursday
                  dataPerDayOfThWeek.insert(4, [thu0, thu1, thu2]);
                  dataPerDayOfThWeek.removeAt(5); //friday
                  dataPerDayOfThWeek.insert(5, [fri0, fri1, fri2]);
                  dataPerDayOfThWeek.removeAt(6); //saturday
                  dataPerDayOfThWeek.insert(6, [sat0, sat1, sat2]);

                  //data per week on missed and using this to draw line chart for user to see decline and peak. I will loop through each of data of the week for chart drawing,use the for loop to add to it
                  List dataPerWeek = [
                    [0, 0, 0],
                  ];

                  return [
                    missedLectureCounter,
                    attendlectureCounter,
                    nullLectureCounter,
                    dataPerDayOfThWeek,
                  ];
                }),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ref.watch(deviceSizeX).w,
                              padding: EdgeInsets.all(18.r),
                              decoration: BoxDecoration(
                                color: ref.watch(lightMode)
                                    ? Colors.white
                                    : Colors.grey[900],
                                borderRadius: BorderRadius.circular(18.r),
                                border: Border.all(
                                  color: ref
                                      .watch(foreGroundColor)
                                      .withAlpha(46),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "Lecture Analysis",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: ref.watch(foreGroundColor),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    snapshot.data[0] > snapshot.data[1]
                                        ? "WARNING!!! MISSED LECTURE IS GREATER THAN ATTENDED LECTURES!"
                                        : "Summary of your attendance history with AI-driven insights and daily trends.",

                                    style: TextStyle(
                                      wordSpacing: 1.2,
                                      fontSize: 14.sp,
                                      color: snapshot.data[0] > snapshot.data[1]
                                          ? Colors.red
                                          : ref
                                                .watch(foreGroundColor)
                                                .withAlpha(230),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                pieContainer(
                                  ref: ref,
                                  color: Colors.red,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedTextKit(
                                          pause: Duration(seconds: 2),
                                          totalRepeatCount: 1,
                                          animatedTexts: [
                                            ScrambleAnimatedText(
                                              snapshot.data[0].toString(),
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30.sp.clamp(20, 40),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          "MISSED",
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: ref.watch(backgroundColor),
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                pieContainer(
                                  ref: ref,
                                  color: Colors.green,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedTextKit(
                                          pause: Duration(seconds: 2),
                                          totalRepeatCount: 1,
                                          animatedTexts: [
                                            ScrambleAnimatedText(
                                              snapshot.data[1].toString(),
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30.sp.clamp(20, 40),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          "ATTENDED",
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: ref.watch(backgroundColor),
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                pieContainer(
                                  ref: ref,
                                  color: Colors.blueAccent,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedTextKit(
                                          pause: Duration(seconds: 2),
                                          totalRepeatCount: 1,
                                          animatedTexts: [
                                            ScrambleAnimatedText(
                                              snapshot.data[2].toString(),
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30.sp.clamp(20, 40),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          "NULLIFIED",
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.white,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(18.r),
                              decoration: BoxDecoration(
                                color: ref.watch(lightMode)
                                    ? Colors.white
                                    : Colors.grey[900],
                                borderRadius: BorderRadius.circular(18.r),
                                border: Border.all(
                                  color: ref
                                      .watch(foreGroundColor)
                                      .withAlpha(45),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Weekly Trend",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ref.watch(foreGroundColor),
                                    ),
                                  ),
                                  SizedBox(height: 14.h),
                                  //bar chart
                                  SizedBox(
                                    height: 320.h,
                                    width: double.infinity,
                                    child: BarChart(
                                      BarChartData(
                                        backgroundColor: Colors.transparent,
                                        gridData: FlGridData(show: false),
                                        borderData: FlBorderData(show: false),
                                        barGroups: List.generate(
                                          (snapshot.data[3] as List).length,
                                          (index) {
                                            return BarChartGroupData(
                                              barsSpace: 10,
                                              groupVertically: false,
                                              x: index,
                                              barRods: [
                                                BarChartRodData(
                                                  width: 25.w,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft: Radius.zero,
                                                        topRight: Radius.zero,
                                                        bottomLeft:
                                                            Radius.circular(3),
                                                        bottomRight:
                                                            Radius.circular(3),
                                                      ),
                                                  color: Colors.red,
                                                  fromY: 0,
                                                  toY: snapshot
                                                      .data[3][index][0],
                                                ),
                                                BarChartRodData(
                                                  width: 25.w,
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                  color: Colors.green,
                                                  fromY: 0,
                                                  toY: snapshot
                                                      .data[3][index][1],
                                                ),
                                                BarChartRodData(
                                                  width: 25.w,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(3),
                                                        topRight:
                                                            Radius.circular(3),
                                                      ),
                                                  color: Colors.blueAccent,
                                                  fromY: 0,
                                                  toY: snapshot
                                                      .data[3][index][2],
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          topTitles: AxisTitles(),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: (value, meta) =>
                                                  Text(
                                                    [
                                                      "SUN",
                                                      "MON",
                                                      "TUE",
                                                      "WED",
                                                      "THU",
                                                      "FRI",
                                                      "SAT",
                                                    ][value.toInt()],
                                                    style: TextStyle(
                                                      color: ref.watch(
                                                        foreGroundColor,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10.sp.clamp(
                                                        0,
                                                        15,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          leftTitles: AxisTitles(),
                                          // leftTitles: AxisTitles(
                                          //   sideTitles: SideTitles(
                                          //     interval:
                                          //         (snapshot.data[0] +
                                          //             snapshot.data[1] +
                                          //             snapshot.data[2]) /
                                          //         4,
                                          //     showTitles: true,
                                          //     getTitlesWidget:
                                          //         (value, meta) => Text(
                                          //           (value).toString().split(
                                          //             ".",
                                          //           )[0],
                                          //           style: TextStyle(
                                          //             color: ref.watch(
                                          //               foreGroundColor,
                                          //             ),
                                          //             fontWeight:
                                          //                 FontWeight.bold,
                                          //             fontSize: 10.sp.clamp(
                                          //               0,
                                          //               15,
                                          //             ),
                                          //           ),
                                          //         ),
                                          //   ),
                                          // ),
                                          rightTitles: AxisTitles(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(18.r),
                              decoration: BoxDecoration(
                                color: ref.watch(lightMode)
                                    ? Colors.white.withOpacity(0.95)
                                    : Colors.grey[900],
                                borderRadius: BorderRadius.circular(18.r),
                                border: Border.all(
                                  color: ref
                                      .watch(foreGroundColor)
                                      .withOpacity(0.12),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "AI Analysis",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ref.watch(foreGroundColor),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Container(
                                    height: 260.h,
                                    decoration: BoxDecoration(
                                      color: ref.watch(lightMode)
                                          ? Colors.grey[100]
                                          : Colors.black26,
                                      borderRadius: BorderRadius.circular(14.r),
                                      border: Border.all(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14.r),
                                      child: FutureBuilder(
                                        key: refreshAiProvider,
                                        future: Future(() async {
                                          List callAi = [];
                                          //check if the user have signed in their login credentials
                                          if (lookForSettingBox().get(
                                                    "backupEmail",
                                                  ) ==
                                                  null ||
                                              lookForSettingBox().get(
                                                    "backupPassword",
                                                  ) ==
                                                  null) {
                                            return [
                                              400,
                                              {
                                                "message":
                                                    "No login Credentials was found therefore ai response cannot be generated\n\nHint: Head to setting and click on backup data or retore data",
                                              },
                                            ];
                                          }
                                          //check if canContinueToAiChat is true - if yes, it mean user just came back from aichat so dont recall the aianalyzer
                                          if (ref.read(canContinueToAiChat) ==
                                              true) {
                                            callAi = await ref.read(
                                              aiAnayzer.future,
                                            );
                                          } else {
                                            ref.invalidate(aiAnayzer);
                                            callAi = await ref
                                                .refresh(aiAnayzer.future)
                                                .timeout(
                                                  Duration(seconds: 10),
                                                  onTimeout: () {
                                                    return [
                                                      404,
                                                      {
                                                        "message":
                                                            "Network Issue",
                                                      },
                                                    ];
                                                  },
                                                );
                                          }

                                          //user have not login their email
                                          if (callAi[0] == 400 &&
                                              callAi[0]["message"] ==
                                                  "user not found") {
                                            return [
                                              400,
                                              {
                                                "message":
                                                    "No login Credentials was found therefore ai response cannot be generated\n\nHint: Head to setting and click on backup data or retore data",
                                              },
                                            ];
                                          }
                                          // incorrect password
                                          else if (callAi[0] == 401) {
                                            return [
                                              401,
                                              {
                                                "message":
                                                    "The password in the login credentials in your backup is not correct therefore ai response cannot be generated\n\nHint: Head to setting and click on backup / restore config to reset your password",
                                              },
                                            ];
                                          }
                                          return callAi;
                                        }),
                                        builder:
                                            (
                                              BuildContext innerContext,
                                              AsyncSnapshot innerSnapshot,
                                            ) {
                                              print(innerSnapshot.data);

                                              if (innerSnapshot.hasData) {
                                                if (innerSnapshot.data?[0] ==
                                                    404) {
                                                  return Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "network issue, could not load feedback.",
                                                          style: TextStyle(
                                                            color: ref.watch(
                                                              foreGroundColor,
                                                            ),
                                                            fontSize: 14.sp,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10.h),
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              refreshAiProvider =
                                                                  UniqueKey();
                                                            });
                                                            ref.invalidate(
                                                              canContinueToAiChat,
                                                            );
                                                            ref.invalidate(
                                                              oneTimeAiAnalysis,
                                                            );
                                                          },
                                                          icon: Icon(
                                                            Icons.refresh,
                                                            color: ref.watch(
                                                              foreGroundColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                                //ai return proper text, now display
                                                final aiText =
                                                    innerSnapshot
                                                        .data?[1]?['message']
                                                        ?.toString() ??
                                                    'No AI response available yet.';

                                                //in some case, it might be a warning like 400 and not a prper text so dont alwasy allow user to enter the Ai chat if its not 200 as response
                                                if (innerSnapshot.data?[0] ==
                                                    200) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((
                                                        _,
                                                      ) {
                                                        ref
                                                                .read(
                                                                  canContinueToAiChat
                                                                      .notifier,
                                                                )
                                                                .state =
                                                            true;
                                                        ref
                                                                .read(
                                                                  oneTimeAiAnalysis
                                                                      .notifier,
                                                                )
                                                                .state =
                                                            aiText;
                                                      });
                                                }
                                                return Container(
                                                  width: ref
                                                      .watch(deviceSizeX)
                                                      .w,
                                                  height: ref
                                                      .watch(deviceSizeY)
                                                      .h,
                                                  child: Center(
                                                    child: Scrollbar(
                                                      controller:
                                                          aiScrollController,
                                                      thumbVisibility: true,
                                                      child: SingleChildScrollView(
                                                        controller:
                                                            aiScrollController,
                                                        padding: EdgeInsets.all(
                                                          16.r,
                                                        ),
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              aiText,
                                                              style: TextStyle(
                                                                fontSize: 15.sp,
                                                                color: ref.watch(
                                                                  foreGroundColor,
                                                                ),
                                                                height: 1.5,
                                                              ),
                                                            ),
                                                            IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  refreshAiProvider =
                                                                      UniqueKey();
                                                                });
                                                                ref.invalidate(
                                                                  canContinueToAiChat,
                                                                );
                                                                ref.invalidate(
                                                                  oneTimeAiAnalysis,
                                                                );
                                                              },
                                                              icon: Icon(
                                                                Icons.refresh,
                                                                color: ref.watch(
                                                                  foreGroundColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }

                                              if (innerSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child: SizedBox(
                                                    width: 120.w,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        LinearProgressIndicator(
                                                          color: ref.watch(
                                                            foreGroundColor,
                                                          ),
                                                          backgroundColor: ref
                                                              .watch(
                                                                foreGroundColor,
                                                              )
                                                              .withAlpha(65),
                                                        ),
                                                        SizedBox(height: 10.h),
                                                        Text(
                                                          'fetching ai insight...',
                                                          style: TextStyle(
                                                            color: ref.watch(
                                                              foreGroundColor,
                                                            ),
                                                            fontSize: 13.sp,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }

                                              //else if nothing
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      'Error, please refresh. If error persist, please restart app',
                                                      style: TextStyle(
                                                        color: ref.watch(
                                                          foreGroundColor,
                                                        ),
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        refreshAiProvider =
                                                            UniqueKey();
                                                      });
                                                      ref.invalidate(
                                                        canContinueToAiChat,
                                                      );
                                                      ref.invalidate(
                                                        oneTimeAiAnalysis,
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.refresh,
                                                      color: ref.watch(
                                                        foreGroundColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),

                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: ref.watch(
                                                foreGroundColor,
                                              ),
                                              foregroundColor: ref.watch(
                                                backgroundColor,
                                              ),
                                              padding: EdgeInsets.all(15),
                                              shadowColor: Colors.red,
                                              elevation: 3,
                                              side: BorderSide(
                                                color: ref.watch(lightMode)
                                                    ? Colors.black12
                                                    : Colors.white38,
                                                strokeAlign: 20,
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (ref.read(
                                                    canContinueToAiChat,
                                                  ) ==
                                                  false) {
                                                notifier(
                                                  context: context,
                                                  message: "no AI response yet",
                                                  fg: ref.read(backgroundColor),
                                                  bg: ref.read(foreGroundColor),
                                                );
                                                return;
                                              }
                                              ref.invalidate(
                                                userAITempChatHolder,
                                              );
                                              ref.invalidate(aiNavBarContent);
                                              ref.invalidate(aiChatResponse);
                                              // await Future.delayed(
                                              //   Duration(seconds: 1),
                                              // );
                                              router.push("/aichat");
                                            },
                                            child: Text(
                                              "continue to ai chat",
                                              textAlign: TextAlign.center,
                                            ),
                                          ).animate().shakeX(
                                            duration: Duration(
                                              milliseconds: 300,
                                            ),
                                            hz: 15,
                                            delay: Duration(milliseconds: 800),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Column(
                      children: [
                        Container(
                          width: 25,
                          height: 10,
                          child: LinearProgressIndicator(
                            color: ref.watch(foreGroundColor),
                          ),
                        ),
                        Text(
                          "Please. wait...",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: ref.watch(foreGroundColor),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Fatal Error",
                        style: TextStyle(
                          color: ref.watch(foreGroundColor),
                          fontSize: 30.sp,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget pieContainer({
  required WidgetRef ref,
  required Color color,
  required Widget? child,
}) {
  return Container(
    margin: EdgeInsets.all(10.r),
    width: 85.w,
    height: 90.w,
    decoration: BoxDecoration(
      color: color,
      boxShadow: ref.watch(lightMode)
          ?
            //light mode shadow
            [
              BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 4,
                color: Colors.black26,
              ),
            ]
          :
            //dark mode shadow
            [
              BoxShadow(
                offset: Offset(2, 3),
                blurRadius: 6,
                color: Colors.white54,
              ),
            ],

      borderRadius: BorderRadius.circular(10.r),
    ),
    child: child ?? SizedBox(),
  );
}

final aiAnayzer = FutureProvider<List>((ref) async {
  final email = lookForSettingBox().get("backupEmail");
  final password = lookForSettingBox().get("backupPassword");
  final _username = ref.read(username);

  final uri = Uri.parse(
    "${ref.read(domain)}ai/?email=${email}&password=${password}&username=${_username}",
  );
  final send = await http.get(uri);
  final response = await jsonDecode(send.body);
  return [send.statusCode, response];
});

final canContinueToAiChat = StateProvider<bool>((ref) {
  return false;
});
final oneTimeAiAnalysis = StateProvider<String>((ref) {
  return '';
});
