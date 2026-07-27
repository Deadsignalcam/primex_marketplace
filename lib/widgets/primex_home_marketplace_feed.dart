import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../features/listings/listing_details_page.dart';

class PrimeXHomeMarketplaceFeed extends StatelessWidget {
  const PrimeXHomeMarketplaceFeed({super.key});

  String imageFrom(Map<String, dynamic> d) {
    if (d['imageUrls'] is List && (d['imageUrls'] as List).isNotEmpty) {
      return (d['imageUrls'] as List).first.toString();
    }
    return (d['imageUrl'] ??
            d['mediaUrl'] ??
            d['bannerUrl'] ??
            d['photoUrl'] ??
            '')
        .toString();
  }

  String videoFrom(Map<String, dynamic> d) {
    return (d['videoUrl'] ?? d['clipUrl'] ?? '').toString();
  }

  Widget tileIcon(bool isAd) {
    return Container(
      height: 72,
      width: double.infinity,
      color: Colors.black45,
      child: Icon(
        isAd ? Icons.campaign : Icons.storefront,
        color: const Color(0xFF00E5FF),
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ads_promotions')
          .orderBy('createdAt', descending: true)
          .limit(20)
          .snapshots(),
      builder: (context, adsSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('listings')
              .orderBy('createdAt', descending: true)
              .limit(30)
              .snapshots(),
          builder: (context, listingsSnap) {
            final items = <Map<String, dynamic>>[];

            if (adsSnap.hasData) {
              for (final doc in adsSnap.data!.docs) {
                final d = doc.data() as Map<String, dynamic>;
                d['_id'] = doc.id;
                d['_isAd'] = true;
                items.add(d);
              }
            }

            if (listingsSnap.hasData) {
              for (final doc in listingsSnap.data!.docs) {
                final d = doc.data() as Map<String, dynamic>;
                d['_id'] = doc.id;
                d['_isAd'] = false;
                items.add(d);
              }
            }

            if (items.isEmpty) {
              return const Text(
                'Live ads and user posts will appear here.',
                style: TextStyle(color: Colors.white70),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LIVE FEED',
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: items.take(36).map((d) {
                    final isAd = d['_isAd'] == true;
                    final img = imageFrom(d);
                    final video = videoFrom(d);
                    final title = (d['title'] ??
                            d['businessName'] ??
                            d['name'] ??
                            'PrimeX Post')
                        .toString();
                    final price =
                        (d['price'] ?? d['plan'] ?? d['type'] ?? '').toString();

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ListingDetailsPage(
                              listingId: d['_id'].toString(),
                              data: d,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 118,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.84),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isAd
                                ? Colors.amberAccent
                                : const Color(0xFF00E5FF),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: img.isNotEmpty
                                      ? Image.network(
                                          img,
                                          height: 72,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              tileIcon(isAd),
                                        )
                                      : tileIcon(isAd),
                                ),
                                if (video.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Color(0xAA00E5FF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.play_arrow,
                                        color: Colors.black, size: 22),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              isAd ? 'PAID AD / PROMOTION' : 'MARKETPLACE',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isAd
                                    ? Colors.amberAccent
                                    : const Color(0xFF00E5FF),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              price,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white60, fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
