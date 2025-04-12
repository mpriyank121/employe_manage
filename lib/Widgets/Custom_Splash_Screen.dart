import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _spartansController;

  late Animation<Offset> _logoSlide;
  late Animation<double> _logoFade;
  late Animation<Offset> _spartansSlide;
  late Animation<double> _spartansFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _spartansController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _spartansSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _spartansController, curve: Curves.easeOut));

    _spartansFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _spartansController, curve: Curves.easeIn),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    await _spartansController.forward();

    await Future.delayed(const Duration(seconds: 2));

    // Reverse animation before navigating
    await Future.wait([
      _logoController.reverse(),
      _spartansController.reverse(),
    ]);

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Get.offAllNamed(isLoggedIn ? '/home' : '/login');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _spartansController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _logoFade,
              child: SlideTransition(
                position: _logoSlide,
                child: Image.asset(
                  'assets/images/app_logo.png',
                  height: 160,
                ),
              ),
            ),
            FadeTransition(
              opacity: _spartansFade,
              child: SlideTransition(
                position: _spartansSlide,
                child: Image.asset(
                  'assets/images/spartans.png',
                  height: 80,
                  width: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
