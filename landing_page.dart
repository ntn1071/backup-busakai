import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  Future<void> requestPermissions(BuildContext context) async {
    // Request required permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.location,
    ].request();

    // Check for denied permissions
    if (statuses.values.any((status) => status.isDenied || status.isPermanentlyDenied)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permissions Required"),
          content: const Text(
            "Some permissions are required for the app to function properly. "
            "Please grant them in your device settings.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> savePermissionStatus() async {
    // Save permission status to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("permissionsGranted", true);
  }

  Future<bool> checkPermissionStatus() async {
    // Check if permissions have already been granted
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("permissionsGranted") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: checkPermissionStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == true) {
            // Permissions already granted, proceed with app content
            return buildLandingContent(context);
          }

          // Show button to request permissions
          return Stack(
            children: [
              // Background image and content
              buildLandingContent(context),
              // Request Permissions Overlay
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await requestPermissions(context);
                    savePermissionStatus();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.blue.shade700,
                  ),
                  child: const Text(
                    "Grant Permissions",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildLandingContent(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/landin_bg.png"), // Your uploaded image
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient Overlay for Glowing Effect
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 11, 46, 123).withOpacity(0.6),
                const Color.fromARGB(255, 25, 83, 130).withOpacity(0.8),
              ],
            ),
          ),
        ),
        // Content
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "BuSakAI\nPasigueño",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 0, 32, 88),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 105, 132, 155).withOpacity(0.5),
                      blurRadius: 60,
                      spreadRadius: 60,
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/bus.png", // Replace with your bus image path
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        // Buttons at the bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            height: 250,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 31, 43, 56),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80),
                topRight: Radius.circular(80),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  text: "Log In",
                  backgroundColor: Colors.blue.shade700,
                  textColor: Colors.white,
                ),
                const SizedBox(height: 25),
                AnimatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  text: "Sign Up",
                  backgroundColor: Colors.lightBlue.shade200,
                  textColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// AnimatedButton class remains the same as before

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const AnimatedButton({
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    super.key,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _scale = 0.95; // Button scales down when pressed
        });
      },
      onTapUp: (_) {
        setState(() {
          _scale = 1.0; // Button scales back to normal
        });
      },
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_scale),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            backgroundColor: widget.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadowColor: Colors.black.withOpacity(0.4),
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            style: TextStyle(fontSize: 18, color: widget.textColor),
          ),
        ),
      ),
    );
  }
}
