import 'package:flutter/material.dart';

class NeonMoneyChart extends StatelessWidget {
  const NeonMoneyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff050b1a),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.cyanAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(.55),
            blurRadius: 35,
            spreadRadius: 4,
          ),
        ],
      ),
      child: CustomPaint(
        painter: NeonMoneyPainter(),
        child: const Center(
          child: Text(
            'MONEY FLOW • BOOSTS • ADS • LEADS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(color: Colors.cyanAccent, blurRadius: 20),
                Shadow(color: Colors.blueAccent, blurRadius: 45),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NeonMoneyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(10, size.height * .72),
      Offset(size.width * .22, size.height * .58),
      Offset(size.width * .42, size.height * .62),
      Offset(size.width * .62, size.height * .38),
      Offset(size.width * .82, size.height * .28),
      Offset(size.width - 10, size.height * .18),
    ];

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    for (final blur in [42.0, 28.0, 16.0]) {
      final glow = Paint()
        ..color = Colors.cyanAccent.withOpacity(.35)
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
      canvas.drawPath(path, glow);
    }

    final core = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, core);

    final grid = Paint()
      ..color = Colors.cyanAccent.withOpacity(.14)
      ..strokeWidth = 1;

    for (int i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
