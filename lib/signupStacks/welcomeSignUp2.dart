import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/utils.dart';

class Welcomesignup2 extends ConsumerStatefulWidget {
  const Welcomesignup2({super.key});

  @override
  ConsumerState<Welcomesignup2> createState() => _Welcomesignup2State();
}

class _Welcomesignup2State extends ConsumerState<Welcomesignup2> {
  bool isDark = true;

  double attendance = 78; // example %

  final List<double> weeklyData = [3, 5, 2, 6, 4, 1, 0]; // Mon-Sun

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ref.watch(backgroundColor),
      ),
      backgroundColor: isDark ? const Color(0xFF0B0F1A) : Colors.grey[100],
      body: Stack(
        children: [
          Container(
            width: ref.watch(deviceSizeX).w,
            height: ref.watch(deviceSizeY).h,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Analytics",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      onPressed: () {
                        setState(() => isDark = !isDark);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Attendance Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: _cardDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Attendance Rate", style: _titleStyle()),
                              const SizedBox(height: 15),

                              Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: CircularProgressIndicator(
                                        value: attendance / 100,
                                        strokeWidth: 10,
                                        backgroundColor: Colors.grey
                                            .withOpacity(0.2),
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    Text(
                                      "${attendance.toInt()}%",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 10),
                              Text(
                                "Your attendance performance is being continuously analyzed to help you stay consistent.",
                                style: _descStyle(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Weekly Bar Chart
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: _cardDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Weekly Lecture Distribution",
                                style: _titleStyle(),
                              ),
                              const SizedBox(height: 20),

                              SizedBox(
                                height: 180,
                                child: BarChart(
                                  BarChartData(
                                    gridData: FlGridData(show: false),
                                    borderData: FlBorderData(show: false),
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, _) {
                                            const days = [
                                              "M",
                                              "T",
                                              "W",
                                              "T",
                                              "F",
                                              "S",
                                              "S",
                                            ];
                                            return Text(
                                              days[value.toInt()],
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.black54,
                                                fontSize: 12,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    barGroups: List.generate(
                                      weeklyData.length,
                                      (i) => BarChartGroupData(
                                        x: i,
                                        barRods: [
                                          BarChartRodData(
                                            toY: weeklyData[i],
                                            width: 14,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            color: Colors.blueAccent,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
                              Text(
                                "Visual breakdown of lectures attended per day to identify your most active periods.",
                                style: _descStyle(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Insight Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: _cardDecoration(),
                          child: Row(
                            children: [
                              Icon(Icons.insights, color: Colors.blueAccent),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Lecture Tracker analyzes your patterns to help you improve consistency and academic performance.",
                                  style: _descStyle(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              width: ref.watch(deviceSizeX).w,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,

                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  router.go("/signup");
                },
                child: const Text(
                  "Get Started",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Styles
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: isDark ? const Color(0xFF141A2A) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  TextStyle _titleStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : Colors.black,
    );
  }

  TextStyle _descStyle() {
    return TextStyle(
      fontSize: 13,
      color: isDark ? Colors.white70 : Colors.black54,
    );
  }
}
