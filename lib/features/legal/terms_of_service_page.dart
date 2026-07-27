import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Text('Terms of Service'), backgroundColor: Colors.black),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Text(
          'PrimeX Marketplace Terms of Service\n\n'
          'PrimeX is a professional marketplace platform for buying, selling, connecting, listings, jobs, services, ads, affiliate programs, and youth badge programs. '
          'Users must follow marketplace rules. No scams, no abuse, no nudity, no illegal activity, no fake accounts, and no posting personal contact information to bypass platform safety.\n\n'
          'Support: support@primexmarketplace.com',
          style: TextStyle(color: Colors.white70, height: 1.4),
        ),
      ),
    );
  }
}
