#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_BACKUP_fire_dashboard_$(date +%Y%m%d_%H%M%S).dart"

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
  String type = 'For Sale';
  String country = 'United States';
  String state = 'Pennsylvania';
  String county = 'Cambria County';
  String city = 'Johnstown';

  static const blue = Color(0xFF006BFF);
  static const cyan = Color(0xFF00F5FF);
  static const bg = Color(0xFF02040D);
  static const purple = Color(0xFF9D4DFF);

  final countries = ['United States', 'Canada', 'Mexico', 'Puerto Rico', 'Dominican Republic', 'United Kingdom'];
  final states = ['Pennsylvania', 'New York', 'New Jersey', 'Florida', 'Georgia', 'Texas', 'California'];
  final counties = ['Cambria County', 'Monroe County', 'Pike County', 'Allegheny County', 'Philadelphia County'];
  final cities = ['Johnstown', 'Bushkill', 'Stroudsburg', 'Pittsburgh', 'Philadelphia', 'Allentown'];

  final listings = [
    {'type':'For Sale','tag':'REAL ESTATE','title':'Single Family Home','loc':'Johnstown, PA','price':'89,900 dollars','pin':'🔵'},
    {'type':'For Sale','tag':'FORECLOSURE','title':'PrimeX Pro Foreclosure Lead','loc':'Cambria County, PA','price':'49.99 Pro unlock','pin':'🟡'},
    {'type':'For Sale','tag':'TAX SALE','title':'Tax Sale Lead','loc':'Monroe County, PA','price':'49.99 Pro unlock','pin':'🟡'},
    {'type':'Rental','tag':'RENTAL','title':'Apartment Rental','loc':'Johnstown, PA','price':'1,250 dollars monthly','pin':'🟣'},
    {'type':'Services','tag':'SERVICE','title':'Property Field Inspector','loc':'Pennsylvania','price':'Book service','pin':'🟢'},
    {'type':'Services','tag':'JOB','title':'Photo Runner Job','loc':'Johnstown, PA','price':'25 dollars hourly','pin':'🟠'},
    {'type':'For Sale','tag':'VEHICLE','title':'Work Truck For Sale','loc':'PA','price':'15,000 dollars','pin':'🟣'},
    {'type':'For Sale','tag':'TOOLS','title':'Power Tools Bundle','loc':'PA','price':'450 dollars','pin':'⚫'},
  ];

  void go(int i) => setState(() => page = i);

  List<Map<String,String>> filtered() {
    if (type == 'Rental') return listings.where((x) => x['type'] == 'Rental').toList();
    if (type == 'Services') return listings.where((x) => x['type'] == 'Services').toList();
    return listings.where((x) => x['type'] == 'For Sale').toList();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      home(),          // 0
      howItWorks(),    // 1
      about(),         // 2
      pricing(),       // 3
      contact(),       // 4
      login(),         // 5
      signup(),        // 6
      dashboard(),     // 7
      marketplace(),   // 8
      mapPage(),       // 9
      messages(),      // 10
      offers(),        // 11
      postListing(),   // 12
      admin(),         // 13
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(children: [nav(), pages[page]]),
      ),
    );
  }

  Widget nav() => Container(
    height: 92,
    padding: const EdgeInsets.symmetric(horizontal: 18),
    decoration: const BoxDecoration(color: Colors.black),
    child: Row(children: [
      InkWell(onTap: () => go(0), child: logo()),
      const Spacer(),
      navItem('Home', 0),
      navItem('How It Works', 1),
      navItem('About Us', 2),
      navItem('Pricing', 3),
      navItem('Contact', 4),
      const SizedBox(width: 10),
      smallBtn('Login', () => go(5), outline: true),
      const SizedBox(width: 8),
      smallBtn('Sign Up', () => go(6)),
    ]),
  );

  Widget logo() => SizedBox(
    width: 270,
    height: 86,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          top: 4,
          child: Text.rich(
            const TextSpan(children: [
              TextSpan(text: 'PRIME', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: .5)),
              TextSpan(text: 'X', style: TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: cyan, shadows: [
                Shadow(color: cyan, blurRadius: 20),
                Shadow(color: blue, blurRadius: 42),
              ])),
            ]),
          ),
        ),
        Positioned(
          left: 2,
          top: 58,
          child: Text(
            'M A R K E T P L A C E',
            style: TextStyle(color: cyan, fontSize: 10, letterSpacing: 5.2, fontWeight: FontWeight.w800, shadows: [Shadow(color: cyan, blurRadius: 12)]),
          ),
        ),
        const Positioned(
          left: 2,
          top: 74,
          child: Text(
            'BUY • SELL • CONNECT',
            style: TextStyle(color: Colors.white, fontSize: 9.5, letterSpacing: 2.4, fontWeight: FontWeight.w800),
          ),
        ),
        Positioned(
          right: 6,
          top: 22,
          child: Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: cyan, width: 1.4),
              boxShadow: [
                BoxShadow(color: cyan.withOpacity(.55), blurRadius: 22),
                BoxShadow(color: blue.withOpacity(.45), blurRadius: 38),
              ],
            ),
            child: const Center(
              child: Text('AI', style: TextStyle(color: cyan, fontSize: 15, fontWeight: FontWeight.w900)),
            ),
          ),
        ),
      ],
    ),
  );

  Widget navItem(String text, int i) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: InkWell(
      onTap: () => go(i),
      child: Text(text, style: TextStyle(color: page == i ? cyan : Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
    ),
  );

  Widget home() => Column(children: [hero(), featureBar(), footer()]);

  Widget hero() => SizedBox(
    height: 560,
    child: Stack(children: [
      Positioned.fill(child: CustomPaint(painter: DigitalPainter())),
      Positioned.fill(child: Container(decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xF202040D), Color(0x7702040D), Color(0x2202040D)]),
      ))),
      Positioned(left: 34, top: 78, width: 430, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('THE #1 MARKETPLACE FOR', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        const Text('EVERYTHING', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900)),
        const Text('YOU NEED', style: TextStyle(fontSize: 38, color: cyan, fontWeight: FontWeight.w900, shadows: [Shadow(color: cyan, blurRadius: 18)])),
        const SizedBox(height: 18),
        const Text('PrimeX Marketplace connects serious buyers and sellers for real estate, foreclosures, services, vehicles, jobs, tools, and business listings.', style: TextStyle(fontSize: 16, height: 1.55)),
        const SizedBox(height: 26),
        Row(children: [
          smallBtn('Login To Browse →', () => go(5)),
          const SizedBox(width: 14),
          smallBtn('Sign Up To Post +', () => go(6), outline: true),
        ]),
      ])),
      Positioned(right: 18, top: 95, child: searchBox()),
    ]),
  );

  Widget searchBox() => Container(
    width: 300,
    padding: const EdgeInsets.all(10),
    decoration: box(),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Expanded(child: typeTab('For Sale')),
        Expanded(child: typeTab('Rental')),
        Expanded(child: typeTab('Services')),
      ]),
      const SizedBox(height: 10),
      dd(country, countries, (v) => setState(() => country = v!), '🌎'),
      dd(state, states, (v) => setState(() => state = v!), '📍'),
      dd(county, counties, (v) => setState(() => county = v!), '🗺'),
      dd(city, cities, (v) => setState(() => city = v!), '🏙'),
      const SizedBox(height: 8),
      fullBtn('Login To Search', () => go(5)),
    ]),
  );

  Widget typeTab(String t) => InkWell(
    onTap: () => setState(() => type = t),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: type == t ? blue : Colors.black.withOpacity(.45), borderRadius: BorderRadius.circular(8)),
      child: Center(child: Text(t.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
    ),
  );

  Widget dd(String value, List<String> items, ValueChanged<String?> onChanged, String icon) => Container(
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(color: Colors.black.withOpacity(.65), borderRadius: BorderRadius.circular(8), border: Border.all(color: cyan.withOpacity(.45))),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        dropdownColor: const Color(0xFF050B18),
        iconEnabledColor: Colors.white,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text('$icon  $e', style: const TextStyle(fontSize: 13)))).toList(),
        onChanged: onChanged,
      ),
    ),
  );

  Widget login() => futurePage('Login', 'Access the PrimeX member dashboard.', [
    input('Email'),
    input('Password'),
    fullBtn('Login To Dashboard', () => go(7)),
  ]);

  Widget signup() => futurePage('Sign Up', 'Create your PrimeX account and enter the dashboard.', [
    input('Full Name'),
    input('Email'),
    input('Phone'),
    input('Password'),
    dd('Buyer', ['Buyer','Seller','Realtor','Investor','Contractor','Service Provider','Employer'], (v) {}, '👤'),
    fullBtn('Create Account + Open Dashboard', () => go(7)),
  ]);

  Widget dashboard() => futurePage('User Dashboard', 'Marketplace tools live here after login. Public website stays clean.', [
    dashTile('Marketplace', 'Browse listings, save opportunities, message sellers, call, and make offers.', () => go(8)),
    dashTile('Map', 'View listing pins by category. PrimeX Pro unlocks foreclosure and tax-sale lead details.', () => go(9)),
    dashTile('Post a Listing', 'Create posts for real estate, rentals, vehicles, services, jobs, tools, and business opportunities.', () => go(12)),
    dashTile('Messages', 'Secure buyer and seller messaging inside PrimeX.', () => go(10)),
    dashTile('Offers + Proof of Funds', 'Submit serious offers and upload proof of funds.', () => go(11)),
    dashTile('My Purchases + Boosts', 'Track paid listings, boosts, foreclosure leads, PrimeX Pro, and subscriptions.', () {}),
    dashTile('Admin Access', 'Admin-only moderation, AI alerts, analytics, and revenue tools.', () => go(13)),
  ]);

  Widget marketplace() => futurePage('Marketplace Inside Dashboard', '$type listings for $city, $state', [
    Row(children: [
      smallBtn('Post Listing +', () => go(12)),
      const SizedBox(width: 12),
      smallBtn('Map', () => go(9), outline: true),
      const SizedBox(width: 12),
      smallBtn('Messages', () => go(10), outline: true),
    ]),
    const SizedBox(height: 18),
    ...filtered().map((x) => listingWide(x)),
  ]);

  Widget postListing() => futurePage('Post a Listing', 'Fill in the listing details and submit for marketplace review.', [
    input('Listing Title'),
    dd('Real Estate', ['Real Estate','Foreclosure','Tax Sale','Rental','Commercial','Vehicles','Services','Jobs','Tools','Business'], (v) {}, '📌'),
    input('Price or Rate'),
    input('Country / State / County / City'),
    input('Description'),
    input('Upload Photos / Video'),
    fullBtn('Publish Listing For Review', () => snack('Listing submitted for review.')),
  ]);

  Widget offers() => futurePage('Make Offer + Proof of Funds', 'Submit verified offers with financing details and proof of funds.', [
    input('Offer Amount'),
    dd('Cash', ['Cash','FHA','VA','Hard Money','Conventional','Seller Financing','Private Lender'], (v) {}, '💰'),
    dd('Investor Buyer', ['Investor Buyer','Realtor Represented Buyer','Owner Occupant Buyer','Wholesaler','Business Buyer'], (v) {}, '👤'),
    input('Upload Proof of Funds PDF / JPG / PNG'),
    input('Message Seller'),
    fullBtn('Submit Offer With Proof of Funds', () => snack('Offer submitted with proof of funds.')),
  ]);

  Widget messages() => futurePage('PrimeX Messages', 'Secure message center for buyer and seller communication.', [
    messageTile('System', 'Keep conversations inside PrimeX for safety.'),
    messageTile('Buyer', 'Is this listing still available?'),
    messageTile('Seller', 'Yes. You can message, call, save, or make an offer.'),
    input('Type your message here'),
    fullBtn('Send Message', () => snack('Message sent.')),
  ]);

  Widget mapPage() => futurePage('PrimeX Map', 'Public pins are visible. PrimeX Pro unlocks premium foreclosure, tax-sale, REO, and lead details.', [
    Container(
      height: 420,
      width: double.infinity,
      decoration: box(),
      child: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: MapPainter())),
        ...listings.asMap().entries.map((e) => Positioned(
          left: 80.0 + (e.key % 4) * 230,
          top: 70.0 + (e.key % 3) * 95,
          child: InkWell(
            onTap: () => snack('${e.value['title']} • ${e.value['price']}'),
            child: Column(children: [
              Text('${e.value['pin']}', style: const TextStyle(fontSize: 34)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black.withOpacity(.75), border: Border.all(color: cyan), borderRadius: BorderRadius.circular(8)),
                child: Text('${e.value['tag']}\n${e.value['title']}', style: const TextStyle(fontSize: 11)),
              ),
            ]),
          ),
        )),
      ]),
    ),
  ]);

  Widget admin() => futurePage('Admin Command Center', 'Separate admin access for platform safety, AI Autopilot, revenue, and analytics.', [
    futureCard('🤖', 'AI Autopilot Review', 'Harassment, discrimination, nudity, sexual solicitation, scams, spam, fake listings, abuse, excessive posting, bot activity, and suspicious behavior.'),
    futureCard('🔐', 'Security Shield', 'Suspicious login review, account protection, identity protection, bot detection, listing review, and admin alerts.'),
    futureCard('📊', 'Revenue + Analytics', 'Track listing fees, boosts, PrimeX Pro subscriptions, foreclosure leads, tax sale leads, messages, views, and user activity.'),
    futureCard('🚫', 'Moderation Tools', 'Warn, restrict, suspend, ban, remove listings, review users, and protect the platform.'),
  ]);

  Widget howItWorks() => futurePage('How PrimeX Works', 'A secure AI-assisted marketplace dashboard for buying, selling, investing, hiring, mapping, messaging, calling, and verified offers.', [
    futureCard('👤', 'Create Your Account', 'Users sign up as buyers, sellers, investors, realtors, contractors, employers, or service providers. After login, every user enters a dashboard built around their listings, purchases, messages, saved items, offers, and activity.'),
    futureCard('🗺', 'Dashboard Map + Pins', 'The map lives inside the dashboard. It shows category pins for real estate, jobs, services, vehicles, tools, rentals, commercial listings, foreclosures, tax sales, and business opportunities.'),
    futureCard('💬', 'Message, Call, Save', 'PrimeX keeps communication inside the platform with secure messages, direct call actions, saved listings, and seller contact tools.'),
    futureCard('💰', 'Offers + Proof of Funds', 'Serious buyers can submit offers and upload proof of funds. Foreclosure, REO, tax sale, commercial, investor, and high-value deals can require verification before review.'),
    futureCard('🛡', 'AI Autopilot Safety', 'PrimeX AI Autopilot monitors harassment, discrimination, hate speech, nudity, sexual content, sexual solicitation, dating-style activity, scams, fraud, spam, fake listings, excessive posting, bot activity, and suspicious behavior.'),
    futureCard('🔐', 'Security Shield', 'PrimeX Security Shield supports account protection, suspicious login review, bot detection, admin alerts, user identity protection, listing review, and safer marketplace activity.'),
    futureCard('📊', 'User + Admin Dashboards', 'Users see their own listings, purchases, boosts, saved listings, messages, offers, proof-of-funds activity, and map tools. Admin sees AI alerts, moderation, revenue analytics, lead tracking, and platform safety separately.'),
  ]);

  Widget about() => futurePage('About PrimeX Marketplace', 'A futuristic professional marketplace powered by Syntax Phantom, built to connect serious users while protecting the platform.', [
    futureCard('⚡', 'Built for Serious Marketplace Activity', 'PrimeX brings together real estate, foreclosures, rentals, vehicles, services, jobs, tools, commercial listings, business opportunities, investors, contractors, realtors, employers, and verified users in one connected platform.'),
    futureCard('🌎', 'Global Marketplace Vision', 'PrimeX is designed for local, nationwide, and global activity. Users can search by region, country, state, province, county, city, category, and listing type.'),
    futureCard('🔒', 'Public Site + Member Dashboard', 'The website explains the platform publicly. Posting, marketplace browsing, map tools, messaging, offers, saved listings, boosts, payments, and subscriptions are handled inside the dashboard.'),
    futureCard('🤖', 'AI + Admin Protection', 'AI Autopilot and admin review tools help reduce scams, adult content, harassment, discrimination, fake listings, spam, abuse, excessive posting, suspicious accounts, and unsafe platform behavior.'),
    futureCard('💼', 'Powered by Syntax Phantom', 'PrimeX is built with a future-focused design, secure workflow, professional dashboard structure, and a mission to help people buy, sell, connect, invest, hire, and grow with confidence.'),
  ]);

  Widget pricing() => pagePlain('Pricing', const Text(
    'Realtor/Broker Listing: 5 dollars / 35 days\nVehicle Listing: 5 dollars / 35 days\nBoost 4 Days: 7.99\nBoost 15 Days: 14.99\nForeclosure Lead: 9.99\nPrimeX Pro: 49.99 per month',
    style: TextStyle(fontSize: 18, height: 1.7),
  ));

  Widget contact() => pagePlain('Contact', const Text(
    'syntax.phantom@primexmarketplace.com\nprimexmarketplace.com\nPA\n\nPowered by Syntax Phantom @ 2026',
    style: TextStyle(fontSize: 18, height: 1.7),
  ));

  Widget futurePage(String title, String subtitle, List<Widget> children) => Padding(
    padding: const EdgeInsets.all(28),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFF02040D), const Color(0xFF062A68).withOpacity(.78), const Color(0xFF02040D)]),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cyan.withOpacity(.9), width: 1.4),
        boxShadow: [BoxShadow(color: blue.withOpacity(.40), blurRadius: 34), BoxShadow(color: cyan.withOpacity(.18), blurRadius: 48)],
      ),
      child: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: AiFuturePainter())),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: cyan, fontSize: 34, fontWeight: FontWeight.w900, shadows: [Shadow(color: cyan, blurRadius: 20)])),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5)),
          const SizedBox(height: 22),
          ...children,
          const SizedBox(height: 20),
          verseBox(),
        ]),
      ]),
    ),
  );

  Widget futureCard(String icon, String title, String body) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.65),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: cyan.withOpacity(.85)),
      boxShadow: [BoxShadow(color: cyan.withOpacity(.22), blurRadius: 24), BoxShadow(color: blue.withOpacity(.25), blurRadius: 35)],
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(icon, style: const TextStyle(fontSize: 34)),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: cyan, fontSize: 19, fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        Text(body, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.55)),
      ])),
    ]),
  );

  Widget pagePlain(String title, Widget child) => Padding(
    padding: const EdgeInsets.all(28),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: box(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: cyan, fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 18),
        child,
      ]),
    ),
  );

  Widget verseBox() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.black.withOpacity(.62), borderRadius: BorderRadius.circular(14), border: Border.all(color: cyan.withOpacity(.55))),
    child: const Text(
      'Philippians 4:13 — I can do all things through Christ who strengthens me.\nPowered by Syntax Phantom @ 2026',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 15, letterSpacing: 1.1, height: 1.5),
    ),
  );

  Widget featureBar() {
    final data = [
      ['🌎','GLOBAL','Worldwide reach'], ['🛡','AI SAFETY','Autopilot review'], ['🔐','SECURITY','Platform shield'], ['💰','OFFERS','Proof of funds'],
      ['💬','MESSAGES','Secure chat'], ['📞','CALLS','Direct contact'], ['🗺','MAP','Category pins'], ['📊','ANALYTICS','Admin insight'],
    ];
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: box(),
      child: Row(children: data.map((i) => Expanded(child: Column(children: [
        Text(i[0], style: const TextStyle(fontSize: 24)),
        Text(i[1], textAlign: TextAlign.center, style: const TextStyle(color: cyan, fontSize: 10, fontWeight: FontWeight.bold)),
        Text(i[2], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 9)),
      ]))).toList()),
    );
  }

  Widget listingWide(Map x) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(14),
    decoration: box(),
    child: Row(children: [
      SizedBox(width: 170, height: 95, child: CustomPaint(painter: HouseCardPainter())),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${x['tag']} • ${x['title']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('${x['loc']} • ${x['price']}', style: const TextStyle(color: cyan)),
      ])),
      smallBtn('Message', () => go(10), outline: true),
      const SizedBox(width: 8),
      smallBtn('Call', () => snack('Calling seller...'), outline: true),
      const SizedBox(width: 8),
      smallBtn('Offer', () => go(11)),
      const SizedBox(width: 8),
      smallBtn('Save', () => snack('Saved listing.'), outline: true),
    ]),
  );

  Widget dashTile(String t, String s, VoidCallback onTap) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: box(),
    child: InkWell(onTap: onTap, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(t, style: const TextStyle(color: cyan, fontSize: 18, fontWeight: FontWeight.bold)),
      Text(s, style: const TextStyle(height: 1.5)),
    ])),
  );

  Widget messageTile(String who, String msg) => Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: box(), child: Text('$who: $msg'));

  Widget input(String text) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.black.withOpacity(.65), borderRadius: BorderRadius.circular(8), border: Border.all(color: cyan.withOpacity(.35))),
    child: Row(children: [Text(text), const Spacer()]),
  );

  Widget smallBtn(String text, VoidCallback onTap, {bool outline = false}) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: outline ? Colors.black.withOpacity(.4) : blue, border: Border.all(color: blue), borderRadius: BorderRadius.circular(8), boxShadow: outline ? [] : [BoxShadow(color: blue.withOpacity(.55), blurRadius: 12)]),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );

  Widget fullBtn(String text, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Container(width: double.infinity, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8)), child: Center(child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)))),
  );

  Widget footer() => Container(padding: const EdgeInsets.all(24), color: Colors.black, child: const Text('PrimeX Marketplace — Buy. Sell. Connect. | Philippians 4:13 | Powered by Syntax Phantom @ 2026', style: TextStyle(color: cyan)));

  BoxDecoration box() => BoxDecoration(color: const Color(0xCC050B18), borderRadius: BorderRadius.circular(14), border: Border.all(color: blue.withOpacity(.85)), boxShadow: [BoxShadow(color: blue.withOpacity(.32), blurRadius: 18)]);

  void snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class DigitalPainter extends CustomPainter {
  static const cyan = Color(0xFF00F5FF), purple = Color(0xFF9D4DFF);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..shader = const LinearGradient(colors: [Colors.black, Color(0xFF08256B), Colors.black]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    for (int i = 0; i < 160; i++) {
      canvas.drawCircle(Offset(((i * 79) % size.width).toDouble(), ((i * 43) % size.height).toDouble()), i % 5 == 0 ? 1.8 : .8, Paint()..color = cyan.withOpacity(.7));
    }
    void label(String t, String s, double x, double y) {
      final r = RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 145, 42), const Radius.circular(10));
      canvas.drawRRect(r, Paint()..color = Colors.black.withOpacity(.55));
      canvas.drawRRect(r, Paint()..color = cyan..style = PaintingStyle.stroke..strokeWidth = 1.2);
      final tp = TextPainter(text: TextSpan(text: '$t\n', style: const TextStyle(color: cyan, fontSize: 11, fontWeight: FontWeight.bold), children: [TextSpan(text: s, style: const TextStyle(color: Colors.white, fontSize: 8))]), textDirection: TextDirection.ltr)..layout(maxWidth: 125);
      tp.paint(canvas, Offset(x + 10, y + 7));
    }
    label('REAL ESTATE', 'Buy • Sell • Invest', size.width * .25, size.height * .13);
    label('FORECLOSURES', 'PrimeX Pro', size.width * .26, size.height * .27);
    label('COMMERCIAL', 'Offices • Retail', size.width * .27, size.height * .41);
    label('VEHICLES', 'Cars • Trucks • RVs', size.width * .66, size.height * .08);
    label('SERVICES', 'Local Pros', size.width * .66, size.height * .18);
    label('TOOLS', 'Equipment', size.width * .66, size.height * .28);
    final base = size.height * .88, start = size.width * .34, end = size.width * .76;
    final hs = [90,160,120,240,180,310,220,360,170,290,230,380,190,330,150,270,210,350];
    final bw = (end - start) / hs.length;
    for (int i = 0; i < hs.length; i++) {
      final h = hs[i].toDouble(), x = start + i * bw, top = base - h, c = i.isEven ? cyan : purple;
      final rect = Rect.fromLTWH(x + 3, top, bw - 6, h);
      canvas.drawRect(rect, Paint()..color = Colors.black.withOpacity(.78));
      canvas.drawRect(rect, Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = 1.6);
      for (double y = top + 18; y < base - 8; y += 18) {
        canvas.drawRect(Rect.fromLTWH(x + 10, y, bw - 20, 3), Paint()..color = c.withOpacity(.85));
      }
    }
    canvas.drawLine(Offset(0, base), Offset(size.width, base), Paint()..color = cyan..strokeWidth = 3);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AiFuturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = const Color(0xFF00F5FF).withOpacity(.10)..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 90) { canvas.drawLine(Offset(x, 0), Offset(x + 90, size.height), grid); }
    for (double y = 0; y < size.height; y += 70) { canvas.drawLine(Offset(0, y), Offset(size.width, y - 35), grid); }
    for (int i = 0; i < 22; i++) {
      final dx = (i * 137) % size.width;
      final dy = (i * 71) % size.height;
      canvas.drawCircle(Offset(dx.toDouble(), dy.toDouble()), 4, Paint()..color = const Color(0xFF00F5FF).withOpacity(.45));
      canvas.drawCircle(Offset(dx.toDouble(), dy.toDouble()), 38, Paint()..color = const Color(0xFF006BFF).withOpacity(.08));
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..shader = const LinearGradient(colors: [Color(0xFF020617), Color(0xFF06276B)]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    final p = Paint()..color = const Color(0xFF00F5FF).withOpacity(.25)..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 60) { canvas.drawLine(Offset(x, 0), Offset(x, size.height), p); }
    for (double y = 0; y < size.height; y += 60) { canvas.drawLine(Offset(0, y), Offset(size.width, y), p); }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HouseCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..shader = const LinearGradient(colors: [Color(0xFF073B7A), Colors.black]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    final glow = Paint()..color = const Color(0xFF00F5FF)..style = PaintingStyle.stroke..strokeWidth = 2;
    final fill = Paint()..color = Colors.black.withOpacity(.6);
    final base = Rect.fromLTWH(size.width * .12, size.height * .50, size.width * .76, size.height * .32);
    final roof = Path()..moveTo(size.width * .08, size.height * .50)..lineTo(size.width * .50, size.height * .20)..lineTo(size.width * .92, size.height * .50)..close();
    canvas.drawRect(base, fill); canvas.drawPath(roof, fill); canvas.drawRect(base, glow); canvas.drawPath(roof, glow);
    for (int i = 0; i < 4; i++) { canvas.drawRect(Rect.fromLTWH(size.width * (.22 + i * .15), size.height * .58, 25, 18), Paint()..color = const Color(0xFFFFD36B)); }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
DART

flutter clean
flutter pub get
flutter build web --release

echo "✅ FIRE PrimeX update complete. Run: flutter run -d chrome"
