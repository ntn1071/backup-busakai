import 'package:flutter/material.dart';
import 'package:busakai/screens/landing_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller before accessing the MediaQuery
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Use the post-frame callback to access MediaQuery safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animation = Tween<double>(
        begin: -100,
        end: ((MediaQuery.of(context).size.height)/2) -30,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ),
      );

      // Start the animation
      _controller.forward();

      // Transition to the landing page after the animation ends
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LandingPage()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated bus moving from bottom to top
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: MediaQuery.of(context).size.width / 2 - 120,  // Center the bus horizontally
                bottom: _animation.value,
                child: child!,
              );
            },
            child: Image.asset(
              'assets/bus.png',  // Bus image from the assets folder
              width: 250,  // Increase the size of the bus
              height: 150, // Increase the size of the bus
            ),
          ),
          // Title at the bottom of the screen
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'BuSakAI Pasigueño',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
