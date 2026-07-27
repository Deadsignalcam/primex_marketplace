import 'package:flutter/material.dart';
import 'dart:html' as html;

class PrimeXPostingAccess extends StatelessWidget {
  const PrimeXPostingAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.cyanAccent,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '35 Day Posting Access',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Post Realtor, Broker, Vehicle, Service, and Job listings for 35 days Craigslist-style.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            '\$5.00 Access',
            style: TextStyle(
              color: Colors.yellowAccent,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () {
              html.window.open(
                'https://buy.stripe.com/4gM14n3u0bLsckP2zhgfu04',
                '_blank',
              );
            },
            child: const Text(
              'Activate 35 Days - \$5',
            ),
          ),
        ],
      ),
    );
  }
}
