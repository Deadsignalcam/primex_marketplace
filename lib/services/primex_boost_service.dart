import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class PrimeXBoostPlan {
  final String id;
  final String title;
  final int days;
  final int amountCents;
  final String priceLabel;
  final String stripeUrl;

  const PrimeXBoostPlan({
    required this.id,
    required this.title,
    required this.days,
    required this.amountCents,
    required this.priceLabel,
    required this.stripeUrl,
  });
}

class PrimeXBoostService {
  static const PrimeXBoostPlan fourDays = PrimeXBoostPlan(
    id: 'boost_4_days',
    title: 'Boost 4 Days',
    days: 4,
    amountCents: 499,
    priceLabel: '\$4.99',
    stripeUrl: 'https://buy.stripe.com/00w6oH1lS02K0C7gq7gfu0h',
  );

  static const PrimeXBoostPlan fifteenDays = PrimeXBoostPlan(
    id: 'boost_15_days',
    title: 'Boost 15 Days',
    days: 15,
    amountCents: 1499,
    priceLabel: '\$14.99',
    stripeUrl: 'https://buy.stripe.com/9B628r0hOaHo0C75Ltgfu0i',
  );

  static Future<String> startCheckout({
    required String listingId,
    required String listingTitle,
    required PrimeXBoostPlan plan,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw StateError(
        'Sign in before purchasing a listing boost.',
      );
    }

    if (listingId.trim().isEmpty) {
      throw StateError(
        'This listing is missing its listing ID.',
      );
    }

    final listingRef =
        FirebaseFirestore.instance.collection('listings').doc(listingId);

    final listing = await listingRef.get();

    if (!listing.exists) {
      throw StateError(
        'This listing no longer exists.',
      );
    }

    final data = listing.data() ?? <String, dynamic>{};

    final ownerId =
        (data['ownerUid'] ?? data['userId'] ?? data['uid'] ?? '').toString();

    if (ownerId.isNotEmpty && ownerId != user.uid) {
      throw StateError(
        'Only the listing owner can purchase its boost.',
      );
    }

    final orderRef =
        FirebaseFirestore.instance.collection('boost_orders').doc();

    await orderRef.set({
      'orderId': orderRef.id,
      'listingId': listingId,
      'listingTitle': listingTitle,
      'ownerUid': user.uid,
      'ownerEmail': user.email ?? '',
      'planId': plan.id,
      'planTitle': plan.title,
      'durationDays': plan.days,
      'amountCents': plan.amountCents,
      'priceLabel': plan.priceLabel,
      'stripeUrl': plan.stripeUrl,
      'paymentStatus': 'pending',
      'boostStatus': 'waiting_for_payment',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await listingRef.set({
      'boostOrderId': orderRef.id,
      'boostPlan': plan.id,
      'boostDurationDays': plan.days,
      'boostPrice': plan.priceLabel,
      'boostStatus': 'pending_payment',
      'boosted': false,
      'boostPriority': 0,
      'boostRequestedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final uri = Uri.parse(
      '${plan.stripeUrl}'
      '?client_reference_id=${Uri.encodeQueryComponent(orderRef.id)}',
    );

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );

    if (!opened) {
      await orderRef.set({
        'paymentStatus': 'checkout_open_failed',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      throw StateError(
        'Stripe checkout could not be opened.',
      );
    }

    return orderRef.id;
  }
}
