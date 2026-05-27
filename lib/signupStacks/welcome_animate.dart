import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/utils.dart';
import 'package:lottie/lottie.dart';

class WelcomeAnimate extends ConsumerStatefulWidget {
  const WelcomeAnimate({super.key});

  @override
  ConsumerState<WelcomeAnimate> createState() => _WelcomeAnimateState();
}

class _WelcomeAnimateState extends ConsumerState<WelcomeAnimate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: false,
        child: Container(
          width: ref.watch(deviceSizeX).w,
          height: ref.watch(deviceSizeY).h,
          child: Builder(
            builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  // errorBuilder: (context, error, stackTrace) =>
                  //     Text(error.toString()),
                  repeat: true,
                  onLoaded: (v) async {
                    await Future.delayed(
                      Duration(seconds: 5, milliseconds: 500),
                    );
                    router.go("/dashboard");
                  },
                  "assets/lottie/welcome.json",
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ref.watch(foreGroundColor),

                      foregroundColor: ref.watch(foreGroundColor),
                    ),
                    onPressed: () {
                      router.go("/dashboard");
                    },
                    child: Text(
                      "SkiP",
                      style: TextStyle(color: ref.watch(backgroundColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
