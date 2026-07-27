import 'package:flutter/material.dart';
import 'primex_affiliate_page.dart';

class PrimeXAffiliateLandingPage extends StatelessWidget {
  const PrimeXAffiliateLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('PrimeX Affiliate Signup'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/primex_digital_marketplace_bg.svg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.black),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(.62)),
          ),
          ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const SizedBox(height: 24),
              const Icon(Icons.handshake, color: Colors.amber, size: 82),
              const SizedBox(height: 16),
              const Text(
                'JOIN PRIME X AFFILIATE PROGRAM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Create your own referral code, share your link, and earn commission when people join PrimeX Pro.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: 24),
              box('Create Your Code',
                  'Example: SYNTAXPHANTOM, ROSALIND, CPFILLC'),
              box('Share Your Link',
                  'https://primexmarketplace.com/ref/YOURCODE'),
              box('Earn Commission',
                  'PrimeX Pro signup: 25% affiliate commission'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PrimeXAffiliatePage()),
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Sign Up / Open Affiliate Dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget box(String title, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.62),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyanAccent.withOpacity(.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
