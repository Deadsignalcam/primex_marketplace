import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../features/auth/login_page.dart';

import '../features/messages/messages_page.dart';
import '../features/profile/followers_page.dart';

class PrimeXProfileSocialWire extends StatelessWidget {
  final String profileUid;
  final String profileName;
  final String profilePhoto;

  const PrimeXProfileSocialWire({
    super.key,
    required this.profileUid,
    required this.profileName,
    this.profilePhoto = '',
  });

  String _threadId(String a, String b) {
    final ids = [a, b]..sort();
    return 'private_${ids[0]}_${ids[1]}';
  }

  Future<void> _message(BuildContext context) async {
    final me = FirebaseAuth.instance.currentUser;
    if (me == null || me.uid == profileUid) return;

    final threadId = _threadId(me.uid, profileUid);

    await FirebaseFirestore.instance
        .collection('messageThreads')
        .doc(threadId)
        .set({
      'threadId': threadId,
      'type': 'private',
      'members': [me.uid, profileUid],
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessagesPage(
          threadId: threadId,
          title: profileName,
        ),
      ),
    );
  }

  Future<void> _toggleFollow(bool isFollowing) async {
    final me = FirebaseAuth.instance.currentUser;
    if (me == null || me.uid == profileUid) return;

    final db = FirebaseFirestore.instance;

    final followerDoc =
        db.collection('followers').doc('${profileUid}_${me.uid}');
    final followingDoc =
        db.collection('following').doc('${me.uid}_$profileUid');

    if (isFollowing) {
      await followerDoc.delete();
      await followingDoc.delete();
      return;
    }

    final now = FieldValue.serverTimestamp();

    await followerDoc.set({
      'followingId': profileUid,
      'followerId': me.uid,
      'followerName': me.displayName ?? me.email ?? 'PrimeX User',
      'followerEmail': me.email ?? '',
      'createdAt': now,
    });

    await followingDoc.set({
      'followerId': me.uid,
      'followingId': profileUid,
      'followingName': profileName,
      'followingPhoto': profilePhoto,
      'createdAt': now,
    });

    await db.collection('notifications').add({
      'toUid': profileUid,
      'fromUid': me.uid,
      'type': 'follow',
      'title': 'New follower',
      'body': '${me.displayName ?? me.email ?? 'Someone'} followed you.',
      'read': false,
      'createdAt': now,
    });
  }

  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser;
    if (me == null || me.uid == profileUid) return const SizedBox.shrink();

    final followRef = FirebaseFirestore.instance
        .collection('following')
        .doc('${me.uid}_$profileUid');

    return StreamBuilder<DocumentSnapshot>(
      stream: followRef.snapshots(),
      builder: (context, snap) {
        final following = snap.data?.exists == true;

        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _message(context),
                icon: const Icon(Icons.message),
                label: const Text('Message'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _toggleFollow(following),
                icon: Icon(following ? Icons.person_remove : Icons.person_add),
                label: Text(following ? 'Unfollow' : 'Follow'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PrimeXProfileFollowCountsWire extends StatelessWidget {
  final String uid;

  const PrimeXProfileFollowCountsWire({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    return Row(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: db
                .collection('followers')
                .where('followingId', isEqualTo: uid)
                .snapshots(),
            builder: (context, snap) {
              final count = snap.data?.docs.length ?? 0;
              return _box(
                context,
                'Followers',
                count,
                FollowersPage(uid: uid, title: 'Followers', type: 'followers'),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: db
                .collection('following')
                .where('followerId', isEqualTo: uid)
                .snapshots(),
            builder: (context, snap) {
              final count = snap.data?.docs.length ?? 0;
              return _box(
                context,
                'Following',
                count,
                FollowersPage(uid: uid, title: 'Following', type: 'following'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _box(BuildContext context, String label, int count, Widget page) {
    return InkWell(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF101827),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.cyanAccent.withOpacity(.35)),
        ),
        child: Column(
          children: [
            Text('$count',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label),
          ],
        ),
      ),
    );
  }
}
