#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_dashboard_final_$(date +%Y%m%d_%H%M%S).dart"

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
  bool primeXPro = false;
  String activeDash = 'Dashboard';

  static const cyan = Color(0xFF00F5FF);
  static const blue = Color(0xFF006BFF);
  static const bg = Color(0xFF02040D);

  void go(int i) => setState(() => page = i);
  void snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  final listings = const [
    {'type':'REAL ESTATE','title':'Single Family Home','city':'Johnstown, PA','price':'89,900 dollars','icon':'🏠','locked':'false'},
    {'type':'VEHICLES','title':'Used Car','city':'Pittsburgh, PA','price':'15,900 dollars','icon':'🚗','locked':'false'},
    {'type':'TOOLS','title':'Power Drill Set','city':'Altoona, PA','price':'199 dollars','icon':'🛠','locked':'false'},
    {'type':'SERVICES','title':'Deck Builder','city':'Cambria County, PA','price':'Book service','icon':'🔧','locked':'false'},
    {'type':'JOBS','title':'Photo Runner Job','city':'Remote / PA','price':'65,000/yr','icon':'💼','locked':'false'},
    {'type':'FORECLOSURE','title':'PrimeX Pro Foreclosure Lead','city':'Cambria County, PA','price':'Pro unlock','icon':'🏚','locked':'true'},
    {'type':'TAX SALE','title':'Tax Sale Certificate','city':'Monroe County, PA','price':'Pro unlock','icon':'📄','locked':'true'},
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      home(), howItWorks(), about(), pricing(), contact(), login(), signup(),
      dashboard(), marketplace(), mapPage(), postListing(), messages(), offers(),
      adminLogin(), profile(), savedListings(), myListings(), payments(), securityCenter()
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(child: Column(children: [nav(), pages[page]])),
    );
  }

  Widget nav() => Container(
    height: 96,
    padding: const EdgeInsets.symmetric(horizontal: 28),
    color: Colors.black,
    child: Row(children: [
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
    ]),
  );

  Widget navItem(String text, int i) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: InkWell(
      onTap: () => go(i),
      child: Text(text, style: TextStyle(color: page == i ? cyan : Colors.white, fontWeight: FontWeight.w900)),
    ),
  );

  Widget home() => pageBox('PrimeX Marketplace', 'Public landing page. Marketplace, map, posting, messages, offers, and admin are inside dashboard.', [
    card('🌎', 'Everything Marketplace', 'Homes, cars, tools, jobs, services, business, electronics, pets, rentals, and more.'),
    card('🔒', 'Premium Leads Protected', 'Foreclosure and tax sale details stay locked until the user pays for PrimeX Pro.'),
    fullBtn('Login To Dashboard', () => go(5)),
  ], publicPage: true);

  Widget login() => pageBox('Login', 'Access the PrimeX member dashboard.', [
    field('Email'),
    field('Password'),
    fullBtn('Login To Dashboard', () => go(7)),
  ]);

  Widget signup() => pageBox('Sign Up', 'Create a PrimeX account.', [
    field('Full Name'),
    field('Email'),
    field('Phone'),
    field('Password'),
    fullBtn('Create Account + Open Dashboard', () => go(7)),
  ]);

  Widget dashboard() => pageBox('User Dashboard', 'All marketplace tools are wired inside the dashboard.', [
    Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        dashBtn('Marketplace', 8),
        dashBtn('Map Pins', 9),
        dashBtn('Post Listing', 10),
        dashBtn('Messages', 11),
        dashBtn('Offers', 12),
        dashBtn('Profile', 14),
        dashBtn('Saved', 15),
        dashBtn('My Listings', 16),
        dashBtn('Payments', 17),
        dashBtn('Security', 18),
        dashBtn('Admin Login', 13),
      ],
    ),
    const SizedBox(height: 18),
    card('👑', 'PrimeX Pro Status', primeXPro ? 'ACTIVE — foreclosure and tax sale lead details unlocked.' : 'NOT ACTIVE — foreclosure and tax sale lead details are locked.'),
    if (!primeXPro) fullBtn('Activate PrimeX Pro 49.99 per month', () => setState(() => primeXPro = true)),
    if (primeXPro) fullBtn('PrimeX Pro Active', () => snack('PrimeX Pro is already active.')),
  ]);

  Widget marketplace() => pageBox('Marketplace Feed', 'Browse listings, message, call, save, and make offers.', [
    ...listings.map((x) => listingCard(x)).toList(),
  ]);

  Widget mapPage() => pageBox('PrimeX Live Map Pins', 'Map-style board with item photos/icons and category pins. Locked leads require PrimeX Pro.', [
    Container(
      height: 520,
      padding: const EdgeInsets.all(18),
      decoration: glass(),
      child: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: NeonMapPainter())),
        mapPin(70, 70, listings[0], Colors.greenAccent),
        mapPin(360, 90, listings[1], Colors.lightBlueAccent),
        mapPin(650, 80, listings[2], Colors.amberAccent),
        mapPin(230, 310, listings[3], cyan),
        mapPin(560, 300, listings[4], Colors.purpleAccent),
        mapPin(850, 125, listings[5], Colors.orangeAccent),
        mapPin(880, 330, listings[6], Colors.yellowAccent),
      ]),
    ),
    const SizedBox(height: 16),
    card('🔵', 'Public Pins', 'Real estate, vehicles, tools, jobs, services, business, rentals, and normal listings are visible.'),
    card('🟡', 'PrimeX Pro Pins', 'Foreclosure and tax sale pins show limited info until PrimeX Pro is active.'),
  ]);

  Widget postListing() => pageBox('Post a Listing', 'Users can post items, photos, address, price, and category.', [
    field('Listing Title'),
    dropdown('Category', ['Real Estate','Vehicle','Tools','Services','Jobs','Business','Rental','Electronics','Furniture','Pets']),
    field('Price or Rate'),
    field('Street Address'),
    dropdown('Country', ['United States','Canada','Mexico','United Kingdom','Dominican Republic']),
    dropdown('State / Province', ['Pennsylvania','New York','New Jersey','Florida','Georgia','Texas','California']),
    dropdown('County', ['Cambria County','Monroe County','Pike County','Allegheny County','Philadelphia County']),
    dropdown('City', ['Johnstown','Bushkill','Stroudsburg','Pittsburgh','Philadelphia','Allentown']),
    field('Description'),
    card('📸', 'Photos / Video', 'Add listing photos and 1-minute video. Firebase Storage wiring is next.'),
    fullBtn('Publish Listing For Review', () => snack('Listing submitted for AI/Admin review.')),
  ]);

  Widget messages() => pageBox('PrimeX Messages', 'Secure buyer and seller messages stay inside PrimeX.', [
    card('🛡', 'System', 'Keep communication inside PrimeX for safety and fraud protection.'),
    card('👤', 'Buyer', 'Is this listing still available?'),
    card('🏠', 'Seller', 'Yes. You can message, call, save, or make an offer.'),
    field('Type your message here'),
    fullBtn('Send Message', () => snack('Message sent.')),
  ]);

  Widget offers() => pageBox('Offers + Proof of Funds', 'Submit verified offers with proof of funds.', [
    field('Offer Amount'),
    dropdown('Financing Type', ['Cash','FHA','VA','Hard Money','Seller Financing']),
    field('Upload Proof of Funds PDF / JPG / PNG'),
    field('Message To Seller'),
    fullBtn('Submit Verified Offer', () => snack('Offer submitted with proof of funds.')),
  ]);

  Widget profile() => pageBox('My Profile', 'Photo, payment method, address, phone, email, and password reset.', [
    card('👤', 'Profile Photo', 'Upload or update user photo.'),
    field('Full Name'),
    field('Email Address'),
    field('Phone Number'),
    field('Street Address'),
    field('City / State / ZIP'),
    card('💳', 'Payment Method', 'Add card or payout method through Stripe.'),
    fullBtn('Add Payment Method', () => snack('Stripe payment method wiring next.')),
    fullBtn('Send Password Reset Email', () => snack('Password reset email sent.')),
    fullBtn('Save Profile', () => snack('Profile saved.')),
  ]);

  Widget savedListings() => pageBox('Saved Listings', 'Saved homes, cars, tools, jobs, services, and opportunities.', [
    card('⭐', 'Saved Item', 'Single Family Home • Johnstown, PA • 89,900 dollars'),
    card('⭐', 'Saved Service', 'Deck Builder • Cambria County, PA'),
  ]);

  Widget myListings() => pageBox('My Listings', 'Manage listings you posted.', [
    card('📌', 'Active Listing', 'Power Drill Set • Altoona, PA • 199 dollars'),
    card('📝', 'Draft Listing', 'Vehicle listing waiting for photos.'),
    fullBtn('Post New Listing', () => go(10)),
  ]);

  Widget payments() => pageBox('Payments + Subscription', 'Manage boosts, listing fees, and PrimeX Pro.', [
    card('👑', 'PrimeX Pro', primeXPro ? 'Active' : 'Not active — 49.99 per month'),
    card('⚡', 'Boost 4 Days', '7.99'),
    card('🚀', 'Boost 15 Days', '14.99'),
    card('🏠', 'Realtor/Broker Listing', '5 dollars / 35 days'),
    fullBtn('Activate PrimeX Pro', () => setState(() => primeXPro = true)),
  ]);

  Widget securityCenter() => pageBox('AI Security Center', 'PrimeX AI Autopilot safety and cyber protection.', [
    card('🤖', 'AI Moderation', 'Flags scams, fraud, harassment, discrimination, nudity, sexual solicitation, fake listings, spam, bots, and abuse.'),
    card('🔐', 'Cyber Shield', 'Watches suspicious logins, account takeover attempts, identity theft patterns, bot signups, and platform abuse.'),
    card('🚫', 'Auto Actions', 'Warn user, remove content, lock listing, suspend account, notify admin, or ban repeat offenders.'),
  ]);

  Widget adminLogin() => pageBox('Admin Login', 'Separate restricted login for PrimeX admin only.', [
    field('Admin Email'),
    field('Admin Password'),
    card('🔐', 'Restricted Area', 'Admin controls users, AI moderation, analytics, revenue, security alerts, and cyber defense.'),
    fullBtn('Enter Admin Command Center', () => snack('Admin access must be verified with Firebase Auth role.')),
  ]);

  Widget howItWorks() => pageBox('How PrimeX Works', 'Professional AI-powered marketplace workflow.', [
    card('👤', 'Create Account', 'Users sign up as buyer, seller, realtor, investor, contractor, employer, or service provider.'),
    card('📍', 'Live Map Pins', 'Listings show on the map with category pins, photo/icon previews, price, city, and listing type.'),
    card('💬', 'Message, Call, Save', 'Users can message, call, save listings, and stay inside PrimeX for safety.'),
    card('💰', 'Offers + Proof of Funds', 'Buyers submit offers and upload proof of funds for serious deals.'),
    card('👑', 'PrimeX Pro', 'Foreclosure and tax sale details unlock only after payment.'),
    card('🛡', 'AI Autopilot', 'AI monitors scams, harassment, discrimination, nudity, solicitation, fake listings, spam, bots, and suspicious activity.'),
  ]);

  Widget about() => pageBox('About PrimeX Marketplace', 'PrimeX is a professional secure marketplace powered by Syntax Phantom.', [
    card('⚡', 'Built For Serious Activity', 'Real estate, foreclosures, vehicles, jobs, tools, services, rentals, business opportunities, and more.'),
    card('🌎', 'Global Vision', 'Search by country, state, county, city, category, and map pin.'),
    card('🔒', 'Protected Marketplace', 'Public users can browse normal listings. Premium foreclosure and tax sale lead details are protected behind PrimeX Pro.'),
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

  Widget listingCard(Map<String,String> x) {
    final locked = x['locked'] == 'true' && !primeXPro;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: glass(),
      child: Row(children: [
        Text(x['icon']!, style: const TextStyle(fontSize: 42)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${x['type']} • ${x['title']}', style: const TextStyle(color: cyan, fontSize: 18, fontWeight: FontWeight.w900)),
          Text(locked ? '${x['city']} • LOCKED — PrimeX Pro required' : '${x['city']} • ${x['price']}', style: const TextStyle(fontSize: 15)),
        ])),
        if (locked)
          btn('Unlock Pro', () => setState(() => primeXPro = true))
        else ...[
          btn('Message', () => go(11), outline: true),
          const SizedBox(width: 8),
          btn('Call', () => snack('Calling seller...'), outline: true),
          const SizedBox(width: 8),
          btn('Offer', () => go(12)),
        ],
      ]),
    );
  }

  Widget mapPin(double left, double top, Map<String,String> x, Color color) {
    final locked = x['locked'] == 'true' && !primeXPro;
    return Positioned(
      left: left,
      top: top,
      child: InkWell(
        onTap: () => locked ? snack('PrimeX Pro required to unlock ${x['type']} details.') : go(8),
        child: Container(
          width: 210,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.74),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: 1.5),
            boxShadow: [BoxShadow(color: color.withOpacity(.55), blurRadius: 22)],
          ),
          child: Row(children: [
            Text(locked ? '🔒' : x['icon']!, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(x['type']!, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 14)),
              Text(locked ? 'PrimeX Pro required' : '${x['city']}\n${x['price']}', style: const TextStyle(fontSize: 11, height: 1.25)),
            ])),
          ]),
        ),
      ),
    );
  }

  Widget pageBox(String title, String subtitle, List<Widget> children, {bool publicPage = false}) => Padding(
    padding: const EdgeInsets.all(28),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: fireBox(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (!publicPage && page != 0)
          Row(children: [
            btn('← Back', () => go(page >= 8 ? 7 : 0), outline: true),
            const SizedBox(width: 10),
            if (page >= 8) btn('Dashboard', () => go(7)),
          ]),
        if (!publicPage && page != 0) const SizedBox(height: 18),
        Text(title, style: const TextStyle(color: cyan, fontSize: 34, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 22),
        ...children,
        verseBox(),
      ]),
    ),
  );

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

  Widget dropdown(String label, List<String> items) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: glass(),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: items.first,
        dropdownColor: const Color(0xFF050B18),
        isExpanded: true,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (_) => snack('$label selected.'),
      ),
    ),
  );

  Widget dashBtn(String text, int target) => InkWell(
    onTap: () => go(target),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: glass(),
      child: Text(text, style: const TextStyle(color: cyan, fontWeight: FontWeight.w900)),
    ),
  );

  Widget btn(String text, VoidCallback onTap, {bool outline = false}) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: outline ? Colors.black.withOpacity(.42) : cyan,
        border: Border.all(color: cyan),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: outline ? cyan : Colors.black, fontWeight: FontWeight.w900)),
    ),
  );

  Widget fullBtn(String text, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
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
}

