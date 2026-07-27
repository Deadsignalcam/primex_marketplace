import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrimeXAffiliateService {
  static const double newUserCredit = 12.25;
  static const double referrerReward = 2.25;
  static const int founderLimit = 20000;

  static String makeCode(User user) {
    final base = (user.email ?? user.uid)
        .split('@')
        .first
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]'), '');
    final short = user.uid.substring(0, 5).toUpperCase();
    return '${base}_$short';
  }

  static Future<Map<String, dynamic>> ensureAffiliate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final affRef =
        FirebaseFirestore.instance.collection('affiliates').doc(user.uid);
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    final snap = await affRef.get();
    final existing = snap.data() ?? {};

    final code = (existing['affiliateCode'] ??
            existing['referralCode'] ??
            makeCode(user))
        .toString();

    final link = 'https://primexmarketplace.com/ref/$code';

    int founderNumber = 0;
    bool founder = existing['founderAffiliate'] == true;

    if (!founder) {
      final founderSnap = await FirebaseFirestore.instance
          .collection('affiliates')
          .where('founderAffiliate', isEqualTo: true)
          .get();

      founderNumber = founderSnap.docs.length + 1;
      founder = founderNumber <= founderLimit;
    } else {
      founderNumber =
          int.tryParse((existing['founderMemberNumber'] ?? '0').toString()) ??
              0;
    }

    final data = {
      'uid': user.uid,
      'email': user.email ?? '',
      'displayName': existing['displayName'] ??
          user.displayName ??
          user.email ??
          'PrimeX Affiliate',
      'photoUrl': existing['photoUrl'] ?? user.photoURL ?? '',
      'affiliateCode': code,
      'referralCode': code,
      'referralLink': link,
      'status': 'active',
      'newUserReward': newUserCredit,
      'friendSignupCredit': newUserCredit,
      'referrerReward': referrerReward,
      'monthlyReferralReward': referrerReward,
      'rewardType': 'fixed_referral',
      'payCycle': 'monthly',
      'pendingPayout': existing['pendingPayout'] ?? 0,
      'totalEarned': existing['totalEarned'] ?? 0,
      'totalPaid': existing['totalPaid'] ?? 0,
      'totalReferrals': existing['totalReferrals'] ?? 0,
      'totalClicks': existing['totalClicks'] ?? 0,
      'youthProgramEligible': true,
      'youthProgramName': 'PrimeX Youth Entrepreneur Program',
      'youthLevel': existing['youthLevel'] ?? 'Affiliate Starter',
      'youthBadge': existing['youthBadge'] ?? '🥉 Affiliate Starter',
      'parentPermissionRecommended': true,
      'founderAffiliate': founder,
      'founderBadge': founder ? '🏆 Founding Affiliate' : '',
      'founderStatus': founder ? 'Active' : '',
      'founderMemberNumber': founder ? founderNumber : 0,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': existing['createdAt'] ?? FieldValue.serverTimestamp(),
    };

    await affRef.set(data, SetOptions(merge: true));
    await userRef.set({
      'uid': user.uid,
      'email': user.email ?? '',
      'displayName': data['displayName'],
      'photoUrl': data['photoUrl'],
      'referralCode': code,
      'referralLink': link,
      'primeXCredit': existing['primeXCredit'] ?? 0,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('affiliate_codes')
        .doc(code)
        .set({
      'code': code,
      'uid': user.uid,
      'email': user.email ?? '',
      'status': 'active',
      'newUserReward': newUserCredit,
      'referrerReward': referrerReward,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return data;
  }
}
