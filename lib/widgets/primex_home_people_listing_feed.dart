import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../features/home/primex_home_item_details_page.dart';
import '../features/profile/primex_public_profile_page.dart';

class PrimeXHomePeopleListingFeed extends StatelessWidget {
  const PrimeXHomePeopleListingFeed({super.key});

  Future<List<Map<String, dynamic>>> loadItems() async {
    final items = <Map<String, dynamic>>[];

    Future<void> pull(String collection, String type) async {
      try {
        final snap = await FirebaseFirestore.instance
            .collection(collection)
            .limit(50)
            .get();

        for (final doc in snap.docs) {
          final d = doc.data();
          d['_id'] = doc.id;
          d['_type'] = type;
          items.add(d);
        }
      } catch (_) {}
    }

    await pull('listings', 'listing');
    await pull('professional_live_feed', 'post');
    await pull('live_feed', 'post');
    await pull('ads_promotions', 'ad');

    items.sort((a, b) {
      final ab = a['boosted'] == true ? 1 : 0;
      final bb = b['boosted'] == true ? 1 : 0;
      if (ab != bb) return bb.compareTo(ab);

      final ar =
          num.tryParse((a['boostRank'] ?? a['fee'] ?? 0).toString()) ?? 0;
      final br =
          num.tryParse((b['boostRank'] ?? b['fee'] ?? 0).toString()) ?? 0;
      return br.compareTo(ar);
    });

    return items.take(60).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: loadItems(),
      builder: (context, snap) {
        final items = snap.data ?? [];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.72),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF00E5FF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LIVE PEOPLE • POSTS • LISTINGS • ADS',
                style: TextStyle(
                  color: Color(0xFF00E5FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              if (items.isEmpty)
                const Text(
                  'Posts, listings, ads and sellers will appear here.',
                  style: TextStyle(color: Colors.white70),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items.map((d) {
                    final type = (d['_type'] ?? 'post').toString();
                    final uid =
                        (d['uid'] ?? d['sellerUid'] ?? d['ownerUid'] ?? '')
                            .toString();
                    final name = (d['displayName'] ??
                            d['sellerName'] ??
                            d['ownerName'] ??
                            'Syntax Phantom')
                        .toString();
                    final title = (d['title'] ??
                            d['text'] ??
                            d['details'] ??
                            d['description'] ??
                            'PrimeX Item')
                        .toString();
                    final avatar = (d['photoUrl'] ??
                            d['profilePhoto'] ??
                            d['sellerPhoto'] ??
                            '')
                        .toString();
                    final photos = List<String>.from(d['photoUrls'] ??
                        d['imageUrls'] ??
                        d['images'] ??
                        d['photos'] ??
                        []);
                    final photo = photos.isNotEmpty ? photos.first : '';

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PrimeXHomeItemDetailsPage(data: d, type: type),
                          ),
                        );
                      },
                      child: Container(
                        width: 112,
                        height: 136,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.70),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: uid.isEmpty
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  PrimeXPublicProfilePage(
                                                uid: uid,
                                                profile: d,
                                              ),
                                            ),
                                          );
                                        },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: const Color(0xFF00E5FF),
                                    backgroundImage: avatar.startsWith('http')
                                        ? NetworkImage(avatar)
                                        : null,
                                    child: avatar.startsWith('http')
                                        ? null
                                        : const Icon(Icons.person,
                                            size: 16, color: Colors.black),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.cyanAccent,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (photo.startsWith('http'))
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(photo,
                                    width: 100, height: 45, fit: BoxFit.cover),
                              )
                            else
                              Container(
                                width: 100,
                                height: 45,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.storefront,
                                    color: Color(0xFF00E5FF), size: 22),
                              ),
                            const SizedBox(height: 4),
                            Text(type.toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900)),
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }
}
