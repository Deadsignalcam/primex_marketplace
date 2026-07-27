#!/usr/bin/env bash
set -e

echo "🔥 PrimeX exact neon homepage update..."

cp -r lib "lib_backup_exact_neon_$(date +%Y%m%d_%H%M%S)"

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
  static const purple = Color(0xFF9D4DFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _hero(),
            _features(),
            _listings(),
          ],
        ),
      ),
    );
  }

  Widget _hero() {
    return SizedBox(
      height: 520,
      child: Stack(
        children: [
          Positioned.fill(child: _digitalCity()),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xEE02040D), Color(0x6602040D), Color(0x2202040D)],
                ),
              ),
            ),
          ),
          Positioned(left: 28, top: 22, child: _primeLogo()),
          Positioned(top: 35, left: 510, right: 260, child: _nav()),
          Positioned(top: 28, right: 28, child: Row(children: [_outline('Login'), const SizedBox(width: 14), _solid('Sign Up')])),
          Positioned(left: 34, top: 190, width: 500, child: _headline()),
          Positioned(right: 34, top: 118, child: _searchBox()),
        ],
      ),
    );
  }

  Widget _primeLogo() {
    return Text.rich(
      const TextSpan(
        children: [
          TextSpan(
            text: 'PRIME',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -2,
              shadows: [Shadow(color: Colors.white, blurRadius: 10)],
            ),
          ),
          TextSpan(
            text: 'X',
            style: TextStyle(
              fontSize: 96,
              fontWeight: FontWeight.w900,
              color: cyan,
              letterSpacing: -8,
              shadows: [
                Shadow(color: cyan, blurRadius: 20),
                Shadow(color: blue, blurRadius: 38),
                Shadow(color: cyan, blurRadius: 58),
              ],
            ),
          ),
          TextSpan(
            text: '\nM A R K E T P L A C E',
            style: TextStyle(fontSize: 16, letterSpacing: 9, color: cyan, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '\nB U Y .  S E L L .  C O N N E C T .',
            style: TextStyle(fontSize: 14, letterSpacing: 5, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _nav() {
    final items = ['Home', 'Marketplace', 'How It Works', 'About Us', 'Pricing', 'Contact'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.map((x) => Text(
        x,
        style: TextStyle(
          color: x == 'Home' ? cyan : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
          shadows: x == 'Home' ? const [Shadow(color: cyan, blurRadius: 10)] : [],
        ),
      )).toList(),
    );
  }

  Widget _headline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('THE #1 MARKETPLACE FOR', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text('FORECLOSURES &', style: TextStyle(fontSize: 43, fontWeight: FontWeight.w900)),
        const Text(
          'REAL ESTATE INVESTMENTS',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: cyan, shadows: [Shadow(color: cyan, blurRadius: 18)]),
        ),
        const SizedBox(height: 20),
        const Text(
          'PrimeX Marketplace connects serious buyers and sellers for real estate, foreclosures, services, vehicles, jobs, tools, and business listings.',
          style: TextStyle(fontSize: 17, color: Colors.white, height: 1.55),
        ),
        const SizedBox(height: 28),
        Row(children: [_solid('Browse Listings  →'), const SizedBox(width: 16), _outline('Post a Listing  +')]),
      ],
    );
  }

  Widget _searchBox() {
    return Container(
      width: 370,
      padding: const EdgeInsets.all(18),
      decoration: _box(),
      child: Column(
        children: [
          Row(children: [Expanded(child: _tab('FOR SALE', true)), Expanded(child: _tab('RENTALS', false)), Expanded(child: _tab('SERVICES', false))]),
          const SizedBox(height: 14),
          _input('🌐  Region / Country'),
          _input('📍  State / Province'),
          _input('🗺  County'),
          _input('🏙  City'),
          const SizedBox(height: 8),
          _fullButton('🔍  Search PrimeX'),
        ],
      ),
    );
  }

  Widget _digitalCity() {
    final heights = [110,190,150,260,210,330,180,280,230,360,200,310,170,290,240,340,190,260,150,300,210,370,180,260];
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black, Color(0xFF061A55), Colors.black]),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: StarsPainter())),
          Positioned(
            left: 390,
            right: 30,
            bottom: 35,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(heights.length, (i) {
                final glow = i.isEven ? cyan : purple;
                return Expanded(
                  child: Container(
                    height: heights[i].toDouble(),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.82),
                      border: Border.all(color: glow.withOpacity(.9)),
                      boxShadow: [BoxShadow(color: glow.withOpacity(.55), blurRadius: 18)],
                    ),
                    child: Column(
                      children: List.generate(14, (x) => Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        color: x.isEven ? glow.withOpacity(.9) : Colors.transparent,
                      )),
                    ),
                  ),
                );
              }),
            ),
          ),
          Positioned(left: 0, right: 0, bottom: 35, child: Container(height: 3, color: cyan, child: const SizedBox())),
          Positioned(left: 0, right: 0, bottom: 0, height: 55, child: Container(color: cyan.withOpacity(.08))),
        ],
      ),
    );
  }

  Widget _features() {
    final items = [
      ['⌂', 'FORECLOSURES', 'Find investor opportunities.'],
      ['🛡', 'AI SAFETY', 'No dating, nudity, scams, hate, or abuse.'],
      ['🌎', 'GLOBAL', 'Country, state, county, city.'],
      ['💰', 'OFFERS', 'Make offer + proof of funds.'],
    ];
    return Container(
      margin: const EdgeInsets.all(28),
      padding: const EdgeInsets.all(18),
      decoration: _box(),
      child: Row(children: items.map((i) => Expanded(child: Row(children: [
        Text(i[0], style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(i[1], style: const TextStyle(color: cyan, fontWeight: FontWeight.bold, fontSize: 16)),
          Text(i[2], style: const TextStyle(color: Colors.white, fontSize: 13)),
        ])),
      ]))).toList()),
    );
  }

  Widget _listings() {
    final cards = [
      ['FORECLOSURE', 'Single Family Home', 'Johnstown, PA', '89,900'],
      ['PRE-FORECLOSURE', 'Investment Property', 'Bushkill, PA', '74,500'],
      ['BANK OWNED', 'Bank Owned Home', 'Cambria County, PA', '66,000'],
      ['TAX LIEN', 'Tax Lien Certificate', 'Monroe County, PA', '15,000'],
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Text('BROWSE TOP OPPORTUNITIES', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          Spacer(),
          Text('View All Listings  →', style: TextStyle(color: cyan, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 12),
        Row(children: cards.map((c) => Expanded(child: _card(c))).toList()),
      ]),
    );
  }

  Widget _card(List<String> c) {
    return Container(
      margin: const EdgeInsets.only(right: 14),
      decoration: _box(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 120,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            gradient: LinearGradient(colors: [Color(0xFF073B7A), Colors.black]),
          ),
          child: CustomPaint(painter: HousePainter(), child: Container()),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c[1], style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('📍 ${c[2]}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('${c[3]} dollars', style: const TextStyle(color: cyan, fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(children: ['View','Message','Call','Offer','Save'].map((x) => Expanded(child: Container(
              margin: const EdgeInsets.only(right: 5),
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(border: Border.all(color: blue), borderRadius: BorderRadius.circular(6)),
              child: Center(child: Text(x, style: const TextStyle(fontSize: 11))),
            ))).toList()),
          ]),
        ),
      ]),
    );
  }

  static Widget _solid(String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
    decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(7), boxShadow: [BoxShadow(color: blue.withOpacity(.85), blurRadius: 16)]),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  static Widget _outline(String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
    decoration: BoxDecoration(border: Border.all(color: blue), borderRadius: BorderRadius.circular(7), color: Colors.black.withOpacity(.35)),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  static Widget _tab(String t, bool active) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: active ? blue : Colors.black.withOpacity(.35), borderRadius: BorderRadius.circular(7)),
    child: Center(child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
  );

  static Widget _input(String t) => Container(
    margin: const EdgeInsets.only(bottom: 11),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: Colors.black.withOpacity(.65), borderRadius: BorderRadius.circular(7), border: Border.all(color: cyan.withOpacity(.35))),
    child: Row(children: [Text(t), const Spacer(), const Text('⌄')]),
  );

  static Widget _fullButton(String t) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: blue.withOpacity(.85), blurRadius: 16)]),
    child: Center(child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
  );

  static BoxDecoration _box() => BoxDecoration(
    color: const Color(0xCC050B18),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: blue.withOpacity(.85)),
    boxShadow: [BoxShadow(color: blue.withOpacity(.35), blurRadius: 18)],
  );
}

