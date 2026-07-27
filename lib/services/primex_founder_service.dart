import 'package:cloud_firestore/cloud_firestore.dart';

class PrimeXFounderService {
  static Future<int> nextFounderNumber() async {
    final snap = await FirebaseFirestore.instance
        .collection('affiliates')
        .where('founderAffiliate', isEqualTo: true)
        .get();

    return snap.docs.length + 1;
  }

  static Future<void> assignFounder(String uid) async {
    final count = await nextFounderNumber();

    if (count > 20000) return;

    await FirebaseFirestore.instance.collection('affiliates').doc(uid).set({
      'founderAffiliate': true,
      'founderBadge': '🏆 Founding Affiliate',
      'founderStatus': 'Active',
      'founderMemberNumber': count,
    }, SetOptions(merge: true));
  }
}
