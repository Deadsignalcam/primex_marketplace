#!/usr/bin/env bash
set -e

echo "🔥 HARD CODING PrimeX homepage — no overlap, bigger PrimeX, better layout"

cp lib/main.dart "lib/main_backup_no_overlap_$(date +%Y%m%d_%H%M%S).dart"

cat > lib/main.dart <<'DART'
import 'package:flutter/material.dart';

void main() => runApp(const PrimeXApp());

class PrimeXApp extends StatelessWidget {
  const PrimeXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrimeX Marketplace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const PrimeXHome(),
    );
  }
}

class PrimeXHome extends StatelessWidget {
  const PrimeXHome({super.key});

  static const bg = Color(0xFF02040D);
  static const blue = Color(0xFF006BFF);
  static const cyan = Color(0xFF00F5FF);
  static const purple = Color(0xFF8A3DFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            navBar(),
            heroSection(),
            featureBar(),
            listingSection(),
          ],
        ),
      ),
    );
  }

  Widget navBar() {
    return Container(
      height: 95,
      padding: const EdgeInsets.symmetric(horizontal: 34),
      color: Colors.black,
      child: Row(
        children: [
          primeLogo(),
          const Spacer(),
          navItem('Home', true),
          navItem('Marketplace', false),
          navItem('How It Works', false),
          navItem('About Us', false),
          navItem('Pricing', false),
          navItem('Contact', false),
          const SizedBox(width: 24),
          outlineButton('Login'),
          const SizedBox(width: 12),
          solidButton('Sign Up'),
        ],
      ),
    );
  }

  Widget primeLogo() {
    return SizedBox(
      width: 330,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'PRIME',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -2,
                  ),
                ),
                TextSpan(
                  text: 'X',
                  style: TextStyle(
                    fontSize: 66,
                    fontWeight: FontWeight.w900,
                    color: cyan,
                    letterSpacing: -6,
                    shadows: [
                      Shadow(color: cyan, blurRadius: 18),
                      Shadow(color: blue, blurRadius: 36),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            'M A R K E T P L A C E',
            style: TextStyle(
              color: cyan,
              fontSize: 12,
              letterSpacing: 7,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'B U Y .  S E L L .  C O N N E C T .',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              letterSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget heroSection() {
    return SizedBox(
      height: 455,
      child: Stack(
        children: [
          Positioned.fill(child: DigitalCityBackground()),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xF502040D),
                    Color(0xAA02040D),
                    Color(0x5502040D),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(36, 55, 36, 30),
            child: Row(
              children: [
                SizedBox(
                  width: 560,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'THE #1 MARKETPLACE FOR',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'FORECLOSURES &',
                        style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900),
                      ),
                      const Text(
                        'REAL ESTATE INVESTMENTS',
                        style: TextStyle(
                          fontSize: 36,
                          color: cyan,
                          fontWeight: FontWeight.w900,
                          shadows: [Shadow(color: cyan, blurRadius: 20)],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'PrimeX Marketplace connects serious buyers and sellers for real estate, foreclosures, services, vehicles, jobs, tools, and business listings.',
                        style: TextStyle(fontSize: 16, color: Colors.white, height: 1.55),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          solidButton('Browse Listings  →'),
                          const SizedBox(width: 16),
                          outlineButton('Post a Listing  +'),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                searchBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(18),
      decoration: glowBox(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Expanded(child: tab('FOR SALE', true)),
            Expanded(child: tab('RENTALS', false)),
            Expanded(child: tab('SERVICES', false)),
          ]),
          const SizedBox(height: 14),
          input('🌐  Region / Country'),
          input('📍  State / Province'),
          input('🗺  County'),
          input('🏙  City'),
          const SizedBox(height: 8),
          fullButton('🔍  Search PrimeX'),
        ],
      ),
    );
  }

  Widget featureBar() {
    final items = [
      ['⌂', 'FORECLOSURES', 'Find investor opportunities.'],
      ['🛡', 'AI SAFETY', 'No dating, nudity, scams, hate, or abuse.'],
      ['🌎', 'GLOBAL', 'Country, state, county, city.'],
      ['💰', 'OFFERS', 'Make offer + proof of funds.'],
    ];

    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(18),
      decoration: glowBox(),
      child: Row(
        children: items.map((i) {
          return Expanded(
            child: Row(
              children: [
                Text(i[0], style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(i[1], style: const TextStyle(color: cyan, fontWeight: FontWeight.bold)),
                      Text(i[2], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget listingSection() {
    final cards = [
      ['FORECLOSURE', 'Single Family Home', 'Johnstown, PA', '89,900'],
      ['PRE-FORECLOSURE', 'Investment Property', 'Bushkill, PA', '74,500'],
      ['BANK OWNED', 'Bank Owned Home', 'Cambria County, PA', '66,000'],
      ['TAX LIEN', 'Tax Lien Certificate', 'Monroe County, PA', '15,000'],
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Text('BROWSE TOP OPPORTUNITIES', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            Spacer(),
            Text('View All Listings  →', style: TextStyle(color: cyan, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 14),
          Row(children: cards.map((c) => Expanded(child: listingCard(c))).toList()),
        ],
      ),
    );
  }

  Widget listingCard(List<String> c) {
    return Container(
      margin: const EdgeInsets.only(right: 14),
      decoration: glowBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 125,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              gradient: LinearGradient(
                colors: [Color(0xFF073B7A), Colors.black],
              ),
            ),
            child: CustomPaint(painter: HousePainter(), child: Container()),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c[1], style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('📍 ${c[2]}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text('${c[3]} dollars', style: const TextStyle(color: cyan, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: ['View', 'Message', 'Call', 'Offer', 'Save'].map((x) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        border: Border.all(color: blue),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(child: Text(x, style: const TextStyle(fontSize: 11))),
                    ),
                  );
                }).toList(),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  static Widget navItem(String text, bool active) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Text(
      text,
      style: TextStyle(
        color: active ? cyan : Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );

  static Widget solidButton(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
    decoration: BoxDecoration(
      color: blue,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [BoxShadow(color: blue.withOpacity(.75), blurRadius: 16)],
    ),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  static Widget outlineButton(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.45),
      border: Border.all(color: blue),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  static Widget tab(String text, bool active) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: active ? blue : Colors.black.withOpacity(.45),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
  );

  static Widget input(String text) => Container(
    margin: const EdgeInsets.only(bottom: 11),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.65),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: cyan.withOpacity(.35)),
    ),
    child: Row(children: [Text(text), const Spacer(), const Text('⌄')]),
  );

  static Widget fullButton(String text) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: blue,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [BoxShadow(color: blue.withOpacity(.85), blurRadius: 16)],
    ),
    child: Center(child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
  );

  static BoxDecoration glowBox() => BoxDecoration(
    color: const Color(0xCC050B18),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: blue.withOpacity(.85)),
    boxShadow: [BoxShadow(color: blue.withOpacity(.32), blurRadius: 18)],
  );
}

class DigitalCityBackground extends StatelessWidget {
  const DigitalCityBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DigitalCityPainter(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF071A4A),
              Colors.black,
            ],
          ),
        ),
      ),
    );
  }
}

class DigitalCityPainter extends CustomPainter {
  static const cyan = Color(0xFF00F5FF);
  static const blue = Color(0xFF006BFF);
  static const purple = Color(0xFF8A3DFF);

  @override
  void paint(Canvas canvas, Size size) {
    final skylineBase = size.height * .90;
    final startX = size.width * .33;
    final endX = size.width;

    final starPaint = Paint()..color = cyan.withOpacity(.65);
    for (int i = 0; i < 100; i++) {
      canvas.drawCircle(
        Offset((i * 83) % size.width, (i * 47) % (size.height * .7)),
        i % 4 == 0 ? 1.5 : .7,
        starPaint,
      );
    }

    final heights = [
      110,180,145,250,210,330,170,295,240,360,200,315,175,285,230,345,190,265,150,310,220,370,180,260
    ];

    final count = heights.length;
    final buildingWidth = (endX - startX) / count;

    for (int i = 0; i < count; i++) {
      final h = heights[i].toDouble();
      final x = startX + i * buildingWidth;
      final top = skylineBase - h;
      final color = i % 2 == 0 ? cyan : purple;

      final glow = Paint()
        ..color = color.withOpacity(.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 12);

      final stroke = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      final fill = Paint()
        ..color = Colors.black.withOpacity(.78)
        ..style = PaintingStyle.fill;

      final rect = Rect.fromLTWH(x + 3, top, buildingWidth - 6, h);
      canvas.drawRect(rect, fill);
      canvas.drawRect(rect, glow);
      canvas.drawRect(rect, stroke);

      final roof = Path()
        ..moveTo(x + buildingWidth * .25, top)
        ..lineTo(x + buildingWidth * .50, top - 26)
        ..lineTo(x + buildingWidth * .75, top)
        ..close();

      canvas.drawPath(roof, fill);
      canvas.drawPath(roof, glow);
      canvas.drawPath(roof, stroke);

      final antenna = Paint()
        ..color = color
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);
      canvas.drawLine(
        Offset(x + buildingWidth / 2, top - 26),
        Offset(x + buildingWidth / 2, top - 70),
        antenna,
      );

      final windowPaint = Paint()..color = color.withOpacity(.85);
      for (double y = top + 22; y < skylineBase - 10; y += 18) {
        canvas.drawRect(
          Rect.fromLTWH(x + 10, y, buildingWidth - 20, 4),
          windowPaint,
        );
      }
    }

    final line = Paint()
      ..color = cyan
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 12);
    canvas.drawLine(Offset(0, skylineBase), Offset(size.width, skylineBase), line);

    final reflection = Paint()..color = blue.withOpacity(.16);
    canvas.drawRect(Rect.fromLTWH(0, skylineBase, size.width, 45), reflection);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HousePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = const Color(0xFF00F5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 7);

    final line = Paint()
      ..color = const Color(0xFF00F5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fill = Paint()
      ..color = Colors.black.withOpacity(.62)
      ..style = PaintingStyle.fill;

    final base = Rect.fromLTWH(size.width * .12, size.height * .50, size.width * .76, size.height * .32);
    final roof = Path()
      ..moveTo(size.width * .08, size.height * .50)
      ..lineTo(size.width * .50, size.height * .20)
      ..lineTo(size.width * .92, size.height * .50)
      ..close();

    canvas.drawRect(base, fill);
    canvas.drawPath(roof, fill);
    canvas.drawRect(base, glow);
    canvas.drawPath(roof, glow);
    canvas.drawRect(base, line);
    canvas.drawPath(roof, line);

    final win = Paint()..color = const Color(0xFFFFD36B);
    for (int i = 0; i < 4; i++) {
      canvas.drawRect(Rect.fromLTWH(size.width * (.22 + i * .15), size.height * .58, 24, 17), win);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
DART

flutter clean
flutter pub get
flutter build web --release

echo "✅ HARD CODE DONE: no overlapping logo, bigger PrimeX, futuristic building painter."
echo "Run: flutter run -d chrome"
