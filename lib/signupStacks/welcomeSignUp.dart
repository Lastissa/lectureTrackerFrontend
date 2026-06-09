import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/utils.dart';

class Welcomesignup extends ConsumerStatefulWidget {
  const Welcomesignup({super.key});

  @override
  ConsumerState<Welcomesignup> createState() => _WelcomesignupState();
}

class _WelcomesignupState extends ConsumerState<Welcomesignup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ref.watch(backgroundColor),
      ),
      backgroundColor: ref.watch(lightMode)
          ? Colors.grey[100]
          : const Color(0xFF0B0F1A),
      body: Center(
        child: Container(
          margin: ref.watch(deviceSizeX).w < 372 ? null : EdgeInsets.all(10),
          width: ref.watch(deviceSizeX).w.clamp(0, 372),
          decoration: BoxDecoration(
            color: ref.watch(backgroundColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 4,
                color: Colors.black38,
              ),
            ],
          ),
          padding: EdgeInsets.all(10),
          child: Stack(
            children: [
              // Positioned(child: ref.watch(darkBg)),
              Column(
                children: [
                  /// Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Lecture Tracker",
                        style: TextStyle(
                          fontSize: 22.sp.clamp(10, 25),
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 31, 52, 110),
                        ),
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //     size: 35.sp.clamp(10, 35),
                      //     ref.watch(lightMode)
                      //         ? Icons.dark_mode
                      //         : Icons.light_mode,
                      //     color: ref.watch(lightMode)
                      //         ? Colors.black
                      //         : Colors.white,
                      //   ),
                      //   onPressed: () {
                      //     if (ref.read(lightMode)) {
                      //       ref.read(lightMode.notifier).state = false;
                      //     } else {
                      //       ref.read(lightMode.notifier).state = true;
                      //     }
                      //   },
                      // ),
                    ],
                  ),

                  SizedBox(height: 15.h),

                  /// Hero Section
                  Container(
                    width: ref.watch(deviceSizeX).w,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(172, 48, 63, 159),
                          const Color.fromARGB(183, 68, 137, 255),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedTextKit(
                          totalRepeatCount: 1,
                          animatedTexts: [
                            TypewriterAnimatedText(
                              "Track Every Lecture. Stay Ahead.",
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8),

                        Text(
                          "Lecture Tracker helps you organize, monitor, and analyze your discipline toward lecture attendance journey with precision.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 15.h),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Features
                          Container(
                            height: 400,
                            child: CarouselSlider(
                              items: [
                                _featureCard(
                                  icon: Icons.schedule,
                                  title: "Lecture Tracking",
                                  description:
                                      "Keep a detailed record of all your lectures, never miss a class, and stay consistent.",
                                ),
                                _featureCard(
                                  icon: Icons.sort,
                                  title: "Course Sorting",
                                  description:
                                      "Organize lectures by course, making navigation simple and efficient.",
                                ),
                                _featureCard(
                                  icon: Icons.history,
                                  title: "Past Lectures",
                                  description:
                                      "Access previous lectures anytime for revision and continuous learning.",
                                ),
                                _featureCard(
                                  icon: Icons.palette,
                                  title: "Sleek Theme Mode",
                                  description:
                                      "Switch between dark and light themes for a comfortable user experience.",
                                ),
                              ],
                              options: CarouselOptions(
                                autoPlay: true,
                                viewportFraction: 0.4,
                                scrollDirection: Axis.vertical,
                                autoPlayInterval: Duration(seconds: 6),
                              ),
                            ),
                          ),

                          // SizedBox(height: 15.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavChildren(
        value: [
          /// Next Button
          Container(
            margin: EdgeInsets.all(5),
            width: ref.watch(deviceSizeX).w * 0.95,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,

                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // print(ref.read(deviceSizeX).w * 0.6);
                // return;
                router.go("/Welcomesignup2");
              },
              child: const Text(
                "Next",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable Feature Card
  Widget _featureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: ref.watch(deviceSizeX).w,
      // height: 150,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 31, 52, 110),

        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blueAccent),
          ),
          //  SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp.clamp(10, 18),
                    color: ref.watch(lightMode) ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13.sp.clamp(10, 16),
                    color: ref.watch(lightMode)
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
