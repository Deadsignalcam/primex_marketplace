#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_logo_bg_redesign_$(date +%Y%m%d_%H%M%S).dart"

python - <<'PY'
from pathlib import Path
import re

p = Path("lib/main.dart")
s = p.read_text(encoding="utf-8")

new_logo = r"""
Widget logo() => SizedBox(
    width: 260,
    height: 82,
    child: CustomPaint(
      painter: PrimeXLogoPainter(),
      child: const SizedBox.expand(),
    ),
  );

"""

s = re.sub(r"Widget logo\(\) => [\s\S]*?\n  Widget navItem", new_logo + "  Widget navItem", s)

# Make all main page boxes use the same futuristic graphic background.
s = s.replace(
"decoration: box(),",
"""decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF02040D),
            Color(0xFF062A68).withOpacity(.82),
            Color(0xFF02040D),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cyan.withOpacity(.9), width: 1.4),
        boxShadow: [
          BoxShadow(color: blue.withOpacity(.35), blurRadius: 32),
          BoxShadow(color: cyan.withOpacity(.15), blurRadius: 45),
        ],
      ),"""
)

# Add custom logo painter before DigitalPainter.
if "class PrimeXLogoPainter" not in s:
    marker = "class DigitalPainter"
    idx = s.find(marker)
    painter = r"""
class PrimeXLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cyan = Color(0xFF00F5FF);
    const blue = Color(0xFF006BFF);
    const purple = Color(0xFF9D4DFF);

    final bg = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF02040D), Color(0xFF061C4F), Color(0xFF02040D)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final frame = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 4, size.width - 4, size.height - 8),
      const Radius.circular(18),
    );

    canvas.drawRRect(frame, bg);

    canvas.drawRRect(
      frame,
      Paint()
        ..color = cyan.withOpacity(.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    canvas.drawRRect(
      frame,
      Paint()
        ..color = cyan.withOpacity(.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 16),
    );

    final chip = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width - 58, 18, 44, 44),
      const Radius.circular(22),
    );
    canvas.drawRRect(chip, Paint()..color = Colors.black.withOpacity(.55));
    canvas.drawRRect(
      chip,
      Paint()
        ..color = cyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );

    final ai = TextPainter(
      text: const TextSpan(
        text: 'AI',
        style: TextStyle(
          color: cyan,
          fontSize: 15,
          fontWeight: FontWeight.w900,
          shadows: [Shadow(color: cyan, blurRadius: 14)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    ai.paint(canvas, Offset(size.width - 46, 31));

    final prime = TextPainter(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'PRIME',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: .5,
            ),
          ),
          TextSpan(
            text: 'X',
            style: TextStyle(
              color: cyan,
              fontSize: 48,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(color: cyan, blurRadius: 18),
                Shadow(color: blue, blurRadius: 34),
                Shadow(color: purple, blurRadius: 24),
              ],
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    prime.paint(canvas, const Offset(14, 8));

    final market = TextPainter(
      text: const TextSpan(
        text: 'MARKETPLACE',
        style: TextStyle(
          color: cyan,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 4.2,
          shadows: [Shadow(color: cyan, blurRadius: 10)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    market.paint(canvas, const Offset(16, 54));

    final tagline = TextPainter(
      text: const TextSpan(
        text: 'BUY • SELL • CONNECT',
        style: TextStyle(
          color: Colors.white,
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tagline.paint(canvas, const Offset(17, 69));

    final linePaint = Paint()
      ..color = cyan.withOpacity(.45)
      ..strokeWidth = 1;

    canvas.drawLine(const Offset(14, 48), Offset(size.width - 72, 48), linePaint);
    canvas.drawLine(Offset(size.width - 72, 21), Offset(size.width - 58, 21), linePaint);
    canvas.drawLine(Offset(size.width - 72, 60), Offset(size.width - 58, 60), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

"""
    if idx != -1:
        s = s[:idx] + painter + s[idx:]

p.write_text(s, encoding="utf-8")
print("✅ PrimeX graphic logo + matching futuristic backgrounds applied.")
PY

flutter clean
flutter pub get
flutter build web --release

echo "✅ Done. Run: flutter run -d chrome"