class PrimeXLogo extends StatelessWidget {
  const PrimeXLogo({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 320,
    height: 78,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text.rich(TextSpan(children: [
          TextSpan(text: 'PRIME', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
          TextSpan(text: 'X', style: TextStyle(color: Color(0xFF00F5FF), fontSize: 46, fontWeight: FontWeight.w900, shadows: [
            Shadow(color: Color(0xFF00F5FF), blurRadius: 22),
            Shadow(color: Color(0xFF006BFF), blurRadius: 38),
          ])),
        ])),
        Text('M A R K E T P L A C E', style: TextStyle(color: Color(0xFF00F5FF), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 4.6)),
        Text('— BUY • SELL • CONNECT —', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.6)),
      ],
    ),
  );
}

class NeonMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cyan = Color(0xFF00F5FF);
    const blue = Color(0xFF006BFF);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..shader = const LinearGradient(colors: [Colors.black, Color(0xFF062A68), Colors.black]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

    final p = Paint()..color = blue.withOpacity(.45)..strokeWidth = 1.2;
    for (double x = 0; x < size.width; x += 70) {
      canvas.drawLine(Offset(x, 0), Offset(x + 100, size.height), p);
    }
    for (double y = 0; y < size.height; y += 55) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 30), p);
    }
    for (int i = 0; i < 90; i++) {
      canvas.drawCircle(
        Offset(((i * 97) % size.width).toDouble(), ((i * 53) % size.height).toDouble()),
        i % 6 == 0 ? 3 : 1.5,
        Paint()..color = cyan.withOpacity(.75),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
DART

flutter clean
flutter pub get
flutter run -d chrome
