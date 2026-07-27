import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXUserAvatar extends StatelessWidget {
  final String userId;
  final String fallbackUrl;
  final double radius;

  const PrimeXUserAvatar({
    super.key,
    required this.userId,
    this.fallbackUrl = '',
    this.radius = 18,
  });

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty && fallbackUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFF101522),
        child: Icon(Icons.person, color: const Color(0xFF00E5FF), size: radius),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('profiles')
          .doc(userId)
          .snapshots(),
      builder: (context, profileSnap) {
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .snapshots(),
          builder: (context, userSnap) {
            final p = profileSnap.data?.data() as Map<String, dynamic>?;
            final u = userSnap.data?.data() as Map<String, dynamic>?;

            final profilePhoto = p?['photoUrl']?.toString().trim() ?? '';
            final userPhoto = u?['photoUrl']?.toString().trim() ?? '';
            final fallback = fallbackUrl.trim();

            final url = profilePhoto.isNotEmpty
                ? profilePhoto
                : userPhoto.isNotEmpty
                    ? userPhoto
                    : fallback;

            return CircleAvatar(
              radius: radius,
              backgroundColor: const Color(0xFF101522),
              backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
              child: url.isEmpty
                  ? Icon(Icons.person,
                      color: const Color(0xFF00E5FF), size: radius)
                  : null,
            );
          },
        );
      },
    );
  }
}

class PrimeXCurrentUserAvatar extends StatelessWidget {
  final double radius;
  const PrimeXCurrentUserAvatar({super.key, this.radius = 18});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').limit(1).snapshots(),
      builder: (context, snap) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0xFF101522),
          child:
              Icon(Icons.person, color: const Color(0xFF00E5FF), size: radius),
        );
      },
    );
  }
}
