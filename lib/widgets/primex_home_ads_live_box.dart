import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXHomeAdsLiveBox extends StatelessWidget {
  const PrimeXHomeAdsLiveBox({super.key});

  String mediaFrom(Map<String, dynamic> d) {
    return (d['mediaUrl'] ?? d['imageUrl'] ?? d['bannerUrl'] ?? '').toString();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('paid_homepage_ads')
          .orderBy('createdAt', descending: true)
          .limit(12)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const SizedBox(height: 125);
        }

        final docs = snap.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'LIVE ADS & PROMOTIONS',
              style: TextStyle(
                color: Color(0xFF00E5FF),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: docs.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.75),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF00E5FF)),
                      ),
                      child: const Center(
                        child: Text(
                          'Paid ads will appear here live after posting.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, i) {
                        final d = docs[i].data() as Map<String, dynamic>;
                        final media = mediaFrom(d);
                        final title =
                            (d['title'] ?? d['businessName'] ?? 'PrimeX Ad')
                                .toString();
                        final plan =
                            (d['plan'] ?? d['type'] ?? 'Sponsored').toString();

                        return Container(
                          width: 170,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.82),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF00E5FF)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: media.isNotEmpty
                                    ? Image.network(
                                        media,
                                        height: 82,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => adIcon(),
                                      )
                                    : adIcon(),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                plan,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.amberAccent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget adIcon() {
    return Container(
      height: 82,
      width: double.infinity,
      color: Colors.black45,
      child: const Icon(Icons.campaign, color: Color(0xFF00E5FF), size: 34),
    );
  }
}
