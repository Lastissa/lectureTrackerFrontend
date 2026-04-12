import 'package:carousel_slider/carousel_slider.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/db.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/utils.dart';

class Editcourse extends ConsumerStatefulWidget {
  const Editcourse({super.key});

  @override
  ConsumerState<Editcourse> createState() => EditcourseState();
}

@override
final listVieweController = ScrollController();
String firstMeridien =
    'AM'; //For knowing wether it is am or pm, had to set a defualt value so if the user did not pick anything, there wont be error as the default value will just be used
int firstIndex = 0; // for switching the am and pm
String secondMeridien =
    'AM'; //For knowing wether it is am or pm,, had to set a defualt value so if the user did not pick anything, there wont be error as the default value will just be used
int lastToFirstHour =
    0; //This is for turning the last entry of the end time of the former course to the start time of the next course, so the user dont have to stress about it
int lastToFirstMinute =
    0; //This is for turning the last entry of the end time of the former course to the start time of the next course, so the user dont have to stress about it
String lastToFirstMeridien =
    'AM'; //This is for turning the last entry of the end time of the former course to the start time of the next course, so the user dont have to stress about it
int secondIndex = 0; // for switching am the and pm
void oneTimeRun({required WidgetRef ref, required BuildContext context}) async {
  final locator = await CustomDbClass.instance.getter;
  List<Map> userRegisteredData = await locator.rawQuery(
    "SELECT * FROM userAllTimetable",
  );
  ref.read(_allUserData.notifier).state = userRegisteredData;

  if (ref.read(_allIsClicked).isEmpty) {
    List<bool> allLectureClicking = await List.generate(
      userRegisteredData.length,
      (index) => true,
    );
    ref.read(_allIsClicked.notifier).state = allLectureClicking;
    List<String> allDaysPickedBefore = await List.generate(
      userRegisteredData.length,
      (index) => userRegisteredData[index]['dayOfTheWeek'],
    );
    ref.read(_allDayOfTheWeekDataLikeMondayETC.notifier).state =
        allDaysPickedBefore;
  }
  final allId = [];
  final allTitle = [];
  final allStartTime = [];
  final allEndTime = [];
  final allDayOfTheWeek = [];
  final allColor = [];

  for (Map i in userRegisteredData) {
    allId.add(i['id']);
    allTitle.add(i['title']);
    allStartTime.add(i['start_time']);
    allEndTime.add(i['end_time']);
    allDayOfTheWeek.add(i['dayOfTheWeek']);
    allColor.add(i['color']);
  }
  ref.read(_id.notifier).state = allId;
  ref.read(_allTitles.notifier).state = allTitle;
  ref.read(_start_time.notifier).state = allStartTime;
  ref.read(_end_time.notifier).state = allEndTime;
  ref.read(_dayOfTheWeek.notifier).state = allDayOfTheWeek;
  ref.read(_color.notifier).state = allColor;
  ref.read(_registeredCourseCount.notifier).state = userRegisteredData.length;

  await Future.delayed(Duration(milliseconds: 600));
}

