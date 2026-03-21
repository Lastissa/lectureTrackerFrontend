import 'package:flutter/material.dart';
import 'package:lecture_tracker/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: HomeFile()));
}

class HomeFile extends ConsumerStatefulWidget {
  const HomeFile({super.key});

  @override
  ConsumerState<HomeFile> createState() => _HomeFileState();
}

class _HomeFileState extends ConsumerState<HomeFile> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(ref.read(deviceSizeX), ref.read(deviceSizeY)),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: routerConfig,
        builder: (context, child) => child!,
      ),
    );
  }
}
