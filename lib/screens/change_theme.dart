import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/screens/editCourse.dart';
import 'package:lecture_tracker/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';

class ChangeTheme extends ConsumerStatefulWidget {
  const ChangeTheme({super.key});

  @override
  ConsumerState<ChangeTheme> createState() => _ChangeThemeState();
}

class _ChangeThemeState extends ConsumerState<ChangeTheme> {
  int _firstHour = lookForSettingBox().get("autoDarkModeInterval") == null
      ? 0
      : int.parse(
          lookForSettingBox().get("autoDarkModeInterval")[0].split(":")[0],
        ); //this check the hive for the list holding the data
  int _firstMinuteFirst =
      lookForSettingBox().get("autoDarkModeInterval") == null
      ? 0
      : int.parse(
          (lookForSettingBox().get("autoDarkModeInterval")[0].split(":")[1])
              .toString()
              .split("")[0],
        ); //the first part of first minute
  int _firstMinuteSecond =
      lookForSettingBox().get("autoDarkModeInterval") == null
      ? 0
      : int.parse(
          (lookForSettingBox().get("autoDarkModeInterval")[0].split(":")[1])
              .toString()
              .split("")[1],
        ); //the second part of the first minute
  int _secondHour = lookForSettingBox().get("autoDarkModeInterval") == null
      ? 0
      : int.parse(
          lookForSettingBox().get("autoDarkModeInterval")[1].split(":")[0],
        );
  int _secondMinuteFirst =
      lookForSettingBox().get("autoDarkModeInterval") == null
      ? 0
      : int.parse(
          (lookForSettingBox().get("autoDarkModeInterval")[1].split(":")[1])
              .toString()
              .split("")[0],
        ); //the first part of second minute
  int _secondMinuteSecond =
      lookForSettingBox().get("autoDarkModeInterval") == null
      ? 0
      : int.parse(
          (lookForSettingBox().get("autoDarkModeInterval")[1].split(":")[1])
              .toString()
              .split("")[1],
        ); //the second part of the second minute
  @override
  Widget build(BuildContext context) {
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
          if (mounted) {
            router.pop();
          } else {
            router.go('/settings');
          }
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Auto Dark Mode",
                        style: TextStyle(
                          letterSpacing: -1,
                          fontSize: 22.sp.clamp(0, 22),
                          fontWeight: FontWeight.w600,
                          color: ref.watch(foreGroundColor),
                        ),
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

                        value: ref.watch(autoThemeChange),
                        onChanged: (v) async {
                          notifier(
                            context: context,
                            message: v.toString(),
                            bg: ref.watch(foreGroundColor),
                            fg: ref.watch(backgroundColor),
                          );
                          ref.watch(autoThemeChange.notifier).state = v;
                          //if v is false, delete the autoDarkModeInterval key
                          lookForSettingBox().delete("autoDarkModeInterval");
                          _firstHour = 0;
                          _firstMinuteFirst = 0;
                          _firstMinuteSecond = 0;
                          _secondHour = 0;
                          _secondMinuteFirst = 0;
                          _secondMinuteSecond = 0;
                        },
                      ),
                    ],
                  ),

                  AnimatedCrossFade(
                    firstChild: SizedBox(width: ref.watch(deviceSizeX) * 0.8.w),
                    secondChild: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      color: ref.watch(lightMode)
                          ? const Color.fromARGB(29, 33, 149, 243)
                          : Colors.white12,
                      width: ref.watch(deviceSizeX) * 0.8.w,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //first Hour
                              timeWidget(
                                ontap: () {
                                  setState(() {
                                    _firstHour = _firstHour + 1;
                                    _firstHour > 23
                                        ? _firstHour = 0
                                        : _firstHour = _firstHour;

                                    final Todisplay = lookForSettingBox().get(
                                      "ddff",
                                    );

                                    notifier(
                                      context: context,
                                      message: Todisplay.toString(),
                                    );
                                  });
                                },
                                //this is for the first_hour text
                                text: _firstHour.toString(),
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
                              timeWidget(
                                ontap: () {
                                  _firstMinuteFirst = _firstMinuteFirst + 1;
                                  _firstMinuteFirst > 5
                                      ? _firstMinuteFirst = 0
                                      : _firstMinuteFirst = _firstMinuteFirst;
                                  setState(() {});
                                },
                                text: _firstMinuteFirst,
                                ref: ref,
                              ),

                              //Second part of first minutes buttom
                              timeWidget(
                                ontap: () {
                                  _firstMinuteSecond = _firstMinuteSecond + 1;
                                  _firstMinuteSecond > 9
                                      ? _firstMinuteSecond = 0
                                      : _firstMinuteSecond = _firstMinuteSecond;
                                  setState(() {});
                                },
                                text: _firstMinuteSecond,
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
                              timeWidget(
                                ontap: () {
                                  _secondHour = _secondHour + 1;
                                  _secondHour > 23
                                      ? _secondHour = 0
                                      : _secondHour = _secondHour;
                                  setState(() {});
                                },
                                text: _secondHour,
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
                              timeWidget(
                                ontap: () {
                                  _secondMinuteFirst = _secondMinuteFirst + 1;
                                  _secondMinuteFirst > 5
                                      ? _secondMinuteFirst = 0
                                      : _secondMinuteFirst = _secondMinuteFirst;
                                  setState(() {});
                                },
                                text: _secondMinuteFirst,
                                ref: ref,
                              ),
                              //second meridien - AM or PM
                              timeWidget(
                                ontap: () {
                                  _secondMinuteSecond = _secondMinuteSecond + 1;
                                  _secondMinuteSecond > 9
                                      ? _secondMinuteSecond = 0
                                      : _secondMinuteSecond =
                                            _secondMinuteSecond;
                                  setState(() {});
                                },
                                text: _secondMinuteSecond,
                                ref: ref,
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () async {
                              return showDialog(
                                context: context,
                                builder: (builder) => AlertDialog(
                                  backgroundColor: ref.watch(foreGroundColor),
                                  title: Center(
                                    child: Text(
                                      'Hint',
                                      style: customButtomTextStyle.copyWith(
                                        color: ref.watch(backgroundColor),
                                      ),
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'Tapping on each box inside above the \'Click Me \' is used to update the time with the format beign \nH : MM to H : MM',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: ref.watch(backgroundColor),
                                            wordSpacing: -0.1,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        Text(""),
                                        Text(
                                          "Reset - return the value to their default\nUpdate - Update the db with the new configuration",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: ref.watch(backgroundColor),
                                            wordSpacing: -0.1,
                                            letterSpacing: -0.5,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _firstHour =
                                            lookForSettingBox().get(
                                                  "autoDarkModeInterval",
                                                ) ==
                                                null
                                            ? 0
                                            : int.parse(
                                                lookForSettingBox()
                                                    .get(
                                                      "autoDarkModeInterval",
                                                    )[0]
                                                    .split(":")[0],
                                              ); //this check the hive for the list holding the data
                                        _firstMinuteFirst =
                                            lookForSettingBox().get(
                                                  "autoDarkModeInterval",
                                                ) ==
                                                null
                                            ? 0
                                            : int.parse(
                                                (lookForSettingBox()
                                                        .get(
                                                          "autoDarkModeInterval",
                                                        )[0]
                                                        .split(":")[1])
                                                    .toString()
                                                    .split("")[0],
                                              ); //the first part of first minute
                                        _firstMinuteSecond =
                                            lookForSettingBox().get(
                                                  "autoDarkModeInterval",
                                                ) ==
                                                null
                                            ? 0
                                            : int.parse(
                                                (lookForSettingBox()
                                                        .get(
                                                          "autoDarkModeInterval",
                                                        )[0]
                                                        .split(":")[1])
                                                    .toString()
                                                    .split("")[1],
                                              ); //the second part of the first minute
                                        _secondHour =
                                            lookForSettingBox().get(
                                                  "autoDarkModeInterval",
                                                ) ==
                                                null
                                            ? 0
                                            : int.parse(
                                                lookForSettingBox()
                                                    .get(
                                                      "autoDarkModeInterval",
                                                    )[1]
                                                    .split(":")[0],
                                              );
                                        _secondMinuteFirst =
                                            lookForSettingBox().get(
                                                  "autoDarkModeInterval",
                                                ) ==
                                                null
                                            ? 0
                                            : int.parse(
                                                (lookForSettingBox()
                                                        .get(
                                                          "autoDarkModeInterval",
                                                        )[1]
                                                        .split(":")[1])
                                                    .toString()
                                                    .split("")[0],
                                              ); //the first part of second minute
                                        _secondMinuteSecond =
                                            lookForSettingBox().get(
                                                  "autoDarkModeInterval",
                                                ) ==
                                                null
                                            ? 0
                                            : int.parse(
                                                (lookForSettingBox()
                                                        .get(
                                                          "autoDarkModeInterval",
                                                        )[1]
                                                        .split(":")[1])
                                                    .toString()
                                                    .split("")[1],
                                              ); //the second part of the second minute
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Reset",
                                        style: TextStyle(
                                          color: ref.watch(backgroundColor),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final autoDarkModeStart =
                                            "${_firstHour < 10 ? "0$_firstHour" : "$_firstHour"}:$_firstMinuteFirst$_firstMinuteSecond";

                                        final autoDarkModeEnd =
                                            "${_secondHour < 10 ? "0$_secondHour" : "$_secondHour"}:$_secondMinuteFirst$_secondMinuteSecond";
                                        lookForSettingBox().put(
                                          "autoDarkModeInterval",
                                          [autoDarkModeStart, autoDarkModeEnd],
                                        );
                                        ref
                                                .read(
                                                  changeThemeSuccess.notifier,
                                                )
                                                .state =
                                            true;

                                        //update too should make sure the rivepod is updated instantly as the db cannot be called until the splshcreen appear
                                        autoDarkModeUpdate(
                                          ref: ref,
                                          context: context,
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "update",
                                        style: TextStyle(
                                          color: ref.watch(backgroundColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                "Click Me",
                                style: customButtomTextStyle.copyWith(
                                  fontSize: 12.sp.clamp(0, 12),
                                  wordSpacing: 2,
                                  letterSpacing: 2,
                                  color: ref.watch(lightMode)
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    crossFadeState: ref.watch(autoThemeChange)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 200),
                    sizeCurve: Curves.easeIn,
                  ),
                ],
              ),

              Positioned(
                child: Container(
                  margin: EdgeInsets.only(top: ref.watch(deviceSizeY) * 0.5.h),
                  child: Center(
                    child: ref.watch(changeThemeSuccess)
                        ? LottieBuilder.asset(
                            onLoaded: (v) async {
                              // print(v);
                              await Future.delayed(Duration(seconds: 2));
                              ref.invalidate(changeThemeSuccess);
                            },
                            width: ref.watch(deviceSizeX) * 0.3.w,
                            // height: ,
                            repeat: false,
                            'assets/lottie/success.json',
                          )
                        : SizedBox(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final autoThemeChange = StateProvider<bool>((ref) {
  if (lookForSettingBox().get("autoDarkModeInterval") == null) {
    return false;
  } else {
    return true;
  }
});

final changeThemeSuccess = StateProvider<bool>((ref) {
  return false;
});

void autoDarkModeUpdate({
  required WidgetRef ref,
  required BuildContext context,
}) {
  final autoDarkModeSetting = lookForSettingBox().get("autoDarkModeInterval");
  if (autoDarkModeSetting != null) {
    String startTime = autoDarkModeSetting[0];
    int startTimeStartHour = int.parse(startTime.split(':')[0]);
    int startTimeStartMinutes = int.parse(startTime.split(':')[1]);
    String endTime = autoDarkModeSetting[1];
    int endTimeStartHour = int.parse(endTime.split(':')[0]);
    int endTimeStartMinutes = int.parse(endTime.split(':')[1]);

    int currentTimeHour = TimeOfDay.now().hour;
    int currentTimeMinutes = TimeOfDay.now().minute;

    //if the endtime is greater than the start time, meaning the user is setting the dark mode to occur to the next day
    if (endTimeStartHour > startTimeStartHour) {
      endTimeStartHour =
          endTimeStartHour +
          24; //i inreased the endtime hour value by 24 so it can catch up with the time diff
    }

    if (startTimeStartHour <= currentTimeHour &&
        currentTimeHour < endTimeStartHour) //1 , 2, 3 or 1,1, 3
    {
      print("enable dark mode");
      ref.read(lightMode.notifier).state = false;
    } else if (startTimeStartHour == currentTimeHour &&
        currentTimeHour == endTimeStartHour) //1, 1, 1
    {
      if (startTimeStartMinutes <= currentTimeMinutes &&
          currentTimeMinutes <= endTimeStartMinutes) {
        print("enable dark mode");
        ref.read(lightMode.notifier).state = false;
      } else {
        //damn, the current time min is greater than the end time min even though both the hour are the same
        ref.read(lightMode.notifier).state = true;
      }
    } else if (startTimeStartHour < currentTimeHour &&
        currentTimeHour <= endTimeStartHour) //1, 2, 2
    {
      if (currentTimeMinutes < endTimeStartMinutes) {
        print("enable dark mode");
        ref.read(lightMode.notifier).state = false;
      } else {
        ref.read(lightMode.notifier).state = true;
      }
    } else {
      //, the current hour min is greater than the end time hour or too low than the start time hour so dark mode cannot be auto apply
      ref.read(lightMode.notifier).state = true;
    }
    print([startTime, TimeOfDay.now().format(context), endTime]);
  }
}
