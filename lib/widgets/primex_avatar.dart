import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXAvatar extends StatelessWidget {
  final String uid;
  final String fallbackUrl;
  final double radius;

  const PrimeXAvatar({
    super.key,
    required this.uid,
    this.fallbackUrl = '',
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    if (uid.isEmpty) return _avatar(fallbackUrl);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('profiles')
          .doc(uid)
          .snapshots(),
      builder: (context, profileSnap) {
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots(),
          builder: (context, userSnap) {
            final p = profileSnap.data?.data() as Map<String, dynamic>?;
            final u = userSnap.data?.data() as Map<String, dynamic>?;

            final pUrl = p?['photoUrl']?.toString().trim() ?? '';
            final uUrl = u?['photoUrl']?.toString().trim() ?? '';
            final fUrl = fallbackUrl.trim();

            final url = pUrl.isNotEmpty
                ? pUrl
                : uUrl.isNotEmpty
                    ? uUrl
                    : fUrl;
            return _avatar(url);
          },
        );
      },
    );
  }

  Widget _avatar(String url) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF101522),
      backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
      child: url.isEmpty
          ? Icon(Icons.person, color: const Color(0xFF00E5FF), size: radius)
          : null,
    );
  }
}
