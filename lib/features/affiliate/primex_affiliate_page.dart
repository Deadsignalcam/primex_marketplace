import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/primex_affiliate_service.dart';
import 'primex_affiliate_profile_edit_page.dart';
import 'primex_youth_entrepreneur_page.dart';

class PrimeXAffiliatePage extends StatelessWidget {
  const PrimeXAffiliatePage({super.key});

  static BoxDecoration neonBox({Color color = Colors.cyanAccent}) {
    return BoxDecoration(
      color: Colors.black.withOpacity(.74),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color),
      boxShadow: [
        BoxShadow(color: color.withOpacity(.18), blurRadius: 18),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final u = FirebaseAuth.instance.currentUser;

    if (u == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Affiliate login required.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: PrimeXAffiliateService.ensureAffiliate(),
      builder: (context, futureSnap) {
        return Scaffold(
          backgroundColor: Colors.black,
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
              SafeArea(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('affiliates')
                      .doc(u.uid)
                      .snapshots(),
                  builder: (context, snap) {
                    final d = snap.data?.data() ?? futureSnap.data ?? {};

                    final name = (d['displayName'] ??
                            u.displayName ??
                            'PrimeX Affiliate')
                        .toString();
                    final photo = (d['photoUrl'] ?? '').toString();
                    final code = (d['affiliateCode'] ?? d['referralCode'] ?? '')
                        .toString();
                    final link = (d['referralLink'] ??
                            'https://primexmarketplace.com/ref/$code')
                        .toString();
                    final founder = d['founderAffiliate'] == true;
                    final member = d['founderMemberNumber'] ?? '...';
                    final youthLevel =
                        (d['youthLevel'] ?? 'Affiliate Starter').toString();

                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Affiliate Dashboard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const PrimeXAffiliateProfileEditPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit Profile'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: neonBox(color: Colors.greenAccent),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 39,
                                backgroundColor: Colors.greenAccent,
                                backgroundImage: photo.startsWith('http')
                                    ? NetworkImage(photo)
                                    : null,
                                child: photo.startsWith('http')
                                    ? null
                                    : const Icon(
                                        Icons.person,
                                        size: 42,
                                        color: Colors.black,
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Welcome Back',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      founder
                                          ? '🏆 Founding Affiliate • Member #$member'
                                          : 'Active Affiliate',
                                      style: const TextStyle(
                                        color: Colors.greenAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '🎓 Youth Entrepreneur • $youthLevel',
                                      style: const TextStyle(
                                        color: Colors.cyanAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        youthCard(context),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            statBox('Clicks', '${d['totalClicks'] ?? 0}',
                                Icons.ads_click),
                            statBox('Referrals', '${d['totalReferrals'] ?? 0}',
                                Icons.people),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            statBox('New User Credit', '\$12.25',
                                Icons.card_giftcard),
                            statBox('You Earn', '\$2.25', Icons.attach_money),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: neonBox(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your Referral Link',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SelectableText(
                                link,
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              row('Referral Code', code),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: neonBox(),
                          child: Column(
                            children: [
                              row('Pending Payout',
                                  '\$${d['pendingPayout'] ?? 0}'),
                              row('Total Earned', '\$${d['totalEarned'] ?? 0}'),
                              row('Total Paid', '\$${d['totalPaid'] ?? 0}'),
                              row('Payout Cycle', 'Monthly'),
                              row(
                                  'Founder Status',
                                  founder
                                      ? 'Active Founder'
                                      : 'Standard Affiliate'),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget youthCard(BuildContext context) {
    return Container(
      decoration: neonBox(color: Colors.greenAccent),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: const Icon(Icons.school, color: Colors.greenAccent, size: 34),
        title: const Text(
          'Youth Entrepreneur Program',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        subtitle: const Text(
          'Ages 13+. Learn marketing, referrals, business skills and responsible online earning.',
          style: TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.greenAccent),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PrimeXYouthEntrepreneurPage(),
            ),
          );
        },
      ),
    );
  }

  Widget statBox(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        height: 122,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: neonBox(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.cyanAccent, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white70)),
            Text(
              value,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget row(String a, String b) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(a, style: const TextStyle(color: Colors.white70)),
          ),
          Flexible(
            child: SelectableText(
              b,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
