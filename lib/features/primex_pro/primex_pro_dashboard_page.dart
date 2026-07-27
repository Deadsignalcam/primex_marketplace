import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openPrimeXProStripe() async {
  final uri = Uri.parse('https://buy.stripe.com/4gMaEX3u02aSckP2zhgfu09');
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class PrimeXProDashboardPage extends StatelessWidget {
  const PrimeXProDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('Login required.', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snap) {
        final data = snap.data?.data() ?? {};
        final isPro =
            data['isPrimeXPro'] == true || data['subscriptionActive'] == true;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('PrimeX Pro Dashboard'),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.25,
                colors: [Color(0xFF092B46), Color(0xFF020617), Colors.black],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isPro ? Icons.verified : Icons.lock,
                        color: isPro ? Colors.greenAccent : Colors.amber,
                        size: 52,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isPro ? 'PrimeX Pro Active' : 'PrimeX Pro Locked',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isPro
                            ? 'You have unlimited Pro market lead access.'
                            : 'Pay 49/month to unlock unlimited Pro market leads.',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      section('Pro Includes'),
                      item('30 photos per Pro lead'),
                      item('5 videos per Pro lead'),
                      item('Full address unlock'),
                      item('Parcel number and auction data'),
                      item('Map pins and county links'),
                      item('ARV, rehab, ROI and investment score'),
                      item('Proof of funds upload'),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: isPro ? null : openPrimeXProStripe,
                  icon: const Icon(Icons.gavel),
                  label: const Text('Open Pro Market Leads'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 12),
                if (!isPro)
                  OutlinedButton.icon(
                    onPressed: openPrimeXProStripe,
                    icon: const Icon(Icons.payment),
                    label: const Text('Pay \$49.99/month For PrimeX Pro'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.58),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.cyanAccent.withOpacity(.25)),
      ),
      child: child,
    );
  }

  Widget section(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      );

  Widget item(String text) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.greenAccent, size: 19),
            const SizedBox(width: 8),
            Expanded(
                child: Text(text, style: const TextStyle(color: Colors.white))),
          ],
        ),
      );
}
