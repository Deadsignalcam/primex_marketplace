import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXProfileCircle extends StatelessWidget {
  final String uid;
  final double radius;

  const PrimeXProfileCircle({
    super.key,
    required this.uid,
    this.radius = 22,
  });

  Future<Map<String, dynamic>> loadProfile() async {
    if (uid.isEmpty) return {};
    final db = FirebaseFirestore.instance;
    final userDoc = await db.collection('users').doc(uid).get();
    final profileDoc = await db.collection('profiles').doc(uid).get();

    return {
      ...(profileDoc.data() ?? {}),
      ...(userDoc.data() ?? {}),
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: loadProfile(),
      builder: (context, snap) {
        final d = snap.data ?? {};
        final photo = (d['photoUrl'] ??
                d['photoURL'] ??
                d['profilePhoto'] ??
                d['avatarUrl'] ??
                d['imageUrl'] ??
                '')
            .toString()
            .trim();

        return CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0xFF07111F),
          backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
          child: photo.isEmpty
              ? const Icon(Icons.person, color: Color(0xFF00E5FF))
              : null,
        );
      },
    );
  }
}
