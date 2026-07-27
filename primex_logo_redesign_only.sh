#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_logo_redesign_only_$(date +%Y%m%d_%H%M%S).dart"

perl -0777 -i -pe 's/class PrimeXLogoPainter extends CustomPainter \{.*?\n\}\n\nclass DigitalPainter/class PrimeXLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cyan = Color(0xFF00F5FF);
    const blue = Color(0xFF006BFF);
    const purple = Color(0xFF9D4DFF);

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 6, size.width - 6, size.height - 12),
      const Radius.circular(24),
    );

    canvas.drawRRect(bgRect, Paint()..shader = const LinearGradient(
      colors: [Color(0xFF01030A), Color(0xFF061A4D), Color(0xFF02040D)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

    canvas.drawRRect(bgRect, Paint()
      ..color = cyan.withOpacity(.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6);

    canvas.drawRRect(bgRect, Paint()
      ..color = blue.withOpacity(.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 18));

    final prime = TextPainter(
      text: const TextSpan(children: [
        TextSpan(text: "PRIME", style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          shadows: [Shadow(color: Colors.white, blurRadius: 8)],
        )),
        TextSpan(text: "X", style: TextStyle(
          color: cyan,
          fontSize: 45,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(color: cyan, blurRadius: 18),
            Shadow(color: blue, blurRadius: 34),
            Shadow(color: purple, blurRadius: 24),
          ],
        )),
      ]),
      textDirection: TextDirection.ltr,
    )..layout();

    prime.paint(canvas, const Offset(18, 13));

    final marketplace = TextPainter(
      text: const TextSpan(text: "M A R K E T P L A C E", style: TextStyle(
        color: cyan,
        fontSize: 9.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 4.1,
        shadows: [Shadow(color: cyan, blurRadius: 10)],
      )),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width - 55);

    marketplace.paint(canvas, const Offset(20, 55));

    final tagline = TextPainter(
      text: const TextSpan(text: "BUY • SELL • CONNECT", style: TextStyle(
        color: Colors.white,
        fontSize: 8.5,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.2,
        shadows: [Shadow(color: Colors.white, blurRadius: 7)],
      )),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width - 55);

    tagline.paint(canvas, const Offset(21, 68));

    final aiBox = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width - 54, 26, 40, 34),
      const Radius.circular(14),
    );

    canvas.drawRRect(aiBox, Paint()..color = Colors.black.withOpacity(.48));
    canvas.drawRRect(aiBox, Paint()
      ..color = cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2);

    final ai = TextPainter(
      text: const TextSpan(text: "AI", style: TextStyle(
        color: cyan,
        fontSize: 14,
        fontWeight: FontWeight.w900,
        shadows: [Shadow(color: cyan, blurRadius: 12)],
      )),
      textDirection: TextDirection.ltr,
    )..layout();

    ai.paint(canvas, Offset(size.width - 43, 34));

    final linePaint = Paint()
      ..color = cyan.withOpacity(.45)
      ..strokeWidth = 1;

    canvas.drawLine(const Offset(18, 50), Offset(size.width - 66, 50), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DigitalPainter/s' lib/main.dart

flutter clean
flutter pub get
flutter build web --release

echo "✅ PrimeX logo redesigned. Run: flutter run -d chrome"
