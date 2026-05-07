import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeLinks {
  static const String boost799 = "https://buy.stripe.com/YOUR_BOOST_799_LINK";
  static const String premium1499 = "https://buy.stripe.com/YOUR_PREMIUM_1499_LINK";

  static Future<void> openCheckout(BuildContext context, String url, String label) async {
    if (url.contains("YOUR_")) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(label),
          content: const Text("Add your real Stripe Payment Link in lib/services/stripe_links.dart first."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }
}
