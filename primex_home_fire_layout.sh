#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_home_fire_$(date +%Y%m%d_%H%M%S).dart"

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
      profile(),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            nav(),
            pages[page],
          ],
        ),
      ),
    );
  }

  Widget nav() => Container(
        height: 96,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        color: Colors.black,
        child: Row(
          children: [
            InkWell(onTap: () => go(0), child: const PrimeXLogo()),
            const Spacer(),
            navItem('Home', 0),
            navItem('How It Works', 1),
            navItem('About Us', 2),
            navItem('Pricing', 3),
            navItem('Contact', 4),
            const SizedBox(width: 14),
            btn('Login', () => go(5), outline: true),
            const SizedBox(width: 10),
            btn('Sign Up', () => go(6)),
          ],
        ),
      );

  Widget navItem(String text, int i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: InkWell(
          onTap: () => go(i),
          child: Text(
            text,
            style: TextStyle(
              color: page == i ? cyan : Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ),
      );

  Widget home() {
    final cats = [
      ['🏠', 'REAL ESTATE', 'Homes, Land,\nApartments'],
      ['🔨', 'FORECLOSURES', 'Bank Owned,\nGreat Deals'],
      ['🏢', 'RENTALS', 'Homes, Apts,\nRooms'],
      ['🚘', 'VEHICLES', 'Cars, Trucks,\nRVs, Boats'],
      ['🛠', 'TOOLS', 'Power Tools,\nEquipment'],
      ['🛋', 'FURNITURE', 'Home, Office,\nOutdoor'],
      ['💼', 'JOBS', 'Full-Time,\nPart-Time'],
      ['🤝', 'SERVICES', 'Local Services,\nProfessionals'],
      ['🏪', 'BUSINESS', 'Businesses,\nFranchises'],
      ['💻', 'ELECTRONICS', 'Phones,\nLaptops'],
      ['🐾', 'PETS', 'Dogs, Cats,\nAnimals'],
      ['🚜', 'FARM', 'Garden,\nSupplies'],
      ['👕', 'FASHION', 'Clothing,\nAccessories'],
      ['⚽', 'HOBBIES', 'Gear, Games,\nCollectibles'],
      ['🎓', 'EDUCATION', 'Courses,\nBooks'],
      ['⋯', 'MORE', 'And Much\nMore'],
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 22),
      child: Container(
        decoration: fireBox(),
        child: Column(
          children: [
            SizedBox(
              height: 520,
              child: Stack(
                children: [
                  Positioned.fill(child: CustomPaint(painter: MapHeroPainter())),
                  Positioned(
                    left: 28,
                    top: 58,
                    width: 430,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('THE #1 MARKETPLACE FOR',
                            style: TextStyle(fontSize: 22, letterSpacing: 1.5, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        const Text('EVERYTHING',
                            style: TextStyle(fontSize: 54, fontWeight: FontWeight.w900)),
                        const Text('YOU NEED',
                            style: TextStyle(
                              fontSize: 54,
                              color: cyan,
                              fontWeight: FontWeight.w900,
                              shadows: [Shadow(color: cyan, blurRadius: 22)],
                            )),
                        const SizedBox(height: 18),
                        const Text(
                          'PrimeX connects serious buyers and sellers for real estate, foreclosures, rentals, vehicles, jobs, tools, services, and business opportunities.',
                          style: TextStyle(fontSize: 16, height: 1.45),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            btn('🔒  LOGIN TO BROWSE  →', () => go(5)),
                            const SizedBox(width: 14),
                            btn('👤  SIGN UP TO POST  +', () => go(6), outline: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pin(520, 60, '🏠', 'HOUSE', 'Johnstown, PA\n189,900 dollars', Colors.greenAccent),
                  pin(760, 45, '🚘', 'CAR', 'Pittsburgh, PA\n15,900 dollars', Colors.lightBlueAccent),
                  pin(1020, 60, '🛠', 'TOOLS', 'Altoona, PA\n199 dollars', Colors.amberAccent),
                  pin(560, 255, '💼', 'JOB', 'Remote, USA\n65,000/yr', Colors.purpleAccent),
                  pin(800, 260, '🔧', 'SERVICE', 'Cambria County, PA\nDeck Builder', cyan),
                  pin(1030, 260, '🏪', 'COMMERCIAL', 'State College, PA\n325,000 dollars', Colors.orangeAccent),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: cyan.withOpacity(.65)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  MiniFeature(icon: '🤖', title: 'AI SAFETY'),
                  MiniFeature(icon: '🔐', title: 'SECURITY SHIELD'),
                  MiniFeature(icon: '💰', title: 'OFFERS & FUNDS'),
                  MiniFeature(icon: '💬', title: 'MESSAGES'),
                  MiniFeature(icon: '📞', title: 'CALLS'),
                  MiniFeature(icon: '📍', title: 'LIVE MAP PINS'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 8, 26, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('BROWSE EVERYTHING',
                      style: TextStyle(color: cyan, fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 8,
                    childAspectRatio: 1.18,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: cats.map((c) => categoryBox(c[0], c[1], c[2])).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
              child: Row(
                children: [
                  Expanded(child: bottomFeature('🤖', 'AI AUTOPILOT', 'Detects scams, fraud, harassment, discrimination, spam, fake listings, and bots.')),
                  Expanded(child: bottomFeature('💬', 'SECURE MESSAGING', 'Chat, call, and negotiate safely inside PrimeX Marketplace.')),
                  Expanded(child: bottomFeature('💰', 'OFFERS & PROOF OF FUNDS', 'Submit serious offers with proof of funds verification.')),
                  Expanded(child: bottomFeature('📍', 'LIVE MAP PINS', 'Find listings near you with live category map pins.')),
                  Expanded(child: bottomFeature('🚀', 'BOOST & PROMOTE', 'Boost your listings to get more views and sell faster.')),
                  Expanded(child: bottomFeature('🌎', 'GLOBAL ACCESS', 'Connect with serious buyers and sellers around the globe.')),
                ],
              ),
            ),
            footer(),
          ],
        ),
      ),
    );
  }

  Widget pin(double left, double top, String icon, String title, String body, Color color) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.72),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 1.5),
          boxShadow: [BoxShadow(color: color.withOpacity(.55), blurRadius: 22)],
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 34)),
            const SizedBox(width: 9),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 15)),
                Text(body, style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.25)),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryBox(String icon, String title, String body) => Container(
        padding: const EdgeInsets.all(8),
        decoration: glass(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 5),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(color: cyan, fontWeight: FontWeight.w900, fontSize: 12)),
            const SizedBox(height: 4),
            Text(body, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 10, height: 1.25)),
          ],
        ),
      );

  Widget bottomFeature(String icon, String title, String body) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(12),
        decoration: glass(),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(color: cyan, fontWeight: FontWeight.w900, fontSize: 11)),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(fontSize: 10, height: 1.25)),
              ]),
            ),
          ],
        ),
      );

  Widget dashboard() => pageBox('User Dashboard', 'Marketplace tools live here after login.', [
        tile('🛒', 'Marketplace', 'Browse listings, save opportunities, message sellers, call, and make offers.', () => go(8)),
        tile('🗺', 'Map', 'View category pins. PrimeX Pro unlocks foreclosure and tax-sale lead details.', () => go(9)),
        tile('➕', 'Post a Listing', 'Post real estate, rentals, vehicles, services, jobs, tools, and business opportunities.', () => go(10)),
        tile('💬', 'Messages', 'Secure buyer and seller messaging inside PrimeX.', () => go(11)),
        tile('💰', 'Offers + Proof of Funds', 'Submit offers and upload proof of funds.', () => go(12)),
        tile('👤', 'My Profile', 'Photo, address, phone, email, payment method, and password reset.', () => go(14)),
        tile('📊', 'Admin Access', 'Moderation, AI alerts, analytics, revenue, and security tools.', () => go(13)),
      ]);

  Widget marketplace() => pageBox('Marketplace', 'Private marketplace inside dashboard.', [
        listing('REAL ESTATE', 'Single Family Home', 'Johnstown, PA', '89,900 dollars'),
        listing('FORECLOSURE', 'PrimeX Pro Lead', 'Cambria County, PA', '49.99 Pro unlock'),
        listing('TAX SALE', 'Tax Sale Lead', 'Monroe County, PA', '49.99 Pro unlock'),
        listing('SERVICE', 'Property Field Inspector', 'Pennsylvania', 'Book service'),
      ]);

  Widget mapPage() => pageBox('PrimeX Map', 'Hard-coded category pins now. Google Map/Firebase live pins next.', [
        card('🔵', 'Real Estate Pin', 'Single Family Home • Johnstown, PA'),
        card('🟡', 'Foreclosure Pin', 'PrimeX Pro foreclosure lead • Cambria County, PA'),
        card('🟢', 'Service Pin', 'Property Field Inspector • Pennsylvania'),
        card('🟠', 'Job Pin', 'Photo Runner Job • Johnstown, PA'),
      ]);

  Widget postListing() => pageBox('Post a Listing', 'Create and submit listing for review.', [
        field('Listing Title'),
        field('Category'),
        field('Price or Rate'),
        field('Address'),
        field('Country / State / County / City'),
        field('Description'),
        field('Upload Photos / Video'),
        fullBtn('Publish Listing For Review', () => snack('Listing submitted for review.')),
      ]);

  Widget messages() => pageBox('PrimeX Messages', 'Secure buyer and seller messaging stays inside PrimeX.', [
        card('🛡', 'System', 'Keep conversations inside PrimeX for safety.'),
        card('👤', 'Buyer', 'Is this listing still available?'),
        card('🏠', 'Seller', 'Yes. You can message, call, save, or make an offer.'),
        field('Type your message here'),
        fullBtn('Send Message', () => snack('Message sent.')),
      ]);

  Widget offers() => pageBox('Offers + Proof of Funds', 'Submit serious offers with financing details.', [
        field('Offer Amount'),
        field('Financing Type'),
        field('Upload Proof of Funds PDF / JPG / PNG'),
        field('Message To Seller'),
        fullBtn('Submit Verified Offer', () => snack('Offer submitted with proof of funds.')),
      ]);

  Widget profile() => pageBox('My Profile + Account Settings', 'Manage account identity, contact, payment, and security.', [
        card('👤', 'Profile Photo', 'Upload or update your profile picture.'),
        fullBtn('Upload Profile Photo', () => snack('Photo upload will connect to Firebase Storage.')),
        field('Full Name'),
        field('Email Address'),
        field('Phone Number'),
        field('Street Address'),
        field('City / State / ZIP'),
        field('Payment Method'),
        fullBtn('Add Payment Method', () => snack('Payment method will connect to Stripe.')),
        fullBtn('Send Password Reset Email', () => snack('Password reset email sent.')),
        fullBtn('Save Profile', () => snack('Profile saved.')),
      ]);

  Widget admin() => pageBox('Admin Command Center', 'Admin-only AI safety, revenue, and security.', [
        card('🤖', 'AI Autopilot', 'Flags scams, harassment, discrimination, nudity, sexual solicitation, fake listings, bots, and suspicious behavior.'),
        card('🔐', 'Cyber Security Shield', 'Monitors suspicious logins, account takeover attempts, and identity theft patterns.'),
        card('📊', 'Revenue Analytics', 'Track listing fees, boosts, PrimeX Pro, leads, and users.'),
        card('🚫', 'Moderation Tools', 'Warn, remove listings, suspend, ban, and review flagged activity.'),
      ]);

  Widget howItWorks() => pageBox('How PrimeX Works', 'Secure AI-powered marketplace dashboard.', [
        card('👤', 'Create Account', 'Sign up as buyer, seller, realtor, investor, contractor, employer, or service provider.'),
        card('🗺', 'Map + Pins', 'Listings appear by category pins.'),
        card('💬', 'Message, Call, Save', 'Keep activity inside PrimeX.'),
        card('💰', 'Offers + Proof of Funds', 'Submit serious offers with proof of funds.'),
        card('🛡', 'AI Autopilot', 'Monitors scams, fraud, harassment, discrimination, nudity, solicitation, fake listings, spam, and bots.'),
      ]);

  Widget about() => pageBox('About PrimeX Marketplace', 'Professional marketplace powered by Syntax Phantom.', [
        card('⚡', 'Serious Marketplace Activity', 'PrimeX connects real estate, foreclosures, vehicles, jobs, tools, services, investors, and business opportunities.'),
        card('🌎', 'Global Vision', 'Search by country, state, county, city, and category.'),
        card('🤖', 'AI + Admin Protection', 'AI Autopilot and admin tools help protect the platform.'),
      ]);

  Widget pricing() => pageBox('Pricing', 'Simple PrimeX pricing.', [
        card('🏠', 'Realtor/Broker Listing', '5 dollars / 35 days'),
        card('🚗', 'Vehicle Listing', '5 dollars / 35 days'),
        card('⚡', 'Boost 4 Days', '7.99'),
        card('🚀', 'Boost 15 Days', '14.99'),
        card('🏚', 'Foreclosure Lead', '9.99 per lead'),
        card('👑', 'PrimeX Pro', '49.99 per month'),
      ]);

  Widget contact() => pageBox('Contact', 'Reach PrimeX Marketplace.', [
        card('📧', 'Email', 'syntax.phantom@primexmarketplace.com'),
        card('🌐', 'Website', 'primexmarketplace.com'),
        card('📍', 'Location', 'PA'),
      ]);

  Widget login() => pageBox('Login', 'Access dashboard.', [
        field('Email'),
        field('Password'),
        fullBtn('Login To Dashboard', () => go(7)),
      ]);

  Widget signup() => pageBox('Sign Up', 'Create account.', [
        field('Full Name'),
        field('Email'),
        field('Phone'),
        field('Password'),
        fullBtn('Create Account + Open Dashboard', () => go(7)),
      ]);

  Widget pageBox(String title, String subtitle, List<Widget> children) => Padding(
        padding: const EdgeInsets.all(28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: fireBox(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (page != 0)
              Row(children: [
                btn('← Back', () => go(page >= 8 ? 7 : 0), outline: true),
                const SizedBox(width: 10),
                if (page >= 8) btn('Dashboard', () => go(7)),
              ]),
            if (page != 0) const SizedBox(height: 18),
            Text(title, style: const TextStyle(color: cyan, fontSize: 34, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 22),
            ...children,
            verseBox(),
          ]),
        ),
      );

  Widget tile(String icon, String title, String body, VoidCallback onTap) => InkWell(onTap: onTap, child: card(icon, title, body));
  Widget listing(String tag, String title, String loc, String price) => card('📌', '$tag • $title', '$loc • $price');

  Widget card(String icon, String title, String body) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: glass(),
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

  Widget field(String text) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: glass(),
        child: Row(children: [Text(text), const Spacer()]),
      );

  Widget btn(String text, VoidCallback onTap, {bool outline = false}) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: outline ? Colors.black.withOpacity(.42) : cyan,
            border: Border.all(color: cyan),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: cyan.withOpacity(.22), blurRadius: 18)],
          ),
          child: Text(text, style: TextStyle(color: outline ? cyan : Colors.black, fontWeight: FontWeight.w900)),
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
        decoration: glass(),
        child: const Text('Philippians 4:13 — I can do all things through Christ who strengthens me.\nPowered by Syntax Phantom @ 2026', textAlign: TextAlign.center),
      );

  Widget footer() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        child: const Text(
          'PrimeX Marketplace — Buy. Sell. Connect.   ✝   Philippians 4:13 — I can do all things through Christ who strengthens me.   |   Powered by Syntax Phantom © 2026',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
      );

  BoxDecoration glass() => BoxDecoration(
        color: const Color(0xCC050B18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cyan.withOpacity(.7)),
        boxShadow: [BoxShadow(color: blue.withOpacity(.25), blurRadius: 15)],
      );

  BoxDecoration fireBox() => BoxDecoration(
        color: const Color(0xEF02040D),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cyan.withOpacity(.75)),
        boxShadow: [BoxShadow(color: blue.withOpacity(.35), blurRadius: 30)],
      );

  void snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class PrimeXLogo extends StatelessWidget {
  const PrimeXLogo({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 310,
        height: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('PRIME X', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 1.5, shadows: [Shadow(color: Color(0xFF00F5FF), blurRadius: 14)])),
            Text('M A R K E T P L A C E', style: TextStyle(color: Color(0xFF00F5FF), fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 5)),
            Text('— BUY • SELL • CONNECT —', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2)),
          ],
        ),
      );
}

