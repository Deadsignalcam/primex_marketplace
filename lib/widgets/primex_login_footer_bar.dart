import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../features/auth/login_page.dart';
import '../features/legal/policy_terms_page.dart';

class PrimeXLoginFooterBar extends StatelessWidget {
  const PrimeXLoginFooterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PolicyTermsPage()),
            );
          },
          icon: const Icon(Icons.policy),
          label: const Text('Privacy Policy • Terms • Safety Rules'),
        ),
        const SizedBox(height: 8),
        if (user != null)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully.')),
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          )
        else
          const Text(
            'By logging in, you agree to PrimeX Marketplace policies, terms, privacy rules, Safe Meet rules, and community standards.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.35),
          ),
      ],
    );
  }
}
