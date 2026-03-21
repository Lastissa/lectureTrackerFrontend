import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lecture_tracker/utils.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => router.pop(),
                icon: Icon(Icons.exit_to_app_sharp),
              ),
            ],
          ),
          //profile page for changing username, email, password ; use google auth,
          //Change the mode. light mode / dark mode
          Row(
            children: [
              ElevatedButton(onPressed: () {}, child: Text("Sign Up")),
              ElevatedButton(onPressed: () {}, child: Text("Sign In")),
            ],
          ),
          Row(children: [Icon(Icons.person), Text("Profile")]),
          Row(children: [Icon(Icons.light_mode), Text("Change mode")]),

          //
        ],
      ),
    );
  }
}
