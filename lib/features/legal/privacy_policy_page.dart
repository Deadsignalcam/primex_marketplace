import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Text('Privacy Policy'), backgroundColor: Colors.black),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Text(
          'PrimeX Marketplace Privacy Policy\n\n'
          'PrimeX protects user privacy. We do not publicly display personal phone numbers or personal emails. '
          'Users communicate through PrimeX secure messaging and platform tools. '
          'Account information, listings, messages, payments, and program applications may be stored securely using Firebase and related services.\n\n'
          'Support: support@primexmarketplace.com',
          style: TextStyle(color: Colors.white70, height: 1.4),
        ),
      ),
    );
  }
}
