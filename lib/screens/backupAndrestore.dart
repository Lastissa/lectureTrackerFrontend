import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lecture_tracker/db.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/screens/userAccountSetting.dart';
import 'package:lecture_tracker/utils.dart';

class BackupAndReset extends ConsumerStatefulWidget {
  final uniqueKey;
  const BackupAndReset({super.key, required this.uniqueKey});

  @override
  ConsumerState<BackupAndReset> createState() => BackupAndResetState();
}

class BackupAndResetState extends ConsumerState<BackupAndReset> {
  void dispose() {
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool hidePassword = true;
  bool nothingShouldWork = false;
  TextEditingController backUpConfirmCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          key: widget.uniqueKey,
          decoration: BoxDecoration(
            // border: Border.all(color: ref.watch(foreGroundColor), width: 1),
            color: ref.watch(backgroundColor),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),

            boxShadow: [
              BoxShadow(
                offset: Offset(0, -2),
                blurRadius: 10,
                color: ref.watch(foreGroundColor).withAlpha(70),
              ),
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 1,
                color: ref.watch(foreGroundColor).withAlpha(255),
              ),
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
                    AnimatedCrossFade(
                      firstChild: Container(
                        width: double.infinity,
                        height: ref.watch(deviceSizeY) * 0.5.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              key: UniqueKey(),
                              children: [
                                Text(
                                  "LastBackupDate",
                                  style: TextStyle(
                                    color: ref.watch(foreGroundColor),
                                  ),
                                ),
                                Text(
                                  lookForSettingBox()
                                      .get("LastBackupDate")
                                      .toString(),
                                  style: TextStyle(
                                    color: ref.watch(foreGroundColor),
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              //perform backup pressed
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
                                                    controller:
                                                        backUpConfirmCodeController,
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
                                              "Type '${confirmCode}' to confirm backup with the following credentials\n\n${lookForSettingBox().get('backupEmail')} \n${lookForSettingBox().get('backupPassword').toString().substring(0, 3)}${"*" * (lookForSettingBox().get("backupPassword").toString().length - 5)}${lookForSettingBox().get("backupPassword").toString().substring(lookForSettingBox().get("backupPassword").toString().length - 2, lookForSettingBox().get("backupPassword").toString().length)}\n${ref.read(username).toUpperCase()}",
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

                                if (confirmCode !=
                                    backUpConfirmCodeController.text)
                                  return;
                                //the backup about to begin
                                final dbLocator =
                                    await CustomDbClass.instance.getter;
                                if (!mounted) {
                                  print(
                                    "i don unmount am. backupAndREset :ln  224",
                                  );
                                  return;
                                }
                                final allRegisteredCourse = await fetchAll(
                                  dbLocator: dbLocator,
                                  tableName: 'userAllTimetable',
                                  limit: 1000,
                                );
                                if (!mounted) {
                                  print(
                                    "i don unmount am. backupAndREset :ln  233",
                                  );
                                  return;
                                }
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
                                if (!mounted) {
                                  print(
                                    "i don unmount am. backupAndREset :ln  266",
                                  );
                                  return;
                                }
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
                                if (toShow[0] == 200) {
                                  lookForSettingBox().put(
                                    "LastBackupDate",
                                    "${DateFormat.yMMMEd().format(DateTime.now())}, ${TimeOfDay.now().hour} : ${TimeOfDay.now().minute < 10 ? "0${TimeOfDay.now().minute}" : TimeOfDay.now().minute}",
                                  );
                                  lookForSettingBox().put(
                                    "retreiveBackupLocalLog",
                                    {
                                      "backup": [
                                        ...lookForSettingBox().get(
                                              "retreiveBackupLocalLog",
                                            )?["backup"] ??
                                            [],
                                        "${DateFormat.yMMMEd().format(DateTime.now())}, ${TimeOfDay.now().hour} : ${TimeOfDay.now().minute < 10 ? "0${TimeOfDay.now().minute}" : TimeOfDay.now().minute}",
                                      ],
                                      "retreive": [
                                        ...lookForSettingBox().get(
                                              "retreiveBackupLocalLog",
                                            )?["retreive"] ??
                                            [],
                                      ],
                                    },
                                  );
                                } else if (toShow[0] == 401) {
                                  await lookForSettingBox().delete(
                                    "backupEmail",
                                  );
                                  await lookForSettingBox().delete(
                                    "backupPassword",
                                  );
                                  lookForSettingBox().delete("LastBackupDate");
                                  lookForSettingBox().delete(
                                    "LastRetreiveData",
                                  );

                                  notifier(
                                    context: context,
                                    message:
                                        "dirty token dectected\nplease relogin",
                                    bg: Colors.red,
                                    fg: Colors.white,
                                    atTop: true,
                                  );
                                } else {}
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
                                              "${lookForSettingBox().get('backupEmail')} \n${lookForSettingBox().get('backupPassword').toString().substring(0, 3)}${"*" * (lookForSettingBox().get("backupPassword").toString().length - 5)}${lookForSettingBox().get("backupPassword").toString().substring(lookForSettingBox().get("backupPassword").toString().length - 2, lookForSettingBox().get("backupPassword").toString().length)}",
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
              : askUserToLogin(
                  ref: ref,
                  context: context,
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  visibilityFunction: () {
                    //  password visibility function
                    setState(() {
                      if (hidePassword) {
                        hidePassword = false;
                      } else {
                        hidePassword = true;
                      }
                    });
                  },
                  createAccountOnpressed: () async {
                    if (FocusScope.of(context).hasFocus) {
                      FocusScope.of(context).unfocus();
                    }
                    if (_emailController.text.contains("@gmail.com") == false) {
                      notifier(
                        context: context,
                        message: "invalid Email",
                        bg: Colors.red,
                        fg: Colors.white,
                        atTop: true,
                      );
                      return;
                    }
                    if (_passwordController.text.length < 6) {
                      notifier(
                        context: context,
                        message: "Password Too Short",
                        bg: Colors.red,
                        fg: Colors.white,
                        atTop: true,
                      );
                      return;
                    }
                    setState(() {
                      nothingShouldWork = true;
                    });
                    if (!mounted) {
                      print("i don unmount am. backupAndREset :ln  680");
                      return;
                    }
                    ref.invalidate(loginForSignUp);
                    final List response = await ref
                        .read(
                          loginForSignUp({
                            "email": _emailController.text.trim(),
                            "password": _passwordController.text,
                            "user_type": "new",
                          }).future,
                        )
                        .timeout(
                          Duration(seconds: 6),
                          onTimeout: () => [
                            "404",
                            {"message": "Network Error!"},
                          ],
                        );
                    if (!mounted) {
                      print("i don unmount am. backupAndREset :ln  704");
                      return;
                    }
                    print(response);
                    try {
                      bool theMessageIamLookingFor =
                          response[1]["message"] == "user not found";
                      if (theMessageIamLookingFor) {
                        //now update the backup credentials
                        await lookForSettingBox().put(
                          'backupEmail',
                          _emailController.text.toUpperCase().trim(),
                        );
                        await lookForSettingBox().put(
                          'backupPassword',
                          _passwordController.text,
                        );
                        _emailController.text = '';
                        _passwordController.text = '';
                        ref.invalidate(isBackupClicked);
                        ref.read(successProvider.notifier).state = true;
                      } else {
                        setState(() {
                          nothingShouldWork = false;
                        });
                        notifier(
                          atTop: true,
                          context: context,
                          message: (response[1]["message"]).toString(),
                          bg: ref.read(foreGroundColor),
                          fg: ref.watch(backgroundColor),
                        );

                        return;
                      }
                    } catch (error) {
                      router.go("/error", extra: error.toString());
                      return;
                    }
                    setState(() {
                      nothingShouldWork = false;
                    });
                  },

                  loginOnpressed: () async {
                    //invalidate stuff in my account so the user login will not be seeing those data
                    ref.invalidate(aboutMe);
                    ref.invalidate(viewBackupHistoryPassed);
                    ref.invalidate(viewBackupHistory);
                    ref.invalidate(resetLinkFutureProvider);
                    ref.invalidate(resetLink);
                    if (FocusScope.of(context).hasFocus) {
                      FocusScope.of(context).unfocus();
                    }
                    if (_emailController.text.contains("@gmail.com") == false) {
                      notifier(
                        context: context,
                        message: "invalid Email",
                        bg: Colors.red,
                        fg: Colors.white,
                        atTop: true,
                      );
                      return;
                    }
                    if (_passwordController.text.length < 6) {
                      notifier(
                        context: context,
                        message: "Password Too Short",
                        bg: Colors.red,
                        fg: Colors.white,
                        atTop: true,
                      );
                      return;
                    }
                    setState(() {
                      nothingShouldWork = true;
                    });
                    if (!mounted) {
                      print("i don unmount am. backupAndREset :ln  809");
                      return;
                    }
                    ref.invalidate(loginForSignUp);
                    final List response = await ref
                        .read(
                          loginForSignUp({
                            "email": _emailController.text.trim(),
                            "password": _passwordController.text,
                            "user_type": "old",
                          }).future,
                        )
                        .timeout(
                          Duration(seconds: 6),
                          onTimeout: () => [
                            "404",
                            {"message": "Network Error!"},
                          ],
                        );
                    if (!mounted) {
                      print("i don unmount am. backupAndREset :ln  833");
                      return;
                    }
                    print(response);
                    if (response[0] != 200) {
                      notifier(
                        context: context,
                        message: "${response[1]["message"]}",
                        bg: Colors.red,
                        fg: Colors.white,
                        atTop: true,
                      );
                    } else {
                      //got a 200 response, it most likely to be something good
                      try {
                        final wordOfConfirmation =
                            response[1]["message"] == "success";
                        if (wordOfConfirmation) {
                          //add the auth_key to backend and keep the user active is is is still genuine
                          lookForSettingBox().put(
                            "auth_key",
                            response[1]["auth_key"],
                          );
                          //now update the backup credentials
                          await lookForSettingBox().put(
                            'backupEmail',
                            _emailController.text.toUpperCase().trim(),
                          );
                          await lookForSettingBox().put(
                            'backupPassword',
                            _passwordController.text,
                          );

                          lookForSettingBox().put(
                            "username",
                            response[1]["username"],
                          );
                          ref.read(username.notifier).state =
                              response[1]["username"];
                          ref.invalidate(isBackupClicked);
                          _emailController.text = '';
                          _passwordController.text = '';

                          ref.read(successProvider.notifier).state = true;
                        }
                      } catch (Error) {
                        notifier(
                          atTop: true,
                          context: context,
                          message: (response[1]["message"]).toString(),
                          bg: ref.read(foreGroundColor),
                          fg: ref.watch(backgroundColor),
                        );
                      }
                    }

                    // print(response);
                    setState(() {
                      nothingShouldWork = false;
                    });
                  },

                  hidePassword: hidePassword,
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
                      TextButton(
                        onPressed: () {
                          setState(() {
                            nothingShouldWork = false;
                          });
                        },
                        child: Text(
                          "cancel",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
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
  final url = Uri.parse("${ref.read(domain)}backupData/json/");
  String email = await lookForSettingBox().get("backupEmail");
  String username = await lookForSettingBox().get("username") == null
      ? "user"
      : await lookForSettingBox().get("username");
  // String password = await lookForSettingBox().get("backupPassword"); //since i am using auth_key, there is no need for password in the query param, there is no need for password in the query param
  String auth_key = await lookForSettingBox().get("auth_key");
  final sendRequest = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
      "username": username,
      // "password": password,
      "auth_key": auth_key,
      "history": dataToSend["history"],
      "currentData": dataToSend["currentData"],
    }),
  );
  final response = await jsonDecode(sendRequest.body);
  print(sendRequest.statusCode);
  // print(response);
  // print(sendRequest.statusCode);

  if (sendRequest.statusCode != 404) {
    return [sendRequest.statusCode, response];
  } else {
    return [
      404,
      {"message": "Network Error!"},
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
  void dispose() async {
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool hidePassword = true;
  bool nothingShouldWork = false;
  TextEditingController retreiveConfirmCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          key: widget.uniqueKey,

          decoration: BoxDecoration(
            // border: Border.all(color: ref.watch(foreGroundColor), width: 1),
            color: ref.watch(backgroundColor),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),

            boxShadow: [
              BoxShadow(
                offset: Offset(0, -2),
                blurRadius: 10,
                color: ref.watch(foreGroundColor).withAlpha(70),
              ),
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 1,
                color: ref.watch(foreGroundColor).withAlpha(255),
              ),
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
                    Column(
                      key: UniqueKey(),
                      children: [
                        Text(
                          "Last Retreieve Date",
                          style: TextStyle(color: ref.watch(foreGroundColor)),
                        ),
                        Text(
                          lookForSettingBox()
                              .get("LastRetreiveData")
                              .toString(),
                          style: TextStyle(
                            color: ref.watch(foreGroundColor),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
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
                                //retreive data onpressed
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
                                                    controller:
                                                        retreiveConfirmCodeController,
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
                                              "Type '${confirmCode}' to confirm retreival with the following credentials\n\n${lookForSettingBox().get('backupEmail')} \n${lookForSettingBox().get('backupPassword').toString().substring(0, 3)}${"*" * (lookForSettingBox().get("backupPassword").toString().length - 5)}${lookForSettingBox().get("backupPassword").toString().substring(lookForSettingBox().get("backupPassword").toString().length - 2, lookForSettingBox().get("backupPassword").toString().length)}",
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

                                if (confirmCode !=
                                    retreiveConfirmCodeController.text)
                                  return;

                                //Retrive data from backend
                                setState(() {
                                  nothingShouldWork = true;
                                });
                                print("...start...");
                                if (!mounted) {
                                  print(
                                    "i don unmount am. RestoreAndREset :ln  1263",
                                  );
                                  return;
                                }
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
                                if (!mounted) {
                                  print(
                                    "i don unmount am. RestoreAndREset :ln  1279",
                                  );
                                  return;
                                }
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
                                } else if (dataToShow[0] == 401) {
                                  await lookForSettingBox().delete(
                                    "backupEmail",
                                  );
                                  await lookForSettingBox().delete(
                                    "backupPassword",
                                  );
                                  lookForSettingBox().delete("LastBackupDate");
                                  lookForSettingBox().delete(
                                    "LastRetreiveData",
                                  );

                                  notifier(
                                    context: context,
                                    message:
                                        "dirty token dectected\nplease relogin",
                                    bg: Colors.red,
                                    fg: Colors.white,
                                    atTop: true,
                                  );
                                } else if (dataToShow[1]?["message"] != null) {
                                  //if message key is == success, perform update to the local db
                                  if (dataToShow[1]["message"] == "success") {
                                    if ((dataToShow[1]["currentData"] as List)
                                            .length <
                                        1) {
                                      notifier(
                                        context: context,
                                        message: "No registered course found",
                                        bg: Colors.red,
                                        fg: Colors.white,
                                      );

                                      //end the retreive since we are done
                                      setState(() {
                                        nothingShouldWork = false;
                                      });

                                      return;
                                    }
                                    //sometimes the history might not have the "data" key cos its empty, if so, just return a message saying no prior backup found
                                    try {
                                      dataToShow[1]["history"];
                                    } catch (error) {
                                      ElegantNotification(
                                        background: ref.read(foreGroundColor),
                                        description: Text(
                                          "Error; No Prior history found.\nTip: at least have one history backed up",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ref.read(backgroundColor),
                                          ),
                                        ),
                                      ).show(context);

                                      //end the retreive since we are done
                                      setState(() {
                                        nothingShouldWork = false;
                                      });

                                      return;
                                    }
                                    //since message is success, first clear the db so we can update it

                                    final locator =
                                        await CustomDbClass.instance.getter;
                                    if (!mounted) {
                                      print(
                                        "i don unmount am. RestoreAndREset :ln  1365",
                                      );
                                      return;
                                    }
                                    await locator.rawDelete(
                                      "DELETE FROM todayLectures",
                                    );
                                    if (!mounted) {
                                      print(
                                        "i don unmount am. RestoreAndREset :ln  1374",
                                      );
                                      return;
                                    }
                                    await locator.rawDelete(
                                      "DELETE FROM userAllTimetable",
                                    );
                                    if (!mounted) {
                                      print(
                                        "i don unmount am. RestoreAndREset :ln  1383",
                                      );
                                      return;
                                    }
                                    await locator.rawDelete(
                                      "DELETE FROM lectureTrackers",
                                    );
                                    if (!mounted) {
                                      print(
                                        "i don unmount am. backupAndREset :ln  1392",
                                      );
                                      return;
                                    }
                                    //draw the date back by one so the splashscreen can go pick data from the main table
                                    // lookForSettingBox().put(
                                    //   "todayDate",
                                    //   DateTime.now().day - 1,
                                    // ); brb - cant draw the date back cos it is passing data from the main table and if the user have marked that activity as done, it will still go and reshow it which is an error
                                    //Now update it
                                    //update the past lectures
                                    for (Map i in dataToShow[1]["history"]) {
                                      if (!mounted) {
                                        print(
                                          "i don unmount am. backupAndREset :ln  1406",
                                        );
                                        return;
                                      }
                                      insertIntoPastLectureTrackers(
                                        dbLocator: locator,
                                        title: i["title"],
                                        date: i["date"],
                                        accomplised: i["accomplised"],
                                      );
                                      ref
                                          .read(pastLectureSQLprovider.notifier)
                                          .update((State) {
                                            return [...State, i];
                                          });
                                    }
                                    //update the main table
                                    for (Map i
                                        in dataToShow[1]["currentData"]) {
                                      insertIntoMainLectures(
                                        dbLocator: locator,
                                        title: i["title"],
                                        start_time: i["start_time"],
                                        end_time: i["end_time"],
                                        dayOfTheWeek: i["dayOfTheWeek"],
                                        color: i["color"],
                                      );
                                    }
                                    notifier(
                                      context: context,
                                      message:
                                          "${dataToShow[0]}, ${dataToShow[1]["message"]}",
                                      bg: ref.watch(foreGroundColor),
                                      fg: ref.watch(backgroundColor),
                                    );
                                    if (dataToShow[0] == 200) {
                                      lookForSettingBox().put(
                                        "LastRetreiveData",
                                        "${DateFormat.yMMMEd().format(DateTime.now())}, ${TimeOfDay.now().hour} : ${TimeOfDay.now().minute < 10 ? "0${TimeOfDay.now().minute}" : TimeOfDay.now().minute}",
                                      );

                                      lookForSettingBox().put(
                                        "retreiveBackupLocalLog",
                                        {
                                          "retreive": [
                                            ...lookForSettingBox().get(
                                                  "retreiveBackupLocalLog",
                                                )?["retreive"] ??
                                                [],
                                            "${DateFormat.yMMMEd().format(DateTime.now())}, ${TimeOfDay.now().hour} : ${TimeOfDay.now().minute < 10 ? "0${TimeOfDay.now().minute}" : TimeOfDay.now().minute}",
                                          ],
                                          "backup": [
                                            ...lookForSettingBox().get(
                                                  "retreiveBackupLocalLog",
                                                )?["backup"] ??
                                                [],
                                          ],
                                        },
                                      );
                                    }
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
                                    message: "msg missing -impossible",
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
                                              "${lookForSettingBox().get('backupEmail')} \n${lookForSettingBox().get('backupPassword').toString().substring(0, 3)}${"*" * (lookForSettingBox().get("backupPassword").toString().length - 5)}${lookForSettingBox().get("backupPassword").toString().substring(lookForSettingBox().get("backupPassword").toString().length - 2, lookForSettingBox().get("backupPassword").toString().length)}",
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
              : askUserToLogin(
                  ref: ref,
                  context: context,
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  visibilityFunction: () {
                    //  password visibility function
                    setState(() {
                      if (hidePassword) {
                        hidePassword = false;
                      } else {
                        hidePassword = true;
                      }
                    });
                  },
                  createAccountOnpressed: () async {
                    if (FocusScope.of(context).hasFocus) {
                      FocusScope.of(context).unfocus();
                    }
                    if (_emailController.text.contains("@gmail.com") == false) {
                      notifier(
                        context: context,
                        message: "invalid Email",
                        bg: Colors.red,
                        fg: Colors.white,
                        atTop: true,
                      );
                      return;
                    }
                    if (_passwordController.text.length < 6) {
                      notifier(
                        context: context,
                        message: "Password Too Short",
                        bg: Colors.red,
                        fg: Colors.white,
                        atTop: true,
                      );
                      return;
                    }
                    setState(() {
                      nothingShouldWork = true;
                    });
                    if (!mounted) {
                      print("i don unmount am. backupAndREset :ln  680");
                      return;
                    }
                    ref.invalidate(loginForSignUp);
                    final List response = await ref
                        .read(
                          loginForSignUp({
                            "email": _emailController.text.trim(),
                            "password": _passwordController.text,
                            "user_type": "new",
                          }).future,
                        )
                        .timeout(
                          Duration(seconds: 6),
                          onTimeout: () => [
                            "404",
                            {"message": "Network Error!"},
                          ],
                        );
                    if (!mounted) {
                      print("i don unmount am. backupAndREset :ln  704");
                      return;
                    }
                    print(response);
                    try {
                      bool theMessageIamLookingFor =
                          response[1]["message"] == "user not found";
                      if (theMessageIamLookingFor) {
                        //now update the backup credentials
                        await lookForSettingBox().put(
                          'backupEmail',
                          _emailController.text.toUpperCase().trim(),
                        );
                        await lookForSettingBox().put(
                          'backupPassword',
                          _passwordController.text,
                        );
                        _emailController.text = '';
                        _passwordController.text = '';
                        ref.invalidate(isBackupClicked);
                        ref.read(successProvider.notifier).state = true;
                      } else {
                        setState(() {
                          nothingShouldWork = false;
                        });
                        notifier(
                          atTop: true,
                          context: context,
                          message: (response[1]["message"]).toString(),
                          bg: ref.read(foreGroundColor),
                          fg: ref.watch(backgroundColor),
                        );

                        return;
                      }
                    } catch (error) {
                      router.go("/error", extra: error.toString());
                      return;
                    }
                    setState(() {
                      nothingShouldWork = false;
                    });
                  },

                  loginOnpressed: () async {
                    //invalidate stuff in my account so the user login will not be seeing those data
                    ref.invalidate(aboutMe);
                    ref.invalidate(viewBackupHistoryPassed);
                    ref.invalidate(viewBackupHistory);
                    ref.invalidate(resetLinkFutureProvider);
                    ref.invalidate(resetLink);
                    if (FocusScope.of(context).hasFocus) {
                      FocusScope.of(context).unfocus();
                    }
                    if (_emailController.text.contains("@gmail.com") == false) {
                      notifier(
                        context: context,
                        message: "invalid Email",
                        bg: Colors.red,
                        fg: Colors.white,
                        atTop: true,
                      );
                      return;
                    }
                    if (_passwordController.text.length < 6) {
                      notifier(
                        context: context,
                        message: "Password Too Short",
                        bg: Colors.red,
                        fg: Colors.white,
                        atTop: true,
                      );
                      return;
                    }
                    setState(() {
                      nothingShouldWork = true;
                    });
                    if (!mounted) {
                      print("i don unmount am. backupAndREset :ln  809");
                      return;
                    }
                    ref.invalidate(loginForSignUp);
                    final List response = await ref
                        .read(
                          loginForSignUp({
                            "email": _emailController.text.trim(),
                            "password": _passwordController.text,
                            "user_type": "old",
                          }).future,
                        )
                        .timeout(
                          Duration(seconds: 6),
                          onTimeout: () => [
                            "404",
                            {"message": "Network Error!"},
                          ],
                        );
                    if (!mounted) {
                      print("i don unmount am. backupAndREset :ln  833");
                      return;
                    }
                    print(response);
                    if (response[0] != 200) {
                      notifier(
                        context: context,
                        message: "${response[1]["message"]}",
                        bg: Colors.red,
                        fg: Colors.white,
                        atTop: true,
                      );
                    } else {
                      //got a 200 response, it most likely to be something good
                      try {
                        final wordOfConfirmation =
                            response[1]["message"] == "success";
                        if (wordOfConfirmation) {
                          //add the auth_key to backend and keep the user active is is is still genuine
                          lookForSettingBox().put(
                            "auth_key",
                            response[1]["auth_key"],
                          );
                          //now update the backup credentials
                          await lookForSettingBox().put(
                            'backupEmail',
                            _emailController.text.toUpperCase().trim(),
                          );
                          await lookForSettingBox().put(
                            'backupPassword',
                            _passwordController.text,
                          );

                          lookForSettingBox().put(
                            "username",
                            response[1]["username"],
                          );
                          ref.read(username.notifier).state =
                              response[1]["username"];
                          ref.invalidate(isBackupClicked);
                          _emailController.text = '';
                          _passwordController.text = '';

                          ref.read(successProvider.notifier).state = true;
                        }
                      } catch (Error) {
                        notifier(
                          atTop: true,
                          context: context,
                          message: (response[1]["message"]).toString(),
                          bg: ref.read(foreGroundColor),
                          fg: ref.watch(backgroundColor),
                        );
                      }
                    }

                    // print(response);
                    setState(() {
                      nothingShouldWork = false;
                    });
                  },

                  hidePassword: hidePassword,
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
                      TextButton(
                        onPressed: () {
                          setState(() {
                            nothingShouldWork = false;
                          });
                        },
                        child: Text(
                          "cancel",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
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
  // String password = await lookForSettingBox().get("backupPassword"); //since i am using auth_key, its useless
  String auth_key = await lookForSettingBox().get("auth_key");
  final url = Uri.parse('${ref.read(domain)}viewData/json/?email=${email}');
  final sendRequest = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"auth_key": auth_key}),
  );

  final responseDecoded = await jsonDecode(sendRequest.body);
  print(responseDecoded);

  return [sendRequest.statusCode, responseDecoded];
});

final domain = StateProvider((ref) {
  return "https://lecture-tracker-omega.vercel.app/";
});

final loginForSignUp = FutureProvider.family((ref, Map dataToUse) async {
  final url = Uri.parse("${ref.read(domain)}login/json/");
  print(url);
  final request = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: await jsonEncode({
      "email": dataToUse["email"],
      "password": dataToUse["password"],
      "user_type": dataToUse["user_type"],
      "username": ref.read(username),
    }),
  );
  final responseDecode = await jsonDecode(request.body);

  return [request.statusCode, responseDecode];
});

Widget askUserToLogin({
  required WidgetRef ref,
  required BuildContext context,
  required Key formKey,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required void Function() visibilityFunction,
  required void Function() createAccountOnpressed,
  required void Function() loginOnpressed,
  required bool hidePassword,
}) {
  return Form(
    key: formKey,
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          InkWell(
            onTap: () => print(ref.watch(deviceSizeX).r),
            child: Text(
              "Welcome".toUpperCase(),
              style: TextStyle(
                color: ref.watch(foreGroundColor),
                fontSize: 20.sp.clamp(0, 22),
                letterSpacing: -1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: ref.watch(deviceSizeY).h * 0.01),
          customTextFeild(
            ref: ref,
            controller: emailController,
            isPassword: false,
            suffix: SizedBox(),
            hint: 'Email',

            validator: (v) {
              if (emailController.text.trim().isEmpty) {
                notifier(
                  atTop: true,
                  context: context,
                  message: 'Email cannot be null',
                  bg: ref.watch(foreGroundColor),
                  fg: ref.watch(backgroundColor),
                );
                return;
              } else if (!emailController.text.toLowerCase().contains(
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
            onchanged: null,
          ).animate().slideX(
            curve: Curves.decelerate,
            begin: -2,
            end: 0,
            duration: Duration(milliseconds: 500),
          ),
          SizedBox(height: ref.watch(deviceSizeY).h * 0.03),
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
            child: customTextFeild(
              prefix: Icon(Icons.lock, color: ref.watch(foreGroundColor)),

              suffix: InkWell(
                onTap: visibilityFunction,

                child: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                  color: ref.watch(lightMode) ? Colors.blueAccent : Colors.teal,
                ),
              ),
              controller: passwordController,
              hint: "Password",
              isPassword: hidePassword,
              validator: (value) {
                if (passwordController.text.trim().isEmpty) {
                  ElegantNotification(
                    toastDuration: Duration(seconds: 2),
                    background: Colors.red,
                    description: Text(
                      style: TextStyle(color: Colors.white),
                      'Password cannot be Empty',
                    ),
                  ).show(context);
                  passwordController.text = '';
                  return;
                } else if (passwordController.text.trim().length < 6) {
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
              onchanged: null,
            ),
            // .animate().slideX(
            //   curve: Curves.decelerate,
            //   begin: 2,
            //   end: 0,
            //   duration: Duration(milliseconds: 500),
            //   delay: Duration(milliseconds: 200),
            // ),
          ),
          SizedBox(height: ref.watch(deviceSizeY).h * 0.03),

          Column(
            children: [
              Container(
                width: ref.watch(deviceSizeX).r < 200
                    ? ref.watch(deviceSizeX).r
                    : ref.watch(deviceSizeX).r * 0.5,
                child:
                    ElevatedButton(
                      //create account onpressed
                      onPressed: createAccountOnpressed,

                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(),
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
              ),
              SizedBox(height: 5),
              //for logging in
              Container(
                width: ref.watch(deviceSizeX).r < 200
                    ? ref.watch(deviceSizeX).r
                    : ref.watch(deviceSizeX).r * 0.5,
                child:
                    ElevatedButton(
                      //loginOnpressed function
                      onPressed: loginOnpressed,

                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(),
                        backgroundColor: ref.watch(foreGroundColor),
                        foregroundColor: ref.watch(lightMode)
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Text(
                        //backup data own
                        "Login",
                        style: TextStyle(letterSpacing: 2),
                      ),
                    ).animate().slideX(
                      curve: Curves.decelerate,
                      begin: 2,
                      end: 0,
                      duration: Duration(milliseconds: 500),
                    ),
              ),
            ],
          ),
          SizedBox(height: ref.watch(deviceSizeY).h * 0.04),

          InkWell(
            onTap: () {
              if (ref.read(isBackupClicked)) {
                ref.invalidate(isBackupClicked);
              } else {
                ref.invalidate(isRestoreDataClicked);
              }
              passwordController.text = '';
            },
            child: Icon(Icons.close, color: ref.watch(foreGroundColor)),
          ),
          // Spacer(flex: 1),
          SizedBox(height: ref.watch(deviceSizeY).h * 0.04),

          Center(
            child: Text(
              "Note: Account creation is only for backup and RestoreAndReset purposes. It does not sync data across devices.",
              style: TextStyle(
                color: ref.watch(foreGroundColor),
                fontSize: 12.sp.clamp(0, 14),
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
