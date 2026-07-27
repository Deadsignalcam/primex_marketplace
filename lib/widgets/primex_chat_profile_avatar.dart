import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXChatProfileAvatar extends StatelessWidget {
  const PrimeXChatProfileAvatar({
    super.key,
    required this.uid,
    required this.fallbackName,
    required this.fallbackPhoto,
    this.radius = 22,
  });

  final String uid;
  final String fallbackName;
  final String fallbackPhoto;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (uid.isEmpty) return fallback();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snap) {
        final d = snap.data?.data() ?? {};
        final photo = (d['photoUrl'] ??
                d['avatarUrl'] ??
                d['profilePhoto'] ??
                fallbackPhoto)
            .toString()
            .trim();

        final name =
            (d['displayName'] ?? d['name'] ?? fallbackName).toString().trim();

        if (photo.startsWith('http')) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: Colors.cyanAccent,
            backgroundImage: NetworkImage(photo),
          );
        }

        return CircleAvatar(
          radius: radius,
          backgroundColor: Colors.cyanAccent,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'P',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
        );
      },
    );
  }

  Widget fallback() {
    final p = fallbackPhoto.trim();

    if (p.startsWith('http')) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.cyanAccent,
        backgroundImage: NetworkImage(p),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.cyanAccent,
      child: Text(
        fallbackName.isNotEmpty ? fallbackName[0].toUpperCase() : 'P',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
