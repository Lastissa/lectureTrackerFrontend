import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lecture_tracker/utils.dart';

class Editcourse extends ConsumerStatefulWidget {
  const Editcourse({super.key});

  @override
  ConsumerState<Editcourse> createState() => EditcourseState();
}

class EditcourseState extends ConsumerState<Editcourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => router.pop('/settings'),
                child: Icon(Icons.exit_to_app),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
