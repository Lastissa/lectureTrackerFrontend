import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/screens/backupAndrestore.dart';
import 'package:lecture_tracker/utils.dart';

class Secretpage extends ConsumerStatefulWidget {
  const Secretpage({super.key});

  @override
  ConsumerState<Secretpage> createState() => _SecretpageState();
}

class _SecretpageState extends ConsumerState<Secretpage> {
  @override
  TextEditingController domainController = TextEditingController();
  Widget build(BuildContext context) {
    domainController.text = "http://127.0.0.1:8000/";
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ref.watch(backgroundColor),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          router.go("/settings");
        },
        child: Container(
          padding: EdgeInsets.all(10),
          width: ref.watch(deviceSizeX).w,
          height: ref.watch(deviceSizeY).h,
          color: ref.watch(backgroundColor),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      size: 30.sp,
                      color: ref.watch(lightMode) ? Colors.black : Colors.white,
                    ),
                    onPressed: () {
                      router.go("/settings");
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  //for changing url for backup and reset it
                  Row(
                    children: [
                      Text(
                        "Domain",
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: ref.watch(foreGroundColor),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: domainController,

                          style: TextStyle(color: ref.watch(foreGroundColor)),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                ref.read(domain.notifier).state =
                                    domainController.text.trim();
                              },
                              icon: Icon(
                                Icons.save_as_outlined,
                                color: ref.watch(foreGroundColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onLongPress: () {
                          notifier(
                            context: context,
                            message: "Reset to default domainS",
                            bg: ref.watch(foreGroundColor),
                            fg: ref.watch(backgroundColor),
                          );
                        },
                        onPressed: () {
                          ref.invalidate(domain);
                        },
                        icon: Icon(Icons.refresh, color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () {
                          domainController.text = ref.read(domain);
                        },
                        onLongPress: () {
                          notifier(
                            context: context,
                            message: "Copy domain to clipboard",
                            bg: ref.watch(foreGroundColor),
                            fg: ref.watch(backgroundColor),
                          );
                        },
                        icon: Icon(
                          Icons.paste,
                          color: ref.watch(foreGroundColor),
                        ),
                      ),
                    ],
                  ),
                  SelectableText(
                    "Current datfault is ${ref.watch(domain)}",
                    style: TextStyle(
                      color: ref.watch(foreGroundColor),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (builder) => AlertDialog(
                        title: Text(
                          style: TextStyle(fontSize: 15.sp),
                          "current key lenght" +
                              lookForSettingBox().keys.length.toString(),
                        ),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            lookForSettingBox().keys.length,
                            (index) => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SelectableText(
                                  "${lookForSettingBox().keys.toList()[index]} : ${lookForSettingBox().get(lookForSettingBox().keys.toList()[index])}",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text("view all keys"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
