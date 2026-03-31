import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/utils.dart';

final note = """
the setting page 
  -> Change username.
  -> update theme.
  -> Edit registered courses
  -> analysis (past lecture analysis e.g ratio of lecture missed to attended, timetable analysis e.g total lecture hours per week & AVE per day, most busiest day, etc)
  -> elevated button for backing up data to cloud; this is where i will use that password
  -> elevated button for recovering data from the online db


  very bottom ; devOpe built it , alonside about developer text .and maybesome sort of signature maybe whatsapp or twitter, use the url launcher for navigation 

""";

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  @override
  bool isChangeUserNameActive = false;
  double temp = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ref.read(lightMode) ? Colors.grey[100] : Colors.black,
      appBar: AppBar(
        toolbarHeight: ref.read(deviceSizeY) * 0.2.h,
        backgroundColor: ref.read(lightMode) ? Colors.grey[100] : Colors.black,
        title: Center(
          child: Text(
            '\nSETTINGS',
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 28.sp.clamp(0, 28),
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: ref.watch(lightMode)
                  ? Colors.blueAccent
                  : Colors.greenAccent,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //the change username
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: ref.watch(deviceSizeY) * 0.02.h,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.person,
                                  color: ref.watch(lightMode)
                                      ? Colors.blueAccent
                                      : Colors.greenAccent,
                                ),
                              ),
                              Text(
                                'Change Username',
                                style: TextStyle(
                                  letterSpacing: -1,
                                  fontSize: 17.sp.clamp(0, 17),
                                  fontWeight: FontWeight.w600,
                                  color: ref.watch(lightMode)
                                      ? Colors.blueAccent
                                      : Colors.greenAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //the change theme
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: ref.watch(deviceSizeY) * 0.02.h,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        ref.watch(lightMode)
                                            ? Icons.sunny
                                            : Icons.nightlight_round_sharp,
                                        color: ref.watch(lightMode)
                                            ? Colors.blueAccent
                                            : Colors.greenAccent,
                                      ),
                                    ),
                                    Text(
                                      "Change Theme",
                                      style: TextStyle(
                                        letterSpacing: -1,
                                        fontSize: 17.sp.clamp(0, 17),
                                        fontWeight: FontWeight.w600,
                                        color: ref.watch(lightMode)
                                            ? Colors.blueAccent
                                            : Colors.greenAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Switch(
                            trackOutlineColor: WidgetStatePropertyAll(
                              ref.watch(lightMode)
                                  ? Colors.blueAccent
                                  : Colors.greenAccent,
                            ),
                            thumbColor: WidgetStateProperty.all(
                              ref.watch(lightMode)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            trackColor: WidgetStateProperty.all(
                              ref.watch(lightMode)
                                  ? Colors.blueAccent
                                  : Colors.greenAccent,
                            ),

                            value: !ref.watch(lightMode),
                            onChanged: (v) async {
                              ref.watch(lightMode.notifier).state = !v;
                              await lookForSettingBox().put('lightMode', !v);
                            },
                          ),
                        ],
                      ),
                      //edit registered courses
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: ref.watch(deviceSizeY) * 0.02.h,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.edit_document,
                                  color: ref.watch(lightMode)
                                      ? Colors.blueAccent
                                      : Colors.greenAccent,
                                ),
                              ),
                              Text(
                                "Edit Registered Course",
                                style: TextStyle(
                                  letterSpacing: -1,
                                  fontSize: 17.sp.clamp(0, 17),
                                  fontWeight: FontWeight.w600,
                                  color: ref.watch(lightMode)
                                      ? Colors.blueAccent
                                      : Colors.greenAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //analysis widget
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: ref.watch(deviceSizeY) * 0.02.h,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.analytics,
                                  color: ref.watch(lightMode)
                                      ? Colors.blueAccent
                                      : Colors.greenAccent,
                                ),
                              ),
                              Text(
                                "Analysis",
                                style: TextStyle(
                                  letterSpacing: -1,
                                  fontSize: 17.sp.clamp(0, 17),
                                  fontWeight: FontWeight.w600,
                                  color: ref.watch(lightMode)
                                      ? Colors.blueAccent
                                      : Colors.greenAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //the backup and restore container
              Container(
                width: ref.read(deviceSizeX).w,
                height: 40,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: ref.read(deviceSizeX) * 0.06.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: ref.watch(lightMode)
                                  ? Colors.blueAccent
                                  : Colors.greenAccent,
                              foregroundColor: ref.watch(lightMode)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () {},
                            child: Text(
                              "Restore Data",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: ref.watch(deviceSizeX) * 0.06.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: ref.watch(lightMode)
                                  ? Colors.blueAccent
                                  : Colors.greenAccent,
                              foregroundColor: ref.watch(lightMode)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () {},
                            child: Text(
                              "Backup Data",
                              style: TextStyle(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: ref.read(deviceSizeX) * 0.06.w),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ref.read(deviceSizeX) * 0.06.w,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: ref.watch(lightMode)
                            ? Colors.blueAccent
                            : Colors.teal,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ref.watch(deviceSizeX) * 0.06.w,
                        vertical: ref.watch(deviceSizeY) * 0.001.h.clamp(0, 10),
                      ),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: ref.watch(lightMode)
                              ? Colors.black87
                              : Colors.white70,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: ref.watch(lightMode)
                            ? Colors.blueAccent
                            : Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
              // Back to Login
              TextButton(
                onPressed: () {
                  router.go('/splashScreen');
                },

                child: Text(
                  "Back to Dashboard",
                  style: TextStyle(
                    color: ref.read(lightMode)
                        ? Colors.grey[700]
                        : Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: ref.watch(deviceSizeY) * 0.04.h.clamp(0, 15)),

              Column(
                children: [
                  //for my own previous works
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.info_outline, color: Colors.grey[700]),
                        Text(
                          '\tDevOpe built it.Want to Connect?👇',
                          style: TextStyle(
                            color: ref.watch(lightMode)
                                ? Colors.grey[700]
                                : Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: ref.read(deviceSizeX) * 0.65.w.clamp(0.5, 0.75),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ref.watch(lightMode)
                          ? Colors.blueAccent
                          : Colors.greenAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 28, // 85.r.clamp(0, 32),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(),
                          child: SvgPicture.asset(
                            'assets/staticImages/whatsapp.svg',
                          ),
                        ), //for my whatsapp link ; whatsapp logo
                        SizedBox(width: 15),
                        Container(
                          width: 28, //85.r.clamp(0, 30),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(),
                          child: SvgPicture.asset(
                            'assets/staticImages/github.svg',
                          ),
                        ), //for my twitter link ; twitter logo
                        SizedBox(width: 15),
                        Container(
                          width: 28, //85.r.clamp(0, 30),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(),
                          child: SvgPicture.asset(
                            'assets/staticImages/twitter_light.svg',
                          ),
                        ), //for my github link ; github logo
                        SizedBox(width: 15),
                        Container(
                          width: 25, //85.r.clamp(0, 25),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(),
                          child: SvgPicture.asset(
                            'assets/staticImages/gmail_light.svg',
                          ),
                        ), //for my email address ; use email logo
                        SizedBox(width: 15),
                        Container(
                          width: 25, //85.r.clamp(0, 25),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(),
                          child: SvgPicture.asset(
                            'assets/staticImages/share.svg',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: ref.watch(deviceSizeY) * 0.02.h.clamp(0, 8)),
            ],
          ),
          Positioned(
            right: 0,
            child:
                0 ==
                    0 //make this false to make the other part come up
                ? SizedBox()
                : Row(
                    children: [
                      InkWell(
                        onTap: () => router.go('/dashboard'),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: CircleAvatar(
                            backgroundColor: const Color.fromARGB(
                              255,
                              185,
                              56,
                              46,
                            ),

                            child: Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (ref.read(lightMode)) {
                            ref.read(lightMode.notifier).state = false;
                            lookForSettingBox().put('lightMode', false);
                          } else {
                            ref.read(lightMode.notifier).state = true;
                            lookForSettingBox().put('lightMode', true);
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: ref.watch(lightMode)
                              ? Colors.black87
                              : Colors.white70,

                          child: Icon(
                            ref.watch(lightMode)
                                ? Icons.sunny
                                : Icons.nightlight_round_sharp,
                            color: ref.watch(lightMode)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// class Settings extends ConsumerStatefulWidget {
//   const Settings({super.key});

//   @override
//   ConsumerState<Settings> createState() => _SettingsState();
// }

// class _SettingsState extends ConsumerState<Settings> {
//   // Controllers to capture text input
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   // State for password visibility
//   bool _isPasswordHidden = true;

//   @override
//   void dispose() {
//     // Always dispose controllers to prevent memory leaks
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _handleLogin() {
//     final email = _emailController.text;
//     final password = _passwordController.text;

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ref.read(lightMode) ? Colors.grey[100] : Colors.black,
//       appBar: AppBar(
//         toolbarHeight: 0,
//         backgroundColor: ref.read(lightMode) ? Colors.grey[100] : Colors.black,
//       ),
//       body: PopScope(
//         canPop: false,
//         onPopInvokedWithResult: (didPop, result) {
//           if (didPop) return;
//           router.go('/dashboard');
//         },
//         child: Stack(
//           children: [
//             Container(
//               width: ref.watch(deviceSizeX).w,
//               height: ref.watch(deviceSizeY).h,
//               color: ref.watch(lightMode) ? Colors.white : Colors.black,
//               padding: EdgeInsets.symmetric(
//                 horizontal: ref.watch(deviceSizeX) * 0.05.w,
//                 vertical: ref.watch(deviceSizeX) * 0.03.h,
//               ),

//               child: Center(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         child: SingleChildScrollView(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               // App Logo or Icon Placeholder
//                               Icon(
//                                 Icons.lock_person_rounded,
//                                 size: 60,
//                                 color: ref.watch(lightMode)
//                                     ? Colors.blueAccent
//                                     : Color.fromARGB(255, 72, 137, 250),
//                               ),
//                               SizedBox(height: ref.watch(deviceSizeY) * 0.03.h),

//                               // Welcome Text
//                               Text(
//                                 'Welcome Back',
//                                 textAlign: TextAlign.center,

//                                 style: TextStyle(
//                                   letterSpacing: -0.5,
//                                   fontSize: 20.sp.clamp(0, 20),
//                                   fontWeight: FontWeight.bold,
//                                   color: ref.watch(lightMode)
//                                       ? Color.fromARGB(255, 10, 24, 153)
//                                       : Colors.white,
//                                 ),
//                               ),
//                               SizedBox(height: ref.watch(deviceSizeY) * 0.01.h),
//                               Text(
//                                 'Login to keep your data backed up',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 13.sp.clamp(0, 16),
//                                   color: ref.watch(lightMode)
//                                       ? Colors.black54
//                                       : Colors.white54,
//                                 ),
//                               ),
//                               SizedBox(height: ref.watch(deviceSizeY) * 0.06.h),

//                               // Email Input Field
//                               TextField(
//                                 controller: _emailController,
//                                 keyboardType: TextInputType.emailAddress,
//                                 cursorColor: ref.watch(lightMode)
//                                     ? Colors.black
//                                     : Colors.white,
//                                 style: TextStyle(
//                                   color: ref.watch(lightMode)
//                                       ? Colors.black
//                                       : Colors.white,
//                                 ),
//                                 decoration: InputDecoration(
//                                   labelText: 'Username',

//                                   labelStyle: TextStyle(
//                                     color: ref.watch(lightMode)
//                                         ? Colors.black
//                                         : Colors.white,
//                                   ),
//                                   prefixIcon: const Icon(
//                                     Icons.person_2_outlined,
//                                     color: Colors.blueAccent,
//                                   ),

//                                   filled: true,

//                                   fillColor: ref.watch(lightMode)
//                                       ? Colors.white
//                                       : Colors.black,
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(width: 0.8),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       width: 1.2,
//                                       color: ref.watch(lightMode)
//                                           ? Color.fromARGB(255, 61, 34, 107)
//                                           : Colors.white38,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: ref.watch(deviceSizeX) * 0.03.h),

//                               // Password Input Field
//                               TextField(
//                                 controller: _passwordController,
//                                 obscureText: _isPasswordHidden,
//                                 decoration: InputDecoration(
//                                   labelText: 'Password',
//                                   labelStyle: TextStyle(
//                                     color: ref.watch(lightMode)
//                                         ? Colors.black
//                                         : Colors.white,
//                                   ),
//                                   prefixIcon: Icon(
//                                     Icons.lock_outline,
//                                     color: Colors.blueAccent,
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _isPasswordHidden
//                                           ? Icons.visibility_off
//                                           : Icons.visibility,
//                                       color: Colors.blueAccent,
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         _isPasswordHidden = !_isPasswordHidden;
//                                       });
//                                     },
//                                   ),

//                                   filled: true,
//                                   fillColor: ref.watch(lightMode)
//                                       ? Colors.white
//                                       : Colors.black12,

//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(width: 0.8),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                       width: 1.2,
//                                       color: ref.watch(lightMode)
//                                           ? Color.fromARGB(255, 61, 34, 107)
//                                           : Colors.white38,
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                               // Forgot Password Link
//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: TextButton(
//                                   onPressed: () {
//                                     // Action for forgot password
//                                   },
//                                   child: Text(
//                                     'Forgot Password?',

//                                     style: TextStyle(
//                                       fontStyle: FontStyle.italic,
//                                       color: ref.watch(lightMode)
//                                           ? Colors.deepPurple
//                                           : Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: ref.watch(deviceSizeY) * 0.03.h),

//                               // Login Button
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(10),
//                                   ),
//                                   boxShadow: ref.watch(lightMode)
//                                       ? []
//                                       : [
//                                           BoxShadow(
//                                             color: const Color.fromARGB(
//                                               155,
//                                               68,
//                                               137,
//                                               255,
//                                             ),
//                                             offset: Offset(2, 2),
//                                             blurRadius: 5,
//                                           ),

//                                           BoxShadow(
//                                             color: const Color.fromARGB(
//                                               155,
//                                               68,
//                                               137,
//                                               255,
//                                             ),
//                                             offset: Offset(-2, -2),
//                                             blurRadius: 5,
//                                           ),
//                                         ],
//                                 ),
//                                 child: ElevatedButton(
//                                   onPressed: _handleLogin,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: ref.watch(lightMode)
//                                         ? Colors.blueAccent
//                                         : Color.fromARGB(255, 4, 24, 59),
//                                     foregroundColor: Colors.white,
//                                     padding: EdgeInsets.symmetric(
//                                       vertical: ref.watch(deviceSizeY) * 0.03.h,
//                                     ),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     elevation: 2,
//                                   ),
//                                   child: Text(
//                                     'Login',
//                                     style: TextStyle(
//                                       letterSpacing: 3,
//                                       fontSize: 18.sp.clamp(0, 18),
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: ref.watch(deviceSizeY) * 0.03.h),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8.0,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: Divider(color: Colors.blueAccent),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal:
//                                             ref.watch(deviceSizeX) * 0.06.w,
//                                       ),
//                                       child: Text(
//                                         "OR",
//                                         style: TextStyle(
//                                           color: ref.watch(lightMode)
//                                               ? Colors.black87
//                                               : Colors.white70,
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Divider(color: Colors.blueAccent),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // Sign Up Prompt
//                               TextButton(
//                                 onPressed: () {
//                                   router.go('/signup');
//                                 },
//                                 child: Text(
//                                   'Sign Up',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: ref.watch(lightMode)
//                                         ? Colors.deepPurple
//                                         : Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               child: Row(
//                 children: [
//                   InkWell(
//                     onTap: () => router.go('/dashboard'),
//                     child: Container(
//                       margin: EdgeInsets.all(10),
//                       child: CircleAvatar(
//                         backgroundColor: const Color.fromARGB(255, 185, 56, 46),

//                         child: Icon(Icons.close, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       if (ref.read(lightMode)) {
//                         ref.read(lightMode.notifier).state = false;
//                         lookForSettingBox().put('lightMode', false);
//                       } else {
//                         ref.read(lightMode.notifier).state = true;
//                         lookForSettingBox().put('lightMode', true);
//                       }
//                     },
//                     child: CircleAvatar(
//                       backgroundColor: ref.watch(lightMode)
//                           ? Colors.black87
//                           : Colors.white70,

//                       child: Icon(
//                         ref.watch(lightMode)
//                             ? Icons.sunny
//                             : Icons.nightlight_round_sharp,
//                         color: ref.watch(lightMode)
//                             ? Colors.white
//                             : Colors.black,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
