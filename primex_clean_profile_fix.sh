#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_clean_profile_$(date +%Y%m%d_%H%M%S).dart"

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

  void go(int i) => setState(() => page = i);
  void snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final pages = [
      home(), howItWorks(), about(), pricing(), contact(), login(), signup(),
      dashboard(), marketplace(), mapPage(), postListing(), messages(), offers(), admin(), profile(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF02040D),
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
      btn('Login', () => go(5), outline: true),
      const SizedBox(width: 10),
      btn('Sign Up', () => go(6)),
    ]),
  );

  Widget navItem(String t, int i) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 9),
    child: InkWell(onTap: () => go(i), child: Text(t, style: TextStyle(color: page == i ? cyan : Colors.white, fontWeight: FontWeight.bold))),
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
    field('Listing Title'), field('Category'), field('Price or Rate'), field('Address'), field('Country / State / County / City'),
    field('Description'), field('Upload Photos / Video'),
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
    field('Offer Amount'), field('Financing Type'), field('Upload Proof of Funds PDF / JPG / PNG'), field('Message To Seller'),
    fullBtn('Submit Verified Offer', () => snack('Offer submitted with proof of funds.')),
  ]);

  Widget profile() => pageBox('My Profile + Account Settings', 'Manage account identity, contact, payment, and security.', [
    card('👤', 'Profile Photo', 'Upload or update your profile picture.'),
    fullBtn('Upload Profile Photo', () => snack('Photo upload will connect to Firebase Storage.')),
    field('Full Name'), field('Email Address'), field('Phone Number'), field('Street Address'), field('City / State / ZIP'),
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

  Widget home() => pageBox('PrimeX Marketplace', 'Public landing page. Login opens dashboard.', [
    card('🌎', 'Global Marketplace', 'Real estate, foreclosures, rentals, vehicles, services, jobs, tools, and business listings.'),
    card('🔐', 'Secure Platform', 'AI safety, proof of funds, account protection, and admin review.'),
    fullBtn('Login To Dashboard', () => go(5)),
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

  Widget login() => pageBox('Login', 'Access dashboard.', [field('Email'), field('Password'), fullBtn('Login To Dashboard', () => go(7))]);
  Widget signup() => pageBox('Sign Up', 'Create account.', [field('Full Name'), field('Email'), field('Phone'), field('Password'), fullBtn('Create Account + Open Dashboard', () => go(7))]);

  Widget pageBox(String title, String subtitle, List<Widget> children) => Padding(
    padding: const EdgeInsets.all(28),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: box(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (page != 0) Row(children: [btn('← Back', () => go(page >= 8 ? 7 : 0), outline: true), const SizedBox(width: 10), if (page >= 8) btn('Dashboard', () => go(7))]),
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
    decoration: glass(),
    child: const Text('Philippians 4:13 — I can do all things through Christ who strengthens me.\nPowered by Syntax Phantom @ 2026', textAlign: TextAlign.center),
  );

  BoxDecoration glass() => BoxDecoration(color: const Color(0xCC050B18), borderRadius: BorderRadius.circular(16), border: Border.all(color: blue.withOpacity(.85)), boxShadow: [BoxShadow(color: blue.withOpacity(.32), blurRadius: 18)]);
  BoxDecoration box() => BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF02040D), const Color(0xFF062A68).withOpacity(.82), const Color(0xFF02040D)]), borderRadius: BorderRadius.circular(22), border: Border.all(color: cyan.withOpacity(.9), width: 1.4));
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
