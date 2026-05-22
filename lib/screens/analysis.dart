import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/backupAndrestore.dart';
import 'package:lecture_tracker/utils.dart';
import 'package:http/http.dart' as http;

class Analysis extends ConsumerStatefulWidget {
  const Analysis({super.key});

  @override
  ConsumerState<Analysis> createState() => AnalysisState();
}

class AnalysisState extends ConsumerState<Analysis> {
  void initState() {
    super.initState();
  }

  bool toggleButtonValue = false;
  UniqueKey refreshAiProvider = UniqueKey();
  @override
  Widget build(BuildContext context) {
    ref.invalidate(aiAnayzer);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ANALYTIS",
                    style: TextStyle(
                      fontSize: 28.sp.clamp(0, 24),
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: ref.watch(foreGroundColor),
                    ),
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
                  print(pastLecture);

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

                  // print(dataPerDayOfThWeek);
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
                        child: Column(
                          children: [
                            //3 cards showing number of lecture missed, attended and nullfied and a pie chart right underneath it to visualize it
                            Row(
                              key: UniqueKey(),
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                pieContainer(
                                  ref: ref,
                                  color: Colors.red,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: AnimatedTextKit(
                                              pause: Duration(seconds: 2),
                                              totalRepeatCount: 1,
                                              animatedTexts: [
                                                ScrambleAnimatedText(
                                                  snapshot.data[0].toString(),
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30.sp.clamp(
                                                      20,
                                                      40,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsGeometry.all(5),
                                          child: Text(
                                            "MISSED",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: ref.watch(backgroundColor),
                                            ),
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
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: AnimatedTextKit(
                                              pause: Duration(seconds: 2),
                                              totalRepeatCount: 1,
                                              animatedTexts: [
                                                ScrambleAnimatedText(
                                                  snapshot.data[1].toString(),
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30.sp.clamp(
                                                      20,
                                                      40,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsGeometry.all(5),
                                          child: Text(
                                            "ATTEND",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: ref.watch(backgroundColor),
                                            ),
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
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: AnimatedTextKit(
                                              pause: Duration(seconds: 2),
                                              totalRepeatCount: 1,
                                              animatedTexts: [
                                                ScrambleAnimatedText(
                                                  snapshot.data[2].toString(),
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30.sp.clamp(
                                                      20,
                                                      40,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsGeometry.all(5),
                                          child: Text(
                                            "NULLIFIED",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //bar chart showing analysis per day (available days in the history sql) and a line chart showing analysis per week (finding repetition in days) right underneath it
                            Row(
                              children: [
                                Container(
                                  width: ref.watch(deviceSizeX).w,
                                  margin: EdgeInsets.symmetric(vertical: 30),
                                  height: 300.h,
                                  child: BarChart(
                                    //the barchart itself does not do much, it the barchart data param in it that do all the heavy work
                                    // swapAnimationDuration: Duration(seconds: 1),
                                    // swapAnimationCurve: Curves.ease,
                                    BarChartData(
                                      //everythig aside the bargroups handle the design of the exterior
                                      backgroundColor: Colors.transparent,

                                      gridData: FlGridData(show: false),
                                      borderData: FlBorderData(show: false),

                                      barGroups: List.generate(
                                        (snapshot.data[3] as List).length,
                                        (index) {
                                          return BarChartGroupData(
                                            groupVertically: true,
                                            x: index,
                                            barRods: [
                                              //missed
                                              BarChartRodData(
                                                width: 38.w,

                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.zero,
                                                  topRight: Radius.zero,
                                                  bottomLeft: Radius.circular(
                                                    3,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    3,
                                                  ),
                                                ),
                                                color: Colors.red,
                                                fromY: 0,
                                                toY: snapshot.data[3][index][0],
                                              ),
                                              //attend
                                              BarChartRodData(
                                                width: 38.w,
                                                borderRadius: BorderRadius.all(
                                                  Radius.zero,
                                                ),
                                                color: Colors.green,
                                                fromY:
                                                    snapshot.data[3][index][0],
                                                toY:
                                                    snapshot.data[3][index][0] +
                                                    snapshot.data[3][index][1],
                                              ),
                                              BarChartRodData(
                                                width: 38.w,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(3),
                                                  topRight: Radius.circular(3),
                                                  bottomLeft: Radius.zero,
                                                  bottomRight: Radius.zero,
                                                ),
                                                color: Colors.blueAccent,
                                                fromY:
                                                    snapshot.data[3][index][0] +
                                                    snapshot.data[3][index][1],
                                                toY:
                                                    snapshot.data[3][index][0] +
                                                    snapshot.data[3][index][1] +
                                                    snapshot.data[3][index][2],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10.sp.clamp(
                                                      0,
                                                      15,
                                                    ),
                                                  ),
                                                ),
                                          ),
                                        ),
                                        topTitles: AxisTitles(),
                                        rightTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            interval:
                                                (snapshot.data[0] +
                                                    snapshot.data[1] +
                                                    snapshot.data[2]) /
                                                4,
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) =>
                                                Text(
                                                  (value).toString().split(
                                                    ".",
                                                  )[0],
                                                  style: TextStyle(
                                                    color: ref.watch(
                                                      foreGroundColor,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10.sp.clamp(
                                                      0,
                                                      15,
                                                    ),
                                                  ),
                                                ),
                                          ),
                                        ),
                                        leftTitles: AxisTitles(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //end of line container for ai analysis
                            Column(
                              children: [
                                Text(
                                  "AI ANALYSIS",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: ref.watch(foreGroundColor),
                                  ),
                                ),

                                FutureBuilder(
                                  key: refreshAiProvider,
                                  future: Future(() async {
                                    final callAi = await ref
                                        .refresh(aiAnayzer.future)
                                        .timeout(
                                          Duration(seconds: 10),
                                          onTimeout: () {
                                            return [
                                              404,
                                              {"message": "Network Issue"},
                                            ];
                                          },
                                        );
                                    return callAi;
                                  }),
                                  builder: (BuildContext, innerSnapshot) {
                                    if (innerSnapshot.hasData) {
                                      print(innerSnapshot.data?[1]);
                                      if (innerSnapshot.data?[0] == 404) {
                                        return IconButton(
                                          onPressed: () {
                                            setState(() {
                                              refreshAiProvider = UniqueKey();
                                            });
                                          },
                                          icon: Icon(
                                            Icons.refresh,
                                            color: ref.watch(foreGroundColor),
                                          ),
                                        );
                                      }
                                      return Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          "${innerSnapshot.data?[1]?["message"]} \n\nStatus code: ${snapshot.data![0]}",

                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: ref.watch(foreGroundColor),
                                          ),
                                        ),
                                      );
                                    } else if (innerSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return SizedBox(
                                        width: 80.w,

                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          margin: EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: LinearProgressIndicator(
                                            color: ref.watch(foreGroundColor),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Text(
                                        "404",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: ref.watch(foreGroundColor),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Container(
                                  key: UniqueKey(),
                                  width: ref.watch(deviceSizeX) * 0.5.w,
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: ElevatedButton(
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
                                    onPressed: () {
                                      notifier(
                                        context: context,
                                        message: "coming soon",
                                        bg: ref.watch(foreGroundColor),
                                        fg: ref.read(backgroundColor),
                                      );
                                    },
                                    child: Text(
                                      "Continue to chat",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ).animate().shake(
                                  delay: Duration(milliseconds: 200),
                                  duration: Duration(seconds: 1),
                                  hz: 8,
                                  offset: Offset(10, 1),
                                ),
                              ],
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
    width: 100.w,
    height: 100.w,
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

// final missedLectureCounter = StateProvider<int>((ref) {
//   return 0;
// });
// final attendlectureCounter = StateProvider<int>((ref) {
//   return 0;
// });
// final nullLectureCounter = StateProvider<int>((ref) {
//   return 0;
// });
