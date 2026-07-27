import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrimeXAffiliateRewardService {
  static const double friendCredit = 12.25;
  static const double referrerReward = 2.25;

  static Future<void> applyReferralCode(String code) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cleanCode =
        code.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (cleanCode.isEmpty) return;

    final codeDoc = await FirebaseFirestore.instance
        .collection('affiliate_codes')
        .doc(cleanCode)
        .get();
    final codeData = codeDoc.data();
    if (codeData == null) return;

    final referrerUid = (codeData['uid'] ?? '').toString();
    if (referrerUid.isEmpty || referrerUid == user.uid) return;

    final rewardId = '${user.uid}_$cleanCode';
    final rewardRef = FirebaseFirestore.instance
        .collection('affiliate_rewards')
        .doc(rewardId);
    final exists = await rewardRef.get();
    if (exists.exists) return;

    final batch = FirebaseFirestore.instance.batch();

    batch.set(rewardRef, {
      'rewardId': rewardId,
      'referralCode': cleanCode,
      'newUserUid': user.uid,
      'newUserEmail': user.email,
      'referrerUid': referrerUid,
      'newUserCredit': friendCredit,
      'referrerReward': referrerReward,
      'status': 'pending_monthly_payout',
      'createdAt': FieldValue.serverTimestamp(),
    });

    batch.set(
        FirebaseFirestore.instance.collection('users').doc(user.uid),
        {
          'referredBy': cleanCode,
          'primeXCredit': FieldValue.increment(friendCredit),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true));

    batch.set(
        FirebaseFirestore.instance.collection('affiliates').doc(referrerUid),
        {
          'pendingPayout': FieldValue.increment(referrerReward),
          'totalEarned': FieldValue.increment(referrerReward),
          'totalReferrals': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true));

    await batch.commit();
  }
}
