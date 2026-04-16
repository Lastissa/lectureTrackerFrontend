import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/db.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/utils.dart';

class Editcourse extends ConsumerStatefulWidget {
  const Editcourse({super.key});

  @override
  ConsumerState<Editcourse> createState() => EditcourseState();
}

@override
@override
class EditcourseState extends ConsumerState<Editcourse> {
  void initstate() {
    print('init state called');
    // firstTimeEnteringPage = true;
    super.initState();
  }

  void dispose() {
    // listVieweController.dispose();
    super.dispose();
  }

  final listVieweController = ScrollController();
  bool firstTimeEnteringPage =
      true; //change to false soon as page load finish and onetimerun is called
  void oneTimeRun({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
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
    }
    final List<String> allTitle = [];
    final List<String> allStartTime = [];
    final List<String> allEndTime = [];
    final List<String> allDayOfTheWeek = [];
    final List<String> allColor = [];

    for (Map i in userRegisteredData) {
      allTitle.add(i['title']);
      allStartTime.add(i['start_time']);
      allEndTime.add(i['end_time']);
      allDayOfTheWeek.add(i['dayOfTheWeek']);
      allColor.add(i['color']);
    }
    ref.read(_allTitles.notifier).state = allTitle;
    ref.read(_start_time.notifier).state = allStartTime;
    ref.read(_end_time.notifier).state = allEndTime;
    ref.read(_dayOfTheWeek.notifier).state = allDayOfTheWeek;
    ref.read(_color.notifier).state = allColor;
    ref.read(_registeredCourseCount.notifier).state = userRegisteredData.length;
    _textControllersList = List.generate(
      userRegisteredData.length,
      (index) => TextEditingController(),
    );

    await Future.delayed(Duration(milliseconds: 600));
  }

  //creating controller for each child of the listview
  List<TextEditingController> _textControllersList = [];

