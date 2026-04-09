import 'package:carousel_slider/carousel_slider.dart';
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
int firstHour = 0;
int firstMinute = 0;
String firstMeridien =
    'AM'; //For knowing wether it is am or pm, had to set a defualt value so if the user did not pick anything, there wont be error as the default value will just be used
int firstIndex = 0; // for switching the am and pm
int secondHour = 0;
int secondMinute = 0;
String secondMeridien =
    'AM'; //For knowing wether it is am or pm,, had to set a defualt value so if the user did not pick anything, there wont be error as the default value will just be used
int lastToFirstHour =
    0; //This is for turning the last entry of the end time of the former course to the start time of the next course, so the user dont have to stress about it
int lastToFirstMinute =
    0; //This is for turning the last entry of the end time of the former course to the start time of the next course, so the user dont have to stress about it
String lastToFirstMeridien =
    'AM'; //This is for turning the last entry of the end time of the former course to the start time of the next course, so the user dont have to stress about it
int secondIndex = 0; // for switching am the and pm

void oneTimeRun({required WidgetRef ref}) async {
  final locator = await CustomDbClass.instance.getter;
  List<Map> userRegisteredData = await locator.rawQuery(
    "SELECT * FROM userAllTimetable",
  );

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

  if (ref.read(_allUserData).isEmpty) {
    ref.read(_allUserData.notifier).state = userRegisteredData;
    ref.read(_registeredCourseCount.notifier).state = userRegisteredData.length;
  }

  // return userRegisteredData;
}

