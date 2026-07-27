import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXUserAccountContent extends StatelessWidget {
  final String userId;

  const PrimeXUserAccountContent({
    super.key,
    required this.userId,
  });

  List<String> media(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    if (value is String && value.trim().isNotEmpty) return [value.trim()];
    return [];
  }

  Widget card(Map<String, dynamic> data) {
    final title =
        (data['title'] ?? data['text'] ?? data['caption'] ?? 'PrimeX Post')
            .toString();
    final price = (data['price'] ?? '').toString();
    final details = (data['details'] ?? data['description'] ?? '').toString();

    final photos = [
      ...media(data['photos']),
      ...media(data['photoUrls']),
      ...media(data['images']),
      ...media(data['imageUrls']),
      ...media(data['mediaUrls']),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent.withOpacity(.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: photos.isEmpty
                ? const Icon(Icons.image, color: Colors.white38)
                : Image.network(
                    photos.first,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, color: Colors.white38),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                if (price.isNotEmpty)
                  Text('\$$price',
                      style: const TextStyle(color: Colors.amberAccent)),
                if (details.isNotEmpty)
                  Text(details,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget section(String title, String collection) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .limit(20)
          .snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (docs.isEmpty)
              const Text('Nothing posted yet.',
                  style: TextStyle(color: Colors.white54)),
            ...docs.map((d) => card(d.data() as Map<String, dynamic>)),
            const SizedBox(height: 18),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        section('My Live Feed Posts', 'posts'),
        section('My Listings', 'listings'),
      ],
    );
  }
}
