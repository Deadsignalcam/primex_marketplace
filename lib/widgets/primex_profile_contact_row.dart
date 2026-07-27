import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'primex_safe_contact_buttons.dart';

class PrimeXProfileContactRow extends StatelessWidget {
  final String? phone;
  final String? email;
  final String? zoomUrl;
  final VoidCallback? onMessage;
  final String? receiverId;
  final String? receiverName;
  final String? receiverPhoto;

  const PrimeXProfileContactRow({
    super.key,
    this.phone,
    this.email,
    this.zoomUrl,
    this.onMessage,
    this.receiverId,
    this.receiverName,
    this.receiverPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final uid = (receiverId ?? '').trim();

    if (uid.isNotEmpty) {
      return PrimeXSafeContactButtons(
        receiverId: uid,
        receiverName: receiverName ?? 'PrimeX Member',
        receiverPhoto: receiverPhoto ?? '',
        sourceTitle: 'Profile Contact',
        zoomUrl: zoomUrl ?? '',
      );
    }

    final myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return FutureBuilder<DocumentSnapshot>(
      future: myUid.isEmpty
          ? null
          : FirebaseFirestore.instance.collection('users').doc(myUid).get(),
      builder: (context, snap) {
        final d = (snap.data?.data() as Map<String, dynamic>?) ?? {};
        return PrimeXSafeContactButtons(
          receiverId: (d['uid'] ?? myUid).toString(),
          receiverName:
              (d['displayName'] ?? d['name'] ?? 'PrimeX Member').toString(),
          receiverPhoto: (d['photoUrl'] ?? d['profilePhoto'] ?? '').toString(),
          sourceTitle: 'Profile Contact',
          zoomUrl: zoomUrl ?? (d['zoomUrl'] ?? d['zoomLink'] ?? '').toString(),
        );
      },
    );
  }
}