class StarsPainter extends CustomPainter {
  const StarsPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0x9900F5FF);
    for (int i = 0; i < 110; i++) {
      canvas.drawCircle(Offset(((i * 83) % size.width).toDouble(), ((i * 47) % size.height).toDouble()), i % 4 == 0 ? 1.7 : .8, p);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HousePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()..color = const Color(0xFF00F5FF)..style = PaintingStyle.stroke..strokeWidth = 2;
    final fill = Paint()..color = Colors.black.withOpacity(.6)..style = PaintingStyle.fill;
    final base = Rect.fromLTWH(size.width * .12, size.height * .48, size.width * .76, size.height * .32);
    final roof = Path()
      ..moveTo(size.width * .08, size.height * .48)
      ..lineTo(size.width * .50, size.height * .20)
      ..lineTo(size.width * .92, size.height * .48)
      ..close();
    canvas.drawRect(base, fill);
    canvas.drawRect(base, glow);
    canvas.drawPath(roof, fill);
    canvas.drawPath(roof, glow);
    final win = Paint()..color = const Color(0xFFFFD36B);
    for (int i = 0; i < 4; i++) {
      canvas.drawRect(Rect.fromLTWH(size.width * (.22 + i * .15), size.height * .56, 25, 18), win);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
DART

flutter clean
flutter pub get
flutter build web --release

echo "✅ PrimeX exact neon homepage installed."
echo "Run: flutter run -d chrome"
