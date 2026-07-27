import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrimeXUnlockService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String get uid => _auth.currentUser?.uid ?? '';

  static Future<void> unlock({
    required String type,
    required String plan,
    required int days,
    String sourceId = '',
  }) async {
    if (uid.isEmpty) return;

    final now = DateTime.now();
    final expires = now.add(Duration(days: days));

    await _db.collection('users').doc(uid).collection('unlocks').add({
      'type': type,
      'plan': plan,
      'sourceId': sourceId,
      'active': true,
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(expires),
    });

    await _db.collection('users').doc(uid).set({
      'lastUnlockType': type,
      'lastUnlockPlan': plan,
      'updatedAt': FieldValue.serverTimestamp(),
      if (type == 'primex_pro') 'primeXPro': true,
    }, SetOptions(merge: true));
  }

  static Stream<QuerySnapshot> myUnlocks() {
    if (uid.isEmpty) {
      return const Stream.empty();
    }

    return _db
        .collection('users')
        .doc(uid)
        .collection('unlocks')
        .where('active', isEqualTo: true)
        .snapshots();
  }
}
