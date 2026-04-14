import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lecture_tracker/utils.dart';

class Fifthdate extends ConsumerStatefulWidget {
  const Fifthdate({super.key});

  @override
  ConsumerState<Fifthdate> createState() => _FifthdateState();
}

class _FifthdateState extends ConsumerState<Fifthdate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${ref.read(wordWeekdayToInt)[(DateTime.now().weekday + 3) % 7]} Lectures',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ref.read(lightMode) ? Colors.black87 : Colors.white70,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          //for the past lectures cards
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: ref.read(fourDaysLaterLectureSQLprovider).isEmpty
                ? 1
                : ref.read(fourDaysLaterLectureSQLprovider).length,
            itemBuilder: (context, index) {
              //incase the provider is empty, just use this data
              List dataToUse = [
                {
                  'title': 'No Upcoming Lecture',
                  'start_time': ':',
                  'end_time': ':',
                  'dayOfTheWeek': '',
                  'color': prefixColors[Random(index).nextInt(13)],
                },
              ];
              if (ref.read(fourDaysLaterLectureSQLprovider).isNotEmpty) {
                dataToUse = ref.read(fourDaysLaterLectureSQLprovider);
              } //the db is returning 0 for 12 so i want to cover that with 12 and also set the hour to have a zero before it, istead of 1 it should be 01
              List<String> start_hour_cover = dataToUse[index]['start_time']
                  .toString()
                  .split(':'); // ['hour', 'minutes AM']

              String? start_hour;
              if (start_hour_cover[0].trim().isEmpty) {
                start_hour = '';
              } else if (start_hour_cover[0].length == 1) {
                start_hour = "0${start_hour_cover[0]}";
              } else {
                start_hour = start_hour_cover[0];
              } //start_hour_cover[0];
              String? start_minutes = start_hour_cover[1].isEmpty
                  ? ''
                  : start_hour_cover[1];
              if (start_hour_cover[1].split(' ')[0].isEmpty) {
                start_minutes =
                    ''; //this will only happen if there are no more lecture card available for the day
              } else if (start_hour_cover[1].split(' ')[0].length == 1) {
                start_minutes = "0${start_minutes}";
              } else {
                start_minutes = start_hour_cover[1];
              }

              List<String> end_hour_cover = dataToUse[index]['end_time']
                  .toString()
                  .split(':'); // ['hour', 'minutes AM']

              String? end_hour;
              if (end_hour_cover[0].trim().isEmpty) {
                end_hour = '';
              } else if (end_hour_cover[0].length == 1) {
                end_hour = "0${end_hour_cover[0]}";
              } else {
                end_hour = end_hour_cover[0];
              } //end_hour_cover[0];
              String? end_minutes = end_hour_cover[1].isEmpty
                  ? ''
                  : end_hour_cover[1];
              if (end_hour_cover[1].split(' ')[0].isEmpty) {
                end_minutes =
                    ''; //this will only happen if there are no more lecture card available for the day
              } else if (end_hour_cover[1].split(' ')[0].length == 1) {
                end_minutes = "0${end_minutes}";
              } else {
                end_minutes = end_hour_cover[1];
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                decoration: BoxDecoration(
                  color: ref.watch(lightMode) ? Colors.white : Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  boxShadow: ref.watch(lightMode)
                      ? [
                          BoxShadow(
                            color: Color.fromARGB(40, 0, 0, 0),
                            offset: Offset(0, -1),
                            blurRadius: 1,
                          ),
                          BoxShadow(
                            color: Color.fromARGB(96, 0, 0, 0),
                            offset: Offset(1, 1),
                            blurRadius: 1,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: const Color.fromARGB(255, 43, 42, 42),
                            offset: Offset(1, 1),
                          ),
                          BoxShadow(
                            color: const Color.fromRGBO(77, 76, 76, 1),
                            offset: Offset(0, -1),
                          ),
                        ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Container(
                    // duration: duration,
                    width: 4,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorMapper[dataToUse[index]["color"]],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  title: Text(
                    dataToUse[index]["title"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ref.read(lightMode) ? Colors.black : Colors.white,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: ref.read(lightMode)
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            const SizedBox(width: 4),
                            const SizedBox(width: 4),
                            Text(
                              '$start_hour ${start_hour.isEmpty ? '' : ':'} $start_minutes ${start_hour.isEmpty ? '' : '-'}  $end_hour${end_hour.isEmpty ? '' : ':'} $end_minutes',
                              style: TextStyle(
                                color: ref.read(lightMode)
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  trailing: Icon(
                    dataToUse[index]['accomplised'] == 1
                        ? Icons.thumb_up_alt
                        : (dataToUse[index]['accomplised'] == 0
                              ? Icons.thumb_down_alt
                              : Icons.multiple_stop_sharp),
                    color: dataToUse[index]['accomplised'] == 1
                        ? Colors.green
                        : (dataToUse[index]['accomplised'] == 0
                              ? Colors.redAccent
                              : (ref.watch(lightMode)
                                    ? Colors.black
                                    : Colors.white70)),
                  ),
                  splashColor: Colors.transparent,
                  // onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
