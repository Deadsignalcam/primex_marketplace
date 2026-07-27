import 'package:cloud_firestore/cloud_firestore.dart';

class PrimeXSyncService {
  static Future<void> syncListingToFeed({
    required String listingId,
    required Map<String, dynamic> data,
  }) async {
    final userId = data['userId'] ?? data['ownerId'] ?? '';
    if (userId.toString().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('live_feed')
        .doc('listing_$listingId')
        .set({
      'sourceId': listingId,
      'sourceCollection': 'listings',
      'type': 'listing',
      'userId': userId,
      'title': data['title'] ?? 'PrimeX Listing',
      'text': data['description'] ??
          data['title'] ??
          'New listing on PrimeX Marketplace',
      'content': data['description'] ??
          data['title'] ??
          'New listing on PrimeX Marketplace',
      'price': data['price'] ?? '',
      'location': data['location'] ?? data['address'] ?? data['city'] ?? '',
      'imageUrls': data['imageUrls'] ?? data['images'] ?? [],
      'imageUrl': data['imageUrl'] ?? '',
      'lat': data['lat'],
      'lng': data['lng'],
      'latitude': data['latitude'],
      'longitude': data['longitude'],
      'mapVisible': true,
      'isBoosted': data['isBoosted'] ?? false,
      'boostedUntil': data['boostedUntil'],
      'boostRank': data['isBoosted'] == true ? 999999 : 0,
      'createdAt': data['createdAt'] ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> updateBoost({
    required String listingId,
    required int days,
  }) async {
    final until = Timestamp.fromDate(DateTime.now().add(Duration(days: days)));

    await FirebaseFirestore.instance.collection('listings').doc(listingId).set({
      'isBoosted': true,
      'boostedUntil': until,
      'boostRank': 999999,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('live_feed')
        .doc('listing_$listingId')
        .set({
      'isBoosted': true,
      'boostedUntil': until,
      'boostRank': 999999,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> deleteListingEverywhere(String listingId) async {
    await FirebaseFirestore.instance
        .collection('listings')
        .doc(listingId)
        .delete();
    await FirebaseFirestore.instance
        .collection('live_feed')
        .doc('listing_$listingId')
        .delete();
  }
}
