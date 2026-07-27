import 'package:cloud_firestore/cloud_firestore.dart';

class PrimeXMapSyncService {
  static Future<void> syncToMap({
    required String sourceId,
    required String sourceCollection,
    required Map<String, dynamic> data,
  }) async {
    final userId = (data['userId'] ?? data['ownerId'] ?? '').toString();

    await FirebaseFirestore.instance
        .collection('map_items')
        .doc('${sourceCollection}_$sourceId')
        .set({
      'sourceId': sourceId,
      'sourceCollection': sourceCollection,
      'userId': userId,
      'title': data['title'] ?? data['name'] ?? 'PrimeX Item',
      'description':
          data['description'] ?? data['details'] ?? data['text'] ?? '',
      'price': data['price'] ?? data['fee'] ?? '',
      'location': data['location'] ?? data['address'] ?? data['city'] ?? '',
      'address': data['address'] ?? data['location'] ?? '',
      'city': data['city'] ?? '',
      'state': data['state'] ?? '',
      'country': data['country'] ?? '',
      'lat': data['lat'] ?? data['latitude'],
      'lng': data['lng'] ?? data['longitude'],
      'latitude': data['latitude'] ?? data['lat'],
      'longitude': data['longitude'] ?? data['lng'],
      'imageUrls': data['imageUrls'] ?? data['images'] ?? [],
      'imageUrl': data['imageUrl'] ?? '',
      'videoUrl': data['videoUrl'] ?? '',
      'type': data['type'] ?? sourceCollection,
      'mapVisible': true,
      'isBoosted': data['isBoosted'] ?? false,
      'boostRank': data['boostRank'] ?? 0,
      'createdAt': data['createdAt'] ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> removeFromMap({
    required String sourceId,
    required String sourceCollection,
  }) async {
    await FirebaseFirestore.instance
        .collection('map_items')
        .doc('${sourceCollection}_$sourceId')
        .delete();
  }
}
