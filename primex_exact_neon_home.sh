#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_exact_neon_$(date +%Y%m%d_%H%M%S).dart"

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
  static const panel = Color(0xDD050B18);
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
            features(),
            listings(),
          ],
        ),
      ),
    );
  }

  Widget nav() => Container(
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        color: Colors.black,
        child: Row(
          children: [
            bigLogo(),
            const Spacer(),
            navItem('Home', true),
            navItem('Marketplace', false),
            navItem('How It Works', false),
            navItem('About Us', false),
            navItem('Pricing', false),
            navItem('Contact', false),
            const SizedBox(width: 32),
            outlineButton('Login'),
            const SizedBox(width: 14),
            solidButton('Sign Up'),
          ],
        ),
      );

  Widget hero() => SizedBox(
        height: 455,
        child: Stack(
          children: [
            Positioned.fill(child: cyberCity()),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xF202040D), Color(0x9902040D), Color(0x4402040D)],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(44, 28, 44, 28),
              child: Row(
                children: [
                  SizedBox(
                    width: 520,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        largeHeroLogo(),
                        const SizedBox(height: 24),
                        const Text('THE #1 MARKETPLACE FOR',
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        const Text('FORECLOSURES &',
                            style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900)),
                        const Text(
                          'REAL ESTATE INVESTMENTS',
                          style: TextStyle(
                            fontSize: 32,
                            color: cyan,
                            fontWeight: FontWeight.w900,
                            shadows: [Shadow(color: cyan, blurRadius: 18)],
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'PrimeX Marketplace connects serious buyers and sellers for real estate, foreclosures, services, vehicles, jobs, tools, and business listings.',
                          style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.55),
                        ),
                        const SizedBox(height: 26),
                        Row(children: [
                          solidButton('Browse Listings  →'),
                          const SizedBox(width: 16),
                          outlineButton('Post a Listing  +'),
                        ]),
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

  Widget bigLogo() => SizedBox(
        width: 250,
        child: CustomPaint(
          painter: PrimeXLogoPainter(),
          child: const SizedBox(height: 70),
        ),
      );

  Widget largeHeroLogo() => SizedBox(
        width: 430,
        child: CustomPaint(
          painter: PrimeXLogoPainter(large: true),
          child: const SizedBox(height: 120),
        ),
      );

  Widget cyberCity() {
    final heights = [150,230,180,320,245,360,210,300,260,380,230,350,200,315,260,390,220,330,190,300];
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color(0xFF07194A), Colors.black],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: StarPainter())),
          Positioned(
            left: 360,
            right: 160,
            bottom: 78,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(heights.length, (i) {
                final color = i % 3 == 0 ? purple : cyan;
                return Expanded(
                  child: Container(
                    height: heights[i].toDouble(),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.88),
                      border: Border.all(color: color, width: 1),
                      boxShadow: [BoxShadow(color: color.withOpacity(.65), blurRadius: 20)],
                    ),
                    child: Column(
                      children: List.generate(13, (x) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          height: 4,
                          color: x.isEven ? color.withOpacity(.9) : Colors.transparent,
                        );
                      }),
                    ),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 76,
            child: Container(
              height: 2,
              color: cyan,
              boxShadow: const [BoxShadow(color: cyan, blurRadius: 28, spreadRadius: 4)],
            ),
          ),
          Positioned(
            left: 330,
            right: 130,
            bottom: 0,
            child: Container(
              height: 76,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [cyan.withOpacity(.28), purple.withOpacity(.16), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchPanel() => Container(
        width: 370,
        padding: const EdgeInsets.all(18),
        decoration: box(),
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
            input('🗺️  County'),
            input('🏙️  City'),
            const SizedBox(height: 8),
            fullButton('🔍  Search PrimeX'),
          ],
        ),
      );

  Widget features() {
    final data = [
      ['🏠', 'FORECLOSURES', 'Find investor opportunities.'],
      ['🛡', 'AI SAFETY', 'No dating, nudity, scams, hate, or abuse.'],
      ['🌎', 'GLOBAL', 'Country, state, county, city.'],
      ['💰', 'OFFERS', 'Make offer + proof of funds.'],
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(40, 18, 40, 14),
      padding: const EdgeInsets.all(18),
      decoration: box(),
      child: Row(
        children: data.map((d) => Expanded(
          child: Row(children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: cyan),
                boxShadow: [BoxShadow(color: cyan.withOpacity(.6), blurRadius: 18)],
              ),
              child: Center(child: Text(d[0], style: const TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(d[1], style: const TextStyle(color: cyan, fontWeight: FontWeight.w900)),
              Text(d[2], style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]))
          ]),
        )).toList(),
      ),
    );
  }

  Widget listings() {
    final cards = [
      ['FORECLOSURE', 'Single Family Home', 'Johnstown, PA', '89,900'],
      ['PRE-FORECLOSURE', 'Investment Property', 'Bushkill, PA', '74,500'],
      ['BANK OWNED', 'Bank Owned Home', 'Cambria County, PA', '66,000'],
      ['TAX LIEN', 'Tax Lien Certificate', 'Monroe County, PA', '15,000'],
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(40, 0, 40, 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Text('BROWSE TOP OPPORTUNITIES', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          Spacer(),
          Text('View All Listings  →', style: TextStyle(color: cyan, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 12),
        Row(children: cards.map((c) => Expanded(child: listing(c))).toList()),
      ]),
    );
  }

  Widget listing(List<String> c) => Container(
        margin: const EdgeInsets.only(right: 14),
        decoration: box(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 135, child: Stack(children: [
            Positioned.fill(child: CustomPaint(painter: HouseCardPainter())),
            Positioned(top: 8, left: 8, child: label(c[0])),
          ])),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c[1], style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('📍 ${c[2]}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 8),
              Text('${c[3]} dollars', style: const TextStyle(color: cyan, fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Wrap(spacing: 6, runSpacing: 6, children: ['View','Message','Call','Offer','Save'].map(smallButton).toList()),
            ]),
          ),
        ]),
      );

  static Widget navItem(String t, bool active) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Text(t, style: TextStyle(color: active ? cyan : Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      );

  static Widget solidButton(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: blue,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [BoxShadow(color: blue.withOpacity(.8), blurRadius: 14)],
        ),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  static Widget outlineButton(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(border: Border.all(color: blue), borderRadius: BorderRadius.circular(7), color: Colors.black54),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  static Widget fullButton(String t) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: blue.withOpacity(.8), blurRadius: 14)]),
        child: Center(child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))),
      );

  static Widget tab(String t, bool active) => Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(color: active ? blue : Colors.black54, borderRadius: BorderRadius.circular(7)),
        child: Center(child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
      );

  static Widget input(String t) => Container(
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(7), border: Border.all(color: cyan.withOpacity(.3))),
        child: Row(children: [Text(t, style: const TextStyle(color: Colors.white70, fontSize: 12)), const Spacer(), const Text('⌄')]),
      );

  static Widget label(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(7)),
        child: Text(t, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      );

  static Widget smallButton(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: BoxDecoration(border: Border.all(color: blue), borderRadius: BorderRadius.circular(6), color: Colors.black54),
        child: Text(t, style: const TextStyle(fontSize: 11)),
      );

  static BoxDecoration box() => BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: blue.withOpacity(.8)),
        boxShadow: [BoxShadow(color: blue.withOpacity(.25), blurRadius: 18)],
      );
}

