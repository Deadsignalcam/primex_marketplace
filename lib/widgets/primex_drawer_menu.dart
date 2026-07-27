import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../features/legal/policy_terms_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/feed/live_feed_page.dart';
import '../features/listings/listings_page.dart';
import '../features/map/map_page.dart';
import '../features/jobs/jobs_services_page.dart';
import '../features/ads/ads_promotions_page.dart';
import '../features/affiliate/primex_affiliate_center_page.dart';
import '../features/affiliate/primex_affiliate_page.dart';
import '../features/affiliate/primex_affiliate_cashout_page.dart';
import '../features/messages/messages_page.dart';
import '../features/profile/profile_page.dart';
import '../features/auth/login_page.dart';
import '../features/admin/admin_gate_page.dart';
import '../features/primex_pro/primex_pro_login_page.dart';
import '../features/primex_pro/primex_pro_dashboard_page.dart';
import '../features/primex_pro/primex_pro_gate_page.dart';
import '../features/primex_pro/primex_pro_page.dart';
import '../features/pro_map/primex_pro_lead_map_page.dart';

class PrimeXDrawerMenu extends StatelessWidget {
  const PrimeXDrawerMenu({super.key});

  bool get isOwner {
    final email =
        FirebaseAuth.instance.currentUser?.email?.trim().toLowerCase() ?? '';
    return email == 'rosariogonzalezrosalind@gmail.com' ||
        email == 'support@primexmarketplace.com';
  }

  void go(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> supportEmail(BuildContext context) async {
    final uri = Uri.parse(
        'mailto:support@primexmarketplace.com?subject=PrimeX%20Support');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email support@primexmarketplace.com')),
      );
    }
  }

  Widget item(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.cyanAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () => go(context, page),
    );
  }

  Widget actionItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.cyanAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget section(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
        child: Text(title,
            style: const TextStyle(
                color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF061125)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PRIME X',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  Text('Marketplace',
                      style: TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('BUY • SELL • CONNECT • GROW',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            section('MARKETPLACE'),
            item(
                context, Icons.dynamic_feed, 'Live Feed', const LiveFeedPage()),
            item(context, Icons.storefront, 'Listings', const ListingsPage()),
            item(context, Icons.map, 'Marketplace Map', const MapPage()),
            item(context, Icons.work, 'Jobs & Services',
                const JobsServicesPage()),
            item(context, Icons.campaign, 'Ads & Promotions',
                const AdsPromotionsPage()),
            section('MY ACCOUNT'),
            item(context, Icons.login, 'Login / Sign Up',
                const LoginPage(role: 'member')),
            item(context, Icons.person, 'My Profile', const ProfilePage()),
            item(context, Icons.message, 'Messages', const MessagesPage()),
            section('AFFILIATE'),
            item(context, Icons.handshake, 'Affiliate Program',
                const PrimeXAffiliateCenterPage()),
            item(context, Icons.payments, 'Affiliate Dashboard / Payouts',
                const PrimeXAffiliatePage()),
            item(context, Icons.account_balance_wallet, 'Request Payout',
                const PrimeXAffiliateCashoutPage()),
            section(r'PRIMEX PRO $49.99'),
            item(context, Icons.login, 'PrimeX Pro Login',
                const PrimeXProLoginPage()),
            item(context, Icons.workspace_premium, 'PrimeX Pro Access / Pay',
                const PrimeXProGatePage()),
            item(context, Icons.dashboard, 'PrimeX Pro Dashboard',
                const PrimeXProDashboardPage()),
            item(context, Icons.location_on, 'PrimeX Pro Lead Map',
                const PrimeXProLeadMapPage()),
            item(context, Icons.home_work,
                'Foreclosures / Tax Sales / Tax Liens', const PrimeXProPage()),
            if (isOwner) ...[
              section('OWNER / ADMIN'),
              item(context, Icons.admin_panel_settings, 'Admin Dashboard',
                  const AdminGatePage()),
            ],
            section('SUPPORT'),
            actionItem(context, Icons.email, 'support@primexmarketplace.com',
                () => supportEmail(context)),
            item(context, Icons.privacy_tip, 'Privacy Policy',
                const PolicyTermsPage()),
            item(context, Icons.description, 'Terms of Service',
                const PolicyTermsPage()),
            section('OWNER CONSOLE'),
            item(context, Icons.admin_panel_settings, 'Admin Dashboard',
                const AdminGatePage()),
            const Divider(color: Colors.white24),
            if (FirebaseAuth.instance.currentUser != null)
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Logout',
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (_) => false,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
