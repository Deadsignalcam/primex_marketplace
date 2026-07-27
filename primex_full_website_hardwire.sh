#!/usr/bin/env bash
set -e

echo "🔥 PrimeX full website hard-wire starting..."

cp -r lib "lib_backup_full_hardwire_$(date +%Y%m%d_%H%M%S)"

mkdir -p lib/pages lib/widgets lib/safety lib/theme

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
      home: const PrimeXHomePage(),
    );
  }
}

class PrimeXHomePage extends StatelessWidget {
  const PrimeXHomePage({super.key});

  static const dark = Color(0xFF020617);
  static const card = Color(0xFF071426);
  static const blue = Color(0xFF007BFF);
  static const cyan = Color(0xFF00E5FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            nav(),
            hero(),
            featureBar(),
            listings(),
            safetySection(),
            offerSection(),
            footer(),
          ],
        ),
      ),
    );
  }

  Widget nav() => Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        color: Colors.black,
        child: Row(
          children: [
            logo(28),
            const Spacer(),
            navItem('Home'),
            navItem('Marketplace'),
            navItem('How It Works'),
            navItem('Pricing'),
            navItem('Contact'),
            const SizedBox(width: 16),
            button('Login', outline: true),
            const SizedBox(width: 10),
            button('Sign Up'),
          ],
        ),
      );

  Widget hero() => Stack(
        children: [
          Container(
            height: 420,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.centerRight,
                radius: 1.1,
                colors: [Color(0xFF074E9F), Color(0xFF020617), Colors.black],
              ),
            ),
          ),
          Positioned.fill(child: futuristicBuildings()),
          Container(
            height: 420,
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 34),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('THE #1 MARKETPLACE FOR',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      const Text('FORECLOSURES &',
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
                      const Text('REAL ESTATE INVESTMENTS',
                          style: TextStyle(fontSize: 30, color: cyan, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 14),
                      const SizedBox(
                        width: 560,
                        child: Text(
                          'PrimeX Marketplace connects serious buyers and sellers for real estate, foreclosures, services, vehicles, jobs, tools, and business listings.',
                          style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(children: [
                        button('Browse Listings →'),
                        const SizedBox(width: 12),
                        button('Post Listing +', outline: true),
                      ]),
                    ],
                  ),
                ),
                searchBox(),
              ],
            ),
          ),
        ],
      );

  Widget futuristicBuildings() => Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          width: 620,
          height: 300,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(18, (i) {
              final heights = [90, 150, 120, 210, 170, 260, 130, 230, 190, 280, 150, 240, 115, 200, 170, 255, 135, 220];
              return Expanded(
                child: Container(
                  height: heights[i].toDouble(),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF00E5FF), Color(0xFF073B7A), Colors.black],
                    ),
                    border: Border.all(color: cyan.withOpacity(.7)),
                    boxShadow: [BoxShadow(color: cyan.withOpacity(.35), blurRadius: 14)],
                  ),
                  child: Column(
                    children: List.generate(
                      8,
                      (x) => Container(
                        margin: const EdgeInsets.all(3),
                        height: 5,
                        color: x.isEven ? cyan.withOpacity(.75) : Colors.transparent,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      );

  Widget searchBox() => Container(
        width: 380,
        padding: const EdgeInsets.all(14),
        decoration: glowBox(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              Expanded(child: tab('FOR SALE', true)),
              Expanded(child: tab('RENTALS', false)),
              Expanded(child: tab('SERVICES', false)),
            ]),
            const SizedBox(height: 12),
            field('Region / Country'),
            field('State / Province'),
            field('County'),
            field('City'),
            buttonFull('Search PrimeX'),
          ],
        ),
      );

  Widget featureBar() {
    final items = [
      ['🏚', 'FORECLOSURES', 'Find investor opportunities.'],
      ['🛡', 'AI SAFETY', 'No dating, nudity, scams, hate, or abuse.'],
      ['🌎', 'GLOBAL', 'Country, state, county, city.'],
      ['💰', 'OFFERS', 'Make offer + proof of funds.'],
    ];
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(16),
      decoration: glowBox(),
      child: Row(
        children: items.map((i) => Expanded(
          child: Row(
            children: [
              Text(i[0], style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(i[1], style: const TextStyle(color: cyan, fontWeight: FontWeight.bold)),
                  Text(i[2], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              )),
            ],
          ),
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
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(18),
      decoration: glowBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BROWSE TOP OPPORTUNITIES',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Row(children: cards.map((c) => Expanded(child: listingCard(c))).toList()),
        ],
      ),
    );
  }

  Widget listingCard(List<String> c) => Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: glowBox(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            propertyPhoto(c[0]),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c[1], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('📍 ${c[2]}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 8),
                Text('${c[3]} dollars',
                    style: const TextStyle(color: cyan, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    miniButton('View'),
                    miniButton('Message'),
                    miniButton('Call'),
                    miniButton('Offer'),
                    miniButton('Save'),
                  ],
                ),
              ]),
            ),
          ],
        ),
      );

  Widget propertyPhoto(String tag) => Container(
        height: 120,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF062B55), Color(0xFF00AEEF), Colors.black],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: futuristicBuildingsSmall()),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8)),
                child: Text(tag, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
            const Positioned(
              right: 8,
              bottom: 8,
              child: Text('📷 Property Photo', style: TextStyle(fontSize: 11, color: Colors.white)),
            ),
          ],
        ),
      );

  Widget futuristicBuildingsSmall() => Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(10, (i) {
            final h = [45, 75, 55, 90, 65, 100, 70, 85, 50, 95][i].toDouble();
            return Expanded(
              child: Container(
                height: h,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.55),
                  border: Border.all(color: cyan.withOpacity(.4)),
                ),
              ),
            );
          }),
        ),
      );

  Widget safetySection() => section(
        title: 'PrimeX AI Autopilot Safety',
        body:
            'No dating, no hookup messages, no nudity, no sexual content, no discrimination, no hate, no scams, no fraud, no harassment. Users posting 30 or more properties in one day are flagged for admin review. Repeat abusers can be suspended or removed from the platform.',
      );

  Widget offerSection() => section(
        title: 'Make Offer + Proof of Funds',
        body:
            'Investors must upload proof of funds before submitting serious offers. Realtor and broker listings can mark proof of funds optional, but investor, foreclosure, REO, wholesale, land, and commercial deals can require verification before offers are sent.',
      );

  Widget section({required String title, required String body}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.all(14),
        padding: const EdgeInsets.all(18),
        decoration: glowBox(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: cyan, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(color: Colors.white70, height: 1.5)),
        ]),
      );

  Widget footer() => Container(
        padding: const EdgeInsets.all(24),
        color: Colors.black,
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                logo(24),
                const SizedBox(height: 8),
                const Text('Buy • Sell • Connect', style: TextStyle(color: Colors.white70)),
              ])),
              const Expanded(child: Text('QUICK LINKS\n\nHome\nMarketplace\nLogin\nSign Up\nContact')),
              const Expanded(child: Text('FEATURES\n\nListings\nMessages\nCalls\nMake Offer\nProof of Funds')),
              const Expanded(child: Text('CONTACT\n\nsyntax.phantom@primexmarketplace.com\nprimexmarketplace.com\nPA')),
            ]),
            const Divider(height: 28),
            const Text('POWERED BY SYNTAX PHANTOM @ 2026  •  PHILIPPIANS IV:13',
                style: TextStyle(color: cyan, letterSpacing: 1.5, fontSize: 12)),
          ],
        ),
      );

  static Widget logo(double size) => Text.rich(TextSpan(children: [
        TextSpan(text: 'PRIME', style: TextStyle(fontSize: size, fontWeight: FontWeight.w900)),
        TextSpan(
          text: 'X',
          style: TextStyle(
            fontSize: size + 12,
            color: cyan,
            fontWeight: FontWeight.w900,
            shadows: const [
              Shadow(color: cyan, blurRadius: 20),
              Shadow(color: Color(0xFF007BFF), blurRadius: 35),
            ],
          ),
        ),
        TextSpan(text: '\nMARKETPLACE', style: TextStyle(fontSize: size / 2.2, letterSpacing: 4)),
      ]));

  static Widget navItem(String t) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      );

  static Widget button(String t, {bool outline = false}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: outline ? Colors.transparent : blue,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: blue),
          boxShadow: outline ? [] : [BoxShadow(color: blue.withOpacity(.7), blurRadius: 10)],
        ),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      );

  static Widget miniButton(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: cyan.withOpacity(.7)),
        ),
        child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      );

  static Widget buttonFull(String t) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))),
      );

  static Widget tab(String t, bool active) => Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(color: active ? blue : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
      );

  static Widget field(String t) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white24)),
        child: Row(children: [Text(t, style: const TextStyle(color: Colors.white70, fontSize: 12)), const Spacer(), const Text('⌄')]),
      );

  static BoxDecoration glowBox() => BoxDecoration(
        color: card.withOpacity(.94),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cyan.withOpacity(.5)),
        boxShadow: [BoxShadow(color: blue.withOpacity(.24), blurRadius: 14)],
      );
}
DART