class MiniFeature extends StatelessWidget {
  final String icon;
  final String title;
  const MiniFeature({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Color(0xFF00F5FF), fontSize: 12, fontWeight: FontWeight.w900)),
        ],
      );
}

class MapHeroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cyan = Color(0xFF00F5FF);
    const blue = Color(0xFF006BFF);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const LinearGradient(
          colors: [Colors.black, Color(0xFF04183F), Colors.black],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final mapPaint = Paint()
      ..color = blue.withOpacity(.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final startX = size.width * .38;
    final endX = size.width * .95;
    final topY = 50.0;
    final bottomY = size.height - 60;

    for (int i = 0; i < 20; i++) {
      final y = topY + i * ((bottomY - topY) / 20);
      canvas.drawLine(Offset(startX, y), Offset(endX, y + (i.isEven ? 30 : -20)), mapPaint);
    }

    for (int i = 0; i < 18; i++) {
      final x = startX + i * ((endX - startX) / 18);
      canvas.drawLine(Offset(x, topY), Offset(x + (i.isEven ? 40 : -30), bottomY), mapPaint);
    }

    for (int i = 0; i < 55; i++) {
      final x = startX + ((i * 97) % (endX - startX)).toDouble();
      final y = topY + ((i * 53) % (bottomY - topY)).toDouble();
      canvas.drawCircle(Offset(x, y), i % 5 == 0 ? 3.5 : 2, Paint()..color = cyan.withOpacity(.8));
    }

    final glow = Paint()
      ..color = cyan.withOpacity(.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 55);
    canvas.drawCircle(Offset(size.width * .72, size.height * .44), 210, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
DART

flutter clean
flutter pub get
flutter run -d chrome
