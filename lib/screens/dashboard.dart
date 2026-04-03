import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lecture_tracker/db.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/cardOverlay.dart';
import 'package:lecture_tracker/utils.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _LectureDashboardState();
}

class _LectureDashboardState extends ConsumerState<Dashboard> {
  final listViewController = ScrollController();

  bool upcomingLectureIsActive = true;
  bool pastLectureIsActice = false;
  int displayToday = 1;
  int displayTommorow = 2;
  int displayNextTommorow = 3;
  int displayNextThirdDay = 4;
  int displayNextFourthDay = 5;
  int displayNextFifthDay = 6;
  int displayNextSixthDay = 7;

  // Function to to pick today lecture
  List<Map> todayLectureCard() {
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
    return Scaffold(
      backgroundColor: ref.read(lightMode) ? Colors.grey[100] : Colors.black,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ref.watch(lightMode)
            ? Colors.grey[100]
            : Colors.black87,
      ),
      body: PopScope(
        child: InkWell(
          onTap: ref.watch(lectureCardActive)
              ? () => ref.watch(lectureCardActive.notifier).state = false
              : null,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dashboard Header / Summary Area
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      // duration: duration,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        boxShadow: ref.watch(lightMode)
                            ? [
                                BoxShadow(
                                  color: ref.watch(lightMode)
                                      ? Colors.black38
                                      : Colors.black87,
                                  offset: Offset(2, 2),
                                  blurRadius: 3,
                                ),

                                BoxShadow(
                                  color: ref.watch(lightMode)
                                      ? Colors.black38
                                      : Colors.black87,
                                  offset: Offset(-2, 0),
                                  blurRadius: 3,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Color.fromARGB(221, 59, 59, 59),
                                  offset: Offset(2, 2),
                                  blurRadius: 3,
                                ),

                                BoxShadow(
                                  color: const Color.fromARGB(221, 59, 59, 59),
                                  offset: Offset(-2, -2),
                                  blurRadius: 3,
                                ),
                              ],
                        color: ref.watch(lightMode)
                            ? Colors.blueAccent
                            : const Color.fromARGB(255, 4, 24, 59),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedTextKit(
                                pause: Duration(seconds: 5),
                                totalRepeatCount: 1,
                                animatedTexts: [
                                  ScrambleAnimatedText(
                                    'Dev Ope Greet You',
                                    textStyle: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TypewriterAnimatedText(
                                    'Welcome ${ref.watch(username)}',
                                    textStyle: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                              AnimatedTextKit(
                                pause: Duration(seconds: 8),
                                repeatForever: true,
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    '${DateFormat.yMMMEd().format(DateTime.now())}',
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TypewriterAnimatedText(
                                    '${todayLectureCard().length} ${todayLectureCard().length > 1 ? "Classes" : "Class"} Today',
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: ref.watch(lectureCardActive)
                                ? () =>
                                      ref
                                              .watch(lectureCardActive.notifier)
                                              .state =
                                          false
                                : () {
                                    if (ref.read(lightMode)) {
                                      ref.read(lightMode.notifier).state =
                                          false;
                                      lookForSettingBox().put(
                                        'lightMode',
                                        false,
                                      );
                                    } else {
                                      ref.read(lightMode.notifier).state = true;
                                      lookForSettingBox().put(
                                        'lightMode',
                                        true,
                                      );
                                    }
                                  },

                            child: Icon(
                              ref.watch(lightMode)
                                  ? Icons.sunny
                                  : Icons.nightlight_round_sharp,
                              color: ref.watch(lightMode)
                                  ? Colors.white70
                                  : Colors.white54,
                              size: 40.r,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: ref.watch(lectureCardActive)
                          ? () => ref.watch(lectureCardActive.notifier).state =
                                false
                          : () {
                              if (pastLectureIsActice) {
                                setState(() {
                                  pastLectureIsActice = false;
                                  upcomingLectureIsActive = true;
                                });
                                return;
                              }

                              setState(() {
                                upcomingLectureIsActive = false;
                                pastLectureIsActice = true;
                              });
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Past Lectures',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ref.read(lightMode)
                                  ? Colors.black87
                                  : Colors.white70,
                            ),
                          ),
                          Icon(
                            pastLectureIsActice
                                ? Icons.arrow_drop_down
                                : Icons.chevron_right,
                            color: ref.watch(lightMode)
                                ? Colors.black87
                                : Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),
                  pastLectureIsActice
                      ? Flexible(
                          //for the past lectures cards
                          child: ListView.builder(
                            controller: listViewController,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            itemCount: ref.read(pastLectureSQLprovider).isEmpty
                                ? 1
                                : ref.read(pastLectureSQLprovider).length,
                            itemBuilder: (context, index) {
                              //incase the provider is empty, just use this data
                              List dataToUse = [
                                {
                                  'title': 'No PAST LECTURE',
                                  'date': DateFormat.yMMMEd().format(
                                    DateTime.now(),
                                  ),
                                  'accomplised':
                                      2, //zero mean false, 1 mean true, 2 mean nullified
                                },
                              ];
                              if (ref.read(pastLectureSQLprovider).isNotEmpty) {
                                dataToUse = ref.read(pastLectureSQLprovider);
                              }
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12.0),
                                decoration: BoxDecoration(
                                  color: ref.watch(lightMode)
                                      ? Colors.white
                                      : Colors.black54,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
                                  boxShadow: ref.watch(lightMode)
                                      ? [
                                          BoxShadow(
                                            color: Color.fromARGB(96, 0, 0, 0),
                                            offset: Offset(1, 1),
                                            blurRadius: 1,
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                              255,
                                              43,
                                              42,
                                              42,
                                            ),
                                            offset: Offset(1, 1),
                                          ),
                                          BoxShadow(
                                            color: const Color.fromRGBO(
                                              77,
                                              76,
                                              76,
                                              1,
                                            ),
                                            offset: Offset(0, -1),
                                          ),
                                        ],
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16),
                                  leading: Container(
                                    // duration: duration,
                                    width: 4,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: ref.watch(lightMode)
                                          ? Colors.black26
                                          : Colors.white24,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  title: Text(
                                    dataToUse[index]["title"],
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              '${dataToUse[index]["date"]}',
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
                                    dataToUse[index]['accomplised'] == 1
                                        ? Icons.thumb_up_alt
                                        : (dataToUse[index]['accomplised'] == 0
                                              ? Icons.thumb_down_alt
                                              : Icons.multiple_stop_sharp),
                                    color: dataToUse[index]['accomplised'] == 1
                                        ? Colors.green
                                        : (dataToUse[index]['accomplised'] == 0
                                              ? Colors.redAccent
                                              : (ref.watch(lightMode)
                                                    ? Colors.black
                                                    : Colors.white70)),
                                  ),
                                  splashColor: Colors.transparent,
                                  // onTap: () {},
                                ),
                              );
                            },
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: ref.watch(lectureCardActive)
                          ? () => ref.watch(lectureCardActive.notifier).state =
                                false
                          : () {
                              if (upcomingLectureIsActive) {
                                setState(() {
                                  upcomingLectureIsActive = false;
                                  pastLectureIsActice = true;
                                });
                                return;
                              }
                              ;
                              setState(() {
                                upcomingLectureIsActive = true;
                                pastLectureIsActice = false;
                              });
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Upcoming Lectures',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ref.read(lightMode)
                                  ? Colors.black87
                                  : Colors.white70,
                            ),
                          ),
                          Icon(
                            upcomingLectureIsActive
                                ? Icons.arrow_drop_down
                                : Icons.chevron_right,
                            color: ref.watch(lightMode)
                                ? Colors.black87
                                : Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ListView.builder wrapped in Expanded to take up remaining screen space
                  upcomingLectureIsActive
                      ? Expanded(
                          //for the upcoming lecture cards
                          child: ListView.builder(
                            controller: listViewController,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            itemCount: todayLectureCard().isEmpty
                                ? 1
                                : todayLectureCard().length,
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
                              if (todayLectureCard().isNotEmpty) {
                                dataToUse = todayLectureCard();
                              }

                              //the db is returning 0 for 12 so i want to cover that with 12 and also set the hour to have a zero before it, istead of 1 it should be 01
                              List<String> start_hour_cover =
                                  dataToUse[index]['start_time']
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
                              String? start_minutes =
                                  start_hour_cover[1].isEmpty
                                  ? ''
                                  : start_hour_cover[1];
                              if (start_hour_cover[1].split(' ')[0].isEmpty) {
                                start_minutes =
                                    ''; //this will only happen if there are no more lecture card available for the day
                              } else if (start_hour_cover[1]
                                      .split(' ')[0]
                                      .length ==
                                  1) {
                                start_minutes = "0${start_minutes}";
                              } else {
                                start_minutes = start_hour_cover[1];
                              }

                              List<String> end_hour_cover =
                                  dataToUse[index]['end_time'].toString().split(
                                    ':',
                                  ); // ['hour', 'minutes AM']

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
                              } else if (end_hour_cover[1]
                                      .split(' ')[0]
                                      .length ==
                                  1) {
                                end_minutes = "0${end_minutes}";
                              } else {
                                end_minutes = end_hour_cover[1];
                              }

                              return Container(
                                // duration: duration,
                                margin: const EdgeInsets.only(bottom: 12.0),

                                decoration: BoxDecoration(
                                  color: ref.watch(lightMode)
                                      ? Colors.white
                                      : Colors.black54,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
                                  boxShadow: ref.watch(lightMode)
                                      ? [
                                          BoxShadow(
                                            color: Color.fromARGB(96, 0, 0, 0),
                                            offset: Offset(1, 1),
                                            blurRadius: 1,
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                              255,
                                              43,
                                              42,
                                              42,
                                            ),
                                            offset: Offset(1, 1),
                                          ),
                                          BoxShadow(
                                            color: const Color.fromRGBO(
                                              77,
                                              76,
                                              76,
                                              1,
                                            ),
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
                                      color:
                                          ColorMapper[dataToUse[index]["color"]],
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  onTap: ref.watch(lectureCardActive)
                                      ? () =>
                                            ref
                                                    .watch(
                                                      lectureCardActive
                                                          .notifier,
                                                    )
                                                    .state =
                                                false
                                      : () async {
                                          //to make sure the overlay does not work if the title is NO UPCOMING LECTURE
                                          if (dataToUse[index]['title'] ==
                                              'No Upcoming Lecture') {
                                            return;
                                          }
                                          //if the text is not 'No Upcoming Lecture', just continue with the overlay

                                          //updating the courseName provider
                                          ref
                                                  .read(
                                                    currentCourseCode.notifier,
                                                  )
                                                  .state =
                                              await dataToUse[index]['title'];
                                          //updating the start_time provider
                                          ref
                                                  .read(
                                                    currentStartTime.notifier,
                                                  )
                                                  .state =
                                              await dataToUse[index]['start_time'];

                                          //updating the end_time provider
                                          ref
                                                  .read(currentEndTime.notifier)
                                                  .state =
                                              await dataToUse[index]['end_time'];
                                          //updating the current day of the week provider
                                          ref
                                                  .read(
                                                    currentDayOfTheWeek
                                                        .notifier,
                                                  )
                                                  .state =
                                              await dataToUse[index]['dayOfTheWeek'];
                                          //updating the colour provider
                                          ref
                                                  .read(currentColor.notifier)
                                                  .state =
                                              await dataToUse[index]['color'];
                                          //to bring the overlay alive
                                          ref
                                                  .read(
                                                    lectureCardActive.notifier,
                                                  )
                                                  .state =
                                              true;
                                        },
                                ),
                              );
                            },
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              //This is for the overlay that will show
              AnimatedCrossFade(
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
            ],
          ),
        ),
      ),
      // The update button
      floatingActionButton: FloatingActionButton(
        onPressed: ref.watch(lectureCardActive)
            ? () => ref.watch(lectureCardActive.notifier).state = false
            : () async {
                bool? userHaveRegisteredCourses = await lookForSettingBox().get(
                  'userHaveCreatedCourses',
                );
                if (userHaveRegisteredCourses != null) {
                  router.go('/settings');
                } else {
                  router.go("/signup");
                }
              },
        child: Icon(
          Icons.settings,
          color: ref.read(lightMode) ? Colors.white : Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
      ),
      bottomNavigationBar: customBottomNavBar(),
    );
  }
}

final lectureCardActive = StateProvider<bool>((ref) {
  return false;
});
final currentCourseCode = StateProvider(
  (ref) {
    return 'NULL';
  },
); //This is for the knowing the current course selected in the dahshboard so overlay can know the name of the said course

final currentStartTime = StateProvider((ref) {
  return 'NULL';
}); // 'x:xx AM'
final currentEndTime = StateProvider((ref) {
  return 'NULL';
}); //'x:xx AM'
final currentColor = StateProvider((ref) {
  return 'NULL';
}); //red
final currentDayOfTheWeek = StateProvider((ref) {
  return 'NULL';
}); //Monday

Widget customBottomNavBar() {
  return Container(
    height: 48,
    width: 100,
    padding: EdgeInsets.symmetric(vertical: 2),
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.all(Radius.circular(2)),
      boxShadow: [
        BoxShadow(offset: Offset(1, 1), color: Colors.black54, blurRadius: 4),
      ],
    ),
    // child: Expanded(child: SizedBox(width: 10)),
    child: Expanded(
      child: CarouselSlider(
        items: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home_rounded, color: Colors.white, size: 40),
              // Text('Today', style: TextStyle(color: Colors.white)),
            ],
          ),
          bottomNavChildren(value: '1'),
          bottomNavChildren(value: '2'),
          bottomNavChildren(value: '3'),
          bottomNavChildren(value: '4'),
          bottomNavChildren(value: '5'),
          bottomNavChildren(value: '6'),
        ],
        options: CarouselOptions(
          pauseAutoPlayOnManualNavigate: true,
          enableInfiniteScroll: true,
          viewportFraction: 0.3,
          autoPlayInterval: Duration(seconds: 5),
          autoPlay: true,
        ),
      ),
    ),
  );
}

Widget bottomNavChildren({required String value}) {
  return CircleAvatar(
    backgroundColor: Colors.blueAccent,
    child: Text(
      value,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
    ),
  );
}
