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
  List firstMeridien = ['AM', 'PM'];
  int firstIndex = 0; // for switching the am and pm
  int secondHour = 0;
  int secondMinute = 0;
  List secondMeridien = ['AM', 'PM'];
  int secondIndex = 0; // for switching am the and pm
  Color defaultColour = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    final isLight = ref.watch(lightMode);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: isLight ? Colors.white : Colors.black,
      ),
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
                              isLight: isLight,
                              controller: _passwordController,
                              hint: "Password",
                              icon: Icons.lock_open_rounded,
                              isPassword: true,

                              validator: (value) {
                                return null;
                              },
                            ),
                            secondChild: _buildModernField(
                              isLight: isLight,
                              controller: _passwordConfirmController,
                              hint: "Confirm Password",
                              suffix: InkWell(
                                onTap: () =>
                                    ref.invalidate(_comfirmpasswordOpen),
                                child: Icon(
                                  Icons.chevron_left,
                                  color: ref.read(lightMode)
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
                          height: 200,
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
                                    onTap: () {},
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
                                    onTap: () {},
                                    child: CircleAvatar(
                                      backgroundColor: const Color.fromARGB(
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
                                    onTap: () {},
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
                          onPressed: () {
                            //this is for the validation
                            if (_formKey.currentState?.validate() ?? false) {
                              //This is for changing the animation cross fade stuff
                              if (_passwordController.text.isNotEmpty) {
                                //This is for the acual create account stuff
                                if (_passwordConfirmController.text ==
                                    _passwordController.text) {
                                  notifier(
                                    context: context,
                                    message: "action soon; create account",
                                    bg: Colors.blueAccent,
                                  );

                                  //invalidate this soon as you are about to leave page
                                  // ref.invalidate(_comfirmpasswordOpen);
                                } else {
                                  ref
                                          .read(_comfirmpasswordOpen.notifier)
                                          .state =
                                      true;
                                  return;
                                }
                              }
                            }
                          },
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
                                  color: ref.read(lightMode)
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
                                  color: ref.read(lightMode)
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

final _comfirmpasswordOpen = StateProvider<bool>((ref) {
  return false;
});

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
