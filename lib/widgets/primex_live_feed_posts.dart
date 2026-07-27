import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXLiveFeedPosts extends StatelessWidget {
  const PrimeXLiveFeedPosts({super.key});

  String _text(Map<String, dynamic> data, List<String> keys, String fallback) {
    for (final k in keys) {
      final v = data[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('listings')
          .limit(8)
          .snapshots(),
      builder: (context, listingSnap) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .limit(8)
              .snapshots(),
          builder: (context, postSnap) {
            final items = <Map<String, dynamic>>[];

            for (final d in listingSnap.data?.docs ?? []) {
              final data = d.data();
              items.add({
                'type': 'LISTING',
                'title': _text(
                    data, ['title', 'name', 'itemName'], 'PrimeX Listing'),
                'body': _text(data, ['description', 'details', 'category'],
                    'New marketplace listing'),
              });
            }

            for (final d in postSnap.data?.docs ?? []) {
              final data = d.data();
              items.add({
                'type': 'POST',
                'title': _text(
                    data,
                    ['title', 'name', 'userName', 'displayName'],
                    'Syntax Phantom'),
                'body': _text(data, ['body', 'message', 'text', 'description'],
                    'New live feed post'),
              });
            }

            if (items.isEmpty) {
              return const Text(
                'LIVE FEED POSTING / LISTING\nNo user posts or listings yet.',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LIVE FEED POSTING / LISTING',
                  style: TextStyle(
                      color: Color(0xFF00E5FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
                const SizedBox(height: 8),
                ...items.take(5).map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${item['type']} • ${item['title']}\n${item['body']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }
}
