import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lecture_tracker/screens/dashboard.dart';
import 'package:lecture_tracker/utils.dart';

class Cardoverlay extends ConsumerStatefulWidget {
  const Cardoverlay({super.key, required this.courseName});
  final String? courseName;

  @override
  ConsumerState<Cardoverlay> createState() => _cardOverlayState();
}

class _cardOverlayState extends ConsumerState<Cardoverlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ref.watch(lightMode)
            ? Colors.blueAccent
            : const Color.fromARGB(255, 4, 24, 59),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: ref.watch(lightMode) ? Colors.black38 : Colors.black87,
            offset: Offset(2, 2),
            blurRadius: 3,
          ),

          BoxShadow(
            color: ref.watch(lightMode) ? Colors.black38 : Colors.black87,
            offset: Offset(-2, 0),
            blurRadius: 3,
          ),
        ],
      ),
      height: 190,
      width: 200,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.courseName?.toUpperCase() ?? 'ERROR',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ref.watch(lightMode) ? Colors.black87 : Colors.white70,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,

                  padding: EdgeInsets.all(15),
                  backgroundColor: ref.watch(lightMode)
                      ? Colors.green
                      : const Color.fromARGB(155, 5, 70, 43),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(6)),
                  ),
                ),
                child: Center(
                  child: Text(
                    "ATTEND",
                    style: TextStyle(
                      color: ref.watch(lightMode) ? Colors.white : Colors.white,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,

                  padding: EdgeInsets.all(15),
                  backgroundColor: ref.watch(lightMode)
                      ? Colors.black54
                      : const Color.fromARGB(179, 27, 40, 114),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(6)),
                  ),
                ),
                child: Center(
                  child: Text(
                    "MISSED",
                    style: TextStyle(
                      color: ref.watch(lightMode) ? Colors.white : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          Padding(
            padding: EdgeInsetsGeometry.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(currentCourseCode);
                    ref.invalidate(lectureCardActive);
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,

                    padding: EdgeInsets.all(15),
                    backgroundColor: ref.watch(lightMode)
                        ? const Color.fromARGB(223, 202, 66, 56)
                        : const Color.fromARGB(199, 110, 38, 33),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(6),
                      ),
                    ),
                  ),
                  child: Text("CLOSE", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
