#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_fix_all_$(date +%Y%m%d_%H%M%S).dart"
mkdir -p assets/images

FOUND="$(find . -iname 'primex_neon_city_bg*.png*' | head -n 1 || true)"
if [ -n "$FOUND" ]; then
  cp "$FOUND" assets/images/primex_neon_city_bg.png
fi

grep -q "assets/images/" pubspec.yaml || cat >> pubspec.yaml <<'YAML'

flutter:
  assets:
    - assets/images/
YAML

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
            footer(),
          ],
        ),
      ),
    );
  }

  Widget nav() => Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 34),
        color: Colors.black,
        child: Row(
          children: [
            logo(),
            const Spacer(),
            navItem('Home', true),
            navItem('Marketplace', false),
            navItem('How It Works', false),
            navItem('About Us', false),
            navItem('Pricing', false),
            navItem('Contact', false),
            const SizedBox(width: 20),
            outline('Login'),
            const SizedBox(width: 12),
            solid('Sign Up'),
          ],
        ),
      );

  Widget logo() => SizedBox(
        width: 310,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'PRIME',
                    style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: 'X',
                    style: TextStyle(
                      fontSize: 72,
                      color: cyan,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(color: cyan, blurRadius: 20),
                        Shadow(color: blue, blurRadius: 35),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text('M A R K E T P L A C E',
                style: TextStyle(color: cyan, fontSize: 12, letterSpacing: 7)),
            SizedBox(height: 4),
            Text('B U Y .  S E L L .  C O N N E C T .',
                style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 4)),
          ],
        ),
      );

  Widget hero() => SizedBox(
        height: 500,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/primex_neon_city_bg.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Color(0xFF071A4A), Colors.black],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xF902040D), Color(0x9902040D), Color(0x3302040D)],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 55, 36, 35),
              child: Row(
                children: [
                  SizedBox(
                    width: 560,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('THE #1 MARKETPLACE FOR',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        const Text('FORECLOSURES &',
                            style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900)),
                        const Text(
                          'REAL ESTATE INVESTMENTS',
                          style: TextStyle(
                            fontSize: 36,
                            color: cyan,
                            fontWeight: FontWeight.w900,
                            shadows: [Shadow(color: cyan, blurRadius: 18)],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'PrimeX Marketplace connects serious buyers and sellers for real estate, foreclosures, services, vehicles, jobs, tools, and business listings.',
                          style: TextStyle(fontSize: 16, height: 1.55),
                        ),
                        const SizedBox(height: 28),
                        Row(children: [
                          solid('Browse Listings  →'),
                          const SizedBox(width: 16),
                          outline('Post a Listing  +'),
                        ]),
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

  Widget searchBox() => Container(
        width: 380,
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
            input('Region / Country'),
            input('State / Province'),
            input('County'),
            input('City'),
            const SizedBox(height: 8),
            full('Search PrimeX'),
          ],
        ),
      );

  Widget features() {
    final data = [
      ['🏠', 'FORECLOSURES', 'Find investor opportunities.'],
      ['🛡️', 'AI SAFETY', 'No dating, nudity, scams, hate, or abuse.'],
      ['🌎', 'GLOBAL', 'Country, state, county, city.'],
      ['💰', 'OFFERS', 'Make offer + proof of funds.'],
    ];

    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(18),
      decoration: box(),
      child: Row(
        children: data
            .map(
              (i) => Expanded(
                child: Row(
                  children: [
                    Text(i[0], style: const TextStyle(fontSize: 30)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(i[1], style: const TextStyle(color: cyan, fontWeight: FontWeight.bold)),
                        Text(i[2], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ]),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget listings() {
    final cards = [
      ['FORECLOSURE', 'Single Family Home', 'Johnstown, PA', '89,900', 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=900'],
      ['PRE-FORECLOSURE', 'Investment Property', 'Bushkill, PA', '74,500', 'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=900'],
      ['BANK OWNED', 'Bank Owned Home', 'Cambria County, PA', '66,000', 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=900'],
      ['TAX LIEN', 'Tax Lien Certificate', 'Monroe County, PA', '15,000', 'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=900'],
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Text('BROWSE TOP OPPORTUNITIES',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            Spacer(),
            Text('View All Listings  →', style: TextStyle(color: cyan, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 14),
          Row(children: cards.map((c) => Expanded(child: card(c))).toList()),
        ],
      ),
    );
  }

  Widget card(List<String> c) => Container(
        margin: const EdgeInsets.only(right: 14),
        decoration: box(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: Image.network(
                    c[4],
                    height: 145,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(height: 145, color: Colors.black),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(7)),
                    child: Text(c[0], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c[1], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('📍 ${c[2]}', style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Text('${c[3]} dollars',
                    style: const TextStyle(color: cyan, fontSize: 18, fontWeight: FontWeight.bold)),
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

  Widget footer() => Container(
        padding: const EdgeInsets.all(24),
        color: Colors.black,
        child: const Text(
          'CONTACT\nsyntax.phantom@primexmarketplace.com\nprimexmarketplace.com\nPA\n\nPowered by Syntax Phantom @ 2026',
          textAlign: TextAlign.center,
          style: TextStyle(color: cyan),
        ),
      );

  static Widget navItem(String t, bool active) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(t, style: TextStyle(color: active ? cyan : Colors.white, fontWeight: FontWeight.bold)));

  static Widget solid(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: blue.withOpacity(.75), blurRadius: 16)]),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  static Widget outline(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        decoration: BoxDecoration(color: Colors.black.withOpacity(.45), border: Border.all(color: blue), borderRadius: BorderRadius.circular(8)),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  static Widget tab(String t, bool active) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: active ? blue : Colors.black.withOpacity(.45), borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
      );

  static Widget input(String t) => Container(
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: Colors.black.withOpacity(.65), borderRadius: BorderRadius.circular(8), border: Border.all(color: cyan.withOpacity(.35))),
        child: Row(children: [Text(t), const Spacer(), const Text('⌄')]),
      );

  static Widget full(String t) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      );

  static BoxDecoration box() => BoxDecoration(
        color: const Color(0xCC050B18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: blue.withOpacity(.85)),
        boxShadow: [BoxShadow(color: blue.withOpacity(.32), blurRadius: 18)],
      );
}
DART

flutter clean
flutter pub get
flutter build web --release

echo "DONE. Now run:"
echo "flutter run -d chrome --web-renderer canvaskit"
