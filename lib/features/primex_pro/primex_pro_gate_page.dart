import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'primex_pro_dashboard_page.dart';

Future<void> openPrimeXProStripe() async {
  final uri = Uri.parse('https://buy.stripe.com/4gMaEX3u02aSckP2zhgfu09');
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class PrimeXProGatePage extends StatelessWidget {
  const PrimeXProGatePage({super.key});

  Future<void> openStripeProCheckout(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login first to upgrade to PrimeX Pro.')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('payment_requests').add({
      'userId': user.uid,
      'email': user.email,
      'plan': 'PrimeX Pro',
      'amount': 49.99,
      'amountCents': 4999,
      'currency': 'usd',
      'status': 'pending_payment',
      'createdAt': FieldValue.serverTimestamp(),
    });

    final doc = await FirebaseFirestore.instance
        .collection('stripe_products')
        .doc('primex_pro_4999')
        .get();

    final data = doc.data() ?? {};
    final link =
        (data['checkoutUrl'] ?? data['paymentLink'] ?? data['url'] ?? '')
            .toString();

    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Stripe link missing. Add it in Firestore: stripe_products/primex_pro_4999'),
        ),
      );
      return;
    }

    final uri = Uri.parse(link);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: user == null
          ? null
          : FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
      builder: (context, snap) {
        final d = snap.data?.data() as Map<String, dynamic>? ?? {};
        final active = d['primeXPro'] == true ||
            d['proStatus'] == 'active' ||
            d['subscriptionStatus'] == 'active';

        if (active) {
          return const PrimeXProDashboardPage();
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('PrimeX Pro'),
          ),
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(18),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF061125),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.cyanAccent.withOpacity(.55)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.workspace_premium,
                      color: Colors.amberAccent, size: 58),
                  const SizedBox(height: 12),
                  const Text(
                    'PrimeX Pro',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\$49.99 / Month',
                    style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Unlock foreclosure leads, sheriff sales, tax sale leads, Pro lead map, full addresses, ROI tools, 30 photos, and 5 videos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => openStripeProCheckout(context),
                    icon: const Icon(Icons.lock_open),
                    label: const Text('Pay \$49.99 / Month with Stripe'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
