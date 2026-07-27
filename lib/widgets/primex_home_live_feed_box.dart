import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXHomeLiveFeedBox extends StatelessWidget {
  const PrimeXHomeLiveFeedBox({super.key});

  String firstImage(Map<String, dynamic> x) {
    if ((x['imageUrl'] ?? '').toString().isNotEmpty)
      return x['imageUrl'].toString();
    if (x['imageUrls'] is List && (x['imageUrls'] as List).isNotEmpty) {
      return (x['imageUrls'] as List).first.toString();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1020),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent.withOpacity(.65)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LIVE FEED',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('live_feed')
                  .orderBy('createdAt', descending: true)
                  .limit(10)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snap.data!.docs;

                docs.sort((a, b) {
                  final ax = a.data() as Map<String, dynamic>;
                  final bx = b.data() as Map<String, dynamic>;
                  final ar =
                      ax['boostRank'] is num ? ax['boostRank'] as num : 0;
                  final br =
                      bx['boostRank'] is num ? bx['boostRank'] as num : 0;
                  return br.compareTo(ar);
                });

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No live feed posts yet.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final x = docs[i].data() as Map<String, dynamic>;
                    final img = firstImage(x);
                    final boosted = x['isBoosted'] == true;
                    final title = (x['title'] ??
                            x['text'] ??
                            x['content'] ??
                            'PrimeX Post')
                        .toString();
                    final price = (x['price'] ?? '').toString();

                    return Container(
                      width: 190,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: boosted ? Colors.amberAccent : Colors.white24,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (img.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                img,
                                height: 90,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Container(
                              height: 90,
                              alignment: Alignment.center,
                              child: const Icon(Icons.feed,
                                  color: Colors.cyanAccent, size: 36),
                            ),
                          const SizedBox(height: 6),
                          if (boosted)
                            const Text(
                              'BOOSTED',
                              style: TextStyle(
                                  color: Colors.amberAccent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                          if (price.isNotEmpty)
                            Text(
                              price.startsWith(r'$') ? price : '\$$price',
                              style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
