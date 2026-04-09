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

          _backUpTextFeild(
            ref: ref,
            controller: _usernameController,
            isPassword: false,
            suffix: SizedBox(),
            hint: 'Username',
            validator: (v) {},
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
              firstChild: _backUpTextFeild(
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
              secondChild: _backUpTextFeild(
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
                  //else if (_passwordController.text !=
                  //     _passwordController.text) {
                  //   notifier(
                  //     bg: Colors.red,

                  //     context: context,
                  //     message: 'Password Does Not Match ',
                  //   );
                  // }

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
        ],
      ),
    );
  }
}

final isBackupClicked = StateProvider<bool>((ref) {
  return false;
});

//for faster re-usage
Widget _backUpTextFeild({
  required WidgetRef ref,
  required TextEditingController controller,
  required bool isPassword,
  required Widget suffix,
  required String? hint,
  required FormFieldValidator validator,
}) {
  return Container(
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
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: ref.watch(foreGroundColor)),
      decoration: InputDecoration(
        suffixIcon: suffix,
        prefixIcon: Icon(Icons.people, color: ref.watch(foreGroundColor)),
        hintText: hint ?? 'empty',
        hintStyle: TextStyle(
          color: ref.watch(lightMode) ? Colors.grey[400] : Colors.grey[600],
        ),
        filled: true,
        fillColor: ref.watch(lightMode)
            ? Colors.white
            : const Color(0xFF1E1E1E),

        // Your OutlineInputBorder preferences
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: ref.watch(lightMode) ? Colors.blueAccent : Colors.tealAccent,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
      ),
      validator: validator,
    ),
  );
}

final _comfirmpasswordOpen = StateProvider((ref) {
  return false;
});
