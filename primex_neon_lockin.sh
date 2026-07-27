#!/usr/bin/env bash
set -e

echo "🔥 PrimeX Neon Lock-In Update"

cp -r lib "lib_backup_neon_$(date +%Y%m%d_%H%M%S)"

mkdir -p lib/theme

cat > lib/theme/primex_theme.dart <<'DART'
import 'package:flutter/material.dart';

class PrimeXTheme {
  static const Color black = Color(0xFF020617);
  static const Color dark = Color(0xFF06111F);
  static const Color card = Color(0xFF081827);
  static const Color neonBlue = Color(0xFF00D9FF);
  static const Color electricBlue = Color(0xFF006BFF);
  static const Color cyan = Color(0xFF38F8FF);
  static const Color white = Color(0xFFFFFFFF);

  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: black,
    primaryColor: neonBlue,
    fontFamily: 'Arial',
    colorScheme: const ColorScheme.dark(
      primary: neonBlue,
      secondary: electricBlue,
      surface: card,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: black,
      foregroundColor: white,
      elevation: 0,
    ),
  );

  static BoxDecoration neonCard = BoxDecoration(
    color: card.withOpacity(.88),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: neonBlue.withOpacity(.65)),
    boxShadow: [
      BoxShadow(
        color: neonBlue.withOpacity(.35),
        blurRadius: 20,
        spreadRadius: 1,
      ),
    ],
  );

  static BoxDecoration neonButton = BoxDecoration(
    gradient: const LinearGradient(
      colors: [electricBlue, neonBlue],
    ),
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: neonBlue.withOpacity(.55),
        blurRadius: 22,
      ),
    ],
  );
}
DART

cat > lib/main.dart <<'DART'
import 'package:flutter/material.dart';
import 'theme/primex_theme.dart';

void main() {
  runApp(const PrimeXApp());
}

class PrimeXApp extends StatelessWidget {
  const PrimeXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrimeX Marketplace',
      debugShowCheckedModeBanner: false,
      theme: PrimeXTheme.theme,
      home: const PrimeXHomePage(),
    );
  }
}

class PrimeXHomePage extends StatelessWidget {
  const PrimeXHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.3,
            colors: [
              Color(0xFF063B7A),
              Color(0xFF020617),
              Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              const PrimeXSidebar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      PrimeXHero(),
                      SizedBox(height: 24),
                      PrimeXStats(),
                      SizedBox(height: 24),
                      PrimeXListings(),
                      SizedBox(height: 24),
                      PrimeXFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimeXSidebar extends StatelessWidget {
  const PrimeXSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ['🏠', 'Dashboard'],
      ['🗺️', 'Map'],
      ['▦', 'Categories'],
      ['➕', 'Post'],
      ['📰', 'Feed'],
      ['💬', 'Messages'],
      ['♡', 'Saved'],
      ['🛡️', 'Admin'],
    ];

    return Container(
      width: 260,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF020617).withOpacity(.95),
        border: Border(
          right: BorderSide(color: PrimeXTheme.neonBlue.withOpacity(.4)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Prime',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'X',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: PrimeXTheme.neonBlue,
                    shadows: [
                      Shadow(color: PrimeXTheme.neonBlue, blurRadius: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'M A R K E T P L A C E',
            style: TextStyle(letterSpacing: 5, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          const Text(
            'BUY • SELL • CONNECT',
            style: TextStyle(
              color: PrimeXTheme.cyan,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 28),
          ...items.map((item) {
            final active = item[1] == 'Dashboard';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                color: active ? PrimeXTheme.electricBlue.withOpacity(.75) : Colors.black.withOpacity(.3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: PrimeXTheme.neonBlue.withOpacity(.55)),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: PrimeXTheme.neonBlue.withOpacity(.5),
                          blurRadius: 18,
                        )
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Text(item[0], style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 14),
                  Text(
                    item[1],
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: PrimeXTheme.neonCard,
            child: const Column(
              children: [
                Text('POWERED BY', style: TextStyle(color: PrimeXTheme.cyan, letterSpacing: 4)),
                SizedBox(height: 8),
                Text('SYNTAX PHANTOM', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('@ 2026', style: TextStyle(color: PrimeXTheme.cyan, letterSpacing: 4)),
                SizedBox(height: 8),
                Text(
                  'PHILIPPIANS IV:13',
                  style: TextStyle(color: PrimeXTheme.cyan, fontSize: 11, letterSpacing: 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrimeXHero extends StatelessWidget {
  const PrimeXHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: PrimeXTheme.neonCard,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PRIMEX MARKETPLACE',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: PrimeXTheme.neonBlue, blurRadius: 22),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'The global marketplace for real estate, foreclosures, services, jobs, vehicles, tools, and business listings.',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    neonButton('Browse Listings'),
                    const SizedBox(width: 14),
                    outlineButton('Post Listing'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 360,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.45),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: PrimeXTheme.neonBlue.withOpacity(.7)),
            ),
            child: const Column(
              children: [
                filterBox('Country', 'United States'),
                filterBox('State', 'Pennsylvania'),
                filterBox('County', 'Cambria County'),
                filterBox('City', 'Johnstown'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget neonButton(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
    decoration: PrimeXTheme.neonButton,
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget outlineButton(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: PrimeXTheme.neonBlue),
    ),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

class filterBox extends StatelessWidget {
  final String label;
  final String value;
  const filterBox(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF06111F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PrimeXTheme.neonBlue.withOpacity(.45)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class PrimeXStats extends StatelessWidget {
  const PrimeXStats({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      ['Active Listings', '1'],
      ['Views Today', '1,245'],
      ['PrimeX Plan', 'Investor'],
      ['Messages', '3'],
    ];

    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(22),
            decoration: PrimeXTheme.neonCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s[0], style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Text(
                  s[1],
                  style: const TextStyle(
                    fontSize: 30,
                    color: PrimeXTheme.cyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class PrimeXListings extends StatelessWidget {
  const PrimeXListings({super.key});

  @override
  Widget build(BuildContext context) {
    final listings = [
      ['FORECLOSURE', 'Single Family Home', 'Johnstown, PA', '89,900'],
      ['PRE-FORECLOSURE', 'Investment Property', 'Bushkill, PA', '74,500'],
      ['BANK OWNED', 'Bank Owned Home', 'Cambria County, PA', '66,000'],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LIVE FEED',
          style: TextStyle(
            fontSize: 28,
            color: PrimeXTheme.cyan,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: listings.map((l) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(18),
                decoration: PrimeXTheme.neonCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l[0], style: const TextStyle(color: PrimeXTheme.cyan, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 80),
                    Text(l[1], style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('📍 ${l[2]}', style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 12),
                    Text(
                      '${l[3]} dollars',
                      style: const TextStyle(
                        color: PrimeXTheme.cyan,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: outlineButton('View')),
                        const SizedBox(width: 8),
                        Expanded(child: outlineButton('Save')),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class PrimeXFooter extends StatelessWidget {
  const PrimeXFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: PrimeXTheme.neonCard,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('syntax.phantom@primexmarketplace.com'),
          Text('Powered by Syntax Phantom @ 2026'),
          Text('Philippians IV:13'),
        ],
      ),
    );
  }
}
DART

flutter clean
flutter pub get
flutter analyze || true
flutter build web --release

echo "🔥 PrimeX neon website updated."
echo "Now test it:"
echo "flutter run -d chrome"
echo "Then deploy:"
echo "firebase deploy --only hosting"
