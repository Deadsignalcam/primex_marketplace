import 'package:cloud_firestore/cloud_firestore.dart';
import 'syntax_phantom_ai_service.dart';

class PrimeXAdminActions {
  static final db = FirebaseFirestore.instance;

  static Future<void> approveDoc(String collection, String id) async {
    await db.collection(collection).doc(id).set({
      'status': 'approved',
      'approved': true,
      'needsReview': false,
      'approvedAt': FieldValue.serverTimestamp(),
      if (collection == 'listings') 'showOnMap': true,
      if (collection == 'listings') 'pinApproved': true,
      if (collection == 'paid_homepage_ads') 'liveOnHomepage': true,
    }, SetOptions(merge: true));
  }

  static Future<void> reviewDoc(String collection, String id) async {
    await db.collection(collection).doc(id).set({
      'status': 'review',
      'needsReview': true,
      'reviewAt': FieldValue.serverTimestamp(),
      if (collection == 'paid_homepage_ads') 'liveOnHomepage': false,
    }, SetOptions(merge: true));
  }

  static Future<void> deleteDoc(String collection, String id) async {
    await db.collection(collection).doc(id).delete();
  }

  static Future<void> banUser(String uid) async {
    await db.collection('users').doc(uid).set({
      'banned': true,
      'status': 'banned',
      'bannedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> unbanUser(String uid) async {
    await db.collection('users').doc(uid).set({
      'banned': false,
      'status': 'active',
      'unbannedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> hideFromMap(String listingId) async {
    await db.collection('listings').doc(listingId).set({
      'showOnMap': false,
      'pinApproved': false,
      'hiddenFromMapAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> approvePin(String listingId) async {
    await db.collection('listings').doc(listingId).set({
      'showOnMap': true,
      'pinApproved': true,
      'pinApprovedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> aiReviewDoc(
      String collection, String id, Map<String, dynamic> data) async {
    final text = [
      data['title'],
      data['businessName'],
      data['name'],
      data['description'],
      data['desc'],
      data['category'],
      data['message'],
      data['body'],
      data['type'],
    ].whereType<Object>().join(' ');

    final result = await SyntaxPhantomAIService.scanText(text);

    await db.collection(collection).doc(id).set({
      'aiStatus': result['status'],
      'aiAction': result['action'],
      'aiReason': result['reason'],
      'aiReviewedAt': FieldValue.serverTimestamp(),
      if (result['status'] == 'FLAGGED') 'status': 'review',
      if (result['status'] == 'FLAGGED') 'needsReview': true,
      if (result['status'] == 'SAFE') 'aiApproved': true,
    }, SetOptions(merge: true));
  }

  // old names still supported
  static Future<void> approveListing(String id) => approveDoc('listings', id);
  static Future<void> rejectListing(String id) => reviewDoc('listings', id);
  static Future<void> deleteListing(String id) => deleteDoc('listings', id);
  static Future<void> approveAd(String id) => approveDoc('ads_promotions', id);
  static Future<void> reviewAd(String id) => reviewDoc('ads_promotions', id);
  static Future<void> deleteAd(String id) => deleteDoc('ads_promotions', id);
  static Future<void> approveHomepageAd(String id) =>
      approveDoc('paid_homepage_ads', id);
  static Future<void> reviewHomepageAd(String id) =>
      reviewDoc('paid_homepage_ads', id);
  static Future<void> deleteHomepageAd(String id) =>
      deleteDoc('paid_homepage_ads', id);
  static Future<void> pushAdToHomepage(
      String adId, Map<String, dynamic> data) async {
    await db.collection('paid_homepage_ads').doc(adId).set({
      ...data,
      'status': 'approved',
      'approved': true,
      'liveOnHomepage': true,
      'sourceCollection': 'ads_promotions',
      'sourceAdId': adId,
      'pushedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await db.collection('ads_promotions').doc(adId).set({
      'status': 'approved',
      'approved': true,
      'liveOnHomepage': true,
      'pushedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> removeAdFromHomepage(String adId) async {
    await db.collection('paid_homepage_ads').doc(adId).set({
      'liveOnHomepage': false,
      'status': 'hidden',
      'hiddenAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
