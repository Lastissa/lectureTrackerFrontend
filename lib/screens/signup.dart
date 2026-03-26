import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/utils.dart';

// Assuming your lightMode provider is defined in a providers file
// final lightMode = StateProvider<bool>((ref) => true);

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _courseCodeController = TextEditingController();
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  int firstHour = 0;
  int firstMinute = 0;
  String firstMeridien =
      'AM'; //For knowing wether it is am or pm, had to set a defualt value so if the user did not pick anything, there wont be error as the default value will just be used
  int firstIndex = 0; // for switching the am and pm
  int secondHour = 0;
  int secondMinute = 0;
  String secondMeridien =
      'AM'; //For knowing wether it is am or pm,, had to set a defualt value so if the user did not pick anything, there wont be error as the default value will just be used
  int secondIndex = 0; // for switching am the and pm
  Color defaultColour = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    final isLight = ref.watch(lightMode);

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      backgroundColor: isLight ? Colors.white : Colors.black,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          router.go('/dashboard');
        },
        child: SizedBox(
          width: ref.watch(deviceSizeX).w,
          height: ref.watch(deviceSizeY).h,
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ref.watch(deviceSizeX) * 0.07.w,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 32),
                        Text(
                          "Get Started",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.sp.clamp(0, 28),
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: isLight ? Colors.black87 : Colors.white,
                          ),
                        ),
                        SizedBox(height: ref.watch(deviceSizeY) * 0.05.h),

                        // Username Input with Shadow
                        _buildModernField(
                          isLight: isLight,
                          controller: _usernameController,
                          hint: "Username",
                          icon: Icons.person_outline_rounded,
                          validator: (value) {
                            if (_usernameController.text.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: ref.watch(deviceSizeY) * 0.02.h),

                        // Password Input with Shadow
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(1, 0),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: AnimatedCrossFade(
                            firstChild: _buildModernField(
                              suffix: InkWell(
                                onTap: () {
                                  _passwordConfirmController.text = '';
                                  ref
                                          .read(_comfirmpasswordOpen.notifier)
                                          .state =
                                      true;
                                },
                                child: Icon(
                                  Icons.chevron_right,
                                  color: ref.watch(lightMode)
                                      ? Colors.blueAccent
                                      : Colors.teal,
                                ),
                              ),
                              isLight: isLight,
                              controller: _passwordController,
                              hint: "Password",
                              icon: Icons.lock_open_rounded,
                              isPassword: true,

                              validator: (value) {
                                if (_passwordController.text.trim().isEmpty) {
                                  ElegantNotification(
                                    background: Colors.red,
                                    description: Text(
                                      style: TextStyle(color: Colors.white),
                                      'password cannot be null',
                                    ),
                                  ).show(context);
                                }
                              },
                            ),
                            secondChild: _buildModernField(
                              isLight: isLight,
                              controller: _passwordConfirmController,
                              hint: "Confirm Password",
                              suffix: InkWell(
                                onTap: () {
                                  ref.invalidate(_comfirmpasswordOpen);
                                  _passwordConfirmController.text = '';
                                },
                                child: Icon(
                                  Icons.chevron_left,
                                  color: ref.watch(lightMode)
                                      ? Colors.blueAccent
                                      : Colors.teal,
                                ),
                              ),
                              icon: Icons.recycling_sharp,
                              isPassword: true,

                              validator: (value) {
                                if (!ref.read(_comfirmpasswordOpen)) {
                                  return null;
                                } else if (_passwordController.text.isEmpty) {
                                  // return 'Confirm password';
                                  notifier(
                                    bg: ref.watch(lightMode)
                                        ? Colors.blueAccent
                                        : const Color.fromARGB(
                                            255,
                                            39,
                                            83,
                                            158,
                                          ),
                                    context: context,
                                    message:
                                        'impossible to show. ope wetin sup?',
                                  );
                                } else if (_passwordConfirmController.text !=
                                    _passwordController.text) {
                                  // return 'Password mismatch';
                                  notifier(
                                    bg: ref.watch(lightMode)
                                        ? Colors.red
                                        : const Color.fromARGB(
                                            255,
                                            39,
                                            83,
                                            158,
                                          ),
                                    context: context,
                                    message: 'Password is not the same',
                                  );
                                }
                                return null;
                              },
                            ),
                            crossFadeState:
                                ref.watch(_comfirmpasswordOpen) &&
                                    _usernameController.text.isNotEmpty
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: Duration(milliseconds: 600),
                            sizeCurve: Curves.bounceIn,
                          ),
                        ),

                        // _buildModernField(isLight: isLight, controller: _courseCountController, hint: 'Number of Courses', icon: Icons., validator: validator)
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          width: ref.watch(deviceSizeX) * 0.9.w,
                          height: 220,
                          decoration: BoxDecoration(
                            // color: Colors.black12,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildModernField(
                                isLight: isLight,
                                controller: _courseCodeController,
                                hint: 'COURSE CODE',
                                icon: Icons.bookmark_add_sharp,
                                validator: (v) {
                                  if (_courseCodeController.text.isEmpty) {
                                    return 'required';
                                  }
                                  return null;
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                width: ref.watch(deviceSizeX) * 0.8.w,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AnimatedCrossFade(
                                    //this one is the defualt one that will show when user enters the signin page normally
                                    firstChild: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(7, (index) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                            right: 10,
                                            top: 1,
                                            bottom: 1,
                                          ),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  ref.watch(lightMode)
                                                  ? Colors.blue
                                                  : Colors.greenAccent,
                                              foregroundColor:
                                                  ref.watch(lightMode)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            onPressed: () {
                                              ref
                                                      .read(
                                                        _dayOfTheWeekChoosen
                                                            .notifier,
                                                      )
                                                      .state =
                                                  true;
                                              //knowing the index first
                                              String knownIndex = [
                                                'M',
                                                'Tu',
                                                'W',
                                                'Th',
                                                'F',
                                                'S',
                                                'Su',
                                              ][index];
                                              ref
                                                  .read(
                                                    _dayOfTheWeekChoosenText
                                                        .notifier,
                                                  )
                                                  .state = {
                                                'M': ref.read(
                                                  wordWeekdayToInt,
                                                )[0], // using the provider for the days usage so i can have a universal edit of the way the days are formatted,
                                                'Tu': ref.read(
                                                  wordWeekdayToInt,
                                                )[1], // using the provider for the days usage so i can have a universal edit of the way the days are formatted,
                                                'W': ref.read(
                                                  wordWeekdayToInt,
                                                )[2], // using the provider for the days usage so i can have a universal edit of the way the days are formatted,
                                                'Th': ref.read(
                                                  wordWeekdayToInt,
                                                )[3], // using the provider for the days usage so i can have a universal edit of the way the days are formatted,
                                                'F': ref.read(
                                                  wordWeekdayToInt,
                                                )[4], // using the provider for the days usage so i can have a universal edit of the way the days are formatted,
                                                'S': ref.read(
                                                  wordWeekdayToInt,
                                                )[5], // using the provider for the days usage so i can have a universal edit of the way the days are formatted,
                                                'Su': ref.read(
                                                  wordWeekdayToInt,
                                                )[6], // using the provider for the days usage so i can have a universal edit of the way the days are formatted,
                                              }[knownIndex]!;
                                            },
                                            child: Text(
                                              [
                                                'M',
                                                'Tu',
                                                'W',
                                                'Th',
                                                'F',
                                                'S',
                                                'Su',
                                              ][index],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    secondChild: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 2,
                                            bottom: 2,
                                            right:
                                                ref.watch(deviceSizeX) * 0.1.w,
                                          ),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  ref.watch(lightMode)
                                                  ? Colors.blue
                                                  : Colors.greenAccent,
                                              foregroundColor:
                                                  ref.watch(lightMode)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              ref.watch(
                                                _dayOfTheWeekChoosenText,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ref.watch(lightMode)
                                                ? Colors.red
                                                : Colors.red,
                                            foregroundColor:
                                                ref.watch(lightMode)
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          onPressed: () {
                                            ref.invalidate(
                                              _dayOfTheWeekChoosen,
                                            );
                                            ref.invalidate(
                                              _dayOfTheWeekChoosenText,
                                            );
                                          },
                                          child: Text('Rechoose'),
                                        ),
                                      ],
                                    ),
                                    duration: Duration(milliseconds: 400),
                                    sizeCurve: Curves.easeIn,
                                    crossFadeState:
                                        ref.watch(_dayOfTheWeekChoosen)
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    //first Hour
                                    _timeWidget(
                                      ontap: () {
                                        setState(() {
                                          if (firstHour == 11) {
                                            firstHour = 0;
                                          } else {
                                            firstHour = firstHour + 1;
                                            secondHour = firstHour;
                                          }
                                        });
                                      },
                                      text: firstHour.toString(),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    //First Minutes
                                    _timeWidget(
                                      ontap: () {
                                        setState(() {
                                          if (firstMinute >= 50) {
                                            firstMinute = 0;
                                          } else {
                                            firstMinute = firstMinute + 10;
                                            secondMinute = firstMinute;
                                          }
                                        });
                                      },
                                      text: firstMinute.toString(),
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
                                    ),

                                    Text('-'),
                                    //second hour
                                    _timeWidget(
                                      ontap: () {
                                        setState(() {
                                          if (secondHour == 11) {
                                            secondHour = 0;
                                          } else {
                                            secondHour = secondHour + 1;
                                          }
                                        });
                                      },
                                      text: secondHour.toString(),
                                    ),

                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    //second minute
                                    _timeWidget(
                                      ontap: () {
                                        setState(() {
                                          if (secondMinute >= 50) {
                                            secondMinute = 0;
                                          } else {
                                            secondMinute = secondMinute + 10;
                                          }
                                        });
                                      },
                                      text: secondMinute.toString(),
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
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      //wiping everything clean
                                      ref.invalidate(_courseCreatedCount);
                                      ref.invalidate(_dayOfTheWeekChoosen);
                                      ref.invalidate(_dayOfTheWeekChoosenText);
                                      _courseCodeController.text = '';
                                      setState(() {
                                        firstHour = 0;
                                        firstMinute = 0;
                                        firstIndex = 0;
                                        secondHour = 0;
                                        secondMinute = 0;
                                        secondIndex = 0;
                                      });
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.restart_alt_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(width: 10),
                                  InkWell(
                                    onTap: ref.watch(_courseCreatedCount) == 0
                                        ? null
                                        : () {
                                            //try to delete the last entry in the riverpod bfore the _coursecount reduce, if there is an index for it in the riverpod using the _courseCreatedCount
                                            try {
                                              ref
                                                  .read(lecturesCard.notifier)
                                                  .state = ref
                                                  .read(lecturesCard)
                                                  .sublist(
                                                    0,
                                                    ref.read(
                                                      _courseCreatedCount,
                                                    ),
                                                  );
                                            } catch (e) {
                                              10; //do nothing
                                            }

                                            ref
                                                    .read(
                                                      _courseCreatedCount
                                                          .notifier,
                                                    )
                                                    .state =
                                                ref.read(_courseCreatedCount) -
                                                1;

                                            Map dataToReturnTo = ref.read(
                                              lecturesCard,
                                            )[ref.read(_courseCreatedCount)];

                                            _courseCodeController.text =
                                                dataToReturnTo['title'];
                                            ref
                                                    .read(
                                                      _dayOfTheWeekChoosenText
                                                          .notifier,
                                                    )
                                                    .state =
                                                dataToReturnTo['dayOfTheWeek'];
                                            ref
                                                    .read(
                                                      _dayOfTheWeekChoosen
                                                          .notifier,
                                                    )
                                                    .state =
                                                true;
                                            //for the time period own
                                            List _start_time =
                                                dataToReturnTo['start_time']?.split(
                                                  ':',
                                                ); //split the start time into ['hour', 'minutes meridien']
                                            List _end_time =
                                                dataToReturnTo['end_time']?.split(
                                                  ':',
                                                ); //split the end time into ['hour', 'minutes meridien']
                                            // ElegantNotification(
                                            //   description: Text(
                                            //     '${(_start_time[1]).substring(3, 5)}',
                                            //   ),
                                            // ).show(context);
                                            setState(() {
                                              firstHour = int.parse(
                                                _start_time[0],
                                              ); //splitting the list and passing the first item of the splited variable
                                              firstMinute = int.parse(
                                                (_start_time[1]).substring(
                                                  0,
                                                  2,
                                                ),
                                              );
                                              // taking the second index 'minute meridien' and since min cannot have more than two var i just substring the werey
                                              firstIndex = ['AM', 'PM'].indexOf(
                                                (_start_time[1])
                                                    .substring(3, 5)
                                                    .toString()
                                                    .trim(),
                                              );

                                              //working on the time here and ctrl c and v for the second timing
                                              secondHour = int.parse(
                                                _end_time[0],
                                              ); //splitting the list and passing the first item of the splited variable
                                              secondMinute = int.parse(
                                                (_end_time[1]).substring(0, 2),
                                              ); //taking the second index 'minute meridien' and since min cannot have more than two var i just substring the werey
                                              secondIndex = ['AM', 'PM']
                                                  .indexOf(
                                                    (_end_time[1])
                                                        .substring(3, 5)
                                                        .toString()
                                                        .trim(),
                                                  );
                                            });
                                          },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          ref.watch(_courseCreatedCount) == 0
                                          ? const Color.fromARGB(
                                              151,
                                              158,
                                              158,
                                              158,
                                            )
                                          : const Color.fromARGB(
                                              195,
                                              68,
                                              137,
                                              255,
                                            ),
                                      child: Icon(
                                        Icons.arrow_left_sharp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  Container(width: 10),
                                  InkWell(
                                    onTap: () {
                                      //check if alll feild have been
                                      _formKey.currentState?.validate();
                                      if (_courseCodeController.text.isEmpty ||
                                          !ref.read(_dayOfTheWeekChoosen)) {
                                        ElegantNotification(
                                          description: Text(
                                            'Day of week cannot be empty',
                                          ),
                                        ).show(context);
                                        return;
                                      }
                                      //before you add the data, check if data already exists, to know wether we should update or add new
                                      if (ref.read(lecturesCard).length >
                                          ref.read(
                                            _courseCreatedCount,
                                          ) //this to check wether the user already have a made data entry before , if so, the relation beween former and latter will not be the same and i can work with that to update istead of adding to the list
                                          ) {
                                        List<Map> dataToUpdate = ref.read(
                                          lecturesCard,
                                        );
                                        dataToUpdate.removeAt(
                                          ref.read(_courseCreatedCount),
                                        ); //remove the former list so we can set the new updated one

                                        dataToUpdate.insert(
                                          ref.read(_courseCreatedCount),
                                          {
                                            'title': _courseCodeController.text
                                                .trim()
                                                .toUpperCase(),
                                            'start_time':
                                                '$firstHour:${firstMinute == 0 ? '00' : firstMinute} $firstMeridien',
                                            'end_time':
                                                '$secondHour:${secondMinute == 0 ? '00' : secondMinute} $secondMeridien',
                                            'dayOfTheWeek': ref.read(
                                              _dayOfTheWeekChoosenText,
                                            ),
                                          },
                                        );
                                        ref.read(lecturesCard.notifier).state =
                                            dataToUpdate; //update the data from the temp holder (dataToUpdate) to the riverpod
                                        _courseCodeController.text = '';
                                        ref.invalidate(_dayOfTheWeekChoosen);
                                        ref.invalidate(
                                          _dayOfTheWeekChoosenText,
                                        );
                                        setState(() {
                                          firstHour = 0;
                                          firstMinute = 0;
                                          firstIndex = 0;
                                          secondHour = 0;
                                          secondIndex = 0;
                                        });
                                        //increment the _courseCreatedCount to male it even with the lenght of the riverpod
                                        ref
                                                .read(
                                                  _courseCreatedCount.notifier,
                                                )
                                                .state =
                                            ref.read(_courseCreatedCount) + 1;
                                        ElegantNotification(
                                          description: Text('Updated'),
                                        ).show(context);
                                      } else {
                                        //add the already data to the provider
                                        ref.read(
                                          updateLectureCard({
                                            'title': _courseCodeController.text
                                                .trim()
                                                .toUpperCase(),
                                            'start_time':
                                                '$firstHour:${firstMinute == 0 ? '00' : firstMinute} $firstMeridien',
                                            'end_time':
                                                '$secondHour:${secondMinute == 0 ? '00' : secondMinute} $secondMeridien',

                                            'dayOfTheWeek': ref.read(
                                              _dayOfTheWeekChoosenText,
                                            ),
                                          }),
                                        );
                                        ref
                                                .read(
                                                  _courseCreatedCount.notifier,
                                                )
                                                .state =
                                            ref.read(_courseCreatedCount) +
                                            1; //increment the course count by one
                                        //all feilds are filled, lecture card updated ,clear the feilds ready for another inputs
                                        ref.invalidate(_dayOfTheWeekChoosen);
                                        ref.invalidate(
                                          _dayOfTheWeekChoosenText,
                                        );
                                        _courseCodeController.text = '';
                                        setState(() {
                                          firstHour = 0;
                                          firstMinute = 0;
                                          // firstIndex = 0;
                                          secondHour = 0;
                                          secondMinute = 0;
                                          // secondIndex = 0;
                                        });
                                        ElegantNotification(
                                          description: Text('added'),
                                        ).show(context);
                                      }
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: const Color.fromARGB(
                                        195,
                                        68,
                                        137,
                                        255,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ref.watch(deviceSizeY) * 0.03.h),

                        // Main Action Button
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLight
                                ? Colors.blueAccent
                                : Colors.tealAccent,
                            foregroundColor: isLight
                                ? Colors.white
                                : Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            "CREATE ACCOUNT",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp.clamp(0, 16),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: ref.watch(lightMode)
                                      ? Colors.blueAccent
                                      : Colors.teal,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ref.watch(deviceSizeX) * 0.06.w,
                                ),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    color: ref.watch(lightMode)
                                        ? Colors.black87
                                        : Colors.white70,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: ref.watch(lightMode)
                                      ? Colors.blueAccent
                                      : Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Back to Login
                        TextButton(
                          onPressed: () {
                            router.go('/settings');
                            ref.invalidate(_comfirmpasswordOpen);
                            ref.invalidate(_courseCreatedCount);
                            ref.invalidate(_dayOfTheWeekChoosen);
                            ref.invalidate(_dayOfTheWeekChoosenText);
                          },

                          child: Text(
                            "Back to Login",
                            style: TextStyle(
                              color: isLight
                                  ? Colors.grey[700]
                                  : Colors.grey[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        router.go('/dashboard');
                        ref.invalidate(_comfirmpasswordOpen);
                        ref.invalidate(_courseCreatedCount);
                        ref.invalidate(_dayOfTheWeekChoosen);
                        ref.invalidate(_dayOfTheWeekChoosenText);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: CircleAvatar(
                          backgroundColor: const Color.fromARGB(
                            255,
                            185,
                            56,
                            46,
                          ),

                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (ref.read(lightMode)) {
                          ref.read(lightMode.notifier).state = false;
                        } else {
                          ref.read(lightMode.notifier).state = true;
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: ref.watch(lightMode)
                            ? Colors.black87
                            : Colors.white70,

                        child: Icon(
                          ref.watch(lightMode)
                              ? Icons.sunny
                              : Icons.nightlight_round_sharp,
                          color: ref.watch(lightMode)
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernField({
    required bool isLight,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FormFieldValidator validator,
    bool? isPassword,
    Widget? suffix,
  }) {
    isPassword = isPassword ?? false;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isLight
                ? const Color.fromARGB(40, 0, 0, 0)
                : const Color.fromARGB(61, 0, 0, 0),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: isLight ? Colors.black87 : Colors.white),
        decoration: InputDecoration(
          suffixIcon: suffix,
          prefixIcon: Icon(
            icon,
            color: isLight ? Colors.blueAccent : Colors.tealAccent,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: isLight ? Colors.grey[400] : Colors.grey[600],
          ),
          filled: true,
          fillColor: isLight ? Colors.white : const Color(0xFF1E1E1E),

          // Your OutlineInputBorder preferences
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: isLight ? Colors.blueAccent : Colors.tealAccent,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
        validator: validator,
      ),
    );
  }
}

Widget _timeWidget({required Function ontap, required text}) {
  return InkWell(
    onTap: () => ontap(),
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(1)),
      ),
      child: Center(child: Text(text)),
    ),
  );
}

final _comfirmpasswordOpen = StateProvider<bool>((ref) {
  return false;
});

final _dayOfTheWeekChoosen = StateProvider<bool>((ref) {
  return false;
});
final _dayOfTheWeekChoosenText = StateProvider<String>((ref) {
  return '';
});

final _courseCreatedCount = StateProvider<int>((ref) {
  return 0;
});
