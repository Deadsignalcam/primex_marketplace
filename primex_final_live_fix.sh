#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_FINAL_LIVE_FIX_$(date +%Y%m%d_%H%M%S).dart"

# remove old backup files from grep noise later, but keep them saved outside lib
mkdir -p primex_old_dart_backups
find lib -maxdepth 1 -name "main_backup*.dart" -exec mv {} primex_old_dart_backups/ \; || true

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
      home: const PrimeXShell(),
    );
  }
}

class PrimeXShell extends StatefulWidget {
  const PrimeXShell({super.key});

  @override
  State<PrimeXShell> createState() => _PrimeXShellState();
}

class _PrimeXShellState extends State<PrimeXShell> {
  int page = 0;

  static const blue = Color(0xFF006BFF);
  static const cyan = Color(0xFF00F5FF);
  static const bg = Color(0xFF02040D);

  void go(int i) => setState(() => page = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      home(),
      howItWorks(),
      about(),
      pricing(),
      contact(),
      login(),
      signup(),
      dashboard(),
      marketplace(),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(children: [
          nav(),
          pages[page],
        ]),
      ),
    );
  }

  Widget nav() => Container(
        height: 96,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        color: Colors.black,
        child: Row(children: [
          InkWell(onTap: () => go(0), child: const PrimeXLogo()),
          const Spacer(),
          navItem('Home', 0),
          navItem('How It Works', 1),
          navItem('About Us', 2),
          navItem('Pricing', 3),
          navItem('Contact', 4),
          const SizedBox(width: 12),
          smallBtn('Login', () => go(5), outline: true),
          const SizedBox(width: 10),
          smallBtn('Sign Up', () => go(6)),
        ]),
      );

  Widget navItem(String text, int i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: InkWell(
          onTap: () => go(i),
          child: Text(
            text,
            style: TextStyle(
              color: page == i ? cyan : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      );

  Widget home() => Column(children: [
        SizedBox(
          height: 560,
          child: Stack(children: [
            Positioned.fill(child: CustomPaint(painter: DigitalPainter())),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xEE02040D),
                    Color(0x7702040D),
                    Color(0x2202040D)
                  ]),
                ),
              ),
            ),
            Positioned(
              left: 34,
              top: 82,
              width: 460,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('THE #1 MARKETPLACE FOR',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  const Text('EVERYTHING',
                      style:
                          TextStyle(fontSize: 42, fontWeight: FontWeight.w900)),
                  const Text('YOU NEED',
                      style: TextStyle(
                          fontSize: 38,
                          color: cyan,
                          fontWeight: FontWeight.w900,
                          shadows: [Shadow(color: cyan, blurRadius: 18)])),
                  const SizedBox(height: 18),
                  const Text(
                    'PrimeX Marketplace connects serious buyers and sellers for real estate, foreclosures, services, vehicles, jobs, tools, and business listings.',
                    style: TextStyle(fontSize: 16, height: 1.55),
                  ),
                  const SizedBox(height: 26),
                  Row(children: [
                    smallBtn('Login To Browse →', () => go(5)),
                    const SizedBox(width: 14),
                    smallBtn('Sign Up To Post +', () => go(6), outline: true),
                  ]),
                ],
              ),
            ),
            Positioned(right: 24, top: 96, child: searchPreview()),
          ]),
        ),
        featureBar(),
        footer(),
      ]);

  Widget searchPreview() => Container(
        width: 310,
        padding: const EdgeInsets.all(14),
        decoration: box(),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Expanded(child: pill('FOR SALE', true)),
            Expanded(child: pill('RENTALS', false)),
            Expanded(child: pill('SERVICES', false)),
          ]),
          const SizedBox(height: 12),
          field('🌎 Region / Country'),
          field('📍 State / Province'),
          field('🗺 County'),
          field('🏙 City'),
          const SizedBox(height: 8),
          fullBtn('Login To Search', () => go(5)),
        ]),
      );

  Widget dashboard() => futurePage('User Dashboard',
      'Marketplace tools live here after login. Public website stays clean.', [
    dashTile('Marketplace',
        'Browse listings, save opportunities, message sellers, call, and make offers.',
        () => go(8)),
    dashTile('Map',
        'View listing pins by category. PrimeX Pro unlocks foreclosure and tax-sale lead details.',
        () {}),
    dashTile('Post a Listing',
        'Create posts for real estate, rentals, vehicles, services, jobs, tools, and business opportunities.',
        () {}),
    dashTile('Messages',
        'Secure buyer and seller messaging inside PrimeX.', () {}),
    dashTile('Offers + Proof of Funds',
        'Submit serious offers and upload proof of funds.', () {}),
    dashTile('Admin Access',
        'Admin-only moderation, AI alerts, analytics, and revenue tools.', () {}),
  ]);

  Widget marketplace() => futurePage('Marketplace Inside Dashboard',
      'Marketplace is private inside the dashboard. Foreclosure and tax-sale leads unlock through PrimeX Pro.', [
    listingTile('REAL ESTATE', 'Single Family Home', 'Johnstown, PA',
        '89,900 dollars', '🔵'),
    listingTile('FORECLOSURE', 'PrimeX Pro Foreclosure Lead',
        'Cambria County, PA', '49.99 Pro unlock', '🟡'),
    listingTile('TAX SALE', 'Tax Sale Lead', 'Monroe County, PA',
        '49.99 Pro unlock', '🟡'),
    listingTile('SERVICE', 'Property Field Inspector', 'Pennsylvania',
        'Book service', '🟢'),
  ]);

  Widget howItWorks() => futurePage(
        'How PrimeX Works',
        'A secure AI-assisted marketplace dashboard for buying, selling, investing, hiring, mapping, messaging, calling, and verified offers.',
        [
          futureCard('👤', 'Create Your Account',
              'Users sign up as buyers, sellers, investors, realtors, contractors, employers, or service providers. After login, every user enters a dashboard built around their listings, purchases, messages, saved items, offers, and activity.'),
          futureCard('🗺', 'Dashboard Map + Pins',
              'The map lives inside the dashboard. It shows category pins for real estate, jobs, services, vehicles, tools, rentals, commercial listings, foreclosures, tax sales, and business opportunities.'),
          futureCard('💬', 'Message, Call, Save',
              'PrimeX keeps communication inside the platform with secure messages, direct call actions, saved listings, and seller contact tools.'),
          futureCard('💰', 'Offers + Proof of Funds',
              'Serious buyers can submit offers and upload proof of funds. Foreclosure, REO, tax sale, commercial, investor, and high-value deals can require verification before review.'),
          futureCard('🛡', 'AI Autopilot Safety',
              'PrimeX AI Autopilot monitors harassment, discrimination, hate speech, nudity, sexual content, sexual solicitation, dating-style activity, scams, fraud, spam, fake listings, excessive posting, bot activity, and suspicious behavior.'),
          futureCard('🔐', 'Security Shield',
              'PrimeX Security Shield supports account protection, suspicious login review, bot detection, admin alerts, user identity protection, listing review, and safer marketplace activity.'),
        ],
      );

  Widget about() => futurePage(
        'About PrimeX Marketplace',
        'A futuristic professional marketplace powered by Syntax Phantom, built to connect serious users while protecting the platform.',
        [
          futureCard('⚡', 'Built for Serious Marketplace Activity',
              'PrimeX brings together real estate, foreclosures, rentals, vehicles, services, jobs, tools, commercial listings, business opportunities, investors, contractors, realtors, employers, and verified users in one connected platform.'),
          futureCard('🌎', 'Global Marketplace Vision',
              'PrimeX is designed for local, nationwide, and global activity. Users can search by region, country, state, province, county, city, category, and listing type.'),
          futureCard('🔒', 'Public Site + Member Dashboard',
              'The website explains the platform publicly. Posting, marketplace browsing, map tools, messaging, offers, saved listings, boosts, payments, and subscriptions are handled inside the dashboard.'),
          futureCard('🤖', 'AI + Admin Protection',
              'AI Autopilot and admin review tools help reduce scams, adult content, harassment, discrimination, fake listings, spam, abuse, excessive posting, suspicious accounts, and unsafe platform behavior.'),
          futureCard('💼', 'Powered by Syntax Phantom',
              'PrimeX is built with a future-focused design, secure workflow, professional dashboard structure, and a mission to help people buy, sell, connect, invest, hire, and grow with confidence.'),
        ],
      );

  Widget pricing() => pagePlain(
        'Pricing',
        const Text(
          'Realtor/Broker Listing: 5 dollars / 35 days\nVehicle Listing: 5 dollars / 35 days\nBoost 4 Days: 7.99\nBoost 15 Days: 14.99\nForeclosure Lead: 9.99\nPrimeX Pro: 49.99 per month',
          style: TextStyle(fontSize: 18, height: 1.7),
        ),
      );

  Widget contact() => pagePlain(
        'Contact',
        const Text(
          'syntax.phantom@primexmarketplace.com\nprimexmarketplace.com\nPA\n\nPowered by Syntax Phantom @ 2026',
          style: TextStyle(fontSize: 18, height: 1.7),
        ),
      );

  Widget login() => futurePage('Login', 'Access the PrimeX member dashboard.',
      [field('Email'), field('Password'), fullBtn('Login To Dashboard', () => go(7))]);

  Widget signup() => futurePage('Sign Up', 'Create your PrimeX account.',
      [field('Full Name'), field('Email'), field('Phone'), field('Password'), fullBtn('Create Account + Open Dashboard', () => go(7))]);

  Widget futurePage(String title, String subtitle, List<Widget> children) =>
      Padding(
        padding: const EdgeInsets.all(28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(26),
          decoration: futureBox(),
          child: Stack(children: [
            Positioned.fill(child: CustomPaint(painter: AiFuturePainter())),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      color: cyan,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      shadows: [Shadow(color: cyan, blurRadius: 20)])),
              const SizedBox(height: 8),
              Text(subtitle,
                  style:
                      const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)),
              const SizedBox(height: 22),
              ...children,
              const SizedBox(height: 20),
              verseBox(),
            ]),
          ]),
        ),
      );

  Widget pagePlain(String title, Widget child) => Padding(
        padding: const EdgeInsets.all(28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: box(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(
                    color: cyan, fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 18),
            child,
          ]),
        ),
      );

  Widget futureCard(String icon, String title, String body) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: box(),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(icon, style: const TextStyle(fontSize: 34)),
          const SizedBox(width: 16),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(
                    color: cyan, fontSize: 19, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(body,
                style:
                    const TextStyle(color: Colors.white, fontSize: 15, height: 1.55)),
          ])),
        ]),
      );

  Widget dashTile(String t, String s, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: futureCard('▣', t, s),
      );

  Widget listingTile(String tag, String title, String loc, String price, String pin) =>
      Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: box(),
        child: Row(children: [
          Text(pin, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$tag • $title',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('$loc • $price', style: const TextStyle(color: cyan)),
          ])),
          smallBtn('Message', () {}, outline: true),
          const SizedBox(width: 8),
          smallBtn('Call', () {}, outline: true),
          const SizedBox(width: 8),
          smallBtn('Offer', () {}),
        ]),
      );

  Widget featureBar() {
    final data = [
      ['🌎', 'GLOBAL', 'Worldwide reach'],
      ['🛡', 'AI SAFETY', 'Autopilot review'],
      ['🔐', 'SECURITY', 'Platform shield'],
      ['💰', 'OFFERS', 'Proof of funds'],
      ['💬', 'MESSAGES', 'Secure chat'],
      ['📞', 'CALLS', 'Direct contact'],
      ['🗺', 'MAP', 'Category pins'],
      ['📊', 'ANALYTICS', 'Admin insight'],
    ];
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: box(),
      child: Row(
          children: data
              .map((i) => Expanded(
                      child: Column(children: [
                    Text(i[0], style: const TextStyle(fontSize: 24)),
                    Text(i[1],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: cyan, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(i[2],
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white70, fontSize: 9)),
                  ])))
              .toList()),
    );
  }

  Widget pill(String t, bool active) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: active ? blue : Colors.black.withOpacity(.45),
            borderRadius: BorderRadius.circular(8)),
        child: Center(
            child: Text(t,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
      );

  Widget field(String text) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.65),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cyan.withOpacity(.35)),
        ),
        child: Row(children: [Text(text), const Spacer()]),
      );

  Widget smallBtn(String text, VoidCallback onTap, {bool outline = false}) =>
      InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: outline ? Colors.black.withOpacity(.4) : blue,
            border: Border.all(color: blue),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      );

  Widget fullBtn(String text, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration:
              BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: Text(text,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
        ),
      );

  Widget verseBox() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(.62),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cyan.withOpacity(.55))),
        child: const Text(
          'Philippians 4:13 — I can do all things through Christ who strengthens me.\nPowered by Syntax Phantom @ 2026',
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Colors.white, fontSize: 15, letterSpacing: 1.1, height: 1.5),
        ),
      );

  Widget footer() => Container(
        padding: const EdgeInsets.all(24),
        color: Colors.black,
        child: const Text(
          'PrimeX Marketplace — Buy. Sell. Connect. | Philippians 4:13 | Powered by Syntax Phantom @ 2026',
          style: TextStyle(color: cyan),
        ),
      );

  BoxDecoration box() => BoxDecoration(
        color: const Color(0xCC050B18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: blue.withOpacity(.85)),
        boxShadow: [BoxShadow(color: blue.withOpacity(.32), blurRadius: 18)],
      );

  BoxDecoration futureBox() => BoxDecoration(
        gradient: LinearGradient(colors: [
          const Color(0xFF02040D),
          const Color(0xFF062A68).withOpacity(.78),
          const Color(0xFF02040D)
        ]),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cyan.withOpacity(.9), width: 1.4),
        boxShadow: [
          BoxShadow(color: blue.withOpacity(.40), blurRadius: 34),
          BoxShadow(color: cyan.withOpacity(.18), blurRadius: 48)
        ],
      );
}