class PrimeXLogoPainter extends CustomPainter {
  final bool large;
  PrimeXLogoPainter({this.large = false});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = large ? 1.45 : 1.0;
    final white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final cyanPaint = Paint()
      ..color = PrimeXHome.cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7 * scale
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    final textStyle = TextStyle(fontSize: 30 * scale, color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: -1);

    final tp = TextPainter(text: TextSpan(text: 'PRIME', style: textStyle), textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(0, large ? 6 : 8));

    final x0 = tp.width + 14;
    final y0 = large ? 0.0 : 8.0;
    canvas.drawLine(Offset(x0, y0), Offset(x0 + 75 * scale, y0 + 70 * scale), cyanPaint);
    canvas.drawLine(Offset(x0 + 75 * scale, y0), Offset(x0, y0 + 70 * scale), cyanPaint);

    final small = TextPainter(
      text: TextSpan(text: 'M A R K E T P L A C E\nB U Y .  S E L L .  C O N N E C T .',
        style: TextStyle(fontSize: 8 * scale, color: PrimeXHome.cyan, letterSpacing: 5)),
      textDirection: TextDirection.ltr,
    )..layout();
    small.paint(canvas, Offset(0, large ? 76 : 50));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StarPainter extends CustomPainter {
  const StarPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = PrimeXHome.cyan.withOpacity(.7);
    for (int i = 0; i < 100; i++) {
      canvas.drawCircle(Offset(((i * 73) % size.width).toDouble(), ((i * 41) % size.height).toDouble()), i % 3 == 0 ? 1.5 : .7, p);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HouseCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()..shader = const LinearGradient(colors: [Color(0xFF052A75), Colors.black]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), sky);

    final glow = Paint()..color = PrimeXHome.cyan..style = PaintingStyle.stroke..strokeWidth = 2;
    final warm = Paint()..color = const Color(0xFFFFD36B);
    final house = Paint()..color = Colors.black.withOpacity(.65)..style = PaintingStyle.fill;

    final base = Rect.fromLTWH(size.width * .12, size.height * .55, size.width * .76, size.height * .28);
    canvas.drawRect(base, house);
    canvas.drawRect(base, glow);

    final roof = Path()
      ..moveTo(size.width * .08, size.height * .55)
      ..lineTo(size.width * .5, size.height * .27)
      ..lineTo(size.width * .92, size.height * .55);
    canvas.drawPath(roof, glow);

    for (int i = 0; i < 4; i++) {
      canvas.drawRect(Rect.fromLTWH(size.width * (.23 + i * .14), size.height * .63, 22, 16), warm);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
DART

flutter clean
flutter pub get
flutter build web --release

echo "DONE. Run: flutter run -d chrome"
