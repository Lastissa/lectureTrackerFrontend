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
          SizedBox(child: TextFormField()),
          SizedBox(child: TextFormField()),
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
