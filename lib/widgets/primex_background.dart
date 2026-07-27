import 'dart:math';
import 'package:flutter/material.dart';

class PrimeXBackground extends StatefulWidget {
  final Widget child;

  const PrimeXBackground({
    super.key,
    required this.child,
  });

  @override
  State<PrimeXBackground> createState() => _PrimeXBackgroundState();
}

class _PrimeXBackgroundState extends State<PrimeXBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: [
            // MAIN DARK BACKGROUND
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF020412),
                    Color(0xFF071B44),
                    Color(0xFF020412),
                  ],
                ),
              ),
            ),

            // GLOWING ORBS
            Positioned(
              top: 100 + sin(controller.value * 6.28) * 20,
              left: 80,
              child: _glowCircle(
                size: 180,
                color: Colors.cyan.withOpacity(.15),
              ),
            ),

            Positioned(
              bottom: 60,
              right: 120,
              child: _glowCircle(
                size: 220,
                color: Colors.blue.withOpacity(.12),
              ),
            ),

            Positioned(
              top: 250,
              right: 40,
              child: _glowCircle(
                size: 140,
                color: Colors.purple.withOpacity(.10),
              ),
            ),

            // GRID
            CustomPaint(
              size: Size.infinite,
              painter: GridPainter(),
            ),

            // CYBER LINES
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: .18,
                  child: Image.network(
                    'https://i.imgur.com/8w0MZsm.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            widget.child,
          ],
        );
      },
    );
  }

  Widget _glowCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 120,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withOpacity(.05)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
