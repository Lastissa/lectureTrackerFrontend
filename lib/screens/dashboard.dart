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
import 'package:sqflite/sqlite_api.dart';

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

  final duration = Duration(milliseconds: 100);
  List<Map> todayLectureCard() {
    //all data have been provided from the splashscreen before we got here so there should not be any async and await issue
    //brb ; start fixing from here , goodluck bro
    List<Map> listToUse =
        []; // list we are returning for display, still need work as i need to remove the already marked done from this list
    List upcomings = ref.watch(decoyDB).isNotEmpty ? ref.watch(decoyDB) : [];
    for (Map i in upcomings) {
      if (i['dayOfTheWeek'] ==
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
                      ? null
                      : () => router.go("/settings"),
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
                              Text(
                                'Welcome ${ref.watch(userName)}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${todayLectureCard().length} Classes Today',
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
                                ? null
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
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: ref.watch(lectureCardActive)
                        ? null
                        : () {
                            if (pastLectureIsActice) {
                              setState(() {
                                pastLectureIsActice = false;
                                upcomingLectureIsActive = true;
                              });
                              return;
                            }
                            ;
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: ref.read(pastLectureSQLDecoy).length,
                          itemBuilder: (context, index) {
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
                                  (ref.read(
                                    pastLectureSQLDecoy,
                                  ))[index]["title"],
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
                                            '${ref.read(pastLectureSQLDecoy)[index]["date"]}',
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
                                  ref.read(
                                            pastLectureSQLDecoy,
                                          )[index]['accomplised'] ==
                                          1
                                      ? Icons.thumb_up_alt
                                      : Icons.thumb_down_alt,
                                  color:
                                      ref.read(
                                            pastLectureSQLDecoy,
                                          )[index]['accomplised'] ==
                                          1
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
                        ? null
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
                        child: todayLectureCard().isNotEmpty
                            ? ListView.builder(
                                controller: listViewController,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                itemCount: todayLectureCard().length,
                                itemBuilder: (context, index) {
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
                                                color: Color.fromARGB(
                                                  96,
                                                  0,
                                                  0,
                                                  0,
                                                ),
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
                                              todayLectureCard()[index]["color"],
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        todayLectureCard()[index]["title"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ref.read(lightMode)
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
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
                                                  '${todayLectureCard()[index]["start_time"]} - ${todayLectureCard()[index]["end_time"]}',
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
                                          ? null
                                          : () {
                                              if (ref.read(lectureCardActive))
                                                return;
                                              ref
                                                      .read(
                                                        currentCourseCode
                                                            .notifier,
                                                      )
                                                      .state =
                                                  todayLectureCard()[index]['title'];
                                              ref
                                                      .read(
                                                        lectureCardActive
                                                            .notifier,
                                                      )
                                                      .state =
                                                  true;
                                            },
                                    ),
                                  );
                                },
                              )
                            : Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                margin: EdgeInsets.all(10),
                                width: 360,
                                height: 10,
                                child: LinearProgressIndicator(
                                  backgroundColor: ref.watch(lightMode)
                                      ? Colors.grey[100]
                                      : Colors.black,
                                  color: Colors.blueAccent,
                                ),
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
      // The update button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ref.watch(lectureCardActive)
            ? null
            : () async {
                //begining of temprorary experiment

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
