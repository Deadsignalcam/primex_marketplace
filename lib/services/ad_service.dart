import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ad_model.dart';

class AdService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<List<AdModel>> approvedAds() {
    return _db
        .collection('ads_promotions')
        .where('status', isEqualTo: 'approved')
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => AdModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  static Stream<List<AdModel>> pendingAds() {
    return _db
        .collection('ads_promotions')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => AdModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  static Future<void> submitAd(AdModel ad) async {
    await _db.collection('ads_promotions').add(ad.toMap());
  }

  static Future<void> approveAd(String id) async {
    await _db
        .collection('ads_promotions')
        .doc(id)
        .update({'status': 'approved'});
  }

  static Future<void> rejectAd(String id) async {
    await _db
        .collection('ads_promotions')
        .doc(id)
        .update({'status': 'rejected'});
  }
}
