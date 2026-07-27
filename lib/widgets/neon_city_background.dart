import 'dart:math';
import 'package:flutter/material.dart';

class NeonCityBackground extends StatelessWidget {
  const NeonCityBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: NeonCityPainter(),
      size: Size.infinite,
    );
  }
}

class NeonCityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF02040A),
          Color(0xFF071B44),
          Color(0xFF12002B),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      bg,
    );

    final gridPaint = Paint()
      ..color = Colors.cyan.withOpacity(.12)
      ..strokeWidth = 1;

    for (double y = size.height * .55; y < size.height; y += 28.0) {
      canvas.drawLine(
        Offset(220, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    for (double x = 220.0; x < size.width; x += 40.0) {
      canvas.drawLine(
        Offset(x, size.height * .55),
        Offset(x - 120, size.height),
        gridPaint,
      );
    }

    final cityPaint = Paint()..color = const Color(0xFF070B18);

    final glowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18)
      ..color = Colors.cyanAccent.withOpacity(.8);

    final random = Random(7);

    double startX = 280.0;

    while (startX < size.width - 120) {
      final buildingWidth = 45.0 + random.nextInt(35);
      final buildingHeight = 120.0 + random.nextInt(180);

      final rect = Rect.fromLTWH(
        startX,
        size.height * .18,
        buildingWidth,
        buildingHeight,
      );

      canvas.drawRect(rect, cityPaint);

      canvas.drawRect(
        Rect.fromLTWH(
          startX,
          size.height * .18,
          buildingWidth,
          4,
        ),
        Paint()..color = Colors.purpleAccent,
      );

      for (double wy = rect.top + 14; wy < rect.bottom - 10; wy += 16) {
        for (double wx = rect.left + 8; wx < rect.right - 8; wx += 12) {
          canvas.drawRect(
            Rect.fromLTWH(wx, wy, 4, 4),
            Paint()..color = Colors.cyanAccent.withOpacity(.7),
          );
        }
      }

      startX += buildingWidth + 18;
    }

    final lightning = Path();

    lightning.moveTo(size.width * .72, 0);
    lightning.lineTo(size.width * .68, 80);
    lightning.lineTo(size.width * .74, 150);
    lightning.lineTo(size.width * .66, 240);
    lightning.lineTo(size.width * .73, 330);

    canvas.drawPath(
      lightning,
      glowPaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    canvas.drawCircle(
      Offset(size.width * .70, size.height * .18),
      140,
      Paint()
        ..color = Colors.blueAccent.withOpacity(.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
