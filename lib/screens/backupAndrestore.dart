import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/db.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/utils.dart';

String domain = "https://lecture-tracker-omega.vercel.app/";

class BackupAndReset extends ConsumerStatefulWidget {
  final uniqueKey;
  const BackupAndReset({super.key, required this.uniqueKey});

  @override
  ConsumerState<BackupAndReset> createState() => BackupAndResetState();
}

class BackupAndResetState extends ConsumerState<BackupAndReset> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool plainPassword = false;
  bool nothingShouldWork = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          key: widget.uniqueKey,
          decoration: BoxDecoration(
            border: Border.all(color: ref.watch(foreGroundColor), width: 1),
            color: ref.watch(backgroundColor),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),

            boxShadow: [],
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
                    AnimatedCrossFade(
                      firstChild: Container(
                        // color: Colors.red,
                        width: double.infinity,
                        height: ref.watch(deviceSizeY) * 0.5.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                int confirmCode1 = Random().nextInt(9);
                                int confirmCode2 = Random().nextInt(9);
                                int confirmCode3 = Random().nextInt(9);
                                int confirmCode4 = Random().nextInt(9);
                                int confirmCode5 = Random().nextInt(9);
                                String confirmCode =
                                    "$confirmCode1$confirmCode2$confirmCode3$confirmCode4$confirmCode5";
                                await showDialog(
                                  barrierColor: ref.watch(backgroundColor),
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (builder) => AlertDialog(
                                    backgroundColor: ref.watch(foreGroundColor),
                                    content: Container(
                                      height: ref.watch(deviceSizeY) * 0.3.h,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                confirmCode = "nothing";
                                              },
                                            ).animate().shake(
                                              duration: Duration(seconds: 1),
                                              hz: 4,
                                            ),

                                            SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    onChanged: (value) {
                                                      if (value.length == 5 &&
                                                          value ==
                                                              confirmCode) {
                                                        //pop the showdialog and allow backup to go on
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      }
                                                    },
                                                    textAlign: TextAlign.center,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ref.watch(
                                                        backgroundColor,
                                                      ),
                                                    ),
                                                    decoration: InputDecoration(
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color: ref.watch(
                                                                backgroundColor,
                                                              ),
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color: ref.watch(
                                                                backgroundColor,
                                                              ),
                                                              width: 1.5,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                  Radius.circular(
                                                                    10,
                                                                  ),
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),

                                            Text(
                                              "Type '${confirmCode}' to confirm backup with the following credentials\n\n${lookForSettingBox().get('backupEmail')} \n${lookForSettingBox().get('backupPassword')}\n${ref.read(username).toUpperCase()}",
                                              style: TextStyle(
                                                color: ref.watch(
                                                  backgroundColor,
                                                ),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "NB: This action will overwrite any previously backed up data and cannot be undone.",
                                              style: TextStyle(
                                                color: ref.watch(
                                                  backgroundColor,
                                                ),
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                                if (confirmCode == "nothing") return;
                                final dbLocator =
                                    await CustomDbClass.instance.getter;
                                final allRegisteredCourse = await fetchAll(
                                  dbLocator: dbLocator,
                                  tableName: 'userAllTimetable',
                                  limit: 1000,
                                );
                                //just before the sending
                                setState(() {
                                  nothingShouldWork = true;
                                });

                                ref.invalidate(backup);
                                final toShow = await ref
                                    .read(
                                      backup({
                                        "history": ref.read(
                                          pastLectureSQLprovider,
                                        ),
                                        "currentData": allRegisteredCourse,
                                      }).future,
                                    )
                                    .timeout(
                                      Duration(seconds: 20),
                                      onTimeout: () {
                                        // print("timeout");
                                        return [
                                          404,
                                          {"message": "timeout"},
                                        ];
                                      },
                                    );
                                notifier(
                                  bg: ref.watch(foreGroundColor),
                                  fg: ref.watch(backgroundColor),
                                  context: context,
                                  message:
                                      "${toShow[0]}, ${toShow[1]["message"]}",
                                  duration: Duration(seconds: 3),
                                );
                                print("${toShow[0]}, ${toShow[1]["message"]}");
                                //after the sending
                                setState(() {
                                  nothingShouldWork = false;
                                });
                                print("End of backup...");
                              },
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
                              duration: Duration(milliseconds: 400),
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
                                      backgroundColor: ref.watch(
                                        foreGroundColor,
                                      ),
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
                                                color: ref.watch(
                                                  backgroundColor,
                                                ),
                                                wordSpacing: -0.1,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                            SelectableText(
                                              "${lookForSettingBox().get('backupEmail')} \n${lookForSettingBox().get('backupPassword')}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: ref.watch(
                                                  backgroundColor,
                                                ),
                                                wordSpacing: -0.1,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            await lookForSettingBox().delete(
                                              'backupEmail',
                                            );
                                            await lookForSettingBox().delete(
                                              'backupPassword',
                                            );
                                            ref.invalidate(isBackupClicked);
                                            Navigator.of(context).pop();

                                            ref
                                                    .read(
                                                      successProvider.notifier,
                                                    )
                                                    .state =
                                                true;
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
                                    "Delete the saved login credentials",
                                    style: TextStyle(
                                      color: ref.watch(lightMode)
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().slideX(
                              delay: Duration(milliseconds: 200),
                              duration: Duration(milliseconds: 400),
                              curve: Curves.decelerate,
                              begin: 2,
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
                          } else if (!_emailController.text
                              .toLowerCase()
                              .contains("@gmail.com")) {
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
                                } else if (_passwordController.text
                                        .trim()
                                        .length <
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
                              _passwordController.text.trim().length >= 6) {
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

                            ref.read(successProvider.notifier).state = true;
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
                        child: Icon(
                          Icons.close,
                          color: ref.watch(foreGroundColor),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Note: Account creation is only for backup and RestoreAndReset purposes. It does not sync data across devices.",
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
        ),
        nothingShouldWork
            ? Positioned(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: ref.watch(deviceSizeY) * 0.7.h,
                  width: ref.watch(deviceSizeX) * 0.9.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ref.watch(foreGroundColor),
                      width: 1,
                    ),
                    color: ref.watch(lightMode)
                        ? Colors.white54
                        : Colors.black54,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),

                    boxShadow: [],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                        width: double.infinity,
                        child: LinearProgressIndicator(
                          color: ref.watch(foreGroundColor),
                          backgroundColor: ref.watch(backgroundColor),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}

final isBackupClicked = StateProvider<bool>((ref) {
  return false;
});

final successProvider = StateProvider<bool>((ref) {
  return false;
});
//Check if user have account(local app account for backup) before by looking into the hive box for backupEmail and backupPassword and username
//if not - PROMPT CREATE ACCOUNT
//if so - PROMPT -CLEAR SAVED EMAIL AND PASSWORD - PERFORM BACKUP

// two provider for performing backup(one for get and one for post)
final backup = FutureProvider.family((ref, Map dataToSend) async {
  final url = Uri.parse("${domain}backupData/json/");
  String email = await lookForSettingBox().get("backupEmail");
  String username = await lookForSettingBox().get("username") == null
      ? "user"
      : await lookForSettingBox().get("username");
  String password = await lookForSettingBox().get("backupPassword");
  final sendRequest = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
      "username": username,
      "password": password,
      "history": dataToSend["history"],
      "currentData": dataToSend["currentData"],
    }),
  );
  final response = await jsonDecode(sendRequest.body);
  // print(sendRequest.statusCode);
  // print(response);
  print(sendRequest.statusCode);
  if (sendRequest.statusCode != 404) {
    return [sendRequest.statusCode, response];
  } else {
    return [
      404,
      {"message": "unable to backup"},
    ];
  }
});

class RestoreAndReset extends ConsumerStatefulWidget {
  final uniqueKey;
  const RestoreAndReset({super.key, required this.uniqueKey});

  @override
  ConsumerState<RestoreAndReset> createState() => _RestoreAndResetState();
}

class _RestoreAndResetState extends ConsumerState<RestoreAndReset> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool plainPassword = false;
  bool nothingShouldWork = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          key: widget.uniqueKey,

          decoration: BoxDecoration(
            border: Border.all(color: ref.watch(foreGroundColor), width: 1),
            color: ref.watch(backgroundColor),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),

            boxShadow: [],
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
                    AnimatedCrossFade(
                      firstChild: Container(
                        // color: Colors.red,
                        width: double.infinity,
                        height: ref.watch(deviceSizeY) * 0.5.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                int confirmCode1 = Random().nextInt(9);
                                int confirmCode2 = Random().nextInt(9);
                                int confirmCode3 = Random().nextInt(9);
                                int confirmCode4 = Random().nextInt(9);
                                int confirmCode5 = Random().nextInt(9);
                                String confirmCode =
                                    "$confirmCode1$confirmCode2$confirmCode3$confirmCode4$confirmCode5";

                                await showDialog(
                                  barrierColor: ref.watch(backgroundColor),
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (builder) => AlertDialog(
                                    backgroundColor: ref.watch(foreGroundColor),
                                    content: Container(
                                      height: ref.watch(deviceSizeY) * 0.3.h,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                confirmCode = "nothing";
                                              },
                                            ).animate().shake(
                                              duration: Duration(seconds: 1),
                                              hz: 4,
                                            ),

                                            SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    onChanged: (value) {
                                                      if (value.length == 5 &&
                                                          value ==
                                                              confirmCode) {
                                                        //pop the showdialog and allow backup to go on
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      }
                                                    },
                                                    textAlign: TextAlign.center,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ref.watch(
                                                        backgroundColor,
                                                      ),
                                                    ),
                                                    decoration: InputDecoration(
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color: ref.watch(
                                                                backgroundColor,
                                                              ),
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color: ref.watch(
                                                                backgroundColor,
                                                              ),
                                                              width: 1.5,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                  Radius.circular(
                                                                    10,
                                                                  ),
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),

                                            Text(
                                              "Type '${confirmCode}' to confirm retreival with the following credentials\n\n${lookForSettingBox().get('backupEmail')} \n${lookForSettingBox().get('backupPassword')}",
                                              style: TextStyle(
                                                color: ref.watch(
                                                  backgroundColor,
                                                ),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "NB: This action will overwrite your current data with the retreived data",
                                              style: TextStyle(
                                                color: ref.watch(
                                                  backgroundColor,
                                                ),
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                                if (confirmCode == "nothing") return;

                                //Retrive data from backend
                                setState(() {
                                  nothingShouldWork = true;
                                });
                                print("...start...");

                                ref.invalidate(retrieveDataFromBackend);
                                final dataToShow = await ref
                                    .read(retrieveDataFromBackend.future)
                                    .timeout(
                                      Duration(seconds: 20),
                                      onTimeout: () => [
                                        404,
                                        {"message": "request not sent"},
                                      ],
                                    );

                                print("...end...");
                                print(dataToShow);
                                if (dataToShow[0] == 404 ||
                                    dataToShow[1]['message'] ==
                                        "user not found") {
                                  //incase the returned value is empty
                                  notifier(
                                    bg: ref.watch(foreGroundColor),
                                    fg: ref.watch(backgroundColor),
                                    context: context,
                                    message:
                                        "${dataToShow[0]} ${dataToShow[1]['message']}",
                                    duration: Duration(seconds: 3),
                                  );
                                } else if (dataToShow[1]?["message"] != null) {
                                  print(dataToShow[1]["history"]["data"]);

                                  //if message key is == success, perform update to the local db
                                  if (dataToShow[1]["message"] == "success") {
                                    //since message is success, first clear the db so we can update it
                                    final locator =
                                        await CustomDbClass.instance.getter;

                                    await locator.rawDelete(
                                      "DELETE FROM todayLectures",
                                    );
                                    await locator.rawDelete(
                                      "DELETE FROM userAllTimetable",
                                    );
                                    await locator.rawDelete(
                                      "DELETE FROM lectureTrackers",
                                    );

                                    //draw the date back by one so the splashscreen can go pick data from the main table
                                    lookForSettingBox().put(
                                      "todayDate",
                                      DateTime.now().day - 1,
                                    );
                                    //Now update it
                                    //update the past lectures
                                    for (Map i
                                        in dataToShow[1]["history"]["data"]) {
                                      insertIntoPastLectureTrackers(
                                        dbLocator: locator,
                                        title: i["title"],
                                        date: i["date"],
                                        accomplised: i["accomplised"],
                                      );
                                    }
                                    //update the main table
                                    for (Map i
                                        in dataToShow[1]["currentData"]["data"])
                                      insertIntoMainLectures(
                                        dbLocator: locator,
                                        title: i["title"],
                                        start_time: i["start_time"],
                                        end_time: i["end_time"],
                                        dayOfTheWeek: i["dayOfTheWeek"],
                                        color: i["color"],
                                      );
                                    notifier(
                                      context: context,
                                      message:
                                          "${dataToShow[0]}, ${dataToShow[1]["message"]}",
                                      bg: ref.watch(foreGroundColor),
                                      fg: ref.watch(backgroundColor),
                                    );
                                  } else {
                                    //just return the message without updating the local db cos the messgae is not 'success'
                                    notifier(
                                      bg: ref.watch(foreGroundColor),
                                      fg: ref.watch(backgroundColor),
                                      context: context,
                                      message:
                                          "${dataToShow[0]}, ${dataToShow[1]["message"]}",
                                      duration: Duration(seconds: 3),
                                    );
                                  }
                                } else {
                                  notifier(
                                    context: context,
                                    message: "msg missing",
                                  ); //this will happen if the backend does not return any message key which is almost impossible unless i remove it
                                }
                                //end the retreive since we are done
                                setState(() {
                                  nothingShouldWork = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(20),
                                backgroundColor: ref.watch(foreGroundColor),
                                elevation: 2,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Perform Data Retrieval',
                                    style: TextStyle(
                                      color: ref.watch(lightMode)
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    "retrieve data with the presaved credentials",
                                    style: TextStyle(
                                      color: ref.watch(lightMode)
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().slideX(
                              duration: Duration(milliseconds: 400),
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
                                      backgroundColor: ref.watch(
                                        foreGroundColor,
                                      ),
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
                                                color: ref.watch(
                                                  backgroundColor,
                                                ),
                                                wordSpacing: -0.1,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                            SelectableText(
                                              "${lookForSettingBox().get('backupEmail')} \n${lookForSettingBox().get('backupPassword')}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: ref.watch(
                                                  backgroundColor,
                                                ),
                                                wordSpacing: -0.1,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            await lookForSettingBox().delete(
                                              'backupEmail',
                                            );
                                            await lookForSettingBox().delete(
                                              'backupPassword',
                                            );
                                            ref.invalidate(isBackupClicked);
                                            Navigator.of(context).pop();

                                            ref
                                                    .read(
                                                      successProvider.notifier,
                                                    )
                                                    .state =
                                                true;
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
                                    "Delete the saved login credentials",
                                    style: TextStyle(
                                      color: ref.watch(lightMode)
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().slideX(
                              delay: Duration(milliseconds: 200),
                              duration: Duration(milliseconds: 400),
                              curve: Curves.decelerate,
                              begin: 2,
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
                        ref.invalidate(isRestoreDataClicked);
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
                          } else if (!_emailController.text
                              .toLowerCase()
                              .contains("@gmail.com")) {
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
                                } else if (_passwordController.text
                                        .trim()
                                        .length <
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
                              _passwordController.text.trim().length >= 6) {
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

                            ref.read(successProvider.notifier).state = true;
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
                          ref.invalidate(isRestoreDataClicked);
                          _passwordController.text = '';
                        },
                        child: Icon(
                          Icons.close,
                          color: ref.watch(foreGroundColor),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Note: Account creation is only for backup and RestoreAndReset purposes. It does not sync data across devices.",
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
        ),
        nothingShouldWork
            ? Positioned(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: ref.watch(deviceSizeY) * 0.7.h,
                  width: ref.watch(deviceSizeX) * 0.9.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ref.watch(foreGroundColor),
                      width: 1,
                    ),
                    color: ref.watch(lightMode)
                        ? Colors.white54
                        : Colors.black54,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),

                    boxShadow: [],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                        width: double.infinity,
                        child: LinearProgressIndicator(
                          color: ref.watch(foreGroundColor),
                          backgroundColor: ref.watch(backgroundColor),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}

final isRestoreDataClicked = StateProvider<bool>((ref) {
  return false;
});

final retrieveDataFromBackend = FutureProvider((ref) async {
  String email = await lookForSettingBox().get("backupEmail");
  String password = await lookForSettingBox().get("backupPassword");
  final url = Uri.parse(
    '${domain}viewData/json/?email=${email}&password=${password}',
  );
  final sendRequest = await http.get(url);
  final responseDecoded = await jsonDecode(sendRequest.body);
  return [sendRequest.statusCode, responseDecoded];
});
