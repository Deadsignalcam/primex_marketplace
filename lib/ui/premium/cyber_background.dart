import 'package:flutter/material.dart';

class CyberBackground extends StatefulWidget {
  const CyberBackground({super.key});

  @override
  State<CyberBackground> createState() => _CyberBackgroundState();
}

class _CyberBackgroundState extends State<CyberBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _GridPainter(_controller.value),
          child: Container(),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  final double t;

  _GridPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.08)
      ..strokeWidth = 1;

    const spacing = 40.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i + (t * 20), 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double j = 0; j < size.height; j += spacing) {
      canvas.drawLine(
        Offset(0, j),
        Offset(size.width, j + (t * 20)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