  @override
  Widget build(BuildContext context) {
    print(firstTimeEnteringPage);
    //to make sure the one time run function run only once when the user enter the page, and not every time the page rebuild, i check if the allUserData provider is empty, if it is empty, then it means the one time run function have not run before, so i run it, but if it is not empty, then it means the one time run function have run before
    if (ref.read(_allUserData).isEmpty && firstTimeEnteringPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        oneTimeRun(ref: ref, context: context);

        await Future.delayed(Duration(milliseconds: 500));
        if (!listVieweController.hasClients) return;
        listVieweController.animateTo(
          listVieweController.position.maxScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.linear,
        );
        setState(() {
          firstTimeEnteringPage = false;
        });
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
          print('didpop value for editpage: $didpop');
          if (didpop) return;
          await _invalidateAll(ref: ref);
          if (mounted) {
            router.pop();
          } else {
            router.go('/settings');
          }
        },
        child: ref.watch(isClosePressed)
            ? Center(child: CircularProgressIndicator(color: Colors.red))
            : Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          await _invalidateAll(ref: ref);
                          if (mounted) {
                            router.pop();
                          } else {
                            router.go('/settings');
                          }
                        },
                        child: Icon(
                          Icons.exit_to_app,
                          color: ref.watch(foreGroundColor),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Center(
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
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onLongPress: () {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            notifier(
                              context: context,
                              message: 'Add new course',
                              bg: ref.watch(foreGroundColor),
                              fg: ref.watch(backgroundColor),
                            );
                          },
                          onTap: () {
                            //for generating the prefix color
                            String _colorToUse =
                                prefixColors[Random().nextInt(
                                  prefixColors.length,
                                )];
                            //i did not ref.read it straight cos the ref.read is a type of map<string, object?> - object is a type of fynamic that perform safety check
                            List<Map> _formerData = [];
                            for (Map i in ref.read(_allUserData)) {
                              _formerData.add(i);
                            }
                            //for the title
                            String titleToAdd =
                                'New Course ${ref.read(_newCourseCount)}';
                            _formerData.add({
                              'title': titleToAdd,
                              'start_time': '0:00 AM',
                              'end_time': '0:00 AM',
                              'dayOfTheWeek': 'Monday',
                              'color': _colorToUse,
                            });

                            ref.read(_allUserData.notifier).state = _formerData;
                            ref.read(_registeredCourseCount.notifier).state =
                                ref.read(_registeredCourseCount) + 1;

                            //update each of the provider holding the other sub element like title, start time, end time, day of the week and color
                            final _formerTitleData = ref.read(_allTitles);
                            _formerTitleData.add(titleToAdd);
                            ref.read(_allTitles.notifier).state =
                                _formerTitleData;
                            final _formerStartTimeData = ref.read(_start_time);
                            _formerStartTimeData.add('0:00 AM');
                            ref.read(_start_time.notifier).state =
                                _formerStartTimeData;
                            final _formerEndTimeData = ref.read(_end_time);
                            _formerEndTimeData.add('0:00 AM');
                            ref.read(_end_time.notifier).state =
                                _formerEndTimeData;
                            final _formerDayOfTheWeekData = ref.read(
                              _dayOfTheWeek,
                            );
                            _formerDayOfTheWeekData.add('Monday');
                            ref.read(_dayOfTheWeek.notifier).state =
                                _formerDayOfTheWeekData;
                            final _formerColorData = ref.read(_color);
                            _formerColorData.add(_colorToUse);
                            final _formerAllIsClicked = ref.read(_allIsClicked);
                            _formerAllIsClicked.add(false);
                            ref.read(_allIsClicked.notifier).state =
                                _formerAllIsClicked;

                            //this is to increase the new course count stuff num
                            ref.read(_newCourseCount.notifier).state =
                                ref.read(_newCourseCount) + 1;

                            //this is to add the text editing controller for the new course added
                            _textControllersList.add(TextEditingController());
                            setState(() {});
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              listVieweController.animateTo(
                                listVieweController.position.maxScrollExtent,
                                duration: Duration(seconds: 1),
                                curve: Curves.linear,
                              );
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: ref.watch(foreGroundColor),
                            child: Icon(
                              Icons.add,
                              color: ref.watch(backgroundColor),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                        itemCount: ref.watch(_allUserData).length == 0
                            ? 1
                            : ref.watch(_allUserData).length,
                        itemBuilder: (itemBuilder, index) {
                          if (ref.watch(_allUserData).length == 0) {
                            return Container(
                              width: ref.watch(deviceSizeX) * 0.8.w,
                              height: 100,
                              decoration: BoxDecoration(),
                              child: Text(
                                'No course registered yet, click the + button to add new course',
                                style: TextStyle(
                                  color: ref.watch(foreGroundColor),
                                  fontSize: 16.sp.clamp(0, 14),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                            //the above is just to show when it is empty
                          }
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
                                  controller: _textControllersList[index],
                                  style: TextStyle(
                                    color: ref.watch(lightMode)
                                        ? Colors.black87
                                        : Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: InkWell(
                                      onTap: () {
                                        final List<String> _formerData = [];
                                        //for getting all the data in the riverpod before
                                        for (var i in ref.read(_color)) {
                                          _formerData.add(i);
                                        }
                                        //for removing that particular index color
                                        _formerData.removeAt(index);
                                        //for generating the new color, we are going to use
                                        String _newColor =
                                            prefixColors[Random().nextInt(
                                              prefixColors.length,
                                            )];
                                        //for inserting the new data
                                        _formerData.insert(index, _newColor);
                                        ref.read(_color.notifier).state =
                                            _formerData;
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.book,
                                        color:
                                            ColorMapper[ref.read(
                                              _color,
                                            )[index]],
                                      ),
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
                                                  //for updating the day of the week text to show
                                                  final List<String>
                                                  _tempHolder = [];
                                                  for (String i in ref.read(
                                                    _dayOfTheWeek,
                                                  )) {
                                                    _tempHolder.add(i);
                                                  }
                                                  _tempHolder.removeAt(index);
                                                  _tempHolder.insert(
                                                    index,
                                                    ref.read(
                                                      wordWeekdayToInt,
                                                    )[listGenerateIndex],
                                                  );
                                                  ref
                                                          .read(
                                                            _dayOfTheWeek
                                                                .notifier,
                                                          )
                                                          .state =
                                                      _tempHolder;
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
                                          ref.watch(_dayOfTheWeek)[index],
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
                                        final List<String> oldData = ref.read(
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
                                        final List<String> oldData = ref.read(
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
                                        final List _formerData = ref.read(
                                          _start_time,
                                        );
                                        final dataRemoved = _formerData
                                            .removeAt(index);
                                        _formerData.insert(
                                          index,
                                          dataRemoved.split(' ')[0] +
                                              ' ' +
                                              (dataRemoved
                                                          .split(' ')[1]
                                                          .trim() ==
                                                      'AM'
                                                  ? 'PM'
                                                  : 'AM'),
                                        );
                                        setState(() {});
                                      },
                                      text: ref
                                          .watch(_start_time)[index]
                                          .toString()
                                          .split(':')[1]
                                          .split(' ')[1]
                                          .trim(),
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
                                        final List<String> oldData = ref.read(
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
                                        final List<String> oldData = ref.read(
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
                                        final List _formerData = ref.read(
                                          _end_time,
                                        );
                                        final dataRemoved = _formerData
                                            .removeAt(index);
                                        _formerData.insert(
                                          index,
                                          dataRemoved.split(' ')[0] +
                                              ' ' +
                                              (dataRemoved
                                                          .split(' ')[1]
                                                          .trim() ==
                                                      'AM'
                                                  ? 'PM'
                                                  : 'AM'),
                                        );
                                        setState(() {});
                                      },
                                      text: ref
                                          .watch(_end_time)[index]
                                          .toString()
                                          .split(':')[1]
                                          .split(' ')[1]
                                          .trim(),
                                      ref: ref,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Container(
                                  //   margin: EdgeInsets.all(10),
                                  //   width: ref.watch(deviceSizeX) * 0.4.w,
                                  //   height: 10,
                                  //   decoration: BoxDecoration(
                                  //     color:
                                  //         ColorMapper[ref.read(_color)[index]],
                                  //     borderRadius: BorderRadius.all(
                                  //       Radius.circular(10),
                                  //     ),
                                  //   ),
                                  // ),
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
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (builder) {
                                              return AlertDialog(
                                                title: Text('Confirm Delete'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: [
                                                      Text(
                                                        'Are you sure you want to delete this permanently?',
                                                      ),
                                                      Text(
                                                        'This action cannot be undone.!!!',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          // fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop(); // Just close the popup
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      //for deleting from the mail table in the db
                                                      final locator =
                                                          await CustomDbClass
                                                              .instance
                                                              .getter;
                                                      locator.rawDelete(
                                                        "DELETE FROM userAllTimetable WHERE title = ? AND start_time = ? AND end_time = ? AND dayOfTheWeek = ? AND color = ?",
                                                        [
                                                          ref.read(
                                                            _allTitles,
                                                          )[index],
                                                          ref.read(
                                                            _start_time,
                                                          )[index],
                                                          ref.read(
                                                            _end_time,
                                                          )[index],
                                                          ref.read(
                                                            _dayOfTheWeek,
                                                          )[index],
                                                          ref.read(
                                                            _color,
                                                          )[index],
                                                        ],
                                                      );
                                                      await lookForSettingBox()
                                                          .put(
                                                            'isDataPassedForToday',
                                                            false,
                                                          );

                                                      //for all stuff i need to change
                                                      List<Map> _formerAllData =
                                                          [];
                                                      List<String>
                                                      _formerTitles = [];
                                                      List<String>
                                                      _formerStartTime = [];
                                                      List<String>
                                                      _formerEndTime = [];
                                                      List<String>
                                                      _formerDayOfTheWeekData =
                                                          [];
                                                      List<String>
                                                      _formerColorData = [];
                                                      List<bool>
                                                      _formerAllIsClicked = [];

                                                      //for adding the data from the riverpod before deletion, did this cos the riverpod is string, object?

                                                      for (Map i in ref.read(
                                                        _allUserData,
                                                      )) {
                                                        _formerAllData.add(i);
                                                      }
                                                      for (String i in ref.read(
                                                        _allTitles,
                                                      )) {
                                                        _formerTitles.add(i);
                                                      }
                                                      for (String i in ref.read(
                                                        _start_time,
                                                      )) {
                                                        _formerStartTime.add(i);
                                                      }
                                                      for (String i in ref.read(
                                                        _end_time,
                                                      )) {
                                                        _formerEndTime.add(i);
                                                      }
                                                      for (String i in ref.read(
                                                        _dayOfTheWeek,
                                                      )) {
                                                        _formerDayOfTheWeekData
                                                            .add(i);
                                                      }
                                                      for (String i in ref.read(
                                                        _color,
                                                      )) {
                                                        _formerColorData.add(i);
                                                      }
                                                      for (bool i in ref.read(
                                                        _allIsClicked,
                                                      )) {
                                                        _formerAllIsClicked.add(
                                                          i,
                                                        );
                                                      }

                                                      //deleting the data from the riverpod
                                                      _formerAllData.removeAt(
                                                        index,
                                                      );
                                                      _formerTitles.removeAt(
                                                        index,
                                                      );
                                                      _formerStartTime.removeAt(
                                                        index,
                                                      );
                                                      _formerEndTime.removeAt(
                                                        index,
                                                      );
                                                      _formerDayOfTheWeekData
                                                          .removeAt(index);
                                                      _formerColorData.removeAt(
                                                        index,
                                                      );
                                                      _formerAllIsClicked
                                                          .removeAt(index);
                                                      //putting the new data after deletion into the riverpod
                                                      ref
                                                              .read(
                                                                _allUserData
                                                                    .notifier,
                                                              )
                                                              .state =
                                                          _formerAllData;
                                                      ref
                                                              .read(
                                                                _allTitles
                                                                    .notifier,
                                                              )
                                                              .state =
                                                          _formerTitles;
                                                      ref
                                                              .read(
                                                                _start_time
                                                                    .notifier,
                                                              )
                                                              .state =
                                                          _formerStartTime;
                                                      ref
                                                              .read(
                                                                _end_time
                                                                    .notifier,
                                                              )
                                                              .state =
                                                          _formerEndTime;
                                                      ref
                                                              .read(
                                                                _dayOfTheWeek
                                                                    .notifier,
                                                              )
                                                              .state =
                                                          _formerDayOfTheWeekData;
                                                      ref
                                                              .read(
                                                                _color.notifier,
                                                              )
                                                              .state =
                                                          _formerColorData;
                                                      ref
                                                              .read(
                                                                _allIsClicked
                                                                    .notifier,
                                                              )
                                                              .state =
                                                          _formerAllIsClicked;
                                                      //updating the coursecount too

                                                      ref
                                                              .read(
                                                                _registeredCourseCount
                                                                    .notifier,
                                                              )
                                                              .state =
                                                          ref.read(
                                                            _registeredCourseCount,
                                                          ) -
                                                          1;
                                                      //this is for deleting from the text editing controller list too
                                                      _textControllersList
                                                          .removeAt(index);
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                      setState(() {});
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
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
                                        onTap: () {
                                          //reseting the texformfeild to default by clearing it out
                                          _textControllersList[index].text = '';
                                          //reseting the click to true
                                          List<bool> _formerClicked = [];
                                          for (bool i in ref.read(
                                            _allIsClicked,
                                          )) {
                                            _formerClicked.add(i);
                                          }
                                          _formerClicked.removeAt(index);
                                          _formerClicked.insert(index, true);
                                          ref
                                                  .read(_allIsClicked.notifier)
                                                  .state =
                                              _formerClicked;
                                          //for changing start time, i need to fetch data from the userAllData table
                                          final List<String> _defaultStartTime =
                                              [];
                                          for (String i in ref.read(
                                            _start_time,
                                          )) {
                                            _defaultStartTime.add(i);
                                          }
                                          _defaultStartTime.removeAt(index);

                                          _defaultStartTime.insert(
                                            index,
                                            ref.read(
                                              _allUserData,
                                            )[index]['start_time'],
                                          );
                                          ref.read(_start_time.notifier).state =
                                              _defaultStartTime;

                                          //for changing end time, i need to fetch data from the userAllData table
                                          final List<String> _defaultEndTime =
                                              [];
                                          for (String i in ref.read(
                                            _end_time,
                                          )) {
                                            _defaultEndTime.add(i);
                                          }
                                          _defaultEndTime.removeAt(index);

                                          _defaultEndTime.insert(
                                            index,
                                            ref.read(
                                              _allUserData,
                                            )[index]['end_time'],
                                          );
                                          ref.read(_end_time.notifier).state =
                                              _defaultEndTime;

                                          //for changing the book color back to its default value
                                          List<String> _defaultColor = [];
                                          for (String i in ref.read(_color)) {
                                            _defaultColor.add(i);
                                          }
                                          _defaultColor.removeAt(index);
                                          _defaultColor.insert(
                                            index,
                                            ref.read(
                                              _allUserData,
                                            )[index]['color'],
                                          );
                                          ref.read(_color.notifier).state =
                                              _defaultColor;
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
                                        onTap: () async {
                                          print(
                                            ref.read(_allUserData)[index],
                                          ); //del soon brb

                                          // check if the textfeild is empty or day of the week have not been choosen
                                          if ((_textControllersList[index])
                                                  .text
                                                  .isEmpty ||
                                              !ref.read(_allIsClicked)[index]) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).clearSnackBars();
                                            notifier(
                                              context: context,
                                              message:
                                                  'Feild cannot be empty!!!',
                                              bg: Colors.red,
                                              fg: ref.watch(backgroundColor),
                                            );
                                            return;
                                          }
                                          //if the textfeild is not empty, check if there are duplicate in the db already, block duplicate
                                          final _locator = await CustomDbClass
                                              .instance
                                              .getter;
                                          //get all value from the db
                                          final _allValue = await fetchAll(
                                            dbLocator: _locator,
                                            tableName: 'userAllTimetable',
                                            limit: 1000,
                                          );
                                          for (Map i in _allValue) {
                                            if (i['title'] ==
                                                    _textControllersList[index]
                                                        .text
                                                        .trim()
                                                        .toUpperCase() &&
                                                i['start_time'] ==
                                                    ref
                                                        .read(
                                                          _start_time,
                                                        )[index]
                                                        .toUpperCase() &&
                                                i['end_time'] ==
                                                    ref
                                                        .read(_end_time)[index]
                                                        .toUpperCase() &&
                                                i['dayOfTheWeek'] ==
                                                    ref.read(
                                                      _dayOfTheWeek,
                                                    )[index] &&
                                                i['color'] ==
                                                    ref.read(_color)[index]) {
                                              showDialog(
                                                context: context,
                                                builder: (builder) {
                                                  return AlertDialog(
                                                    backgroundColor: ref.watch(
                                                      foreGroundColor,
                                                    ),
                                                    title: Center(
                                                      child: Text(
                                                        'Data Already Exist',
                                                        style: customButtomTextStyle
                                                            .copyWith(
                                                              color: ref.watch(
                                                                backgroundColor,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                    content: SingleChildScrollView(
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        'The about to save data already exist in the database hence update will not proceed.\nTap anywhere outside this dialog to close',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: ref.watch(
                                                            backgroundColor,
                                                          ),
                                                          wordSpacing: -0.1,
                                                          letterSpacing: -0.5,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                              return;
                                            }
                                          }
                                          //check if day of the week have been choosen
                                          if (!ref.read(_allIsClicked)[index]) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).clearSnackBars();
                                            notifier(
                                              context: context,
                                              message:
                                                  'day of the week CANNOT be empty!',
                                              bg: ref.watch(foreGroundColor),
                                              fg: ref.watch(backgroundColor),
                                            );
                                          }
                                          //if data does not exist in the db before and the controller is not empty, proceed to update the db
                                          // update the main _userAllData to have the now updated data so i can overwrite istead of creating new data if user want to update
                                          //first Deleting the old data from the db
                                          await _locator.rawDelete(
                                            "DELETE FROM userAllTimetable WHERE title = ? AND start_time = ? AND end_time = ? AND dayOfTheWeek = ? AND color = ?",
                                            [
                                              ref.read(
                                                _allUserData,
                                              )[index]['title'],
                                              ref.read(
                                                _allUserData,
                                              )[index]['start_time'],
                                              ref.read(
                                                _allUserData,
                                              )[index]['end_time'],
                                              ref.read(
                                                _allUserData,
                                              )[index]['dayOfTheWeek'],
                                              ref.read(
                                                _allUserData,
                                              )[index]['color'],
                                            ],
                                          );

                                          print(
                                            ref.read(_allUserData)[index],
                                          ); //brb
                                          //inserting the new data into the db, and generating a new id
                                          await _locator.rawInsert(
                                            "INSERT INTO userAllTimetable(title,start_time,end_time,dayOfTheWeek,color) VALUES(?, ?, ?, ?, ?)",
                                            [
                                              _textControllersList[index].text
                                                  .toUpperCase(),
                                              ref.read(_start_time)[index],
                                              ref.read(_end_time)[index],
                                              ref.read(_dayOfTheWeek)[index],
                                              ref.read(_color)[index],
                                            ],
                                          );

                                          //updating the _alluserdata stuff
                                          final List<Map> _tempHolder1 = [];
                                          for (Map i in ref.read(
                                            _allUserData,
                                          )) {
                                            _tempHolder1.add(i);
                                          }
                                          _tempHolder1.removeAt(index);
                                          _tempHolder1.insert(index, {
                                            'title': _textControllersList[index]
                                                .text
                                                .toUpperCase()
                                                .trim(),
                                            'start_time': ref.read(
                                              _start_time,
                                            )[index],
                                            'end_time': ref.read(
                                              _end_time,
                                            )[index],
                                            'dayOfTheWeek': ref.read(
                                              _dayOfTheWeek,
                                            )[index],
                                            'color': ref.read(_color)[index],
                                          });
                                          ref
                                                  .read(_allUserData.notifier)
                                                  .state =
                                              _tempHolder1;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).clearSnackBars();
                                          notifier(
                                            context: context,
                                            message: 'saved',
                                            bg: ref.watch(foreGroundColor),
                                            fg: ref.watch(backgroundColor),
                                          );

                                          //update the hint text of the controller.
                                          final List<String> _tempHolder = [];
                                          for (String i in ref.read(
                                            _allTitles,
                                          )) {
                                            _tempHolder.add(i);
                                          }
                                          _tempHolder.removeAt(
                                            index,
                                          ); //removing the old data in the titles
                                          _tempHolder.insert(
                                            index,
                                            _textControllersList[index].text
                                                .trim()
                                                .toUpperCase(),
                                          ); //updating it
                                          //passing the edited list back to the controller
                                          ref.read(_allTitles.notifier).state =
                                              _tempHolder;
                                          //clear the controller to let user know it have been saved
                                          _textControllersList[index].text = '';
                                        },

                                        child: CircleAvatar(
                                          backgroundColor: ref.watch(
                                            foreGroundColor,
                                          ),
                                          child: Icon(
                                            Icons.save,
                                            color: ref.read(backgroundColor),
                                          ),
                                        ),
                                      ),
                                    ],
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
                    crossFadeState: firstTimeEnteringPage
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 350),
                  ),
                  Spacer(flex: 1),
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
                child: Center(child: Text("PM")),
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
              Text(" - update as latest data ", style: customButtomTextStyle),
            ],
          ),
          bottomNavChildren(
            value: [Text("Long press icons", style: customButtomTextStyle)],
          ),
          bottomNavChildren(
            value: [
              Text("Click", style: customButtomTextStyle),
              Container(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.add, color: Colors.white),
              ),
              Text("to add new row", style: customButtomTextStyle),
            ],
          ),
          bottomNavChildren(
            value: [
              Text('Click on ', style: customButtomTextStyle),
              Icon(Icons.book, color: Colors.white),
              Text(" edit prefix Color", style: customButtomTextStyle),
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

//for storing all titles of each row in the listview
final _allTitles = StateProvider<List<String>>((ref) {
  return [];
});
//for storing all start_time of each row in the listview
final _start_time = StateProvider<List<String>>((ref) {
  return [];
});
//for storing all end_time of each row in the listview
final _end_time = StateProvider<List<String>>((ref) {
  return [];
});
//for storing all dayOfTheWeek of each db row in the listview
final _dayOfTheWeek = StateProvider<List<String>>((ref) {
  return [];
});
//for storing all color of each row in the listview
final _color = StateProvider<List<String>>((ref) {
  return [];
});

//knowing day choosen when about to back up, this is for when user press the update/save ann i will put the old data here and if user want to reset to old data i will just take it from here and update the old row with the user new data
final _dayChoosenForBackUp = StateProvider<Map<String, String>>((ref) {
  return {
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

Future<void> _invalidateAll({required WidgetRef ref}) async {
  ref.read(isClosePressed.notifier).state = true;
  await Future.delayed(Duration(milliseconds: 300));
  ref.invalidate(_allIsClicked);
  ref.invalidate(_allUserData);

  ref.invalidate(_dayChoosenForBackUp);
  ref.invalidate(_registeredCourseCount);

  ref.invalidate(_color);
  ref.invalidate(_dayOfTheWeek);
  ref.invalidate(_end_time);
  ref.invalidate(_end_time);
  ref.invalidate(_start_time);
  ref.invalidate(_allTitles);

  ref.invalidate(_newCourseCount);
}

//for decieving user that app have close
final isClosePressed = StateProvider((ref) {
  return false;
});

//for increasing the 'new course', like new course 1 , new course 2 , etc
final _newCourseCount = StateProvider<int>((ref) {
  return 1;
});

// class EditCourseOverLay  extends StatelessWidget {
//   const EditCourseOverLay ({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
