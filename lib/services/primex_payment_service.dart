import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class PrimeXPaymentService {
  static Future<void> pay({
    required String itemType,
    required String plan,
    required String stripeUrl,
    String itemId = '',
    String title = '',
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('payments').add({
      'uid': user?.uid ?? '',
      'displayName': user?.displayName ?? 'Syntax Phantom',
      'photoURL': user?.photoURL ?? '',
      'itemType': itemType,
      'itemId': itemId,
      'title': title,
      'plan': plan,
      'stripeUrl': stripeUrl,
      'status': 'checkout_opened',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await launchUrl(Uri.parse(stripeUrl), mode: LaunchMode.externalApplication);
  }
}
