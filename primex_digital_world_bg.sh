#!/usr/bin/env bash
set -e

echo "🔥 PrimeX digital marketplace background hard-code..."

cp lib/main.dart "lib/main_backup_digital_world_$(date +%Y%m%d_%H%M%S).dart"

python - <<'PY'
from pathlib import Path
p = Path("lib/main.dart")
s = p.read_text()

# Replace image background / block background calls with a real digital coded background
s = s.replace("Positioned.fill(child: DigitalCityBackground()),", "Positioned.fill(child: PrimeXDigitalWorldBackground()),")

# If old image asset background exists, replace it too
import re
s = re.sub(
r"Positioned\.fill\(\s*child:\s*Image\.asset\([\s\S]*?\),\s*\),",
"Positioned.fill(child: PrimeXDigitalWorldBackground()),",
s
)

# Remove yellow caution stripe artifacts if any
s = s.replace("Color(0xFFFFD36B)", "Color(0xFF00F5FF)")
s = s.replace("Colors.yellow", "PrimeXHome.cyan")

extra = r'''

class PrimeXDigitalWorldBackground extends StatelessWidget {
  const PrimeXDigitalWorldBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PrimeXDigitalWorldPainter(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.1,
            colors: [
              Color(0xFF092B7A),
              Color(0xFF020617),
              Colors.black,
            ],
          ),
        ),
      ),
    );
  }
}

class PrimeXDigitalWorldPainter extends CustomPainter {
  static const cyan = Color(0xFF00F5FF);
  static const blue = Color(0xFF006BFF);
  static const purple = Color(0xFF9D4DFF);

  @override
  void paint(Canvas canvas, Size size) {
    final star = Paint()..color = cyan.withOpacity(.55);
    final line = Paint()
      ..color = blue.withOpacity(.25)
      ..strokeWidth = 1;

    // digital world map network dots/lines
    final points = <Offset>[
      Offset(size.width * .38, size.height * .18),
      Offset(size.width * .46, size.height * .26),
      Offset(size.width * .55, size.height * .18),
      Offset(size.width * .62, size.height * .30),
      Offset(size.width * .70, size.height * .20),
      Offset(size.width * .76, size.height * .36),
      Offset(size.width * .50, size.height * .38),
    ];

    for (final a in points) {
      for (final b in points) {
        if ((a - b).distance < size.width * .28) {
          canvas.drawLine(a, b, line);
        }
      }
      canvas.drawCircle(a, 5, Paint()..color = cyan.withOpacity(.9));
      canvas.drawCircle(
        a,
        16,
        Paint()
          ..color = cyan.withOpacity(.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }

    // stars
    for (int i = 0; i < 140; i++) {
      canvas.drawCircle(
        Offset(((i * 79) % size.width).toDouble(), ((i * 43) % (size.height * .75)).toDouble()),
        i % 5 == 0 ? 1.8 : .8,
        star,
      );
    }

    // skyline
    final base = size.height * .88;
    final startX = size.width * .28;
    final endX = size.width * .78;
    final heights = [80,140,105,210,150,280,190,330,145,260,210,360,180,300,130,250,190,340,150,270];

    final bw = (endX - startX) / heights.length;

    for (int i = 0; i < heights.length; i++) {
      final h = heights[i].toDouble();
      final x = startX + i * bw;
      final top = base - h;
      final c = i % 2 == 0 ? cyan : purple;

      final fill = Paint()..color = Colors.black.withOpacity(.75);
      final stroke = Paint()
        ..color = c
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      final glow = Paint()
        ..color = c.withOpacity(.8)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 12);

      final rect = Rect.fromLTWH(x + 3, top, bw - 6, h);
      canvas.drawRect(rect, fill);
      canvas.drawRect(rect, glow);
      canvas.drawRect(rect, stroke);

      // roof / antenna
      canvas.drawLine(Offset(x + bw / 2, top), Offset(x + bw / 2, top - 42), stroke);
      canvas.drawCircle(Offset(x + bw / 2, top - 45), 3, Paint()..color = c);

      // windows
      final window = Paint()..color = c.withOpacity(.85);
      for (double y = top + 20; y < base - 8; y += 17) {
        canvas.drawRect(Rect.fromLTWH(x + 10, y, bw - 20, 3.5), window);
      }
    }

    // bottom reflection line
    canvas.drawLine(
      Offset(0, base),
      Offset(size.width, base),
      Paint()
        ..color = cyan
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 14),
    );

    // category floating cards
    void card(String title, String sub, Offset o, IconData icon) {
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(o.dx, o.dy, 190, 58),
        const Radius.circular(12),
      );
      canvas.drawRRect(r, Paint()..color = Colors.black.withOpacity(.55));
      canvas.drawRRect(
        r,
        Paint()
          ..color = cyan.withOpacity(.85)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: '$title\n',
          style: const TextStyle(color: cyan, fontSize: 13, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: sub,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.normal),
            )
          ],
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 150);
      tp.paint(canvas, o + const Offset(14, 10));
    }

    card('REAL ESTATE', 'Buy • Sell • Invest', Offset(size.width * .22, size.height * .28), Icons.home);
    card('VEHICLES', 'Cars • Trucks • RVs', Offset(size.width * .70, size.height * .25), Icons.directions_car);
    card('SERVICES', 'Local professionals', Offset(size.width * .72, size.height * .40), Icons.handyman);
    card('JOBS', 'Find or post jobs', Offset(size.width * .70, size.height * .55), Icons.work);
    card('TOOLS', 'Equipment & supplies', Offset(size.width * .24, size.height * .50), Icons.construction);

    // glowing center X
    final xp = TextPainter(
      text: TextSpan(
        text: 'X',
        style: TextStyle(
          color: cyan.withOpacity(.55),
          fontSize: 90,
          fontWeight: FontWeight.w900,
          shadows: const [
            Shadow(color: cyan, blurRadius: 30),
            Shadow(color: blue, blurRadius: 50),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    xp.paint(canvas, Offset(size.width * .50, size.height * .66));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
'''

# remove old duplicate class if it exists? leave okay; add only if missing
if "class PrimeXDigitalWorldBackground" not in s:
    s += extra

p.write_text(s)
PY

flutter clean
flutter pub get
flutter build web --release

echo "✅ Digital PrimeX background added with world network, city, real estate, vehicles, services, jobs, tools."
echo "Run: flutter run -d chrome"