class EditcourseState extends ConsumerState<Editcourse> {
  @override
  Widget build(BuildContext context) {
    //to make sure the one time run function run only once when the user enter the page, and not every time the page rebuild, i check if the allUserData provider is empty, if it is empty, then it means the one time run function have not run before, so i run it, but if it is not empty, then it means the one time run function have run before
    if (ref.read(_allUserData).isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        oneTimeRun(ref: ref, context: context);

        await Future.delayed(Duration(milliseconds: 500));
        if (!listVieweController.hasClients) return;
        listVieweController.animateTo(
          listVieweController.position.maxScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.linear,
        );
      });
    }

    return Scaffold(
      backgroundColor: ref.watch(backgroundColor),
      appBar: AppBar(
        backgroundColor: ref.watch(backgroundColor),
        toolbarHeight: 0,
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didpop, result) async {
          if (didpop) return;
          await _invalidateAll(ref: ref);
          router.pop();
        },
        child: ref.watch(isClosePressed)
            ? Center(child: CircularProgressIndicator(color: Colors.red))
            : Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          ref.read(isClosePressed.notifier).state = true;
                          await _invalidateAll(ref: ref);
                          router.pop();
                        },
                        child: Icon(
                          Icons.exit_to_app,
                          color: ref.watch(foreGroundColor),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      "${ref.watch(_registeredCourseCount)} Course Registered",
                      style: TextStyle(
                        fontSize: 28.sp.clamp(0, 24),
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: ref.watch(foreGroundColor),
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                  AnimatedCrossFade(
                    firstChild: Container(
                      margin: EdgeInsets.only(
                        top: ref.watch(deviceSizeY) * 0.2.h,
                      ),
                      width: ref.watch(deviceSizeX) * 0.3.w,
                      child: LinearProgressIndicator(),
                    ),
                    secondChild: //configure the user interface to contain the user data
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(),
                      width: ref.read(deviceSizeX).w,
                      height: ref.watch(deviceSizeY) * 0.67.h,
                      margin: EdgeInsets.symmetric(
                        horizontal: ref.watch(deviceSizeX) * 0.05.w,
                      ),
                      child: ListView.builder(
                        controller: listVieweController,
                        itemCount: ref.watch(_allUserData).length,
                        itemBuilder: (itemBuilder, index) {
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ref.watch(lightMode)
                                          ? const Color.fromARGB(40, 0, 0, 0)
                                          : const Color.fromARGB(61, 0, 0, 0),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                    color: ref.watch(lightMode)
                                        ? Colors.black87
                                        : Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.book,
                                      color: ref.watch(foreGroundColor),
                                    ),

                                    hintText: ref.watch(_allTitles)[index],
                                    hintStyle: TextStyle(
                                      color: ref.watch(lightMode)
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                    ),
                                    filled: true,
                                    fillColor: ref.watch(lightMode)
                                        ? Colors.white
                                        : const Color(0xFF1E1E1E),

                                    // Your OutlineInputBorder preferences
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color: ref.watch(foreGroundColor),

                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                  ),
                                ),
                              ),
                              //This is for the carousel slider and the stuff it will change into
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                width: ref.watch(deviceSizeX) * 0.8.w,
                                height: 35,

                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(),
                                child: AnimatedCrossFade(
                                  //this one is the defualt one that will show when user enters the signin page normally
                                  firstChild: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: CarouselSlider(
                                          options: CarouselOptions(
                                            pauseAutoPlayOnManualNavigate: true,
                                            enableInfiniteScroll: true,
                                            viewportFraction: 0.3,
                                            autoPlayInterval: Duration(
                                              seconds: 2,
                                            ),
                                            autoPlay: true,
                                          ),
                                          items: List.generate(7, (
                                            listGenerateIndex,
                                          ) {
                                            return Container(
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(),
                                              width: 70,
                                              height: 30,
                                              margin: EdgeInsets.only(
                                                right: 10,
                                                top: 1,
                                                bottom: 1,
                                              ),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: ref.watch(
                                                    foreGroundColor,
                                                  ),

                                                  foregroundColor:
                                                      ref.watch(lightMode)
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                onPressed: () async {
                                                  //for the text itself
                                                  final List<String>
                                                  _formerData = ref.read(
                                                    _allDayOfTheWeekDataLikeMondayETC,
                                                  );
                                                  _formerData.removeAt(index);
                                                  _formerData.insert(
                                                    index,
                                                    [
                                                      'Monday',
                                                      'Tuesday',
                                                      'Wednesday',
                                                      'Thursday',
                                                      'Friday',
                                                      'Saturday',
                                                      'Sunday',
                                                    ][listGenerateIndex],
                                                  );
                                                  ref
                                                          .read(
                                                            _allDayOfTheWeekDataLikeMondayETC
                                                                .notifier,
                                                          )
                                                          .state =
                                                      _formerData;

                                                  //this is for when user click , it should change to the choosed text,
                                                  List<bool> currentClicks = ref
                                                      .read(_allIsClicked);
                                                  currentClicks.removeAt(index);
                                                  currentClicks.insert(
                                                    index,
                                                    true,
                                                  );
                                                  ref
                                                          .read(
                                                            _allIsClicked
                                                                .notifier,
                                                          )
                                                          .state =
                                                      currentClicks;

                                                  setState(() {});
                                                },
                                                child: Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  [
                                                    'M',
                                                    'Tu',
                                                    'W',
                                                    'Th',
                                                    'F',
                                                    'S',
                                                    'Su',
                                                  ][listGenerateIndex],
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  secondChild: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        onPressed: () {},
                                        child: Text(
                                          ref.watch(
                                            _allDayOfTheWeekDataLikeMondayETC,
                                          )[index],
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: ref.watch(lightMode)
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        onPressed: () async {
                                          List<bool> currentClicks = ref.read(
                                            _allIsClicked,
                                          );
                                          currentClicks.removeAt(index);
                                          currentClicks.insert(index, false);
                                          ref
                                                  .read(_allIsClicked.notifier)
                                                  .state =
                                              currentClicks;
                                          setState(() {});
                                        },
                                        child: Text('Rechoose'),
                                      ),
                                    ],
                                  ),
                                  duration: Duration(milliseconds: 400),
                                  sizeCurve: Curves.easeIn,
                                  crossFadeState:
                                      ref.watch(_allIsClicked)[index]
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    //first Hour
                                    _timeWidget(
                                      ontap: () {
                                        final List oldData = ref.read(
                                          _start_time,
                                        );
                                        //to get the remaining after the first hour have been removed from the start time
                                        List toRemove = oldData
                                            .removeAt(index)
                                            .toString()
                                            .split(':');
                                        oldData.insert(
                                          index,
                                          "${int.parse(toRemove[0]) == 11 ? '0' : (int.parse(toRemove[0]) + 1).toString()}:${toRemove[1]}",
                                        );
                                        ref.read(_start_time.notifier).state =
                                            oldData;

                                        setState(() {});
                                      },
                                      //this is for the first_hour text
                                      text:
                                          ref
                                                  .watch(_start_time)[index]
                                                  .toString()
                                                  .split(':')[0] ==
                                              '0'
                                          ? '12'
                                          : ref
                                                .watch(_start_time)[index]
                                                .toString()
                                                .split(':')[0],
                                      ref: ref,
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ref.watch(lightMode)
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    //First Minutes
                                    _timeWidget(
                                      ontap: () {
                                        final List oldData = ref.read(
                                          _start_time,
                                        );
                                        //to get the remaining after the first minute have been removed from the start time
                                        List toRemove = oldData
                                            .removeAt(index)
                                            .toString()
                                            .split(':');
                                        oldData.insert(
                                          index,
                                          "${toRemove[0]}:${(int.parse(toRemove[1].split(' ')[0]) + 5) % 60} ${toRemove[1].split(' ')[1]}",
                                        );
                                        ref.read(_start_time.notifier).state =
                                            oldData;
                                        setState(() {});
                                      },
                                      text:
                                          ref
                                                  .watch(_start_time)[index]
                                                  .toString()
                                                  .split(':')[1]
                                                  .split(' ')[0]
                                                  .trim()
                                                  .length <
                                              2
                                          ? '0${ref.watch(_start_time)[index].toString().split(':')[1].split(' ')[0].trim()}'
                                          : ref
                                                .watch(_start_time)[index]
                                                .toString()
                                                .split(':')[1]
                                                .split(' ')[0]
                                                .trim(),
                                      ref: ref,
                                    ),
                                    //First meridien - AM or PM
                                    _timeWidget(
                                      ontap: () {
                                        setState(() {
                                          if (firstIndex == 0) {
                                            firstIndex = 1;
                                          } else {
                                            firstIndex = 0;
                                          }
                                          firstMeridien = [
                                            'AM',
                                            'PM',
                                          ][firstIndex];
                                          secondMeridien = [
                                            'AM',
                                            'PM',
                                          ][firstIndex];
                                          secondIndex = firstIndex;
                                        });
                                      },
                                      text: ['AM', 'PM'][firstIndex],
                                      ref: ref,
                                    ),

                                    Text(
                                      'to',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ref.watch(lightMode)
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    //second hour
                                    _timeWidget(
                                      ontap: () {
                                        final List oldData = ref.read(
                                          _end_time,
                                        );
                                        //to get the remaining after the second hour have been removed from the end time
                                        List toRemove = oldData
                                            .removeAt(index)
                                            .toString()
                                            .split(':');
                                        oldData.insert(
                                          index,
                                          "${int.parse(toRemove[0]) == 11 ? '0' : (int.parse(toRemove[0]) + 1).toString()}:${toRemove[1]}",
                                        );
                                        ref.read(_end_time.notifier).state =
                                            oldData;
                                        setState(() {});
                                      },
                                      text:
                                          ref
                                                  .watch(_end_time)[index]
                                                  .toString()
                                                  .split(':')[0] ==
                                              '0'
                                          ? '12'
                                          : ref
                                                .watch(_end_time)[index]
                                                .toString()
                                                .split(':')[0],
                                      ref: ref,
                                    ),

                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ref.watch(lightMode)
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    //second minute
                                    _timeWidget(
                                      ontap: () {
                                        final List oldData = ref.read(
                                          _end_time,
                                        );
                                        //to get the remaining after the second minute have been removed from the end time
                                        List toRemove = oldData
                                            .removeAt(index)
                                            .toString()
                                            .split(':');
                                        oldData.insert(
                                          index,
                                          "${toRemove[0]}:${(int.parse(toRemove[1].split(' ')[0]) + 5) % 60} ${toRemove[1].split(' ')[1]}",
                                        );
                                        ref.read(_end_time.notifier).state =
                                            oldData;
                                        setState(() {});
                                      },
                                      text:
                                          ref
                                                  .watch(_end_time)[index]
                                                  .toString()
                                                  .split(':')[1]
                                                  .split(' ')[0]
                                                  .trim()
                                                  .length <
                                              2
                                          ? '0${ref.watch(_end_time)[index].toString().split(':')[1].split(' ')[0].trim()}'
                                          : ref
                                                .watch(_end_time)[index]
                                                .toString()
                                                .split(':')[1]
                                                .split(' ')[0]
                                                .trim(),
                                      ref: ref,
                                    ),
                                    //second meridien - AM or PM
                                    _timeWidget(
                                      ontap: () {
                                        setState(() {
                                          if (secondIndex == 0) {
                                            secondIndex = 1;
                                          } else {
                                            secondIndex = 0;
                                          }
                                        });
                                        secondMeridien = [
                                          'AM',
                                          'PM',
                                        ][secondIndex];
                                      },
                                      text: ['AM', 'PM'][secondIndex],
                                      ref: ref,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onLongPress: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).clearSnackBars();
                                      notifier(
                                        context: context,
                                        message: 'Delete row entirely!!!',
                                        bg: Colors.red,
                                        fg: ref.watch(backgroundColor),
                                      );
                                    },

                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.delete_forever,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w.clamp(5, 50)),
                                  InkWell(
                                    onLongPress: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).clearSnackBars();
                                      notifier(
                                        message: 'reset to old values',

                                        context: context,
                                        bg: ref.watch(foreGroundColor),
                                        fg: ref.watch(backgroundColor),
                                      );
                                    },

                                    child: CircleAvatar(
                                      backgroundColor: ref.watch(
                                        foreGroundColor,
                                      ),
                                      child: Icon(
                                        Icons.restart_alt_rounded,

                                        color: ref.watch(backgroundColor),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 10.w.clamp(5, 50)),
                                  InkWell(
                                    onLongPress: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).clearSnackBars();
                                      notifier(
                                        context: context,
                                        message: 'Update Row',
                                        bg: Colors.blueAccent,
                                        fg: ref.watch(backgroundColor),
                                      );
                                    },

                                    child: CircleAvatar(
                                      backgroundColor: ref.watch(
                                        foreGroundColor,
                                      ),
                                      child: Icon(
                                        Icons.save,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              // index == ref.read(_allIsClicked).length - 1
                              //     ? Row(
                              //         children: [
                              //           Expanded(
                              //             child: ElevatedButton(
                              //               style: ElevatedButton.styleFrom(
                              //                 backgroundColor: ref.watch(
                              //                   foreGroundColor,
                              //                 ),
                              //               ),
                              //               onPressed: () {},
                              //               child: Text('Save'),
                              //             ),
                              //           ),
                              //         ],
                              //       )
                              //     : SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                    crossFadeState: ref.watch(_allUserData).isEmpty
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 350),
                  ),
                  Spacer(flex: 1),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         print(ref.read(deviceSizeX).w);
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: ref.watch(foreGroundColor),
                  //       ),
                  //       child: Text(
                  //         'SAVE',

                  //         style: TextStyle(
                  //           color: ref.watch(backgroundColor),
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ),
                  //     InkWell(
                  //       onTap: () {
                  //         // ref.read(all)
                  //       },
                  //       child: CircleAvatar(child: Icon(Icons.add)),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
      ),

      bottomNavigationBar: customBottomSlider(
        height: ref.watch(deviceSizeX) * 0.15.h,
        direction: Axis.vertical,
        ref: ref,
        children: [
          bottomNavChildren(
            direction: Axis.horizontal,
            value: [
              Text('Click on ', style: customButtomTextStyle),
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(blurRadius: 3, color: Colors.grey[100]!),
                  ],
                  border: BoxBorder.all(
                    width: 1.5,
                    color: ref.read(foreGroundColor),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                child: Center(child: Text("X")),
              ),
              Text(" to edit time", style: customButtomTextStyle),
            ],
          ),
          bottomNavChildren(
            direction: Axis.horizontal,
            value: [
              Icon(Icons.restart_alt_rounded, color: Colors.white),
              Text(" - reset input to default ", style: customButtomTextStyle),
            ],
          ),

          bottomNavChildren(
            direction: Axis.horizontal,
            value: [
              Icon(Icons.delete_forever, color: Colors.white),
              Text(" -delete row forever ", style: customButtomTextStyle),
            ],
          ),

          bottomNavChildren(
            direction: Axis.horizontal,
            value: [
              Icon(Icons.save, color: Colors.white),
              Text(" - update latest data ", style: customButtomTextStyle),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _timeWidget({
  required Function ontap,
  required text,
  required WidgetRef ref,
}) {
  return InkWell(
    onTap: () => ontap(),
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey[100]!)],
        border: BoxBorder.all(width: 1.5, color: ref.read(foreGroundColor)),
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Center(
        child: Text(
          text.toString(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

//for knowing which lecture have been clicked, it is a list of the lenght of the user user regsitered course
final _allIsClicked = StateProvider<List<bool>>((ref) {
  return [];
});
//for storing user data, it is a list of map, each map have the data of one course, and the list have the data of all courses - this is for knowing what to reset into.
final _allUserData = StateProvider<List<Map>>((ref) {
  return [];
});
//for storing all id of each row in the listview
final _id = StateProvider((ref) {
  return [];
});
//for storing all titles of each row in the listview
final _allTitles = StateProvider((ref) {
  return [];
});
//for storing all start_time of each row in the listview
final _start_time = StateProvider((ref) {
  return [];
});
//for storing all end_time of each row in the listview
final _end_time = StateProvider((ref) {
  return [];
});
//for storing all dayOfTheWeek of each row in the listview
final _dayOfTheWeek = StateProvider((ref) {
  return [];
});
//for storing all color of each row in the listview
final _color = StateProvider((ref) {
  return [];
});

//knowing day choosen when about to back up, this is for when user press the update/save ann i will put the old data here and if user want to reset to old data i will just take it from here and update the old row with the user new data
final _dayChoosenForBackUp = StateProvider<Map<String, String>>((ref) {
  return {
    'id': '',
    'title': '',
    'start_time': 'x:xx AM',
    'end_time': 'x:xx AM',
    'dayOfTheWeek': 'Thursday',
    'color': 'deepOrange',
  };
});
//lecture lenght
final _registeredCourseCount = StateProvider((ref) {
  return 0;
});

//for each day of the week column, so i can know the data tha will be there by default
final _allDayOfTheWeekDataLikeMondayETC = StateProvider<List<String>>((ref) {
  return [];
});

Future<void> _invalidateAll({required WidgetRef ref}) async {
  await Future.delayed(Duration(milliseconds: 300));
  ref.invalidate(_allIsClicked);
  ref.invalidate(_allUserData);

  ref.invalidate(_dayChoosenForBackUp);
  ref.invalidate(_registeredCourseCount);
  ref.invalidate(_allDayOfTheWeekDataLikeMondayETC);

  ref.invalidate(_color);
  ref.invalidate(_dayOfTheWeek);
  ref.invalidate(_end_time);
  ref.invalidate(_end_time);
  ref.invalidate(_start_time);
  ref.invalidate(_allTitles);
  ref.invalidate(_id);
}

//for decieving user that app have close
final isClosePressed = StateProvider((ref) {
  return false;
});
