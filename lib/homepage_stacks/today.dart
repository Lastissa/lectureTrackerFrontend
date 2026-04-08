import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lecture_tracker/screens/cardOverlay.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/utils.dart';

class Today extends ConsumerStatefulWidget {
  const Today({super.key});

  @override
  ConsumerState<Today> createState() => _TodayState();
}

class _TodayState extends ConsumerState<Today> {
  // Function to to pick today lecture
  List<Map> _todayLectureCard() {
    //all data have been provided from the splashscreen before we got here so there should not be any async and await issue
    List<Map> listToUse = []; // list we are returning for display,
    List upcomings = ref.watch(decoyDB).isNotEmpty ? ref.watch(decoyDB) : [];
    for (Map i in upcomings) {
      if (i.containsKey('dayOfTheWeek') &&
          i['dayOfTheWeek'] ==
              ref.read(wordWeekdayToInt)[DateTime.now().weekday - 1]) {
        listToUse.add(i);
      }
    }

    listToUse = listToUse.reversed.toList();
    return listToUse;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Today Lectures',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ref.read(lightMode)
                          ? Colors.black87
                          : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              //for the upcoming lecture cards
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _todayLectureCard().isEmpty
                    ? 1
                    : _todayLectureCard().length,
                itemBuilder: (context, index) {
                  //to return nothing when today lecture card is empty
                  List dataToUse = [
                    {
                      'title': 'No Upcoming Lecture',
                      'start_time': ':',
                      'end_time': ':',
                      'dayOfTheWeek': '',
                      'color': colors[0],
                    },
                  ];
                  if (_todayLectureCard().isNotEmpty) {
                    dataToUse = _todayLectureCard();
                  }

                  //the db is returning 0 for 12 so i want to cover that with 12 and also set the hour to have a zero before it, istead of 1 it should be 01
                  List<String> start_hour_cover = dataToUse[index]['start_time']
                      .toString()
                      .split(':'); // ['hour', 'minutes AM']

                  String? start_hour;
                  if (start_hour_cover[0].trim().isEmpty) {
                    start_hour = '';
                  } else if (start_hour_cover[0].length == 1) {
                    start_hour = "0${start_hour_cover[0]}";
                  } else {
                    start_hour = start_hour_cover[0];
                  } //start_hour_cover[0];
                  String? start_minutes = start_hour_cover[1].isEmpty
                      ? ''
                      : start_hour_cover[1];
                  if (start_hour_cover[1].split(' ')[0].isEmpty) {
                    start_minutes =
                        ''; //this will only happen if there are no more lecture card available for the day
                  } else if (start_hour_cover[1].split(' ')[0].length == 1) {
                    start_minutes = "0${start_minutes}";
                  } else {
                    start_minutes = start_hour_cover[1];
                  }

                  List<String> end_hour_cover = dataToUse[index]['end_time']
                      .toString()
                      .split(':'); // ['hour', 'minutes AM']

                  String? end_hour;
                  if (end_hour_cover[0].trim().isEmpty) {
                    end_hour = '';
                  } else if (end_hour_cover[0].length == 1) {
                    end_hour = "0${end_hour_cover[0]}";
                  } else {
                    end_hour = end_hour_cover[0];
                  } //end_hour_cover[0];
                  String? end_minutes = end_hour_cover[1].isEmpty
                      ? ''
                      : end_hour_cover[1];
                  if (end_hour_cover[1].split(' ')[0].isEmpty) {
                    end_minutes =
                        ''; //this will only happen if there are no more lecture card available for the day
                  } else if (end_hour_cover[1].split(' ')[0].length == 1) {
                    end_minutes = "0${end_minutes}";
                  } else {
                    end_minutes = end_hour_cover[1];
                  }

                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (dataToUse[index]['title'] == 'No Upcoming Lecture') {
                        return;
                      }
                      ref.read(lectureCardActive.notifier).state = true;
                      ref.read(currentCourseCode.notifier).state =
                          dataToUse[index]["title"];

                      ref.read(currentStartTime.notifier).state =
                          "${int.parse(start_hour ?? '0')}${start_hour!.isEmpty ? '' : ':'}$start_minutes";
                      ref.read(currentEndTime.notifier).state =
                          '${int.parse(end_hour ?? '')}${end_hour!.isEmpty ? '' : ':'}$end_minutes';

                      ref.read(currentDayOfTheWeek.notifier).state =
                          dataToUse[index]['dayOfTheWeek'];
                      ref.read(currentColor.notifier).state =
                          dataToUse[index]['color'];
                      if (dataToUse[index]['dayOfTheWeek'] == 'Saturday') {
                        print(dataToUse[index]);
                        print("title: ${ref.read(currentCourseCode)}");
                        print(
                          "start_time: ${int.parse(start_hour)}${start_hour.isEmpty ? '' : ':'}$start_minutes",
                        );
                        print(
                          "End time: ${int.parse(end_hour)}${end_hour.isEmpty ? '' : ':'} $end_minutes'",
                        );
                        print(
                          "dayofthe week ${dataToUse[index]['dayOfTheWeek']}",
                        );
                        print("color: ${dataToUse[index]['color']}");
                      }
                    },

                    child: Container(
                      // duration: duration,
                      margin: const EdgeInsets.only(bottom: 12.0),

                      decoration: BoxDecoration(
                        color: ref.watch(lightMode)
                            ? Colors.white
                            : Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        boxShadow: ref.watch(lightMode)
                            ? [
                                BoxShadow(
                                  color: Color.fromARGB(96, 0, 0, 0),
                                  offset: Offset(1, 1),
                                  blurRadius: 1,
                                ),
                                BoxShadow(
                                  color: Color.fromARGB(40, 0, 0, 0),
                                  offset: Offset(1, -1),
                                  blurRadius: 1,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 43, 42, 42),
                                  offset: Offset(1, 1),
                                ),
                                BoxShadow(
                                  color: const Color.fromRGBO(77, 76, 76, 1),
                                  offset: Offset(0, -1),
                                ),
                              ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          // duration: duration,
                          width: 4,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorMapper[dataToUse[index]["color"]],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        title: Text(
                          "${dataToUse[index]["title"]}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ref.read(lightMode)
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: ref.read(lightMode)
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$start_hour ${start_hour.isEmpty ? '' : ':'} $start_minutes ${start_hour.isEmpty ? '' : '-'}  $end_hour${end_hour.isEmpty ? '' : ':'} $end_minutes',
                                    style: TextStyle(
                                      color: ref.read(lightMode)
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.grey[400],
                        ),
                        splashColor: Colors.transparent,
                      ),
                    ),
                  );
                },
              ),
            ),

            //This is for the overlay that will show
          ],
        ),
        Positioned(
          child: AnimatedCrossFade(
            firstChild: SizedBox(),
            secondChild: Builder(
              builder: (context) {
                return Center(
                  //send all the data that particular card hold to the overlay
                  //add this to the sql for past lecture tracker
                  child: Cardoverlay(
                    courseName: ref.watch(currentCourseCode),
                    start_time: ref.watch(currentStartTime),
                    end_time: ref.watch(currentEndTime),
                    dayOfTheWeek: ref.watch(currentDayOfTheWeek),
                    color: ref.watch(currentColor),
                  ),
                );
              },
            ),

            crossFadeState: ref.watch(lectureCardActive)
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 150),
            // firstCurve: Curves.bounceIn,
            // secondCurve: Curves.easeOut,
          ),
        ),
      ],
    );
  }
}
