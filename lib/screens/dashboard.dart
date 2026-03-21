import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lecture_tracker/utils.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _LectureDashboardState();
}

class _LectureDashboardState extends ConsumerState<Dashboard> {
  final listViewController = ScrollController();
  // Initial list of lectures

  List<dynamic> upcomingLectures = userCourseInfo;
  bool upcomingLectureIsActive = true;
  bool pastLectureIsActice = false;

  // Function to simulate updating the list
  void _updateLectureList() {
    setState(() {
      upcomingLectures.add({
        'title': 'NEW 101',
        'start_time': '02:00 PM',
        'end_time': '04:00 PM',
        'color': Colors.blue,
      });
      //For autoamatic scroll to the last part of the page on update.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        listViewController.animateTo(
          listViewController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.bounceInOut,
        );
      });
    });
  }

  final duration = Duration(milliseconds: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ref.watch(lightMode) ? Colors.grey[100] : Colors.black87,
      appBar: AppBar(
        toolbarHeight: 10,
        backgroundColor: ref.watch(lightMode)
            ? Colors.grey[100]
            : Colors.black87,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Header / Summary Area
              InkWell(
                splashColor: Colors.transparent,

                onTap: () => router.push("/settings"),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: AnimatedContainer(
                    duration: duration,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      boxShadow: ref.watch(lightMode)
                          ? []
                          : [
                              BoxShadow(
                                color: const Color.fromRGBO(77, 76, 76, 1),
                                offset: Offset(1, 1),
                              ),
                              BoxShadow(
                                color: const Color.fromRGBO(77, 76, 76, 1),
                                offset: Offset(0, -1),
                              ),
                            ],
                      color: ref.watch(lightMode)
                          ? Colors.blueAccent
                          : const Color.fromARGB(255, 41, 40, 40),
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
                          child: Icon(
                            Icons.sunny,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              Expanded(
                child: ListView.builder(
                  controller: listViewController,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: upcomingLectureIsActive
                      ? upcomingLectures.length
                      : 0,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: duration,
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
                          // Action when a specific lecture is tapped
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Positioned(
          //   bottom: 80,
          //   right: 15,
          //   child: Container(
          //     padding: EdgeInsets.all(10),
          //     decoration: BoxDecoration(
          //       color: Colors.blueAccent,
          //       borderRadius: BorderRadius.all(Radius.circular(10)),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black,
          //           offset: Offset(0, 1),
          //           blurRadius: 1.5,
          //         ),
          //       ],
          //     ),
          //     width: 50,
          //     height: 50,
          //     child: Icon(
          //       Icons.settings,
          //       color: ref.read(lightMode) ? Colors.black87 : Colors.white70,
          //     ),
          //   ),
          // ),
        ],
      ),
      // The update button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _updateLectureList,
        icon: Icon(
          Icons.refresh,
          color: ref.read(lightMode) ? Colors.black : Colors.white,
        ),
        label: Text(
          'Update List',
          style: TextStyle(
            color: ref.read(lightMode) ? Colors.black : Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
