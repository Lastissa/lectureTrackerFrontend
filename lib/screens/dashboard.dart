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

  // Function to refresh the page

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
                  InkWell(
                    splashColor: Colors.transparent,
                    hoverDuration: Duration.zero,
                    highlightColor: Colors.transparent,

                    onTap: ref.watch(lectureCardActive)
                        ? () => ref.watch(lectureCardActive.notifier).state =
                              false
                        : () async {
                            bool? userHaveRegisteredCourses =
                                await lookForSettingBox().get(
                                  'userHaveCreatedCourses',
                                );
                            if (userHaveRegisteredCourses != null) {
                              router.go('/settings');
                            } else {
                              router.go("/signup");
                            }
                          },
                    child: Padding(
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
                                    color: const Color.fromARGB(
                                      221,
                                      59,
                                      59,
                                      59,
                                    ),
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
                                Text(
                                  'Welcome ${ref.watch(username)}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${todayLectureCard().length} ${todayLectureCard().length > 1 ? "Classes" : "Class"} Today',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Text(DateFormat('EEEE').format(DateTime.now())),
                              ],
                            ),
                            InkWell(
                              onTap: ref.watch(lectureCardActive)
                                  ? () =>
                                        ref
                                                .watch(
                                                  lectureCardActive.notifier,
                                                )
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
                                        ref.read(lightMode.notifier).state =
                                            true;
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
                                      1, //zero mean false, 1 mean true
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
                                        : Icons.thumb_down_alt,
                                    color: dataToUse[index]['accomplised'] == 1
                                        ? Colors.green
                                        : Colors.redAccent,
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
                                  'start_time': '',
                                  'end_time': '',
                                  'dayOfTheWeek': '',
                                  'color': colors[0],
                                },
                              ];
                              if (todayLectureCard().isNotEmpty) {
                                dataToUse = todayLectureCard();
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
                                              '${dataToUse[index]["start_time"]} - ${dataToUse[index]["end_time"]}',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ref.watch(lectureCardActive)
            ? () => ref.watch(lectureCardActive.notifier).state = false
            : () async {
                final locator = await CustomDbClass.instance.getter;
                List all = await fetchAll(
                  dbLocator: locator,
                  tableName: 'userAllTimetable',
                  limit: 10000,
                );
                //start
                notifier(
                  context: context,
                  message: 'Refreshed😎',
                  bg: Colors.blueAccent,
                );
                //For autoamatic scroll to the last part of the page on update.

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (listViewController.hasClients) {
                    listViewController.animateTo(
                      listViewController.position.minScrollExtent,
                      duration: Duration(milliseconds: 150),
                      curve: Curves.bounceInOut,
                    );
                  }
                });
              },
        icon: Icon(
          Icons.refresh,
          color: ref.read(lightMode) ? Colors.white : Colors.white,
        ),
        label: Text(
          'Refresh',
          style: TextStyle(
            color: ref.read(lightMode) ? Colors.black : Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
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
});//Monday

