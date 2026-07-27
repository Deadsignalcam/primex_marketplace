#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_before_map_wire_$(date +%Y%m%d_%H%M%S).dart"

flutter pub add google_maps_flutter url_launcher
flutter pub get

MAP_KEY="$(grep -Rho "AIza[0-9A-Za-z_-]\{20,\}" . --exclude-dir=build --exclude-dir=.dart_tool | head -n 1 || true)"

if [ -n "$MAP_KEY" ]; then
  echo "✅ Google Map key found."
  if ! grep -q "maps.googleapis.com/maps/api/js" web/index.html; then
    sed -i "/<\/head>/i <script src=\"https://maps.googleapis.com/maps/api/js?key=$MAP_KEY\"></script>" web/index.html
  fi
else
  echo "⚠️ No Google Maps key found in project. Map page will still compile, but Google map may not load."
fi

cat > lib/main.dart <<'DART'
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String country = 'United States';
  String state = 'Pennsylvania';
  String county = 'Cambria County';
  String city = 'Johnstown';
  String category = 'Real Estate';

  final countries = ['United States', 'Canada', 'Mexico', 'United Kingdom', 'Dominican Republic'];
  final states = ['Pennsylvania', 'New York', 'New Jersey', 'Florida', 'Georgia', 'Texas', 'California'];
  final counties = ['Cambria County', 'Monroe County', 'Pike County', 'Allegheny County', 'Philadelphia County'];
  final cities = ['Johnstown', 'Bushkill', 'Stroudsburg', 'Pittsburgh', 'Philadelphia', 'Allentown'];
  final categories = ['Real Estate', 'Foreclosure', 'Tax Sale', 'Rental', 'Vehicle', 'Service', 'Job', 'Tools'];

  void go(int i) => setState(() => page = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      home(), howItWorks(), about(), pricing(), contact(), login(), signup(),
      dashboard(), marketplace(), mapPage(), postListing(), messages(), offers(), admin(),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(child: Column(children: [nav(), pages[page]])),
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
      child: Text(text, style: TextStyle(color: page == i ? cyan : Colors.white, fontWeight: FontWeight.w800)),
    ),
  );

  Widget dashboard() => futurePage('User Dashboard', 'Marketplace tools live here after login.', [
    dashTile('🛒', 'Marketplace', 'Browse listings, save opportunities, message sellers, call, and make offers.', () => go(8)),
    dashTile('🗺', 'Map', 'Live Google Map pins by category. PrimeX Pro unlocks foreclosure and tax-sale lead details.', () => go(9)),
    dashTile('➕', 'Post a Listing', 'Create posts for real estate, rentals, vehicles, services, jobs, tools, and business opportunities.', () => go(10)),
    dashTile('💬', 'Messages', 'Secure buyer and seller messaging inside PrimeX.', () => go(11)),
    dashTile('💰', 'Offers + Proof of Funds', 'Submit serious offers and upload proof of funds.', () => go(12)),
    dashTile('📊', 'Admin Access', 'Admin-only moderation, AI alerts, analytics, revenue, and security tools.', () => go(13)),
  ]);

  Widget marketplace() => futurePage('Marketplace Inside Dashboard', 'Listings are inside dashboard only.', [
    listingTile('REAL ESTATE', 'Single Family Home', 'Johnstown, PA', '89,900 dollars', '5707306740'),
    listingTile('FORECLOSURE', 'PrimeX Pro Foreclosure Lead', 'Cambria County, PA', '49.99 Pro unlock', '5707306740'),
    listingTile('TAX SALE', 'Tax Sale Lead', 'Monroe County, PA', '49.99 Pro unlock', '5707306740'),
    listingTile('SERVICE', 'Property Field Inspector', 'Pennsylvania', 'Book service', '5707306740'),
  ]);

  Widget mapPage() => futurePage('PrimeX Map', 'Pins are wired by category. Tap pins for listing details.', [
    SizedBox(
      height: 460,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(40.3267, -78.9219),
            zoom: 8,
          ),
          mapType: MapType.normal,
          markers: {
            const Marker(markerId: MarkerId('real_estate'), position: LatLng(40.3267, -78.9219), infoWindow: InfoWindow(title: 'Single Family Home', snippet: '89,900 dollars')),
            const Marker(markerId: MarkerId('foreclosure'), position: LatLng(40.4595, -78.5917), infoWindow: InfoWindow(title: 'Foreclosure Lead', snippet: 'PrimeX Pro unlock')),
            const Marker(markerId: MarkerId('tax_sale'), position: LatLng(41.0589, -75.3396), infoWindow: InfoWindow(title: 'Tax Sale Lead', snippet: '49.99 Pro')),
            const Marker(markerId: MarkerId('service'), position: LatLng(40.4406, -79.9959), infoWindow: InfoWindow(title: 'Service Provider', snippet: 'Property Field Inspector')),
          },
        ),
      ),
    ),
  ]);

  Widget postListing() => futurePage('Post a Listing', 'Hard-wired form ready for Firebase save next.', [
    field('Listing Title'),
    dropdown(category, categories, (v) => setState(() => category = v!)),
    field('Price or Rate'),
    dropdown(country, countries, (v) => setState(() => country = v!)),
    dropdown(state, states, (v) => setState(() => state = v!)),
    dropdown(county, counties, (v) => setState(() => county = v!)),
    dropdown(city, cities, (v) => setState(() => city = v!)),
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
    dropdown('Cash', ['Cash', 'FHA', 'VA', 'Hard Money', 'Seller Financing'], (_) {}),
    field('Upload Proof of Funds PDF / JPG / PNG'),
    field('Message To Seller'),
    fullBtn('Submit Verified Offer', () => snack('Offer submitted with proof of funds.')),
  ]);

  Widget admin() => futurePage('Admin Command Center', 'Admin-only controls for AI safety, security, revenue, and analytics.', [
    card('🤖', 'AI Autopilot', 'Flags scams, harassment, discrimination, nudity, sexual solicitation, fraud, spam, fake listings, bots, and suspicious behavior.'),
    card('🔐', 'Cyber Security Shield', 'Monitors suspicious logins, account takeover attempts, identity theft patterns, bot activity, and platform abuse.'),
    card('📊', 'Revenue Analytics', 'Track listing fees, boosts, PrimeX Pro, foreclosure leads, tax-sale leads, and active users.'),
    card('🚫', 'Moderation Tools', 'Warn users, remove listings, suspend accounts, ban repeat offenders, and review flagged activity.'),
  ]);

  Widget home() => futurePage('PrimeX Marketplace', 'Public website. Login to open the full dashboard.', [
    card('🌎', 'Global Marketplace', 'Real estate, foreclosures, rentals, vehicles, services, jobs, tools, and business listings.'),
    card('🔐', 'Secure Platform', 'AI safety, proof of funds, account protection, and admin review.'),
    fullBtn('Login To Dashboard', () => go(5)),
  ]);

  Widget howItWorks() => futurePage('How PrimeX Works', 'A secure AI-powered marketplace dashboard.', [
    card('👤', 'Create Your Account', 'Sign up as buyer, seller, realtor, investor, contractor, employer, or service provider.'),
    card('🗺', 'Map + Pins', 'Listings appear on Google Map by category.'),
    card('💬', 'Message, Call, Save', 'Keep activity inside PrimeX for safety.'),
    card('💰', 'Offers + Proof of Funds', 'Submit serious offers with proof of funds.'),
    card('🛡', 'AI Autopilot Safety', 'Monitors scams, fraud, harassment, discrimination, nudity, solicitation, fake listings, spam, bots, and suspicious activity.'),
  ]);

  Widget about() => futurePage('About PrimeX Marketplace', 'A professional marketplace powered by Syntax Phantom.', [
    card('⚡', 'Built for Serious Activity', 'PrimeX connects serious users across real estate, foreclosures, vehicles, jobs, tools, services, and business opportunities.'),
    card('🌎', 'Global Vision', 'Search by country, state, county, city, and category.'),
    card('🤖', 'AI + Admin Protection', 'AI Autopilot and admin tools help protect the platform.'),
  ]);

  Widget pricing() => futurePage('Pricing', 'Simple PrimeX pricing.', [
    card('🏠', 'Realtor/Broker Listing', '5 dollars / 35 days'),
    card('🚗', 'Vehicle Listing', '5 dollars / 35 days'),
    card('⚡', 'Boost 4 Days', '7.99'),
    card('🚀', 'Boost 15 Days', '14.99'),
    card('🏚', 'Foreclosure Lead', '9.99 per lead'),
    card('👑', 'PrimeX Pro', '49.99 per month'),
  ]);

  Widget contact() => futurePage('Contact', 'Reach PrimeX Marketplace.', [
    card('📧', 'Email', 'syntax.phantom@primexmarketplace.com'),
    card('🌐', 'Website', 'primexmarketplace.com'),
    card('📍', 'Location', 'PA'),
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

  Widget futurePage(String title, String subtitle, List<Widget> children) => Padding(
    padding: const EdgeInsets.all(28),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: futureBox(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: cyan, fontSize: 34, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 22),
        ...children,
        verseBox(),
      ]),
    ),
  );

  Widget dashTile(String icon, String title, String body, VoidCallback onTap) => InkWell(onTap: onTap, child: card(icon, title, body));

  Widget listingTile(String tag, String title, String loc, String price, String phone) => card('📌', '$tag • $title', '$loc • $price');

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
      if (title.contains('REAL ESTATE') || title.contains('FORECLOSURE') || title.contains('TAX SALE') || title.contains('SERVICE')) ...[
        smallBtn('Message', () => go(11), outline: true),
        const SizedBox(width: 8),
        smallBtn('Call', () => launchUrl(Uri.parse('tel:5707306740')), outline: true),
        const SizedBox(width: 8),
        smallBtn('Offer', () => go(12)),
      ],
    ]),
  );

  Widget dropdown(String value, List<String> items, ValueChanged<String?> onChanged) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(color: Colors.black.withOpacity(.65), borderRadius: BorderRadius.circular(8), border: Border.all(color: cyan.withOpacity(.35))),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        dropdownColor: const Color(0xFF050B18),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    ),
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
    child: Container(width: double.infinity, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(8)), child: Center(child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)))),
  );

  Widget verseBox() => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.black.withOpacity(.62), borderRadius: BorderRadius.circular(14), border: Border.all(color: cyan.withOpacity(.55))),
    child: const Text('Philippians 4:13 — I can do all things through Christ who strengthens me.\nPowered by Syntax Phantom @ 2026', textAlign: TextAlign.center),
  );

  BoxDecoration glassBox() => BoxDecoration(color: const Color(0xCC050B18), borderRadius: BorderRadius.circular(16), border: Border.all(color: blue.withOpacity(.85)), boxShadow: [BoxShadow(color: blue.withOpacity(.32), blurRadius: 18)]);

  BoxDecoration futureBox() => BoxDecoration(
    gradient: LinearGradient(colors: [const Color(0xFF02040D), const Color(0xFF062A68).withOpacity(.82), const Color(0xFF02040D)]),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: cyan.withOpacity(.9), width: 1.4),
    boxShadow: [BoxShadow(color: blue.withOpacity(.40), blurRadius: 34)],
  );

  void snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class PrimeXLogo extends StatelessWidget {
  const PrimeXLogo({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(width: 420, height: 105, child: Center(child: Text('PRIMEX  MARKETPLACE\nBUY • SELL • CONNECT', style: TextStyle(color: Color(0xFF00F5FF), fontSize: 20, fontWeight: FontWeight.w900))));
}
DART

flutter clean
flutter pub get
flutter run -d chrome
