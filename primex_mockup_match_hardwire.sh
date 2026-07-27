#!/usr/bin/env bash
set -e

echo "🔥 PrimeX mockup match hard-wire..."

cp -r lib "lib_backup_mockup_match_$(date +%Y%m%d_%H%M%S)"

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
  static const panel = Color(0xCC050B18);
  static const blue = Color(0xFF006BFF);
  static const cyan = Color(0xFF00F5FF);
  static const purple = Color(0xFF9D4DFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            nav(),
            hero(),
            featureStrip(),
            listings(),
            footer(),
          ],
        ),
      ),
    );
  }

  Widget nav() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(color: Colors.black),
      child: Row(
        children: [
          logo(30),
          const Spacer(),
          navText('Home', true),
          navText('Marketplace', false),
          navText('How It Works', false),
          navText('About Us', false),
          navText('Pricing', false),
          navText('Contact', false),
          const SizedBox(width: 28),
          outlineBtn('Login'),
          const SizedBox(width: 14),
          solidBtn('Sign Up'),
        ],
      ),
    );
  }

  Widget hero() {
    return SizedBox(
      height: 430,
      child: Stack(
        children: [
          Positioned.fill(child: neonSkyline()),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xEE02040D),
                    Color(0x9902040D),
                    Color(0x6602040D),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(34, 40, 34, 26),
            child: Row(
              children: [
                SizedBox(
                  width: 560,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'THE #1 MARKETPLACE FOR',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'FORECLOSURES &',
                        style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900),
                      ),
                      const Text(
                        'REAL ESTATE INVESTMENTS',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: cyan,
                          shadows: [Shadow(color: cyan, blurRadius: 18)],
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'PrimeX Marketplace connects serious buyers and sellers for real estate, foreclosures, services, vehicles, jobs, tools, and business listings.',
                        style: TextStyle(fontSize: 15, height: 1.6, color: Colors.white70),
                      ),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          solidBtn('Browse Listings  →'),
                          const SizedBox(width: 14),
                          outlineBtn('Post a Listing  +'),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                searchPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget neonSkyline() {
    final heights = [
      90, 160, 115, 210, 140, 270, 180, 320, 150, 250, 190, 350,
      210, 300, 170, 280, 130, 235, 180, 330, 145, 260, 115, 220
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color(0xFF061A55), Colors.black],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: StarGridPainter(),
            ),
          ),
          Positioned(
            left: 260,
            right: 120,
            bottom: 70,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(heights.length, (i) {
                final h = heights[i].toDouble();
                final glow = i % 3 == 0 ? purple : cyan;
                return Expanded(
                  child: Container(
                    height: h,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.85),
                      border: Border.all(color: glow.withOpacity(.9), width: 1),
                      boxShadow: [
                        BoxShadow(color: glow.withOpacity(.55), blurRadius: 16),
                      ],
                    ),
                    child: Column(
                      children: List.generate(
                        12,
                        (x) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          height: 4,
                          color: x.isEven ? glow.withOpacity(.85) : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 60,
            child: Container(
              height: 2,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(color: cyan, blurRadius: 18, spreadRadius: 3),
                ],
                color: cyan,
              ),
            ),
          ),
          Positioned(
            left: 220,
            right: 100,
            bottom: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    cyan.withOpacity(.25),
                    purple.withOpacity(.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchPanel() {
    return Container(
      width: 360,
      padding: const EdgeInsets.all(18),
      decoration: glowBox(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: tab('FOR SALE', true)),
              Expanded(child: tab('RENTALS', false)),
              Expanded(child: tab('SERVICES', false)),
            ],
          ),
          const SizedBox(height: 14),
          input('🌐  Region / Country'),
          input('📍  State / Province'),
          input('🗺️  County'),
          input('🏙️  City'),
          const SizedBox(height: 6),
          fullButton('🔍  Search PrimeX'),
        ],
      ),
    );
  }

  Widget featureStrip() {
    final items = [
      ['⌂', 'FORECLOSURES', 'Find investor opportunities.'],
      ['🛡', 'AI SAFETY', 'No dating, nudity, scams, hate, or abuse.'],
      ['🌎', 'GLOBAL', 'Country, state, county, city.'],
      ['💰', 'OFFERS', 'Make offer + proof of funds.'],
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(22, 18, 22, 12),
      padding: const EdgeInsets.all(18),
      decoration: glowBox(),
      child: Row(
        children: items.map((i) {
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: cyan),
                    boxShadow: [BoxShadow(color: cyan.withOpacity(.55), blurRadius: 18)],
                  ),
                  child: Center(child: Text(i[0], style: const TextStyle(fontSize: 26))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(i[1], style: const TextStyle(color: cyan, fontWeight: FontWeight.w900)),
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

  Widget listings() {
    final items = [
      ['FORECLOSURE', 'Single Family Home', 'Johnstown, PA', '89,900'],
      ['PRE-FORECLOSURE', 'Investment Property', 'Bushkill, PA', '74,500'],
      ['BANK OWNED', 'Bank Owned Home', 'Cambria County, PA', '66,000'],
      ['TAX LIEN', 'Tax Lien Certificate', 'Monroe County, PA', '15,000'],
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(22, 0, 22, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('BROWSE TOP OPPORTUNITIES', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              Spacer(),
              Text('View All Listings  →', style: TextStyle(color: cyan, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: items.map((e) => Expanded(child: listingCard(e))).toList(),
          ),
        ],
      ),
    );
  }

  Widget listingCard(List<String> data) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: glowBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          propertyImage(data[0]),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.black.withOpacity(.45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data[1], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('📍 ${data[2]}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 8),
                Text(
                  '${data[3]} dollars',
                  style: const TextStyle(color: cyan, fontWeight: FontWeight.w900, fontSize: 18),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    smallBtn('View'),
                    smallBtn('Message'),
                    smallBtn('Call'),
                    smallBtn('Offer'),
                    smallBtn('Save'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget propertyImage(String label) {
    return SizedBox(
      height: 122,
      child: Stack(
        children: [
          Positioned.fill(child: neonHouseArt()),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(7)),
              child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget neonHouseArt() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF062A6E), Colors.black],
        ),
      ),
      child: CustomPaint(
        painter: HousePainter(),
        child: Container(),
      ),
    );
  }

  Widget footer() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.black,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(child: Text('PRIMEX MARKETPLACE\n\nBuy • Sell • Connect')),
              Expanded(child: Text('QUICK LINKS\n\nHome\nMarketplace\nHow It Works\nAbout Us\nContact')),
              Expanded(child: Text('FEATURES\n\nListings\nMessages\nCalls\nOffers\nProof of Funds')),
              Expanded(child: Text('CONTACT\n\nsyntax.phantom@primexmarketplace.com\nprimexmarketplace.com\nPA')),
            ],
          ),
          const Divider(height: 28),
          const Text(
            'POWERED BY  SYNTAX PHANTOM  @ 2026',
            style: TextStyle(color: cyan, letterSpacing: 2, fontSize: 12),
          ),
        ],
      ),
    );
  }

  static Widget logo(double size) => Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'PRIME', style: TextStyle(fontSize: size, fontWeight: FontWeight.w900)),
            TextSpan(
              text: 'X',
              style: TextStyle(
                fontSize: size + 20,
                fontWeight: FontWeight.w900,
                color: cyan,
                shadows: const [
                  Shadow(color: cyan, blurRadius: 18),
                  Shadow(color: blue, blurRadius: 28),
                ],
              ),
            ),
            TextSpan(text: '\nM A R K E T P L A C E', style: TextStyle(fontSize: size / 2.8, letterSpacing: 4)),
          ],
        ),
      );

  static Widget navText(String t, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(t, style: TextStyle(color: active ? cyan : Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          if (active)
            Container(
              margin: const EdgeInsets.only(top: 6),
              height: 2,
              width: 36,
              color: cyan,
            ),
        ],
      ),
    );
  }

  static Widget solidBtn(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: blue,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [BoxShadow(color: blue.withOpacity(.9), blurRadius: 14)],
        ),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      );

  static Widget outlineBtn(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.25),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: blue),
        ),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      );

  static Widget fullButton(String t) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8), boxShadow: [
          BoxShadow(color: blue.withOpacity(.85), blurRadius: 14),
        ]),
        child: Center(child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))),
      );

  static Widget tab(String t, bool active) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: active ? blue : Colors.black.withOpacity(.35), borderRadius: BorderRadius.circular(7)),
        child: Center(child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
      );

  static Widget input(String t) => Container(
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.65),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: cyan.withOpacity(.3)),
        ),
        child: Row(
          children: [
            Text(t, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const Spacer(),
            const Text('⌄'),
          ],
        ),
      );

  static Widget smallBtn(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.4),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: blue.withOpacity(.7)),
        ),
        child: Text(t, style: const TextStyle(fontSize: 11)),
      );

  static BoxDecoration glowBox() => BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: blue.withOpacity(.75)),
        boxShadow: [
          BoxShadow(color: blue.withOpacity(.25), blurRadius: 16),
        ],
      );
}