class EditcourseState extends ConsumerState<Editcourse> {
  @override
  Widget build(BuildContext context) {
    if (ref.read(_allUserData).isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        oneTimeRun(ref: ref);
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
        onPopInvokedWithResult: (didpop, result) {
          if (didpop) return;
          ref.invalidate(_allIsClicked);
          ref.invalidate(_allUserData);
          ref.invalidate(_dayChoosenForBackUp);
          ref.invalidate(_allDayOfTheWeekDataLikeMondayETC);
          ref.invalidate(_registeredCourseCount);
          router.pop();
        },
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    ref.invalidate(_allIsClicked);
                    ref.invalidate(_allUserData);
                    ref.invalidate(_dayChoosenForBackUp);
                    ref.invalidate(_allDayOfTheWeekDataLikeMondayETC);
                    ref.invalidate(_registeredCourseCount);
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
                margin: EdgeInsets.only(top: ref.watch(deviceSizeY) * 0.2.h),
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
                    // print(
                    //   snapshot.data?.length,
                    // );
                    // return Text(snapshot.data?[index].toString() ?? 'empty');
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
                            initialValue: ref.watch(
                              _allUserData,
                            )[index]['title'],
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

                              hintText: ref.watch(_allUserData)[index]['title'],
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
                                      autoPlayInterval: Duration(seconds: 2),
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
                                            //for changing only that particular position to true in the auto list
                                            //to make sure every other one open close back except the only one tapped
                                            // List allLecture =
                                            //     await List.generate(
                                            //       ref.read(
                                            //         _registeredCourseCount,
                                            //       ),
                                            //       (index) => false,
                                            //     );
                                            //pass it on to the allClicks provider to it can reset itself
                                            // ref
                                            //         .read(_allIsClicked.notifier)
                                            //         .state =
                                            //     allLecture;
                                            List<bool> currentClicks = ref.read(
                                              _allIsClicked,
                                            );
                                            currentClicks.removeAt(index);
                                            currentClicks.insert(index, true);
                                            ref
                                                    .read(
                                                      _allIsClicked.notifier,
                                                    )
                                                    .state =
                                                currentClicks;

                                            setState(() {});
                                            print(ref.read(_allIsClicked));
                                            print(
                                              ref.read(
                                                _allDayOfTheWeekDataLikeMondayETC,
                                              ),
                                            );
                                          },
                                          child: Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.visible,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ref.watch(foreGroundColor),
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
                                    // List allLecture = await List.generate(
                                    //   ref.read(_registeredCourseCount),
                                    //   (index) => false,
                                    // );
                                  },
                                  child: Text('Rechoose'),
                                ),
                              ],
                            ),
                            duration: Duration(milliseconds: 400),
                            sizeCurve: Curves.easeIn,
                            crossFadeState: ref.watch(_allIsClicked)[index]
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //first Hour
                              _timeWidget(
                                ontap: () {
                                  setState(() {
                                    if (firstHour == 11) {
                                      firstHour = 0;
                                      secondHour = 0;
                                      firstIndex = firstIndex == 0 ? 1 : 0;
                                      secondIndex = firstIndex;
                                    } else {
                                      firstHour = firstHour + 1;
                                      secondHour = firstHour;
                                    }
                                  });
                                },
                                text: firstHour == 0
                                    ? '12'
                                    : firstHour.toString(),
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
                                  setState(() {
                                    if (firstMinute >= 55) {
                                      if (firstHour == 11) {
                                        firstIndex = firstIndex == 0 ? 1 : 0;
                                        secondIndex = firstIndex;
                                      }
                                      firstMinute = 0;
                                      secondMinute = 0;
                                      firstHour = firstHour == 11
                                          ? 0
                                          : firstHour + 1;
                                      secondHour = secondHour == 11
                                          ? 0
                                          : secondHour + 1;
                                    } else {
                                      firstMinute = firstMinute + 5;
                                      secondMinute = firstMinute;
                                    }
                                  });
                                },
                                text: firstMinute < 10
                                    ? "0${firstMinute}"
                                    : firstMinute.toString(),
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
                                    firstMeridien = ['AM', 'PM'][firstIndex];
                                    secondMeridien = ['AM', 'PM'][firstIndex];
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
                                  setState(() {
                                    if (secondHour == 11) {
                                      secondHour = 0;
                                      secondIndex = secondIndex == 0 ? 1 : 0;
                                    } else {
                                      secondHour = secondHour + 1;
                                    }
                                  });
                                },
                                text: secondHour == 0
                                    ? '12'
                                    : secondHour.toString(),
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
                                  setState(() {
                                    if (secondMinute >= 55) {
                                      if (secondHour == 11) {
                                        secondIndex = secondIndex == 0 ? 1 : 0;
                                      }
                                      secondMinute = 0;
                                      secondHour = secondHour == 11
                                          ? 0
                                          : secondHour + 1;
                                    } else {
                                      secondMinute = secondMinute + 5;
                                    }
                                  });
                                },
                                text: secondMinute < 10
                                    ? "0${secondMinute}"
                                    : secondMinute.toString(),
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
                                  secondMeridien = ['AM', 'PM'][secondIndex];
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
                                ScaffoldMessenger.of(context).clearSnackBars();
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
                                ScaffoldMessenger.of(context).clearSnackBars();
                                notifier(
                                  message: 'reset to old values',

                                  context: context,
                                  bg: ref.watch(foreGroundColor),
                                  fg: ref.watch(backgroundColor),
                                );
                              },

                              child: CircleAvatar(
                                backgroundColor: ref.watch(foreGroundColor),
                                child: Icon(
                                  Icons.restart_alt_rounded,

                                  color: ref.watch(backgroundColor),
                                ),
                              ),
                            ),

                            SizedBox(width: 10.w.clamp(5, 50)),
                            InkWell(
                              onLongPress: () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                notifier(
                                  context: context,
                                  message: 'Update Row',
                                  bg: Colors.blueAccent,
                                  fg: ref.watch(backgroundColor),
                                );
                              },

                              child: CircleAvatar(
                                backgroundColor: ref.watch(foreGroundColor),
                                child: Icon(Icons.save, color: Colors.white),
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
              Text(" -reset input to default ", style: customButtomTextStyle),
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
              Text(" -update latest data ", style: customButtomTextStyle),
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
        border: BoxBorder.all(
          width: 1.5,
          color: ref.read(lightMode) ? Colors.blueAccent : Colors.greenAccent,
        ),
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

//for knowing which lecture have been clicked
final _allIsClicked = StateProvider<List<bool>>((ref) {
  return [];
});
//for storing user data
final _allUserData = StateProvider<List<Map>>((ref) {
  return [];
});
//
//knowing day choosen when about to back up
final _dayChoosenForBackUp = StateProvider<String>((ref) {
  return '';
});
//lecture lenght
final _registeredCourseCount = StateProvider((ref) {
  return 0;
});

//for each day of the week column, so i can know the data tha will be there by default
final _allDayOfTheWeekDataLikeMondayETC = StateProvider<List<String>>((ref) {
  return [];
});
