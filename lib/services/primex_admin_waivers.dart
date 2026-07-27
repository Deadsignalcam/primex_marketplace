import 'package:cloud_firestore/cloud_firestore.dart';

class PrimeXAdminWaivers {
  static Future<void> waiveNormsOnly() async {
    final db = FirebaseFirestore.instance;

    final q = await db
        .collection('users')
        .where('email', isEqualTo: 'norms12v@gmail.com')
        .limit(1)
        .get();

    if (q.docs.isEmpty) return;

    await q.docs.first.reference.set({
      'proActive': true,
      'membershipActive': true,
      'paymentStatus': 'waived',
      'stripeWaived': true,
      'waivedForEmail': 'norms12v@gmail.com',
      'membershipType': 'PrimeX Pro',
      'waivedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
