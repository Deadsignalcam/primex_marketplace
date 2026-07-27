import 'package:flutter/material.dart';

class PrimeXProPage extends StatelessWidget {
  const PrimeXProPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('PrimeX Pros'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/primex_jobs_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(.76)),
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'PrimeX Pro Center',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Pros can manage premium listings, 30 photos, 5 videos, lead access, service tools, and professional marketplace features here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 18),
              proBox(Icons.verified, 'Pro Profile',
                  'Build a verified seller or service profile.'),
              proBox(Icons.photo_library, '30 Photos / 5 Videos',
                  'Premium media limits for Pro users.'),
              proBox(Icons.map, 'Map Pin Priority',
                  'Premium listings and leads appear on the map.'),
              proBox(Icons.work, 'Jobs & Services Leads',
                  'Access contractor, service, and lead tools.'),
              proBox(Icons.home_work, 'Property Leads',
                  'Foreclosure, sheriff sale, and tax lead tools.'),
            ],
          ),
        ],
      ),
    );
  }

  Widget proBox(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                Text(subtitle, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