class PrimeXLogo extends StatelessWidget {
  const PrimeXLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 245,
      height: 86,
      child: CustomPaint(painter: PrimeXLogoPainter()),
    );
  }
}

class PrimeXLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cyan = Color(0xFF00F5FF);
    const blue = Color(0xFF006BFF);

    final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 8, size.width - 4, size.height - 16),
        const Radius.circular(18));
    canvas.drawRRect(
        r,
        Paint()
          ..shader = const LinearGradient(colors: [
            Color(0xFF02040D),
            Color(0xFF061C4F),
            Color(0xFF02040D)
          ]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.drawRRect(
        r,
        Paint()
          ..color = cyan.withOpacity(.85)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.3);

    final prime = TextPainter(
      text: const TextSpan(children: [
        TextSpan(
            text: 'PRIME',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w900,
                letterSpacing: .5)),
        TextSpan(
            text: 'X',
            style: TextStyle(
                color: cyan,
                fontSize: 38,
                fontWeight: FontWeight.w900,
                shadows: [
                  Shadow(color: cyan, blurRadius: 16),
                  Shadow(color: blue, blurRadius: 30)
                ])),
      ]),
      textDirection: TextDirection.ltr,
    )..layout();
    prime.paint(canvas, const Offset(14, 13));

    final market = TextPainter(
      text: const TextSpan(
          text: 'MARKETPLACE',
          style: TextStyle(
              color: cyan,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 3.4)),
      textDirection: TextDirection.ltr,
    )..layout();
    market.paint(canvas, const Offset(16, 51));

    final tag = TextPainter(
      text: const TextSpan(
          text: 'BUY • SELL • CONNECT',
          style: TextStyle(
              color: Colors.white,
              fontSize: 8.2,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.8)),
      textDirection: TextDirection.ltr,
    )..layout();
    tag.paint(canvas, const Offset(16, 66));

    final aiCircle = Paint()
      ..color = cyan.withOpacity(.12)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width - 35, 43), 20, aiCircle);
    canvas.drawCircle(
        Offset(size.width - 35, 43),
        20,
        Paint()
          ..color = cyan
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2);

    final ai = TextPainter(
      text: const TextSpan(
          text: 'AI',
          style:
              TextStyle(color: cyan, fontSize: 13, fontWeight: FontWeight.w900)),
      textDirection: TextDirection.ltr,
    )..layout();
    ai.paint(canvas, Offset(size.width - 43, 35));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DigitalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cyan = Color(0xFF00F5FF);
    const purple = Color(0xFF9D4DFF);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()
          ..shader = const LinearGradient(colors: [
            Colors.black,
            Color(0xFF08256B),
            Colors.black
          ]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

    final base = size.height * .88;
    final start = size.width * .34;
    final end = size.width * .76;
    final hs = [90, 160, 120, 240, 180, 310, 220, 360, 170, 290, 230, 380];
    final bw = (end - start) / hs.length;

    for (int i = 0; i < hs.length; i++) {
      final h = hs[i].toDouble();
      final x = start + i * bw;
      final top = base - h;
      final c = i.isEven ? cyan : purple;
      canvas.drawRect(Rect.fromLTWH(x + 3, top, bw - 6, h),
          Paint()..color = Colors.black.withOpacity(.78));
      canvas.drawRect(
          Rect.fromLTWH(x + 3, top, bw - 6, h),
          Paint()
            ..color = c
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.6);
      for (double y = top + 18; y < base - 8; y += 18) {
        canvas.drawRect(
            Rect.fromLTWH(x + 10, y, bw - 20, 3),
            Paint()..color = c.withOpacity(.85));
      }
    }
    canvas.drawLine(Offset(0, base), Offset(size.width, base),
        Paint()..color = cyan..strokeWidth = 3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AiFuturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFF00F5FF).withOpacity(.10)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 90) {
      canvas.drawLine(Offset(x, 0), Offset(x + 90, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 70) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 35), grid);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
DART

flutter clean
flutter pub get
flutter build web --release

echo "✅ LIVE lib/main.dart fixed. Run: flutter run -d chrome"
