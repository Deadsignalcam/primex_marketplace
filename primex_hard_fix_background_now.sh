#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_background_fix_$(date +%Y%m%d_%H%M%S).dart"

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
      height: 560,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: DigitalMarketplacePainter())),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xF202040D),
                    Color(0x8802040D),
                    Color(0x2202040D),
                  ],
                ),
              ),
            ),
          ),
          Positioned(left: 34, top: 24, child: _logo()),
          Positioned(top: 38, left: 500, right: 260, child: _nav()),
          Positioned(top: 28, right: 28, child: Row(children: [_outline('Login'), const SizedBox(width: 14), _solid('Sign Up')])),
          Positioned(left: 34, top: 190, width: 470, child: _headline()),
          Positioned(right: 34, top: 130, child: _searchBox()),
        ],
      ),
    );
  }

  Widget _logo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'PRIME',
                style: TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              TextSpan(
                text: 'X',
                style: TextStyle(
                  fontSize: 88,
                  fontWeight: FontWeight.w900,
                  color: cyan,
                  shadows: [
                    Shadow(color: cyan, blurRadius: 20),
                    Shadow(color: blue, blurRadius: 38),
                  ],
                ),
              ),
            ],
          ),
        ),
        Text('M A R K E T P L A C E', style: TextStyle(color: cyan, fontSize: 13, letterSpacing: 8)),
        SizedBox(height: 4),
        Text('B U Y .  S E L L .  C O N N E C T .', style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 4)),
      ],
    );
  }

  Widget _nav() {
    final items = ['Home', 'Marketplace', 'How It Works', 'About Us', 'Pricing', 'Contact'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.map((x) => Text(
        x,
        style: TextStyle(color: x == 'Home' ? cyan : Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      )).toList(),
    );
  }

  Widget _headline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('THE #1 MARKETPLACE FOR', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        const Text('EVERYTHING', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900)),
        const Text(
          'YOU NEED',
          style: TextStyle(fontSize: 38, color: cyan, fontWeight: FontWeight.w900, shadows: [Shadow(color: cyan, blurRadius: 18)]),
        ),
        const SizedBox(height: 18),
        const Text(
          'PrimeX Marketplace connects serious buyers and sellers for real estate, foreclosures, services, vehicles, jobs, tools, and business listings.',
          style: TextStyle(fontSize: 16, color: Colors.white, height: 1.55),
        ),
        const SizedBox(height: 26),
        Row(children: [_solid('Browse Listings  →'), const SizedBox(width: 16), _outline('Post a Listing  +')]),
      ],
    );
  }

  Widget _searchBox() {
    return Container(
      width: 390,
      padding: const EdgeInsets.all(18),
      decoration: _box(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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

  Widget _features() {
    final data = [
      ['🌎', 'GLOBAL REACH', 'List globally.'],
      ['🛡', 'AI SAFETY', 'No scams, no hate, no abuse.'],
      ['✅', 'VERIFIED USERS', 'Trusted buyers and sellers.'],
      ['💰', 'OFFERS', 'Make offers with confidence.'],
      ['📄', 'PROOF OF FUNDS', 'Verify funds instantly.'],
      ['💬', 'MESSAGING', 'Built-in secure messaging.'],
      ['📞', 'CALL', 'Call directly in-app.'],
      ['📊', 'ANALYTICS', 'Track views, leads & more.'],
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(28, 18, 28, 20),
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Row(
        children: data.map((i) => Expanded(
          child: Column(
            children: [
              Text(i[0], style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 8),
              Text(i[1], textAlign: TextAlign.center, style: const TextStyle(color: cyan, fontSize: 12, fontWeight: FontWeight.bold)),
              Text(i[2], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _listings() {
    final cards = [
      ['FORECLOSURE', 'Single Family Home', 'Johnstown, PA', '89,900'],
      ['PRE-FORECLOSURE', 'Investment Property', 'Bushkill, PA', '74,500'],
      ['BANK OWNED', 'Bank Owned Home', 'Cambria County, PA', '66,000'],
      ['TAX LIEN', 'Tax Lien Certificate', 'Monroe County, PA', '15,000'],
      ['COMMERCIAL', 'Retail Strip Center', 'Pittsburgh, PA', '499,000'],
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Text('BROWSE TOP OPPORTUNITIES', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            Spacer(),
            Text('View All Listings  →', style: TextStyle(color: cyan, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 12),
          Row(children: cards.map((c) => Expanded(child: _card(c))).toList()),
        ],
      ),
    );
  }

  Widget _card(List<String> c) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(height: 130, width: double.infinity, child: CustomPaint(painter: HouseCardPainter())),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(6)),
                  child: Text(c[0], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c[1], style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('📍 ${c[2]}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 8),
              Text('${c[3]} dollars', style: const TextStyle(color: cyan, fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
          ),
        ],
      ),
    );
  }

  static Widget _solid(String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(7), boxShadow: [BoxShadow(color: blue.withOpacity(.8), blurRadius: 14)]),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  static Widget _outline(String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(border: Border.all(color: blue), borderRadius: BorderRadius.circular(7), color: Colors.black.withOpacity(.35)),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  static Widget _tab(String t, bool active) => Container(
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(color: active ? blue : Colors.black.withOpacity(.35), borderRadius: BorderRadius.circular(7)),
    child: Center(child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
  );

  static Widget _input(String t) => Container(
    margin: const EdgeInsets.only(bottom: 11),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.black.withOpacity(.7), borderRadius: BorderRadius.circular(7), border: Border.all(color: cyan.withOpacity(.35))),
    child: Row(children: [Text(t), const Spacer(), const Text('⌄')]),
  );

  static Widget _fullButton(String t) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8)),
    child: Center(child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
  );

  static BoxDecoration _box() => BoxDecoration(
    color: const Color(0xCC050B18),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: blue.withOpacity(.85)),
    boxShadow: [BoxShadow(color: blue.withOpacity(.35), blurRadius: 18)],
  );
}

class DigitalMarketplacePainter extends CustomPainter {
  static const cyan = Color(0xFF00F5FF);
  static const blue = Color(0xFF006BFF);
  static const purple = Color(0xFF9D4DFF);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..shader = const LinearGradient(colors: [Colors.black, Color(0xFF08256B), Colors.black]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final star = Paint()..color = cyan.withOpacity(.7);
    for (int i = 0; i < 160; i++) {
      canvas.drawCircle(Offset(((i * 79) % size.width).toDouble(), ((i * 43) % size.height).toDouble()), i % 5 == 0 ? 1.8 : .8, star);
    }

    final network = Paint()
      ..color = cyan.withOpacity(.45)
      ..strokeWidth = 1.2;
    final pts = [
      Offset(size.width * .38, size.height * .16),
      Offset(size.width * .48, size.height * .24),
      Offset(size.width * .58, size.height * .15),
      Offset(size.width * .66, size.height * .28),
      Offset(size.width * .76, size.height * .18),
    ];
    for (int i = 0; i < pts.length - 1; i++) {
      canvas.drawLine(pts[i], pts[i + 1], network);
    }
    for (final p in pts) {
      canvas.drawCircle(p, 8, Paint()..color = cyan);
      canvas.drawCircle(p, 22, Paint()..color = cyan.withOpacity(.18));
    }

    final base = size.height * .88;
    final startX = size.width * .33;
    final endX = size.width * .78;
    final heights = [90,160,120,240,180,310,220,360,170,290,230,380,190,330,150,270,210,350];
    final bw = (endX - startX) / heights.length;

    for (int i = 0; i < heights.length; i++) {
      final h = heights[i].toDouble();
      final x = startX + i * bw;
      final top = base - h;
      final color = i.isEven ? cyan : purple;

      final rect = Rect.fromLTWH(x + 3, top, bw - 6, h);
      canvas.drawRect(rect, Paint()..color = Colors.black.withOpacity(.78));
      canvas.drawRect(rect, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.6);
      canvas.drawRect(rect, Paint()..color = color.withOpacity(.7)..style = PaintingStyle.stroke..strokeWidth = 2..maskFilter = const MaskFilter.blur(BlurStyle.outer, 12));

      canvas.drawLine(Offset(x + bw / 2, top), Offset(x + bw / 2, top - 55), Paint()..color = color..strokeWidth = 2);

      for (double y = top + 18; y < base - 8; y += 18) {
        canvas.drawRect(Rect.fromLTWH(x + 10, y, bw - 20, 3), Paint()..color = color.withOpacity(.85));
      }
    }

    canvas.drawLine(Offset(0, base), Offset(size.width, base), Paint()..color = cyan..strokeWidth = 3..maskFilter = const MaskFilter.blur(BlurStyle.outer, 14));

    void label(String title, String sub, double x, double y) {
      final r = RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 210, 62), const Radius.circular(12));
      canvas.drawRRect(r, Paint()..color = Colors.black.withOpacity(.58));
      canvas.drawRRect(r, Paint()..color = cyan..style = PaintingStyle.stroke..strokeWidth = 1.2);
      final tp = TextPainter(
        text: TextSpan(
          text: '$title\n',
          style: const TextStyle(color: cyan, fontSize: 14, fontWeight: FontWeight.bold),
          children: [TextSpan(text: sub, style: const TextStyle(color: Colors.white, fontSize: 11))],
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 190);
      tp.paint(canvas, Offset(x + 14, y + 10));
    }

    label('REAL ESTATE', 'Buy • Sell • Invest', size.width * .22, size.height * .22);
    label('FORECLOSURES', 'Hot Deals Daily', size.width * .23, size.height * .37);
    label('COMMERCIAL', 'Offices • Retail • Land', size.width * .24, size.height * .52);
    label('VEHICLES', 'Cars • Trucks • RVs', size.width * .70, size.height * .20);
    label('SERVICES', 'Local Professionals', size.width * .72, size.height * .35);
    label('TOOLS & JOBS', 'Post • Hire • Sell', size.width * .72, size.height * .50);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HouseCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..shader = const LinearGradient(colors: [Color(0xFF073B7A), Colors.black]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);
    final glow = Paint()..color = const Color(0xFF00F5FF)..style = PaintingStyle.stroke..strokeWidth = 2..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);
    final line = Paint()..color = const Color(0xFF00F5FF)..style = PaintingStyle.stroke..strokeWidth = 2;
    final fill = Paint()..color = Colors.black.withOpacity(.6);
    final base = Rect.fromLTWH(size.width * .12, size.height * .50, size.width * .76, size.height * .32);
    final roof = Path()..moveTo(size.width * .08, size.height * .50)..lineTo(size.width * .50, size.height * .20)..lineTo(size.width * .92, size.height * .50)..close();
    canvas.drawRect(base, fill);
    canvas.drawPath(roof, fill);
    canvas.drawRect(base, glow);
    canvas.drawPath(roof, glow);
    canvas.drawRect(base, line);
    canvas.drawPath(roof, line);
    for (int i = 0; i < 4; i++) {
      canvas.drawRect(Rect.fromLTWH(size.width * (.22 + i * .15), size.height * .58, 25, 18), Paint()..color = const Color(0xFFFFD36B));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
DART

flutter clean
flutter pub get
flutter build web --release

echo "DONE. Now run:"
echo "flutter run -d chrome"
