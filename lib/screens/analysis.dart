import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/utils.dart';

class Analysis extends ConsumerStatefulWidget {
  const Analysis({super.key});

  @override
  ConsumerState<Analysis> createState() => AnalysisState();
}

class AnalysisState extends ConsumerState<Analysis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ref.watch(backgroundColor),
      ),
      body: Container(
        width: ref.watch(deviceSizeX).w,
        height: ref.watch(deviceSizeY).h,
        color: ref.watch(backgroundColor),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    size: 30.sp,
                    color: ref.watch(lightMode) ? Colors.black : Colors.white,
                  ),
                  onPressed: () {
                    router.go("/settings");
                  },
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //3 cards showing number of lecture missed, attended and nullfied and a pie chart right underneath it to visualize it
                    Row(
                      children: [
                        pieContainer(
                          ref: ref,
                          color: Colors.red,
                          text: "Missed",
                        ),
                        pieContainer(
                          ref: ref,
                          color: Colors.green,
                          text: "Attended",
                        ),
                        pieContainer(
                          ref: ref,
                          color: const Color.fromARGB(255, 78, 143, 196),
                          text: "Nullified",
                        ),
                      ],
                    ),

                    //bar chart showing analysis per day (available days in the history sql) and a line chart showing analysis per week (finding repetition in days) right underneath it
                    Row(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget pieContainer({
  required WidgetRef ref,
  required Color color,
  required String text,
}) {
  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) {
      if (didPop) return;
      router.go("/settings");
    },
    child: Container(
      margin: EdgeInsets.all(10.r),
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: color,
        boxShadow: ref.watch(lightMode)
            ?
              //light mode shadow
              [
                BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  color: Colors.black26,
                ),
              ]
            :
              //dark mode shadow
              [
                BoxShadow(
                  offset: Offset(2, 3),
                  blurRadius: 6,
                  color: Colors.white54,
                ),
              ],

        borderRadius: BorderRadius.circular(10.r),
      ),
    ),
  );
}
