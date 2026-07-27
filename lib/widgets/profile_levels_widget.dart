import 'package:flutter/material.dart';
import '../data/primex_config.dart';

class ProfileLevelsWidget extends StatelessWidget {
  const ProfileLevelsWidget({super.key});

  Widget levelCard({
    required String title,
    required String price,
    required String details,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(.85),
            const Color(0xFF071B44),
          ],
        ),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            details,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        levelCard(
          title: 'Free Seller',
          price: 'FREE',
          details:
              'Post standard listings free worldwide on PrimeX Marketplace.',
          color: Colors.blue,
        ),
        levelCard(
          title: 'Boost 4 Days',
          price: '\$${PrimeXConfig.boost4Day}',
          details:
              'Push your listing higher on search results and map pins for 4 days.',
          color: Colors.cyan,
        ),
        levelCard(
          title: 'Boost 15 Days',
          price: '\$${PrimeXConfig.boost15Day}',
          details:
              'Stay pinned at the top longer with stronger marketplace visibility.',
          color: Colors.purple,
        ),
        levelCard(
          title: 'PrimeX Pro',
          price: '\$${PrimeXConfig.proLevelMonthly}/month',
          details:
              'Investor tools, foreclosure leads, analytics, lead tracking, priority visibility, and advanced property systems.',
          color: Colors.orange,
        ),
      ],
    );
  }
}