class StarGridPainter extends CustomPainter {
  const StarGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final star = Paint()..color = const Color(0x9900F5FF);
    final line = Paint()
      ..color = const Color(0x33006BFF)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x + 120, size.height), line);
    }

    for (int i = 0; i < 80; i++) {
      final dx = (i * 73) % size.width;
      final dy = (i * 41) % size.height;
      canvas.drawCircle(Offset(dx.toDouble(), dy.toDouble()), i % 3 == 0 ? 1.6 : .8, star);
    }
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
      ..strokeWidth = 2;

    final fill = Paint()
      ..color = Colors.black.withOpacity(.55)
      ..style = PaintingStyle.fill;

    final base = Rect.fromLTWH(size.width * .14, size.height * .45, size.width * .72, size.height * .35);
    canvas.drawRect(base, fill);
    canvas.drawRect(base, glow);

    final roof = Path()
      ..moveTo(size.width * .1, size.height * .45)
      ..lineTo(size.width * .5, size.height * .18)
      ..lineTo(size.width * .9, size.height * .45)
      ..close();
    canvas.drawPath(roof, fill);
    canvas.drawPath(roof, glow);

    for (int i = 0; i < 4; i++) {
      final x = size.width * (.24 + i * .14);
      final r = Rect.fromLTWH(x, size.height * .53, 28, 18);
      canvas.drawRect(r, Paint()..color = const Color(0xFFFFD36B).withOpacity(.85));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
DART

flutter clean
flutter pub get
flutter build web --release

echo "🔥 PrimeX now hard-wired to match the digital neon mockup closer."
echo "Run: flutter run -d chrome"
