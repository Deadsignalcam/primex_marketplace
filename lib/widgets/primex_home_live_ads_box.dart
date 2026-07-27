import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXHomeLiveAdsBox extends StatelessWidget {
  const PrimeXHomeLiveAdsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFD700), width: 1.3),
      ),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance.collection('ads').limit(6).snapshots(),
        builder: (context, snap) {
          final ads = snap.data?.docs ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LIVE ADS / PROMOTIONS / ADVERTISEMENT',
                style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (ads.isEmpty)
                const Text(
                  'Upload banners, clips, videos, and paid promotions here.',
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                )
              else
                ...ads.map((doc) {
                  final d = doc.data();
                  final title = d['title']?.toString() ?? 'PrimeX Ad';
                  final text = d['description']?.toString() ?? 'Live promotion';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '📢 $title\n$text',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
