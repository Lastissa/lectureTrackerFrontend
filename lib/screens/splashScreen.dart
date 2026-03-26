import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lecture_tracker/utils.dart';

class Splashscreen extends ConsumerStatefulWidget {
  const Splashscreen({super.key});

  @override
  ConsumerState<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends ConsumerState<Splashscreen> {
  void toRun() async {
    //get the db values here(create if not exist before) and make sure it is ready for use, pass it to the decoyDB(rename later) to avoid always hitting the db constantly
    //the db will have two tables, one for upcoming list; the oga patapata and one for past records
    //the past records will store as much as possible and they will be used for statistic and analytics for user
    //the upcomings will only be for the particular day lectures so i will have to filter the db content
    //upon all this ready, pass the past lectures to the pastLectureSQLDecoy provider

    //and at this point, all data should have load before the splashcreen remove, if error occurs? notify the user and allow reload
    await Future.delayed(Duration(seconds: 2));
    router.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    toRun();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ref.read(lightMode) ? Colors.grey[100] : Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              'PLEASE WAIT...',
              style: TextStyle(
                color: ref.watch(lightMode) ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
