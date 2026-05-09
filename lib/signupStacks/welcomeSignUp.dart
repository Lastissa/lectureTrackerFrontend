import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.indigo.shade700,

                    child: InkWell(
                      onTap: () {
                        router.go('/dashboard');
                      },
                      child: Icon(Icons.close_sharp, color: Colors.white),
                    ),
                  ),
                  Text(
                    "Lecture Tracker",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ref.watch(lightMode) ? Colors.black : Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      size: 35,
                      ref.watch(lightMode) ? Icons.dark_mode : Icons.light_mode,
                      color: ref.watch(lightMode) ? Colors.black : Colors.white,
                    ),
                    onPressed: () {
                      if (ref.read(lightMode)) {
                        ref.read(lightMode.notifier).state = false;
                      } else {
                        ref.read(lightMode.notifier).state = true;
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Hero Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade700, Colors.blueAccent],
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
                    // Text(
                    //   "Track Every Lecture. Stay Ahead.",
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    SizedBox(height: 8),

                    Text(
                      "Lecture Tracker helps you organize, monitor, and revisit your academic journey with precision.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// Features
              Expanded(
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
              SizedBox(height: 15),

              /// CTA Button
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,

                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
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
        ),
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
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ref.watch(lightMode)
            ? const Color.fromARGB(255, 31, 52, 110)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blueAccent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: ref.watch(lightMode) ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
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
