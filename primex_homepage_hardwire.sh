#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_before_homepage_$(date +%Y%m%d_%H%M%S).dart"

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

  static const blue = Color(0xFF008CFF);
  static const cyan = Color(0xFF00E5FF);
  static const dark = Color(0xFF020817);
  static const card = Color(0xFF071426);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _nav(),
            _hero(),
            _features(),
            _opportunities(),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _nav() => Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        decoration: const BoxDecoration(color: Colors.black),
        child: Row(
          children: [
            _logo(34),
            const Spacer(),
            _navItem('Home', true),
            _navItem('Marketplace', false),
            _navItem('How It Works', false),
            _navItem('About Us', false),
            _navItem('Pricing', false),
            _navItem('Contact', false),
            const SizedBox(width: 30),
            _outline('Login'),
            const SizedBox(width: 14),
            _solid('Sign Up'),
          ],
        ),
      );

  Widget _hero() => Container(
        height: 360,
        padding: const EdgeInsets.all(40),
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color(0xFF063B8E), Colors.black],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('THE #1 MARKETPLACE FOR',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('FORECLOSURES &',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900)),
                  const Text('REAL ESTATE INVESTMENTS',
                      style: TextStyle(fontSize: 40, color: cyan, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 16),
                  const SizedBox(
                    width: 520,
                    child: Text(
                      'PrimeX Marketplace connects serious buyers and sellers of foreclosures, pre-foreclosures, bank-owned properties, tax liens, services, jobs, vehicles, and more.',
                      style: TextStyle(fontSize: 17, color: Colors.white70, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(children: [_solid('Browse Listings  →'), const SizedBox(width: 16), _outline('Post a Listing  ⊞')]),
                ],
              ),
            ),
            _searchBox(),
          ],
        ),
      );

  Widget _searchBox() => Container(
        width: 460,
        padding: const EdgeInsets.all(20),
        decoration: _glowBox(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              Expanded(child: _tab('FOR SALE', true)),
              Expanded(child: _tab('RENTALS', false)),
              Expanded(child: _tab('SERVICES', false)),
            ]),
            const SizedBox(height: 14),
            _field('📍  City, County, State or Zip'),
            _field('🏠  Property Type'),
            Row(children: [Expanded(child: _field('Min Price')), const SizedBox(width: 12), Expanded(child: _field('Max Price'))]),
            const SizedBox(height: 12),
            _solidFull('🔍  Search'),
          ],
        ),
      );

  Widget _features() {
    final items = [
      ['⌂', 'FORECLOSURES', 'Find pre-foreclosures, bank-owned & more.'],
      ['🛡', 'SECURE & TRUSTED', 'Verified listings and secure transactions.'],
      ['🌐', 'NATIONWIDE ACCESS', 'Search deals across the United States.'],
      ['⚡', 'INSTANT UPDATES', 'Real-time notifications on new opportunities.'],
    ];
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(22),
      decoration: _glowBox(),
      child: Row(
        children: items.map((i) => Expanded(
          child: Row(children: [
            CircleAvatar(backgroundColor: blue.withOpacity(.25), child: Text(i[0])),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(i[1], style: const TextStyle(color: cyan, fontWeight: FontWeight.bold)),
              Text(i[2], style: const TextStyle(color: Colors.white70)),
            ]))
          ]),
        )).toList(),
      ),
    );
  }

  Widget _opportunities() {
    final cards = [
      ['FORECLOSURE', 'Single Family Home', 'Johnstown, PA', '89,900'],
      ['PRE-FORECLOSURE', 'Investment Property', 'Bushkill, PA', '74,500'],
      ['BANK OWNED', 'Bank Owned Home', 'Cambria County, PA', '66,000'],
      ['TAX LIEN', 'Tax Lien Certificate', 'Monroe County, PA', '15,000'],
    ];
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: _glowBox(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Text('BROWSE TOP OPPORTUNITIES', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          Spacer(),
          Text('View All Listings  →', style: TextStyle(color: cyan, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 18),
        Row(children: cards.map((c) => Expanded(child: _listing(c[0], c[1], c[2], c[3]))).toList()),
      ]),
    );
  }

  Widget _listing(String tag, String title, String loc, String price) => Container(
        margin: const EdgeInsets.only(right: 16),
        decoration: _glowBox(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 130, decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF0B2A55), Colors.black]),
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
          ), child: Align(alignment: Alignment.topLeft, child: Padding(
            padding: const EdgeInsets.all(12),
            child: Chip(label: Text(tag), backgroundColor: blue),
          ))),
          Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('📍 $loc', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Text('$price dollars', style: const TextStyle(color: cyan, fontSize: 20, fontWeight: FontWeight.bold)),
          ]))
        ]),
      );

  Widget _footer() => Container(
        padding: const EdgeInsets.all(34),
        color: Colors.black,
        child: Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _logo(28),
              const Text('The #1 platform for real estate investors to buy, sell, and connect with serious opportunities.'),
            ])),
            const Expanded(child: Text('QUICK LINKS\n\nHome\nMarketplace\nHow It Works\nAbout Us\nContact Us')),
            const Expanded(child: Text('RESOURCES\n\nBlog\nHelp Center\nTerms of Service\nPrivacy Policy\nPricing')),
            const Expanded(child: Text('CONTACT\n\nsyntax.phantom@primexmarketplace.com\nJohnstown, PA, USA')),
          ]),
          const Divider(height: 30),
          const Text('POWERED BY  SYNTAX PHANTOM @ 2026', style: TextStyle(color: cyan, letterSpacing: 2)),
        ]),
      );

  static BoxDecoration _glowBox() => BoxDecoration(
        color: card.withOpacity(.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cyan.withOpacity(.55)),
        boxShadow: [BoxShadow(color: blue.withOpacity(.35), blurRadius: 22)],
      );

  static Widget _logo(double size) => Text.rich(TextSpan(children: [
        TextSpan(text: 'PRIME', style: TextStyle(fontSize: size, color: Colors.white, fontWeight: FontWeight.w900)),
        TextSpan(text: 'X', style: TextStyle(fontSize: size + 8, color: cyan, fontWeight: FontWeight.w900, shadows: const [Shadow(color: cyan, blurRadius: 18)])),
        TextSpan(text: '\nMARKETPLACE', style: TextStyle(fontSize: size / 2.2, letterSpacing: 4, color: Colors.white)),
      ]));

  static Widget _navItem(String t, bool active) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(t, style: TextStyle(color: active ? cyan : Colors.white, fontWeight: FontWeight.bold)),
      );

  static Widget _solid(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: blue.withOpacity(.8), blurRadius: 14)]),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  static Widget _outline(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(border: Border.all(color: blue), borderRadius: BorderRadius.circular(8)),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  static Widget _tab(String t, bool a) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: a ? blue : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))),
      );

  static Widget _field(String t) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white24)),
        child: Row(children: [Text(t, style: const TextStyle(color: Colors.white70)), const Spacer(), const Text('⌄')]),
      );

  static Widget _solidFull(String t) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: blue.withOpacity(.8), blurRadius: 14)]),
        child: Center(child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))),
      );
}
DART

flutter clean
flutter pub get
flutter build web --release

echo "PrimeX homepage hard wired."
echo "Run: flutter run -d chrome"
