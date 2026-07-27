import 'package:flutter/material.dart';
import '../services/primex_social_auth_service.dart';

class PrimeXSocialLoginButtons extends StatelessWidget {
  const PrimeXSocialLoginButtons({super.key});

  Future<void> safeRun(BuildContext context, Future<void> Function() fn) async {
    try {
      await fn();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Fast sign in',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.g_mobiledata, size: 28),
                label: const Text('Google'),
                onPressed: () =>
                    safeRun(context, PrimeXSocialAuthService.signInWithGoogle),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.apple),
                label: const Text('Apple'),
                onPressed: () =>
                    safeRun(context, PrimeXSocialAuthService.signInWithApple),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
