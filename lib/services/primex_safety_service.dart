import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrimeXSafetyService {
  static Future<void> reportItem({
    required String collection,
    required String itemId,
    required String reason,
    String details = '',
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('reports').add({
      'collection': collection,
      'itemId': itemId,
      'reason': reason,
      'details': details,
      'reportedBy': user?.uid ?? 'guest',
      'reporterEmail': user?.email ?? '',
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> hideItem(String collection, String itemId) async {
    await FirebaseFirestore.instance.collection(collection).doc(itemId).set({
      'hidden': true,
      'status': 'hidden_by_admin',
      'reviewedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> approveItem(String collection, String itemId) async {
    await FirebaseFirestore.instance.collection(collection).doc(itemId).set({
      'approved': true,
      'hidden': false,
      'status': 'approved',
      'reviewedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> rejectItem(String collection, String itemId) async {
    await FirebaseFirestore.instance.collection(collection).doc(itemId).set({
      'approved': false,
      'hidden': true,
      'status': 'rejected',
      'reviewedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> strikeUser(String userId) async {
    if (userId.isEmpty) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'strikeCount': FieldValue.increment(1),
      'lastStrikeAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
