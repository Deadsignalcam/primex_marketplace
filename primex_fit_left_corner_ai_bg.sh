#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_left_corner_ai_bg_$(date +%Y%m%d_%H%M%S).dart"

python - <<'PY'
from pathlib import Path

p = Path("lib/main.dart")
s = p.read_text(encoding="utf-8")

start = s.find("Widget logo()")
end = s.find("Widget navItem(")

if start == -1 or end == -1:
    raise SystemExit("Could not find logo/navItem in lib/main.dart")

new_logo = r"""
Widget logo() => SizedBox(
    width: 245,
    height: 78,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          top: 2,
          child: Text.rich(
            const TextSpan(children: [
              TextSpan(
                text: 'PRIME',
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              TextSpan(
                text: 'X',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: cyan,
                  shadows: [
                    Shadow(color: cyan, blurRadius: 18),
                    Shadow(color: blue, blurRadius: 32),
                  ],
                ),
              ),
            ]),
          ),
        ),
        Positioned(
          left: 2,
          top: 48,
          child: Text(
            'M A R K E T P L A C E',
            style: TextStyle(
              color: cyan,
              fontSize: 9,
              letterSpacing: 4.5,
              fontWeight: FontWeight.w700,
              shadows: [Shadow(color: cyan, blurRadius: 12)],
            ),
          ),
        ),
        Positioned(
          left: 2,
          top: 63,
          child: Text(
            'BUY • SELL • CONNECT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8.5,
              letterSpacing: 2.2,
              fontWeight: FontWeight.w800,
              shadows: [Shadow(color: Colors.white, blurRadius: 8)],
            ),
          ),
        ),
        Positioned(
          left: 190,
          top: 20,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: cyan, width: 1.2),
              boxShadow: [
                BoxShadow(color: cyan.withOpacity(.55), blurRadius: 20),
                BoxShadow(color: blue.withOpacity(.45), blurRadius: 35),
              ],
            ),
            child: const Center(
              child: Text(
                'AI',
                style: TextStyle(
                  color: cyan,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  """

s = s[:start] + new_logo + s[end:]

# Make nav a little taller but keep no overflow
s = s.replace("height: 84,", "height: 90,")
s = s.replace("height: 82,", "height: 90,")

# Hard replace pageBox with futuristic AI background if found
start = s.find("Widget pageBox(")
end = s.find("Widget dashTile(")

if start != -1 and end != -1:
    new_pagebox = r"""
Widget pageBox(String title, Widget child) => Padding(
    padding: const EdgeInsets.all(28),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF02040D),
            const Color(0xFF061C4F).withOpacity(.95),
            const Color(0xFF02040D),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cyan.withOpacity(.9), width: 1.4),
        boxShadow: [
          BoxShadow(color: blue.withOpacity(.38), blurRadius: 34),
          BoxShadow(color: cyan.withOpacity(.16), blurRadius: 48),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: AiFuturePainter())),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: cyan,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  shadows: [Shadow(color: cyan, blurRadius: 18)],
                ),
              ),
              const SizedBox(height: 18),
              child,
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.55),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cyan.withOpacity(.45)),
                ),
                child: const Text(
                  'Philippians 4:13 — I can do all things through Christ who strengthens me.  •  Powered by Syntax Phantom @ 2026',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: .8),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  """
    s = s[:start] + new_pagebox + s[end:]

# Add AiFuturePainter before MapPainter
if "class AiFuturePainter" not in s:
    marker = "class MapPainter"
    idx = s.find(marker)
    if idx != -1:
        ai_painter = r"""
class AiFuturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cyanPaint = Paint()
      ..color = const Color(0xFF00F5FF).withOpacity(.12)
      ..strokeWidth = 1;

    final glowPaint = Paint()
      ..color = const Color(0xFF006BFF).withOpacity(.10)
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += 90) {
      canvas.drawLine(Offset(x, 0), Offset(x + 80, size.height), cyanPaint);
    }

    for (double y = 20; y < size.height; y += 70) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 30), cyanPaint);
    }

    for (int i = 0; i < 18; i++) {
      final dx = (i * 137) % size.width;
      final dy = (i * 71) % size.height;
      canvas.drawCircle(Offset(dx.toDouble(), dy.toDouble()), 42, glowPaint);
      canvas.drawCircle(
        Offset(dx.toDouble(), dy.toDouble()),
        4,
        Paint()..color = const Color(0xFF00F5FF).withOpacity(.45),
      );
    }

    final tp = TextPainter(
      text: TextSpan(
        text: 'PRIMEX AI ASSISTANT  •  SECURITY SHIELD  •  MARKETPLACE INTELLIGENCE',
        style: TextStyle(
          color: const Color(0xFF00F5FF).withOpacity(.16),
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    tp.paint(canvas, Offset(30, size.height - 54));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

"""
        s = s[:idx] + ai_painter + s[idx:]

p.write_text(s, encoding="utf-8")
print("✅ PrimeX left corner redesigned and AI future background added.")
PY

flutter clean
flutter pub get
flutter build web --release

echo "✅ Done. Run: flutter run -d chrome"
