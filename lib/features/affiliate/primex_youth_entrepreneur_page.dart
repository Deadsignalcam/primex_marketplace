import 'package:flutter/material.dart';

class PrimeXYouthEntrepreneurPage extends StatelessWidget {
  const PrimeXYouthEntrepreneurPage({super.key});

  static BoxDecoration neonBox() {
    return BoxDecoration(
      color: Colors.black.withOpacity(.74),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.cyanAccent),
      boxShadow: [
        BoxShadow(
          color: Colors.cyanAccent.withOpacity(.20),
          blurRadius: 18,
        ),
      ],
    );
  }

  Widget card(String title, IconData icon, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: neonBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.cyanAccent, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Text(
                '✓ $item',
                style: const TextStyle(color: Colors.white70, height: 1.25),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Youth Entrepreneur Program'),
        backgroundColor: Colors.black,
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
            child: Container(color: Colors.black.withOpacity(.72)),
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Icon(Icons.school, color: Colors.greenAccent, size: 86),
              const SizedBox(height: 12),
              const Text(
                'PrimeX Youth Entrepreneur Program',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Helping young entrepreneurs learn, earn, and build their future from home.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, height: 1.35),
              ),
              const SizedBox(height: 20),
              card('Ages 13+', Icons.verified_user, [
                'Parent permission recommended for members under 18',
                'Payouts should use a parent-approved payment account',
                'Safe, professional online earning education',
              ]),
              card('Learn Real Business Skills', Icons.lightbulb, [
                'Marketing',
                'Social media promotion',
                'Affiliate sales',
                'Customer service',
                'Entrepreneurship',
              ]),
              card('Earn Rewards', Icons.payments, [
                'New member receives 12.25 PrimeX account credit',
                'Affiliate earns 2.25 per qualified referral',
                'Unlimited referrals',
                'Monthly payout tracking',
              ]),
              card('Achievement Levels', Icons.emoji_events, [
                '🥉 Affiliate Starter',
                '🥈 Community Promoter',
                '🥇 Digital Marketer',
                '💎 PrimeX Ambassador',
                '👑 Founder Elite',
              ]),
              card('Safety Rules', Icons.shield, [
                'No spam',
                'No fake accounts',
                'No misleading advertising',
                'No sharing personal information',
                'Professional conduct required',
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
