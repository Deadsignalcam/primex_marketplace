import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrimeXFollowButton extends StatefulWidget {
  final String ownerId;

  const PrimeXFollowButton({
    super.key,
    required this.ownerId,
  });

  @override
  State<PrimeXFollowButton> createState() => _PrimeXFollowButtonState();
}

class _PrimeXFollowButtonState extends State<PrimeXFollowButton> {
  bool working = false;

  String get myUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<Map<String, dynamic>> userData(
    String uid,
  ) async {
    if (uid.isEmpty) return {};

    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return snapshot.data() ?? {};
  }

  Future<void> follow() async {
    if (working ||
        myUid.isEmpty ||
        widget.ownerId.isEmpty ||
        myUid == widget.ownerId) {
      return;
    }

    setState(() => working = true);

    try {
      final db = FirebaseFirestore.instance;

      final me = await userData(myUid);
      final other = await userData(widget.ownerId);

      final batch = db.batch();

      batch.set(
        db
            .collection('users')
            .doc(myUid)
            .collection('following')
            .doc(widget.ownerId),
        {
          'userId': widget.ownerId,
          'followingId': widget.ownerId,
          'followingName':
              (other['displayName'] ?? other['name'] ?? 'PrimeX Member')
                  .toString(),
          'followingPhoto':
              (other['photoUrl'] ?? other['profilePhotoUrl'] ?? '').toString(),
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      batch.set(
        db
            .collection('users')
            .doc(widget.ownerId)
            .collection('followers')
            .doc(myUid),
        {
          'userId': myUid,
          'followerId': myUid,
          'followerName': (me['displayName'] ??
                  me['name'] ??
                  FirebaseAuth.instance.currentUser?.email ??
                  'PrimeX Member')
              .toString(),
          'followerPhoto':
              (me['photoUrl'] ?? me['profilePhotoUrl'] ?? '').toString(),
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      await batch.commit();
    } finally {
      if (mounted) {
        setState(() => working = false);
      }
    }
  }

  Future<void> unfollow() async {
    if (working ||
        myUid.isEmpty ||
        widget.ownerId.isEmpty ||
        myUid == widget.ownerId) {
      return;
    }

    setState(() => working = true);

    try {
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      batch.delete(
        db
            .collection('users')
            .doc(myUid)
            .collection('following')
            .doc(widget.ownerId),
      );

      batch.delete(
        db
            .collection('users')
            .doc(widget.ownerId)
            .collection('followers')
            .doc(myUid),
      );

      await batch.commit();
    } finally {
      if (mounted) {
        setState(() => working = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (myUid.isEmpty || widget.ownerId.isEmpty || myUid == widget.ownerId) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(myUid)
          .collection('following')
          .doc(widget.ownerId)
          .snapshots(),
      builder: (context, snapshot) {
        final following = snapshot.data?.exists == true;

        return OutlinedButton.icon(
          onPressed: working
              ? null
              : following
                  ? unfollow
                  : follow,
          icon: working
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Icon(
                  following ? Icons.person_remove : Icons.person_add,
                  size: 17,
                ),
          label: Text(
            following ? 'Unfollow' : 'Follow',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(
              color: Colors.cyanAccent,
            ),
          ),
        );
      },
    );
  }
}
