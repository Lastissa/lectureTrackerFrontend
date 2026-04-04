import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lecture_tracker/utils.dart';

class Yesterday extends ConsumerStatefulWidget {
  const Yesterday({super.key});

  @override
  ConsumerState<Yesterday> createState() => _YesterdayState();
}

class _YesterdayState extends ConsumerState<Yesterday> {
  final listViewController = ScrollController();

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
                'Past Lectures',
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
            controller: listViewController,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: ref.read(pastLectureSQLprovider).isEmpty
                ? 1
                : ref.read(pastLectureSQLprovider).length,
            itemBuilder: (context, index) {
              //incase the provider is empty, just use this data
              List dataToUse = [
                {
                  'title': 'No PAST LECTURE',
                  'date': DateFormat.yMMMEd().format(DateTime.now()),
                  'accomplised':
                      2, //zero mean false, 1 mean true, 2 mean nullified
                },
              ];
              if (ref.read(pastLectureSQLprovider).isNotEmpty) {
                dataToUse = ref.read(pastLectureSQLprovider);
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
                      color: ref.watch(lightMode)
                          ? Colors.black26
                          : Colors.white24,
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
                            Text(
                              '${dataToUse[index]["date"]}',
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
                        ? ref.watch(lectureAttendedIcon)
                        : (dataToUse[index]['accomplised'] == 0
                              ? ref.watch(lectureMissedIcon)
                              : ref.watch(lectureCancelledIcon)),
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
