import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXHomeLivePostingBox extends StatelessWidget {
  const PrimeXHomeLivePostingBox({super.key});

  String pick(Map<String, dynamic> data, List<String> keys, String fallback) {
    for (final k in keys) {
      final v = data[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return fallback;
  }

  Widget line(String type, Map<String, dynamic> data) {
    final title =
        pick(data, ['title', 'name', 'itemName', 'category'], 'PrimeX Update');
    final body = pick(
        data,
        ['description', 'details', 'message', 'text', 'body'],
        'New activity on PrimeX');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF00E5FF).withOpacity(.55)),
      ),
      child: Row(
        children: [
          Icon(type == 'LISTING' ? Icons.sell : Icons.dynamic_feed,
              color: const Color(0xFF00E5FF), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$type • $title\n$body',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('listings')
          .limit(6)
          .snapshots(),
      builder: (context, listingsSnap) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .limit(6)
              .snapshots(),
          builder: (context, postsSnap) {
            final widgets = <Widget>[];

            for (final doc in listingsSnap.data?.docs ?? []) {
              widgets.add(line('LISTING', doc.data()));
            }

            for (final doc in postsSnap.data?.docs ?? []) {
              widgets.add(line('POST', doc.data()));
            }

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.18),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF00E5FF), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LIVE FEED POSTING / LISTING',
                    style: TextStyle(
                        color: Color(0xFF00E5FF),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (widgets.isEmpty)
                    const Text(
                      'No posts or listings yet. New user activity will show here.',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    )
                  else
                    ...widgets.take(6),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
