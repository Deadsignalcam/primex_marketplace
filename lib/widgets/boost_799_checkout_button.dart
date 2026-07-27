import 'package:flutter/material.dart';
import 'dart:html' as html;

class Boost799CheckoutButton extends StatelessWidget {
  const Boost799CheckoutButton({super.key});

  static const String checkoutUrl =
      'https://buy.stripe.com/bJe28r6Gc2aS98D6Pxgfu02';

  void _openCheckout() {
    html.window.location.href = checkoutUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyanAccent, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Boost Listing - 4 Days',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('PrimeX Marketplace featured boost for \$7.99.',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: _openCheckout,
              child: const Text('Pay \$7.99 Boost with Stripe'),
            ),
          ),
        ],
      ),
    );
  }
}
