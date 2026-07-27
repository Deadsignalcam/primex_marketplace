#!/usr/bin/env bash
set -e

echo "Adding PrimeX platform rules page..."

mkdir -p lib/pages

cat > lib/pages/primex_rules_page.dart <<'DART'
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
        padding: const EdgeInsets.all(22),
        child: Container(
          padding: const EdgeInsets.all(22),
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
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38F8FF),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'PrimeX Marketplace is a professional marketplace for buying, selling, real estate, foreclosures, services, jobs, vehicles, tools, and business listings. This is not a dating, hookup, adult, or harassment platform.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Not Allowed',
                style: TextStyle(
                  fontSize: 22,
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
                          style: const TextStyle(color: Colors.white, fontSize: 15),
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
                  fontSize: 22,
                  color: Color(0xFF00D9FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Violations may be automatically flagged, blocked, sent to admin review, suspended, or permanently removed from PrimeX Marketplace. Three serious violations can result in a permanent ban.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
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
DART

# Update safety blocked words too
cat > lib/safety/primex_safety_rules.dart <<'DART'
class PrimeXSafetyRules {
  static const int maxPostsPerDay = 30;
  static const int banLimit = 3;

  static const List<String> blockedWords = [
    'nude','nudity','sexy','sex','escort','onlyfans','porn','xxx',
    'hookup','hook up','dating','date me','come over','adult services',
    'hate','racist','discrimination','threat','harass',
    'weapon','gun','drugs','scam','fraud',
  ];

  static Map<String, dynamic> scanContent({
    required String text,
    required int postsToday,
    required int userStrikes,
  }) {
    final lower = text.toLowerCase();
    final matched = blockedWords.where((w) => lower.contains(w)).toList();

    if (matched.isNotEmpty) {
      return {
        'allowed': false,
        'flagged': true,
        'status': 'blocked',
        'reason': 'Blocked PrimeX policy content detected.',
        'matchedWords': matched,
        'action': 'remove_or_send_to_admin_review',
      };
    }

    if (postsToday >= maxPostsPerDay) {
      return {
        'allowed': false,
        'flagged': true,
        'status': 'rate_limited',
        'reason': '30 or more posts in one day. Admin review required.',
        'action': 'admin_review',
      };
    }

    if (userStrikes >= banLimit) {
      return {
        'allowed': false,
        'flagged': true,
        'status': 'banned',
        'reason': 'User reached 3 violations.',
        'action': 'kick_from_platform',
      };
    }

    return {
      'allowed': true,
      'flagged': false,
      'status': 'approved',
      'reason': 'Passed PrimeX AI Autopilot.',
      'action': 'publish_or_send',
    };
  }
}
DART

flutter clean
flutter pub get
flutter analyze || true
flutter build web --release

echo "PrimeX rules page and no-dating/no-adult/no-abuse policy added."
