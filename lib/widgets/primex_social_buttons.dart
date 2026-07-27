import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../features/messages/messages_page.dart';
import '../features/profile/followers_page.dart';

class PrimeXSocialButtons extends StatefulWidget {
  final String profileUid;
  final String profileName;
  final String? profilePhoto;

  const PrimeXSocialButtons({
    super.key,
    required this.profileUid,
    required this.profileName,
    this.profilePhoto,
  });

  @override
  State<PrimeXSocialButtons> createState() => _PrimeXSocialButtonsState();
}

class _PrimeXSocialButtonsState extends State<PrimeXSocialButtons> {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  String get myUid => auth.currentUser?.uid ?? '';

  String privateThreadId(String a, String b) {
    final ids = [a, b]..sort();
    return 'private_${ids[0]}_${ids[1]}';
  }

  Future<void> toggleFollow(bool following) async {
    if (myUid.isEmpty || myUid == widget.profileUid) return;

    final followerDoc =
        db.collection('followers').doc('${widget.profileUid}_$myUid');
    final followingDoc =
        db.collection('following').doc('${myUid}_${widget.profileUid}');

    final me = auth.currentUser;

    if (following) {
      await followerDoc.delete();
      await followingDoc.delete();
    } else {
      final now = FieldValue.serverTimestamp();

      await followerDoc.set({
        'userId': widget.profileUid,
        'followingId': widget.profileUid,
        'followerId': myUid,
        'followerName': me?.displayName ?? me?.email ?? 'PrimeX User',
        'followerEmail': me?.email ?? '',
        'createdAt': now,
      });

      await followingDoc.set({
        'userId': myUid,
        'followerId': myUid,
        'followingId': widget.profileUid,
        'followingName': widget.profileName,
        'followingPhoto': widget.profilePhoto ?? '',
        'createdAt': now,
      });

      await db.collection('notifications').add({
        'toUid': widget.profileUid,
        'fromUid': myUid,
        'type': 'follow',
        'title': 'New follower',
        'body': '${me?.displayName ?? me?.email ?? 'Someone'} followed you.',
        'read': false,
        'createdAt': now,
      });
    }
  }

  Future<void> openPrivateMessage() async {
    if (myUid.isEmpty || myUid == widget.profileUid) return;

    final threadId = privateThreadId(myUid, widget.profileUid);

    await db.collection('messageThreads').doc(threadId).set({
      'threadId': threadId,
      'type': 'private',
      'members': [myUid, widget.profileUid],
      'memberNames': {
        myUid: auth.currentUser?.displayName ?? auth.currentUser?.email ?? 'Me',
        widget.profileUid: widget.profileName,
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessagesPage(
          threadId: threadId,
          title: widget.profileName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (myUid.isEmpty || myUid == widget.profileUid) {
      return const SizedBox.shrink();
    }

    final followDoc =
        db.collection('following').doc('${myUid}_${widget.profileUid}');

    return StreamBuilder<DocumentSnapshot>(
      stream: followDoc.snapshots(),
      builder: (context, snap) {
        final following = snap.data?.exists == true;

        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: openPrivateMessage,
                icon: const Icon(Icons.message),
                label: const Text('Message'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => toggleFollow(following),
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

class PrimeXFollowCounts extends StatelessWidget {
  final String uid;

  const PrimeXFollowCounts({super.key, required this.uid});

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
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FollowersPage(
                        uid: uid, title: 'Followers', type: 'followers'),
                  ),
                ),
                child: _countBox('Followers', count),
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
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FollowersPage(
                        uid: uid, title: 'Following', type: 'following'),
                  ),
                ),
                child: _countBox('Following', count),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _countBox(String label, int count) {
    return Container(
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
    );
  }
}
