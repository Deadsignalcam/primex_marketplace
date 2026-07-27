import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXHomeLiveFeedFull extends StatelessWidget {
  const PrimeXHomeLiveFeedFull({super.key});

  String pick(Map<String, dynamic> d, List<String> keys, String fallback) {
    for (final k in keys) {
      final v = d[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return fallback;
  }

  Widget card(String type, Map<String, dynamic> d) {
    final title =
        pick(d, ['title', 'name', 'itemName', 'category'], 'PrimeX Listing');
    final body = pick(d, ['description', 'details', 'message', 'text', 'body'],
        'New PrimeX activity');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.38),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00E5FF)),
      ),
      child: Row(
        children: [
          Icon(type == 'LISTING' ? Icons.storefront : Icons.dynamic_feed,
              color: const Color(0xFF00E5FF), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$type • $title\n$body',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF00E5FF), width: 1.3),
      ),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('listings')
            .limit(10)
            .snapshots(),
        builder: (context, listingSnap) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .limit(10)
                .snapshots(),
            builder: (context, postSnap) {
              final items = <Widget>[];

              for (final d in listingSnap.data?.docs ?? []) {
                items.add(card('LISTING', d.data()));
              }

              for (final d in postSnap.data?.docs ?? []) {
                items.add(card('LIVE POST', d.data()));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LIVE FEED POSTING / LISTING',
                    style: TextStyle(
                        color: Color(0xFF00E5FF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (items.isEmpty)
                    const Text(
                      'No live posts or listings yet. Everything users post/list will show here.',
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold),
                    )
                  else
                    ...items.take(8),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
