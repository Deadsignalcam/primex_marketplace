import 'package:flutter/material.dart';

class PrimeXRulesPage extends StatelessWidget {
  const PrimeXRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final banned = [
      'Dating, hookup, or romantic solicitation',
      'Sexual messages, nude photos, adult content, escort services',
      'Harassment, threats, bullying, or unwanted repeated contact',
      'Discrimination, hate speech, or racist content',
      'Scams, fraud, fake listings, or misleading property posts',
      'Posting 30 or more properties in one day without review',
      'Abusing messages, calls, comments, or platform tools',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: const Text('PrimeX Marketplace Rules'),
        backgroundColor: const Color(0xFF020617),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF06111F),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF00D9FF)),
            boxShadow: const [
              BoxShadow(color: Color(0x8800D9FF), blurRadius: 20),
            ],
          ),
          child: ListView(
            children: [
              const Text(
                'PrimeX Safety Policy',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38F8FF),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'PrimeX Marketplace is a professional marketplace for buying, selling, real estate, foreclosures, services, jobs, vehicles, tools, and business listings. This is not a dating, hookup, adult, or harassment platform.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 24),
              const Text(
                'Not Allowed',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF00D9FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...banned.map(
                (rule) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.block, color: Colors.redAccent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          rule,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'AI Autopilot Enforcement',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF00D9FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Violations may be automatically flagged, blocked, sent to admin review, suspended, or permanently removed from PrimeX Marketplace. Three serious violations can result in a permanent ban.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 24),
              const Text(
                'Powered by Syntax Phantom @ 2026',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF38F8FF), letterSpacing: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
