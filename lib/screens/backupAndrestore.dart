import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/utils.dart';

class BackupAndReset extends ConsumerStatefulWidget {
  const BackupAndReset({super.key});

  @override
  ConsumerState<BackupAndReset> createState() => BackupAndResetState();
}

class BackupAndResetState extends ConsumerState<BackupAndReset> {
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _usernameController = TextEditingController();

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
      child: 1 == 1
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Coming soon...',
                  style: TextStyle(
                    color: ref.watch(foreGroundColor),
                    fontSize: 20.sp,
                    letterSpacing: -1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref.invalidate(isBackupClicked);
                  },
                  icon: Icon(Icons.close, color: Colors.red),
                ),
              ],
            )
          : Column(
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
                  controller: _usernameController,
                  isPassword: false,
                  suffix: SizedBox(),
                  hint: 'Username',
                  validator: (v) {},
                  prefix: null,
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
                  child: AnimatedCrossFade(
                    firstChild: customTextFeild(
                      prefix: Icon(
                        Icons.lock,
                        color: ref.watch(foreGroundColor),
                      ),

                      suffix: InkWell(
                        onTap: () {
                          _passwordConfirmController.text = '';
                          ref.read(_comfirmpasswordOpen.notifier).state = true;
                        },
                        child: Icon(
                          Icons.chevron_right,
                          color: ref.watch(lightMode)
                              ? Colors.blueAccent
                              : Colors.teal,
                        ),
                      ),
                      controller: _passwordController,
                      hint: "Password",
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
                          return;
                        }
                        return;
                      },
                      ref: ref,
                    ),
                    secondChild: customTextFeild(
                      prefix: Icon(
                        Icons.lock,
                        color: ref.watch(foreGroundColor),
                      ),

                      controller: _passwordConfirmController,
                      hint: "Confirm Password",
                      suffix: InkWell(
                        onTap: () {
                          ref.invalidate(_comfirmpasswordOpen);
                          _passwordConfirmController.text = '';
                        },
                        child: Icon(
                          Icons.chevron_left,
                          color: ref.watch(foreGroundColor),
                        ),
                      ),
                      isPassword: true,
                      validator: (value) {
                        if (!ref.read(_comfirmpasswordOpen)) {
                          return null;
                        }

                        return null;
                      },
                      ref: ref,
                    ),
                    crossFadeState: ref.watch(_comfirmpasswordOpen)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 600),
                    sizeCurve: Curves.bounceIn,
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text("Create Account")),
                InkWell(
                  onTap: () => ref.invalidate(isBackupClicked),
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
    );
  }
}

final isBackupClicked = StateProvider<bool>((ref) {
  return false;
});

final _comfirmpasswordOpen = StateProvider((ref) {
  return false;
});
