#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_broken_backup_$(date +%Y%m%d_%H%M%S).dart"

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

class PrimeXHome extends StatefulWidget {
  const PrimeXHome({super.key});

  @override
  State<PrimeXHome> createState() => _PrimeXHomeState();
}

class _PrimeXHomeState extends State<PrimeXHome> {
  int page = 0;

  static const cyan = Color(0xFF00F5FF);
  static const blue = Color(0xFF006BFF);
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
      mapPage(),
      postListing(),
      messages(),
      offers(),
      admin(),
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
        height: 112,
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      );

  Widget home() => Column(children: [
        SizedBox(
          height: 610,
          child: Stack(children: [
            Positioned.fill(child: CustomPaint(painter: HeroPainter())),
            Positioned(
              left: 36,
              top: 88,
              width: 440,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('THE #1 MARKETPLACE FOR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                const Text('EVERYTHING', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900)),
                const Text('YOU NEED', style: TextStyle(fontSize: 42, color: cyan, fontWeight: FontWeight.w900, shadows: [Shadow(color: cyan, blurRadius: 18)])),
                const SizedBox(height: 20),
                const Text(
                  'PrimeX Marketplace connects serious buyers and sellers for real estate, foreclosures, services, vehicles, jobs, tools, and business listings.',
                  style: TextStyle(fontSize: 16, height: 1.55, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 26),
                Row(children: [
                  smallBtn('Login To Browse →', () => go(5)),
                  const SizedBox(width: 14),
                  smallBtn('Sign Up To Post +', () => go(6), outline: true),
                ]),
              ]),
            ),
            Positioned(right: 32, top: 110, child: searchBox()),
          ]),
        ),
        featureBar(),
        footer(),
      ]);

  Widget dashboard() => futurePage('User Dashboard', 'Marketplace tools live here after login.', [
        dashTile('🛒', 'Marketplace', 'Browse listings, save opportunities, message sellers, call, and make offers.', () => go(8)),
        dashTile('🗺', 'Map', 'View category pins. PrimeX Pro unlocks foreclosure and tax-sale lead details.', () => go(9)),
        dashTile('➕', 'Post a Listing', 'Create posts for real estate, rentals, vehicles, services, jobs, tools, and business opportunities.', () => go(10)),
        dashTile('💬', 'Messages', 'Secure buyer and seller messaging inside PrimeX.', () => go(11)),
        dashTile('💰', 'Offers + Proof of Funds', 'Submit serious offers and upload proof of funds.', () => go(12)),
        dashTile('📊', 'Admin Access', 'Admin-only moderation, AI alerts, analytics, revenue, and security tools.', () => go(13)),
      ]);

  Widget marketplace() => futurePage('Marketplace Inside Dashboard', 'Marketplace is private inside the dashboard. Foreclosure and tax-sale leads unlock through PrimeX Pro.', [
        listingTile('REAL ESTATE', 'Single Family Home', 'Johnstown, PA', '89,900 dollars', '🔵'),
        listingTile('FORECLOSURE', 'PrimeX Pro Foreclosure Lead', 'Cambria County, PA', '49.99 Pro unlock', '🟡'),
        listingTile('TAX SALE', 'Tax Sale Lead', 'Monroe County, PA', '49.99 Pro unlock', '🟡'),
        listingTile('SERVICE', 'Property Field Inspector', 'Pennsylvania', 'Book service', '🟢'),
      ]);

  Widget mapPage() => futurePage('PrimeX Map', 'Map pins show listings by category. Premium lead details unlock with PrimeX Pro.', [
        card('🔵', 'Real Estate Pin', 'Single Family Home • Johnstown, PA • 89,900 dollars'),
        card('🟡', 'Foreclosure Pin', 'PrimeX Pro foreclosure lead • Cambria County, PA'),
        card('🟢', 'Service Pin', 'Property Field Inspector • Pennsylvania'),
        card('🟠', 'Job Pin', 'Photo Runner Job • Johnstown, PA'),
      ]);

  Widget postListing() => futurePage('Post a Listing', 'Create a listing for real estate, rentals, vehicles, services, jobs, tools, or business opportunities.', [
        field('Listing Title'),
        field('Category'),
        field('Price or Rate'),
        field('Country / State / County / City'),
        field('Description'),
        field('Upload Photos / Video'),
        fullBtn('Publish Listing For Review', () => snack('Listing submitted for review.')),
      ]);

  Widget messages() => futurePage('PrimeX Messages', 'Secure buyer and seller messaging stays inside PrimeX.', [
        card('🛡', 'System', 'Keep conversations inside PrimeX for safety.'),
        card('👤', 'Buyer', 'Is this listing still available?'),
        card('🏠', 'Seller', 'Yes. You can message, call, save, or make an offer.'),
        field('Type your message here'),
        fullBtn('Send Message', () => snack('Message sent.')),
      ]);

  Widget offers() => futurePage('Offers + Proof of Funds', 'Submit serious offers with financing details and proof of funds.', [
        field('Offer Amount'),
        field('Financing Type: Cash / FHA / VA / Hard Money / Seller Financing'),
        field('Buyer Type: Investor / Realtor / Owner Occupant'),
        field('Upload Proof of Funds PDF / JPG / PNG'),
        field('Message To Seller'),
        fullBtn('Submit Verified Offer', () => snack('Offer submitted with proof of funds.')),
      ]);

  Widget admin() => futurePage('Admin Command Center', 'Admin-only controls for AI safety, moderation, revenue, security, users, and analytics.', [
        card('🤖', 'AI Autopilot', 'Flags scams, harassment, discrimination, nudity, sexual solicitation, fraud, spam, fake listings, bots, and suspicious behavior.'),
        card('🔐', 'Cyber Security Shield', 'Monitors suspicious logins, account takeover attempts, identity theft patterns, bot activity, and platform abuse.'),
        card('📊', 'Revenue Analytics', 'Track listing fees, boosts, PrimeX Pro, foreclosure leads, tax-sale leads, and active users.'),
        card('🚫', 'Moderation Tools', 'Warn users, remove listings, suspend accounts, ban repeat offenders, and review flagged activity.'),
      ]);

  Widget howItWorks() => futurePage('How PrimeX Works', 'A secure AI-powered marketplace dashboard for buying, selling, posting, searching, messaging, calling, mapping, and verified offers.', [
        card('👤', 'Create Your Account', 'Users sign up as buyers, sellers, investors, realtors, contractors, employers, or service providers.'),
        card('🗺', 'Dashboard Map + Pins', 'Listings appear on the map by category: real estate, jobs, services, vehicles, tools, rentals, foreclosures, and tax sales.'),
        card('💬', 'Message, Call, Save', 'PrimeX keeps communication inside the platform with secure messages, direct call actions, and saved listings.'),
        card('💰', 'Offers + Proof of Funds', 'Serious buyers can submit offers and upload proof of funds before sellers review high-value deals.'),
        card('🛡', 'AI Autopilot Safety', 'AI monitors scams, fraud, harassment, discrimination, nudity, sexual solicitation, fake listings, spam, bots, and suspicious activity.'),
        card('🔐', 'Security Shield', 'Security Shield supports account protection, suspicious login review, identity protection, bot detection, and admin alerts.'),
      ]);

  Widget about() => futurePage('About PrimeX Marketplace', 'A futuristic professional marketplace powered by Syntax Phantom, built to connect serious users while protecting the platform.', [
        card('⚡', 'Built for Serious Marketplace Activity', 'PrimeX brings together real estate, foreclosures, rentals, vehicles, services, jobs, tools, commercial listings, business opportunities, investors, contractors, realtors, employers, and verified users.'),
        card('🌎', 'Global Marketplace Vision', 'PrimeX is designed for local, nationwide, and global search by region, country, state, county, city, category, and listing type.'),
        card('🔒', 'Public Site + Member Dashboard', 'The public website explains the platform. Marketplace activity lives inside the dashboard after login.'),
        card('🤖', 'AI + Admin Protection', 'AI Autopilot and admin tools help reduce scams, adult content, harassment, discrimination, fake listings, spam, abuse, and cyber threats.'),
      ]);

  Widget pricing() => futurePage('Pricing', 'Simple PrimeX pricing for listings, boosts, leads, and PrimeX Pro.', [
        card('🏠', 'Realtor/Broker Listing', '5 dollars / 35 days'),
        card('🚗', 'Vehicle Listing', '5 dollars / 35 days'),
        card('⚡', 'Boost 4 Days', '7.99'),
        card('🚀', 'Boost 15 Days', '14.99'),
        card('🏚', 'Foreclosure Lead', '9.99 per lead'),
        card('👑', 'PrimeX Pro', '49.99 per month for unlimited foreclosure leads'),
      ]);

  Widget contact() => futurePage('Contact', 'Reach PrimeX Marketplace and Syntax Phantom support.', [
        card('📧', 'Email', 'syntax.phantom@primexmarketplace.com'),
        card('🌐', 'Website', 'primexmarketplace.com'),
        card('📍', 'Location', 'PA'),
        card('⚡', 'Powered By', 'Syntax Phantom @ 2026'),
      ]);

  Widget login() => futurePage('Login', 'Access the PrimeX member dashboard.', [
        field('Email'),
        field('Password'),
        fullBtn('Login To Dashboard', () => go(7)),
      ]);

  Widget signup() => futurePage('Sign Up', 'Create your PrimeX account.', [
        field('Full Name'),
        field('Email'),
        field('Phone'),
        field('Password'),
        fullBtn('Create Account + Open Dashboard', () => go(7)),
      ]);

  Widget searchBox() => Container(
        width: 330,
        padding: const EdgeInsets.all(16),
        decoration: glassBox(),
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

  Widget futurePage(String title, String subtitle, List<Widget> children) => Padding(
        padding: const EdgeInsets.all(28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: futureBox(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: cyan, fontSize: 34, fontWeight: FontWeight.w900, shadows: [Shadow(color: cyan, blurRadius: 18)])),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)),
            const SizedBox(height: 22),
            ...children,
            verseBox(),
          ]),
        ),
      );

  Widget dashTile(String icon, String title, String body, VoidCallback onTap) => InkWell(onTap: onTap, child: card(icon, title, body));

  Widget card(String icon, String title, String body) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: glassBox(),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: cyan, fontSize: 19, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(body, style: const TextStyle(fontSize: 15, height: 1.55)),
          ])),
        ]),
      );

  Widget listingTile(String tag, String title, String loc, String price, String pin) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: glassBox(),
        child: Row(children: [
          Text(pin, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$tag • $title', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('$loc • $price', style: const TextStyle(color: cyan)),
          ])),
          smallBtn('Message', () => go(11), outline: true),
          const SizedBox(width: 8),
          smallBtn('Call', () => snack('Calling seller...'), outline: true),
          const SizedBox(width: 8),
          smallBtn('Offer', () => go(12)),
        ]),
      );

  Widget featureBar() {
    final data = [
      ['🌎', 'GLOBAL'], ['🛡', 'AI SAFETY'], ['🔐', 'SECURITY'], ['💰', 'OFFERS'],
      ['💬', 'MESSAGES'], ['📞', 'CALLS'], ['🗺', 'MAP'], ['📊', 'ANALYTICS'],
    ];
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: glassBox(),
      child: Row(children: data.map((i) => Expanded(child: Column(children: [
        Text(i[0], style: const TextStyle(fontSize: 24)),
        Text(i[1], textAlign: TextAlign.center, style: const TextStyle(color: cyan, fontSize: 10, fontWeight: FontWeight.bold)),
      ]))).toList()),
    );
  }

  Widget pill(String t, bool active) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: active ? blue : Colors.black.withOpacity(.45), borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text(t, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
      );

  Widget field(String text) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.black.withOpacity(.65), borderRadius: BorderRadius.circular(8), border: Border.all(color: cyan.withOpacity(.35))),
        child: Row(children: [Text(text), const Spacer()]),
      );

  Widget smallBtn(String text, VoidCallback onTap, {bool outline = false}) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: outline ? Colors.black.withOpacity(.4) : blue, border: Border.all(color: blue), borderRadius: BorderRadius.circular(8)),
          child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      );

  Widget fullBtn(String text, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold))),
        ),
      );

  Widget verseBox() => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.black.withOpacity(.62), borderRadius: BorderRadius.circular(14), border: Border.all(color: cyan.withOpacity(.55))),
        child: const Text(
          'Philippians 4:13 — I can do all things through Christ who strengthens me.\nPowered by Syntax Phantom @ 2026',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 15, letterSpacing: 1.1, height: 1.5),
        ),
      );

  Widget footer() => Container(
        padding: const EdgeInsets.all(24),
        color: Colors.black,
        child: const Text('PrimeX Marketplace — Buy. Sell. Connect. | Philippians 4:13 | Powered by Syntax Phantom @ 2026', style: TextStyle(color: cyan)),
      );

  BoxDecoration glassBox() => BoxDecoration(
        color: const Color(0xCC050B18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: blue.withOpacity(.85)),
        boxShadow: [BoxShadow(color: blue.withOpacity(.32), blurRadius: 18)],
      );

  BoxDecoration futureBox() => BoxDecoration(
        gradient: LinearGradient(colors: [
          const Color(0xFF02040D),
          const Color(0xFF062A68).withOpacity(.82),
          const Color(0xFF02040D),
        ]),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cyan.withOpacity(.9), width: 1.4),
        boxShadow: [
          BoxShadow(color: blue.withOpacity(.40), blurRadius: 34),
          BoxShadow(color: cyan.withOpacity(.18), blurRadius: 48),
        ],
      );

  void snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class PrimeXLogo extends StatelessWidget {
  const PrimeXLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 420, height: 105, child: CustomPaint(painter: PrimeXLogoPainter()));
  }
}

class PrimeXLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cyan = Color(0xFF00F5FF);
    const blue = Color(0xFF006BFF);

    final rect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 8, size.width - 8, size.height - 16), const Radius.circular(24));
    canvas.drawRRect(rect, Paint()..shader = const LinearGradient(colors: [Color(0xFF01030A), Color(0xFF061A4D), Color(0xFF02040D)]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.drawRRect(rect, Paint()..color = cyan..style = PaintingStyle.stroke..strokeWidth = 1.8);
    canvas.drawRRect(rect, Paint()..color = blue.withOpacity(.35)..style = PaintingStyle.stroke..strokeWidth = 5..maskFilter = const MaskFilter.blur(BlurStyle.outer, 18));

    final prime = TextPainter(
      text: const TextSpan(children: [
        TextSpan(text: 'PRIME', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: .8)),
        TextSpan(text: 'X', style: TextStyle(color: cyan, fontSize: 48, fontWeight: FontWeight.w900, shadows: [Shadow(color: cyan, blurRadius: 20), Shadow(color: blue, blurRadius: 36)])),
      ]),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 250);
    prime.paint(canvas, const Offset(22, 10));

    final market = TextPainter(
      text: const TextSpan(text: 'MARKETPLACE', style: TextStyle(color: cyan, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2.1)),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 220);
    market.paint(canvas, const Offset(24, 62));

    final tag = TextPainter(
      text: const TextSpan(text: 'BUY • SELL • CONNECT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.6)),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 230);
    tag.paint(canvas, const Offset(24, 82));

    final ai = RRect.fromRectAndRadius(Rect.fromLTWH(size.width - 82, 29, 56, 46), const Radius.circular(16));
    canvas.drawRRect(ai, Paint()..color = Colors.black.withOpacity(.58));
    canvas.drawRRect(ai, Paint()..color = cyan..style = PaintingStyle.stroke..strokeWidth = 1.5);

    final aiText = TextPainter(
      text: const TextSpan(text: 'AI', style: TextStyle(color: cyan, fontSize: 19, fontWeight: FontWeight.w900, shadows: [Shadow(color: cyan, blurRadius: 14)])),
      textDirection: TextDirection.ltr,
    )..layout();
    aiText.paint(canvas, Offset(size.width - 62, 41));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cyan = Color(0xFF00F5FF);
    const blue = Color(0xFF006BFF);
    const purple = Color(0xFF9D4DFF);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..shader = const LinearGradient(colors: [Colors.black, Color(0xFF08256B), Colors.black]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

    for (int i = 0; i < 160; i++) {
      canvas.drawCircle(Offset(((i * 83) % size.width).toDouble(), ((i * 47) % size.height).toDouble()), i % 5 == 0 ? 1.8 : .8, Paint()..color = cyan.withOpacity(.55));
    }

    final base = size.height * .90;
    final start = size.width * .33;
    final end = size.width * .83;
    final hs = [130, 210, 160, 300, 240, 390, 270, 450, 210, 340, 280, 420, 230, 360, 190, 310, 260, 440];
    final bw = (end - start) / hs.length;

    for (int i = 0; i < hs.length; i++) {
      final h = hs[i].toDouble();
      final x = start + i * bw;
      final top = base - h;
      final c = i.isEven ? cyan : purple;

      canvas.drawRect(Rect.fromLTWH(x + 4, top, bw - 8, h), Paint()..color = Colors.black.withOpacity(.78));
      canvas.drawRect(Rect.fromLTWH(x + 4, top, bw - 8, h), Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = 1.8);

      for (double y = top + 20; y < base - 10; y += 20) {
        canvas.drawRect(Rect.fromLTWH(x + 12, y, bw - 24, 3), Paint()..color = c.withOpacity(.9));
      }
    }

    canvas.drawLine(Offset(0, base), Offset(size.width, base), Paint()..color = cyan..strokeWidth = 3);
    canvas.drawCircle(Offset(size.width * .63, size.height * .40), 170, Paint()..color = blue.withOpacity(.18)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
DART

flutter clean
flutter pub get
flutter run -d chrome
