import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lecture_tracker/screens/cardOverlay.dart';
import 'package:lecture_tracker/utils.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _LectureDashboardState();
}

class _LectureDashboardState extends ConsumerState<Dashboard> {
  final listViewController = ScrollController();
  // Initial list of lectures

  // List<dynamic> upcomingLectures = ref.read(lecturesCard);
  bool upcomingLectureIsActive = true;
  bool pastLectureIsActice = false;

  // Function to refresh the page
  void _updateLectureList() {
    //For autoamatic scroll to the last part of the page on update.
    setState(() {
      notifier(
        context: context,
        bg: ref.watch(lightMode)
            ? Colors.blueAccent
            : const Color.fromARGB(255, 31, 59, 107),
        fg: ref.watch(lightMode) ? Colors.white : Colors.white,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (listViewController.hasClients) {
          listViewController.animateTo(
            listViewController.position.minScrollExtent,
            duration: Duration(milliseconds: 150),
            curve: Curves.bounceInOut,
          );
        }
      });
    });

    // });
  }

  final duration = Duration(milliseconds: 100);
  @override
  Widget build(BuildContext context) {
    List upcomingLectures = ref.watch(lecturesCard).isNotEmpty
        ? ref.watch(lecturesCard)
        : [
            {
              'title': 'SAMPLE',
              'start_time': 'start',
              'end_time': 'end',
              'color': Colors.deepOrange,
            },
          ];
    return Scaffold(
      backgroundColor: ref.watch(lightMode) ? Colors.grey[100] : Colors.black87,
      appBar: AppBar(
        toolbarHeight: 10,
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

                  onTap: () => router.go("/settings"),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: AnimatedContainer(
                      duration: duration,
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
                                '${upcomingLectures.length} Classes Today',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              if (ref.read(lightMode)) {
                                ref.read(lightMode.notifier).state = false;
                              } else {
                                ref.read(lightMode.notifier).state = true;
                              }
                            },
                            // child:  AnimatedCrossFade(
                            //   firstChild: Icon(
                            //     Icons.sunny,
                            //     color: Colors.white70,
                            //     size: 40,
                            //   ),
                            //   secondChild: Icon(
                            //     Icons.nightlight_round_sharp,
                            //     color: Colors.white54,

                            //     size: 40,
                            //   ),
                            //   crossFadeState: ref.watch(lightMode)
                            //       ? CrossFadeState.showFirst
                            //       : CrossFadeState.showSecond,
                            //   duration: Duration(milliseconds: 1),
                            //   sizeCurve: Curves.easeInOut,
                            // ),
                            child: ref.watch(lightMode)
                                ? Icon(
                                    Icons.sunny,
                                    color: Colors.white70,
                                    size: 40,
                                  )
                                : Icon(
                                    Icons.nightlight_round_sharp,
                                    color: Colors.white54,

                                    size: 40,
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
                    onTap: () {
                      if (pastLectureIsActice) return;
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: pastLectureSQLDecoy.length,
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
                                leading: AnimatedContainer(
                                  duration: duration,
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
                                  pastLectureSQLDecoy[index]["title"],
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
                                            '${pastLectureSQLDecoy[index]["date"]}',
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
                                // trailing: Icon(
                                //   Icons.chevron_right,
                                //   color: Colors.grey[400],
                                // ),
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
                    onTap: () {
                      if (upcomingLectureIsActive) return;
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
                        child: ListView.builder(
                          controller: listViewController,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: upcomingLectures.length,
                          itemBuilder: (context, index) {
                            return AnimatedContainer(
                              duration: duration,
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
                                leading: AnimatedContainer(
                                  duration: duration,
                                  width: 4,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: upcomingLectures[index]["color"],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                title: Text(
                                  upcomingLectures[index]["title"],
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
                                            '${upcomingLectures[index]["start_time"]} - ${upcomingLectures[index]["end_time"]}',
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
                                onTap: () {
                                  if (ref.read(LectureCardActive)) return;
                                  ref.read(currentCourseCode.notifier).state =
                                      upcomingLectures[index]['title'];
                                  ref.read(LectureCardActive.notifier).state =
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
            AnimatedCrossFade(
              firstChild: SizedBox(),
              secondChild: Builder(
                builder: (context) => Center(
                  child: cardOverlay(courseName: ref.watch(currentCourseCode)),
                ),
              ),

              crossFadeState: ref.watch(LectureCardActive)
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
        onPressed: _updateLectureList,
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

final LectureCardActive = StateProvider<bool>((ref) {
  return false;
});