cat > lib/safety/primex_safety_rules.dart <<'DART'
class PrimeXSafetyRules {
  static const int maxPostsPerDay = 30;
  static const int banLimit = 3;

  static const List<String> blockedWords = [
    'nude','nudity','sexy','sex','escort','onlyfans','porn','xxx',
    'hookup','hook up','dating','date me','adult services',
    'hate','racist','discrimination','harass','threat',
    'scam','fraud','fake listing'
  ];

  static Map<String, dynamic> scanContent({
    required String text,
    required int postsToday,
    required int userStrikes,
  }) {
    final lower = text.toLowerCase();
    final matched = blockedWords.where((w) => lower.contains(w)).toList();

    if (matched.isNotEmpty) {
      return {
        'allowed': false,
        'flagged': true,
        'status': 'blocked',
        'reason': 'PrimeX policy violation',
        'matchedWords': matched,
        'action': 'admin_review_or_remove',
      };
    }

    if (postsToday >= maxPostsPerDay) {
      return {
        'allowed': false,
        'flagged': true,
        'status': 'rate_limited',
        'reason': '30 or more posts in one day',
        'action': 'admin_review',
      };
    }

    if (userStrikes >= banLimit) {
      return {
        'allowed': false,
        'flagged': true,
        'status': 'banned',
        'reason': '3 violations reached',
        'action': 'kick_from_platform',
      };
    }

    return {
      'allowed': true,
      'flagged': false,
      'status': 'approved',
      'reason': 'Passed PrimeX AI Autopilot',
      'action': 'publish_or_send',
    };
  }
}
DART

flutter clean
flutter pub get
flutter analyze || true
flutter build web --release

echo "✅ PrimeX full public website hard-wired."
echo "✅ Futuristic buildings added."
echo "✅ Neon X logo added."
echo "✅ Contact added: syntax.phantom@primexmarketplace.com / primexmarketplace.com / PA"
echo "✅ Listing cards now show property photo area."
echo "✅ Message, Call, Offer, Save buttons added."
echo "✅ Proof of Funds section added."
echo "✅ AI safety rules added."
echo ""
echo "Now run:"
echo "flutter run -d chrome"
