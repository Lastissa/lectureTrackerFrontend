import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lecture_tracker/homepage_stacks/fifthDate.dart';
import 'package:lecture_tracker/homepage_stacks/fourthDate.dart';
import 'package:lecture_tracker/homepage_stacks/seventhDate.dart';
import 'package:lecture_tracker/homepage_stacks/sixthDate.dart';
import 'package:lecture_tracker/homepage_stacks/thirdDay.dart';
import 'package:lecture_tracker/homepage_stacks/today.dart';
import 'package:lecture_tracker/homepage_stacks/tommorrow.dart';
import 'package:lecture_tracker/homepage_stacks/yesterday.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/utils.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _LectureDashboardState();
}

class _LectureDashboardState extends ConsumerState<Dashboard> {
  bool upcomingLectureIsActive = true;
  bool pastLectureIsActice = false;
  int displayToday = 1;
  int displayTommorow = 2;
  int displayNextTommorow = 3;
  int displayNextThirdDay = 4;
  int displayNextFourthDay = 5;
  int displayNextFifthDay = 6;
  int displayNextSixthDay = 7;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard Header / Summary Area
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
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
                              '${ref.watch(todayLectureCount)} ${ref.watch(todayLectureCount) > 1 ? "Classes" : "Class"} Today',
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
                          ? () => ref.watch(lectureCardActive.notifier).state =
                                false
                          : () {
                              if (ref.read(lightMode)) {
                                ref.read(lightMode.notifier).state = false;
                                lookForSettingBox().put('lightMode', false);
                              } else {
                                ref.read(lightMode.notifier).state = true;
                                lookForSettingBox().put('lightMode', true);
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
            Expanded(
              child: PageView(
                // index: _currentToDisplay,
                children: [
                  Today(),
                  Yesterday(),
                  Tommorrow(),
                  ThirdDay(),
                  Fourthdate(),
                  Fifthdate(),
                  Sixthdate(),
                  Seventhdate(),
                ],
              ),
            ),
          ],
        ),
      ),
      // The update button
      floatingActionButton:
          FloatingActionButton(
            onPressed: ref.watch(lectureCardActive)
                ? null
                : () async {
                    bool? userHaveRegisteredCourses = await lookForSettingBox()
                        .get('userHaveCreatedCourses');
                    if (userHaveRegisteredCourses != null) {
                      router.go('/settings');
                    } else {
                      router.go("/Welcomesignup");
                      // router.go('/signup');
                    }
                  },
            child: Icon(
              Icons.settings,
              color: ref.read(lightMode) ? Colors.white : Colors.white,
            ),
            backgroundColor: Colors.blueAccent,
          ).animate().slideY(
            curve: Curves.decelerate,
            begin: 5,
            end: 0,
            duration: Duration(milliseconds: 500),
            delay: Duration(milliseconds: 250),
          ),
      bottomNavigationBar: customBottomSlider(
        ref: ref,
        children: [
          bottomNavChildren(
            value: [
              Text('Swipe ', style: customButtomTextStyle),
              Icon(Icons.switch_right_sharp, color: Colors.white),
              Text(' to view other lectures', style: customButtomTextStyle),
            ],
            // onTap: () {},
          ),
          bottomNavChildren(
            value: [
              Text('Click ', style: customButtomTextStyle),
              Icon(Icons.settings, color: Colors.white),
              Text(' to enter app setting', style: customButtomTextStyle),
            ],
            // onTap: () {},
          ),
          bottomNavChildren(
            value: [
              Text('Click ', style: customButtomTextStyle),
              Icon(
                ref.watch(lightMode)
                    ? Icons.sunny
                    : Icons.nightlight_round_sharp,
                color: Colors.white,
              ),
              Text(
                ' to enter ${ref.watch(lightMode) ? 'dark' : 'light'} mode',
                style: customButtomTextStyle,
              ),
            ],
            // onTap: () {},
          ),
          bottomNavChildren(
            value: [
              Icon(
                ref.watch(lectureAttendedIcon),
                color: ref.watch(lightMode) ? Colors.greenAccent : Colors.green,
              ),
              Text(' -', style: customButtomTextStyle),
              Text(' mean you attended class.', style: customButtomTextStyle),
            ],
            // onTap: () {},
          ),
          bottomNavChildren(
            value: [
              Icon(
                ref.watch(lectureMissedIcon),
                color: ref.watch(lightMode) ? Colors.redAccent : Colors.red,
              ),
              Text(' -', style: customButtomTextStyle),
              Text(' mean you missed class.', style: customButtomTextStyle),
            ],
            // onTap: () {},
          ),
          bottomNavChildren(
            value: [
              Icon(
                ref.watch(lectureCancelledIcon),
                color: ref.watch(lightMode) ? Colors.black : Colors.white70,
              ),
              Text(' -', style: customButtomTextStyle),
              Text(' mean lecture did not hold.', style: customButtomTextStyle),
            ],
            // onTap: () {},
          ),
        ],
      ),
    );
  }
}

Widget customBottomSlider({
  required WidgetRef ref,
  required List<Widget> children,
  Axis? direction,
  double? height,
}) {
  return Container(
    height: height ?? 48,
    width: 100,
    padding: EdgeInsets.symmetric(vertical: 8),
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: ref.watch(lightMode)
          ? Colors.blueAccent
          : Color.fromARGB(255, 4, 24, 59),
      borderRadius: BorderRadius.all(Radius.circular(2)),
      boxShadow: [
        BoxShadow(offset: Offset(1, 1), color: Colors.black54, blurRadius: 4),
      ],
    ),
    // child: Expanded(child: SizedBox(width: 10)),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Icon(Icons.info_outline_rounded, color: Colors.white),
        ),
        Expanded(
          flex: 7,
          child: CarouselSlider(
            items: children,
            options: CarouselOptions(
              scrollDirection: direction ?? Axis.horizontal,
              // clipBehavior: Clip.none,
              viewportFraction: 1,
              pauseAutoPlayOnManualNavigate: true,
              enableInfiniteScroll: true,
              autoPlayInterval: Duration(seconds: 4),
              autoPlay: true,
            ),
          ),
        ),
      ],
    ),
  ).animate().slideY(
    curve: Curves.decelerate,
    begin: 2,
    end: 0,
    duration: Duration(milliseconds: 500),
    delay: Duration(milliseconds: 300),
  );
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

//this will not return zero cos splash screen would have counted it before we even get here unless there is indeed zero lectures
final todayLectureCount = StateProvider((ref) {
  return 0;
});

Widget bottomNavChildren({required List<Widget> value, Axis? direction}) {
  return Container(
    child: SingleChildScrollView(
      scrollDirection: direction ?? Axis.vertical,
      child: Row(children: value),
    ),
  );
}

TextStyle customButtomTextStyle = TextStyle(
  overflow: TextOverflow.ellipsis,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 18.sp.clamp(0, 18),
);
