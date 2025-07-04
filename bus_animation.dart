import 'package:flutter/material.dart';

class BusAnimation extends StatefulWidget {
  const BusAnimation({super.key});

  @override
  _BusAnimationState createState() => _BusAnimationState();
}

class _BusAnimationState extends State<BusAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -200.0, end: 600.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
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
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: _animation.value,
                top: MediaQuery.of(context).size.height / 2 - 30, // Adjust to center the bus vertically
                child: child!,
              );
            },
            child: Image.asset(
              'assets/bus.png', // Use the bus image from the assets folder
              width: 300,
              height: 300,
            ),
          ),
          // Optionally, add a trail of smoke or wind
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: _animation.value - 50, // Position the trail slightly behind the bus
                top: MediaQuery.of(context).size.height / 2 + 10,
                child: child!,
              );
            },
            child: CustomPaint(
              size: const Size(100, 100),
              painter: SmokePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class SmokePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Draw smoke trail with circles or any custom shape
    for (int i = 0; i < 10; i++) {
      double offset = (i * 10).toDouble();
      canvas.drawCircle(
        Offset(size.width / 2 - offset, size.height / 2),
        5.0 + (i * 0.3), // Decreasing size with each step
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
