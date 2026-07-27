import 'package:cloud_firestore/cloud_firestore.dart';

class MarketplaceEngine {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static CollectionReference get listings => _db.collection('listings');

  static Future<void> createListing(Map<String, dynamic> data) async {
    await listings.add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'likes': 0,
      'hearts': 0,
      'comments': 0,
    });
  }

  static Stream<QuerySnapshot> streamAllListings() {
    return listings.orderBy('createdAt', descending: true).snapshots();
  }

  static Stream<QuerySnapshot> streamByCategory(String category) {
    return listings
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<DocumentSnapshot> getListing(String id) {
    return listings.doc(id).get();
  }
}
