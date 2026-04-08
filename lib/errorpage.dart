//this page is soley for incase an error occur in the splashcreen, the error stack will be sent here

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lecture_tracker/utils.dart';

class Errorpage extends ConsumerStatefulWidget {
  final String errorMessage;
  const Errorpage({super.key, required this.errorMessage});

  @override
  ConsumerState<Errorpage> createState() => _ErrorpageState();
}

class _ErrorpageState extends ConsumerState<Errorpage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) =>
                router.go('/splashScreen'),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => router.go('/splashScreen'),
                  icon: Icon(Icons.chevron_left, color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('ERROR STACK👇')],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: BoxBorder.all(color: Colors.black45),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(widget.errorMessage),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
