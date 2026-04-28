import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/utils.dart';

class BackupAndReset extends ConsumerStatefulWidget {
  const BackupAndReset({super.key});

  @override
  ConsumerState<BackupAndReset> createState() => BackupAndResetState();
}

class BackupAndResetState extends ConsumerState<BackupAndReset> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _emailController = TextEditingController();
  bool plainPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ref.watch(foreGroundColor), width: 1),
        color: ref.watch(backgroundColor),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),

        boxShadow: [
          // BoxShadow(
          //   color: ref.watch(foreGroundColor),
          //   offset: Offset(2, 2),
          //   blurRadius: 1,
          // ),

          // BoxShadow(
          //   color: ref.watch(lightMode) ? Colors.black38 : Colors.black87,
          //   offset: Offset(-2, -2),
          //   blurRadius: 3,
          // ),
        ],
      ),

      height: ref.watch(deviceSizeY) * 0.7.h,
      width: ref.watch(deviceSizeX) * 0.9.w,
      padding: EdgeInsets.all(10),
      child:
          lookForSettingBox().get('backupEmail') != null &&
              lookForSettingBox().get('backupPassword') != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Text(
                //   'Coming soon...',
                //   style: TextStyle(
                //     color: ref.watch(foreGroundColor),
                //     fontSize: 20.sp,
                //     letterSpacing: -1,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                AnimatedCrossFade(
                  firstChild: Container(
                    // color: Colors.red,
                    width: double.infinity,
                    height: ref.watch(deviceSizeY) * 0.5.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(20),
                            backgroundColor: ref.watch(foreGroundColor),
                            elevation: 2,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Perform BackUp',
                                style: TextStyle(
                                  color: ref.watch(lightMode)
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "Backup data with the presaved credentials ",
                                style: TextStyle(
                                  color: ref.watch(lightMode)
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ).animate().slideX(
                          duration: Duration(milliseconds: 800),
                          curve: Curves.decelerate,
                          begin: -1,
                          end: 0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              barrierDismissible:
                                  false, // User must tap a button to close
                              context: context,
                              builder: (builder) {
                                return AlertDialog(
                                  backgroundColor: ref.watch(foreGroundColor),
                                  title: Text(
                                    'Clear Saved Credentials',
                                    style: customButtomTextStyle.copyWith(
                                      color: ref.watch(backgroundColor),
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        Text(
                                          "The below data will be cleared",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: ref.watch(backgroundColor),
                                            wordSpacing: -0.1,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        SelectableText(
                                          "${lookForSettingBox().get('backupEmail')} \n${lookForSettingBox().get('backupPassword')}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: ref.watch(backgroundColor),
                                            wordSpacing: -0.1,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        lookForSettingBox().delete(
                                          'backupEmail',
                                        );
                                        lookForSettingBox().delete(
                                          'backupPassword',
                                        );
                                        ref.invalidate(isBackupClicked);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Yes, delete',
                                        style: TextStyle(
                                          color: ref.watch(backgroundColor),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'No, cancel',
                                        style: TextStyle(
                                          color: ref.watch(backgroundColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(20),
                            backgroundColor: ref.watch(foreGroundColor),
                            elevation: 2,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Clear Login Details',
                                style: TextStyle(
                                  color: ref.watch(lightMode)
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "Deleted the saved login credentials",
                                style: TextStyle(
                                  color: ref.watch(lightMode)
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ).animate().slideX(
                          delay: Duration(milliseconds: 600),
                          duration: Duration(milliseconds: 800),
                          curve: Curves.decelerate,
                          begin: 1,
                          end: 0,
                        ),
                      ],
                    ),
                  ),
                  secondChild: CircularProgressIndicator(
                    color: ref.watch(foreGroundColor),
                  ),
                  crossFadeState: CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 400),
                ),
                IconButton(
                  onPressed: () {
                    ref.invalidate(isBackupClicked);
                  },
                  icon: Icon(Icons.cancel, size: 40, color: Colors.red)
                      .animate()
                      .slideY(
                        curve: Curves.decelerate,
                        begin: 6,
                        end: 0,
                        duration: Duration(milliseconds: 700),
                      ),
                ),
              ],
            )
          : Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  Text(
                    "Create Account",
                    style: TextStyle(
                      color: ref.watch(foreGroundColor),
                      fontSize: 20.sp,
                      letterSpacing: -1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  customTextFeild(
                    ref: ref,
                    controller: _emailController,
                    isPassword: false,
                    suffix: SizedBox(),
                    hint: 'Email',
                    validator: (v) {
                      if (_emailController.text.trim().isEmpty) {
                        notifier(
                          atTop: true,
                          context: context,
                          message: 'Email cannot be null',
                          bg: ref.watch(foreGroundColor),
                          fg: ref.watch(backgroundColor),
                        );
                        return;
                      } else if (!_emailController.text.toLowerCase().contains(
                        "@gmail.com",
                      )) {
                        notifier(
                          atTop: true,
                          context: context,
                          message: 'Not a valid email',
                          bg: ref.watch(foreGroundColor),
                          fg: ref.watch(backgroundColor),
                        );
                        return;
                      }
                      return;
                    },
                    prefix: null,
                  ).animate().slideX(
                    curve: Curves.decelerate,
                    begin: -2,
                    end: 0,
                    duration: Duration(milliseconds: 500),
                  ),
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
                    //for the password input, i want to have a suffix icon that when clicked, it changes the state of the password from plain text to hidden and vice versa
                    child:
                        customTextFeild(
                          prefix: Icon(
                            Icons.lock,
                            color: ref.watch(foreGroundColor),
                          ),

                          suffix: InkWell(
                            onTap: () {
                              //i comment it out cos it changes to confirm password
                              // _passwordConfirmController.text = '';
                              // ref.read(_comfirmpasswordOpen.notifier).state =
                              //     true;
                              setState(() {
                                if (plainPassword) {
                                  plainPassword = false;
                                } else {
                                  plainPassword = true;
                                }
                              });
                            },
                            child: Icon(
                              plainPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: ref.watch(lightMode)
                                  ? Colors.blueAccent
                                  : Colors.teal,
                            ),
                          ),
                          controller: _passwordController,
                          hint: "Password",
                          isPassword: plainPassword,
                          validator: (value) {
                            if (_passwordController.text.trim().isEmpty) {
                              ElegantNotification(
                                toastDuration: Duration(seconds: 2),
                                background: Colors.red,
                                description: Text(
                                  style: TextStyle(color: Colors.white),
                                  'Password cannot be Empty',
                                ),
                              ).show(context);
                              _passwordController.text = '';
                              return;
                            } else if (_passwordController.text.trim().length <
                                6) {
                              notifier(
                                context: context,
                                message: 'Password too short',
                                bg: Colors.red,
                                atTop: true,
                              );
                              return;
                            }
                            return;
                          },
                          ref: ref,
                        ).animate().slideX(
                          curve: Curves.decelerate,
                          begin: 2,
                          end: 0,
                          duration: Duration(milliseconds: 500),
                          delay: Duration(milliseconds: 200),
                        ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState!.validate();
                      if (_emailController.text.toLowerCase().contains(
                            "@gmail.com",
                          ) &&
                          _passwordController.text.trim().length > 6) {
                        //now update the backup credentials
                        await lookForSettingBox().put(
                          'backupEmail',
                          _emailController.text.toUpperCase().trim(),
                        );
                        await lookForSettingBox().put(
                          'backupPassword',
                          _passwordController.text,
                        );
                        print(lookForSettingBox().get('backupEmail'));
                        print(lookForSettingBox().get('backupPassword'));
                        ref.invalidate(isBackupClicked);
                        _emailController.text = '';
                        _passwordController.text = '';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ref.watch(foreGroundColor),
                      foregroundColor: ref.watch(lightMode)
                          ? Colors.white
                          : Colors.black,
                    ),
                    child: Text("Create Account"),
                  ).animate().slideX(
                    curve: Curves.decelerate,
                    begin: -2,
                    end: 0,
                    duration: Duration(milliseconds: 500),
                  ),
                  InkWell(
                    onTap: () {
                      ref.invalidate(isBackupClicked);
                      _passwordController.text = '';
                    },
                    child: Icon(Icons.close, color: ref.watch(foreGroundColor)),
                  ),
                  Center(
                    child: Text(
                      "Note: Account creation is only for backup and restore purposes. It does not sync data across devices.",
                      style: TextStyle(
                        color: ref.watch(foreGroundColor),
                        fontSize: 12.sp,
                        letterSpacing: -1,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

final isBackupClicked = StateProvider<bool>((ref) {
  return false;
});

//Check if user have account before by looking into the hive box for backupsername and backupPassword
//if not - PROMPT CREATE ACCOUNT
//if so - PROMPT -CLEAR SAVED EMAIL AND PASSWORD - PERFORM BACKUP
