import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyTermsPage extends StatelessWidget {
  const PolicyTermsPage({super.key});

  Future<void> call911(BuildContext context) async {
    final uri = Uri.parse('tel:911');
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Could not open phone dialer. Call 911 manually if this is an emergency.')),
      );
    }
  }

  Future<void> shareLocation(BuildContext context) async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Location permission is required to share your location.')),
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final link =
          'https://maps.google.com/?q=${pos.latitude},${pos.longitude}';
      final msg = 'PrimeX Safe Meet Location: $link';

      await Clipboard.setData(ClipboardData(text: msg));

      final sms = Uri.parse('sms:?body=${Uri.encodeComponent(msg)}');
      await launchUrl(sms);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location copied and message app opened.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location share error: $e')),
      );
    }
  }

  Widget safeMeetActions(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xDD07101D),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFFD700)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Safe Meet Tools',
                style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => shareLocation(context),
              icon: const Icon(Icons.share_location),
              label: const Text('Share My Location'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => call911(context),
              icon: const Icon(Icons.emergency),
              label: const Text('Call 911 Emergency'),
              style:
                  OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
            ),
          ],
        ),
      );

  Widget box(String title, String body) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xDD07101D),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF00E5FF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(body,
                style: const TextStyle(
                    color: Colors.white, fontSize: 13, height: 1.35)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black, title: const Text('Policies & Terms')),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('assets/images/primex_neon_city_two_bg.png',
                  fit: BoxFit.cover)),
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(.75))),
          ListView(
            padding: const EdgeInsets.all(14),
            children: [
              const Center(
                  child: Text('PrimeX Marketplace',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold))),
              const Center(
                  child: Text(
                      'Privacy Policy • Terms • Safety Rules • Community Standards',
                      style: TextStyle(
                          color: Color(0xFF00E5FF),
                          fontWeight: FontWeight.bold))),
              const SizedBox(height: 16),
              box('Privacy Promise',
                  'PrimeX Marketplace protects user privacy. Personal emails, phone numbers, passwords, payment details, and private account information are not publicly displayed.'),
              box('Information We Collect',
                  'PrimeX may collect account information, profile details, listings, posts, uploaded photos/videos, messages, saved items, reports, location data, and marketplace activity to operate the platform.'),
              box('Marketplace Terms',
                  'PrimeX is a marketplace platform for buying, selling, advertising, jobs, services, real estate, and professional connections. Users are responsible for their own listings, transactions, and agreements.'),
              box('Safe Meet Rules',
                  'For item exchanges, meet in safe public places. For real estate, deed, or professional transfers, meet at a title company, courthouse, attorney office, broker office, or licensed closing office.'),
              safeMeetActions(context),
              box('Pet Policy',
                  'Animals may only be rehomed into a good home. Animal sales are not allowed. Pet supplies, toys, and accessories may be sold or given away.'),
              box('Prohibited Content',
                  'Fraud, scams, stolen property, counterfeit items, illegal drugs, prohibited weapons, harassment, hate speech, explicit sexual content, malware, and unlawful content are prohibited.'),
              box('Payments & Refunds',
                  'Payments may be processed through trusted providers such as Stripe. Digital ads, boosts, subscriptions, and premium services may be non-refundable unless required by law or clearly stated.'),
              box('Advertising Policy',
                  'Ads and promotions must follow PrimeX rules. PrimeX may review, reject, remove, or suspend ads that violate policy or create user risk.'),
              box('Community Standards',
                  'Users must treat others respectfully, avoid spam, avoid impersonation, protect private information, follow the law, and report suspicious activity.'),
              box('Account Deletion',
                  'Users may request account deletion through PrimeX support. Some records may be retained for legal compliance, safety investigations, fraud prevention, payment records, or legitimate business needs.'),
              box('Limitation of Liability',
                  'PrimeX is provided as a marketplace platform. To the fullest extent permitted by law, PrimeX is not responsible for user-to-user disputes, losses, injuries, damages, or third-party transactions.'),
              const SizedBox(height: 20),
              const Center(
                  child: Text(
                      'PrimeX Marketplace — Buy • Sell • Connect • Grow',
                      style: TextStyle(
                          color: Color(0xFF00E5FF),
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ],
      ),
    );
  }
}
