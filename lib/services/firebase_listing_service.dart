import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';

class FirebaseListingService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<List<ListingModel>> liveListings() {
    return db
        .collection('listings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => ListingModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> addListing(ListingModel listing) async {
    await db.collection('listings').add(listing.toMap());
  }

  Future<void> toggleSaved(String id, bool saved) async {
    await db.collection('listings').doc(id).update({'saved': saved});
  }

  Future<void> boostListing(String id, String plan) async {
    await db.collection('listings').doc(id).update({
      'boosted': true,
      'boostPlan': plan,
      'boostedAt': DateTime.now().toIso8601String(),
    });
  }
}
