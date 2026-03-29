import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lecture_tracker/main.dart';
import 'package:lecture_tracker/utils.dart';

//If user have no account yet
class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  // Controllers to capture text input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State for password visibility
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text;
    final password = _passwordController.text;

    print('Attempting login with: $email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ref.read(lightMode) ? Colors.grey[100] : Colors.black,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ref.read(lightMode) ? Colors.grey[100] : Colors.black,
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          router.go('/dashboard');
        },
        child: Stack(
          children: [
            Container(
              width: ref.watch(deviceSizeX).w,
              height: ref.watch(deviceSizeY).h,
              color: ref.watch(lightMode) ? Colors.white : Colors.black,
              padding: EdgeInsets.symmetric(
                horizontal: ref.watch(deviceSizeX) * 0.05.w,
                vertical: ref.watch(deviceSizeX) * 0.03.h,
              ),

              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // App Logo or Icon Placeholder
                              Icon(
                                Icons.lock_person_rounded,
                                size: 60,
                                color: ref.watch(lightMode)
                                    ? Colors.blueAccent
                                    : Color.fromARGB(255, 72, 137, 250),
                              ),
                              SizedBox(height: ref.watch(deviceSizeY) * 0.03.h),

                              // Welcome Text
                              Text(
                                'Welcome Back',
                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  letterSpacing: -0.5,
                                  fontSize: 20.sp.clamp(0, 20),
                                  fontWeight: FontWeight.bold,
                                  color: ref.watch(lightMode)
                                      ? Color.fromARGB(255, 10, 24, 153)
                                      : Colors.white,
                                ),
                              ),
                              SizedBox(height: ref.watch(deviceSizeY) * 0.01.h),
                              Text(
                                'Login to keep your data backed up',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.sp.clamp(0, 16),
                                  color: ref.watch(lightMode)
                                      ? Colors.black54
                                      : Colors.white54,
                                ),
                              ),
                              SizedBox(height: ref.watch(deviceSizeY) * 0.06.h),

                              // Email Input Field
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: ref.watch(lightMode)
                                    ? Colors.black
                                    : Colors.white,
                                style: TextStyle(
                                  color: ref.watch(lightMode)
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Username',

                                  labelStyle: TextStyle(
                                    color: ref.watch(lightMode)
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.person_2_outlined,
                                    color: Colors.blueAccent,
                                  ),

                                  filled: true,

                                  fillColor: ref.watch(lightMode)
                                      ? Colors.white
                                      : Colors.black,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(width: 0.8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      width: 1.2,
                                      color: ref.watch(lightMode)
                                          ? Color.fromARGB(255, 61, 34, 107)
                                          : Colors.white38,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: ref.watch(deviceSizeX) * 0.03.h),

                              // Password Input Field
                              TextField(
                                controller: _passwordController,
                                obscureText: _isPasswordHidden,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: ref.watch(lightMode)
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Colors.blueAccent,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordHidden
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordHidden = !_isPasswordHidden;
                                      });
                                    },
                                  ),

                                  filled: true,
                                  fillColor: ref.watch(lightMode)
                                      ? Colors.white
                                      : Colors.black12,

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(width: 0.8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      width: 1.2,
                                      color: ref.watch(lightMode)
                                          ? Color.fromARGB(255, 61, 34, 107)
                                          : Colors.white38,
                                    ),
                                  ),
                                ),
                              ),

                              // Forgot Password Link
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // Action for forgot password
                                  },
                                  child: Text(
                                    'Forgot Password?',

                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: ref.watch(lightMode)
                                          ? Colors.deepPurple
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: ref.watch(deviceSizeY) * 0.03.h),

                              // Login Button
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  boxShadow: ref.watch(lightMode)
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                              155,
                                              68,
                                              137,
                                              255,
                                            ),
                                            offset: Offset(2, 2),
                                            blurRadius: 5,
                                          ),

                                          BoxShadow(
                                            color: const Color.fromARGB(
                                              155,
                                              68,
                                              137,
                                              255,
                                            ),
                                            offset: Offset(-2, -2),
                                            blurRadius: 5,
                                          ),
                                        ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ref.watch(lightMode)
                                        ? Colors.blueAccent
                                        : Color.fromARGB(255, 4, 24, 59),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: ref.watch(deviceSizeY) * 0.03.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      letterSpacing: 3,
                                      fontSize: 18.sp.clamp(0, 18),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: ref.watch(deviceSizeY) * 0.03.h),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Divider(color: Colors.blueAccent),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            ref.watch(deviceSizeX) * 0.06.w,
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
                                      child: Divider(color: Colors.blueAccent),
                                    ),
                                  ],
                                ),
                              ),
                              // Sign Up Prompt
                              TextButton(
                                onPressed: () {
                                  router.go('/signup');
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ref.watch(lightMode)
                                        ? Colors.deepPurple
                                        : Colors.white,
                                  ),
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
            ),
            Positioned(
              child: Row(
                children: [
                  InkWell(
                    onTap: () => router.go('/dashboard'),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 185, 56, 46),

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
      ),
    );
  }
}

//if user already have account log in
