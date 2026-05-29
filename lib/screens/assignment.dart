import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/utils.dart';
import 'package:lottie/lottie.dart';

class Assignment extends ConsumerStatefulWidget {
  const Assignment({super.key});

  @override
  ConsumerState<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends ConsumerState<Assignment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ref.watch(backgroundColor),
      ),
      backgroundColor: ref.watch(backgroundColor),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => router.pop(),
                icon: Icon(
                  Icons.chevron_left,
                  color: ref.watch(foreGroundColor),
                ),
              ),
              Switch(
                padding: EdgeInsets.all(10),
                trackOutlineColor: WidgetStatePropertyAll(
                  ref.watch(foreGroundColor),
                ),
                thumbColor: WidgetStateProperty.all(
                  ref.watch(lightMode) ? Colors.white : Colors.black,
                ),
                trackColor: WidgetStateProperty.all(ref.watch(foreGroundColor)),

                value: !ref.watch(lightMode),
                onChanged: (v) async {
                  ref.watch(lightMode.notifier).state = !v;
                  await lookForSettingBox().put('lightMode', !v);
                },
              ),
            ],
          ),
          Container(
            width: ref.watch(deviceSizeX).w,
            height: 200,
            child: LottieBuilder.asset(
              repeat: true,
              ref.watch(lightMode)
                  ? "assets/lottie/assignment.json"
                  : "assets/lottie/assignment_dark.json",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Assignment",
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 19.sp.clamp(0, 20),
                    fontWeight: FontWeight.w600,
                    color: ref.watch(foreGroundColor),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: ref.watch(foreGroundColor),
                  child: Icon(Icons.add, color: ref.watch(backgroundColor)),
                ),
              ],
            ),
          ),
          //today and tommorrow assignment onlt
          Expanded(
            child: Container(
              width: ref.watch(deviceSizeX).w,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ref.watch(lightMode) ? Colors.white : Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: BoxBorder.all(
                  color: ref.watch(foreGroundColor).withAlpha(45),
                ),
              ),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [LottieBuilder.asset("assets/lottie/coming.json")],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
