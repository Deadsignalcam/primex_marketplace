import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../features/chat/primex_call_page.dart';
import '../features/chat/primex_chat_page.dart';

class PrimeXMemberActions extends StatelessWidget {
  final String userId;
  final String name;

  const PrimeXMemberActions({
    super.key,
    required this.userId,
    required this.name,
  });

  String get myUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> follow() async {
    final db = FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(myUid)
        .collection('following')
        .doc(userId)
        .set({
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await db
        .collection('users')
        .doc(userId)
        .collection('followers')
        .doc(myUid)
        .set({
      'userId': myUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unfollow() async {
    final db = FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(myUid)
        .collection('following')
        .doc(userId)
        .delete();
    await db
        .collection('users')
        .doc(userId)
        .collection('followers')
        .doc(myUid)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    if (myUid.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        if (myUid != userId)
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(myUid)
                .collection('following')
                .doc(userId)
                .snapshots(),
            builder: (context, snap) {
              final following = snap.data?.exists == true;
              return ElevatedButton.icon(
                onPressed: following ? unfollow : follow,
                icon: Icon(following ? Icons.person_remove : Icons.person_add),
                label: Text(following ? 'Unfollow' : 'Follow'),
              );
            },
          ),
        ElevatedButton.icon(
          onPressed: myUid == userId
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PrimeXCallPage(
                        otherUserId: userId,
                        otherName: name,
                        video: false,
                      ),
                    ),
                  );
                },
          icon: const Icon(Icons.call),
          label: const Text('Audio'),
        ),
        ElevatedButton.icon(
          onPressed: myUid == userId
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PrimeXChatPage(
                        otherUserId: userId,
                        otherName: name,
                      ),
                    ),
                  );
                },
          icon: const Icon(Icons.message),
          label: const Text('Message'),
        ),
        ElevatedButton.icon(
          onPressed: myUid == userId
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PrimeXCallPage(
                        otherUserId: userId,
                        otherName: name,
                        video: true,
                      ),
                    ),
                  );
                },
          icon: const Icon(Icons.videocam),
          label: const Text('Video'),
        ),
      ],
    );
  }
}
