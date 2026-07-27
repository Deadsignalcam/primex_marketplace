import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrimeXReactionBar extends StatelessWidget {
  final String postId;
  final Map<String, dynamic> reactions;

  const PrimeXReactionBar({
    super.key,
    required this.postId,
    required this.reactions,
  });

  static const Map<String, String> emojis = {
    'like': '👍',
    'love': '❤️',
    'laugh': '😂',
    'wow': '😮',
    'pray': '🙏',
    'fire': '🔥',
  };

  Future<void> react(String key) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    final userReactionRef = postRef.collection('reactions').doc(user.uid);

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final oldSnap = await tx.get(userReactionRef);

      String? oldKey;
      if (oldSnap.exists) {
        final oldData = oldSnap.data();
        if (oldData != null && oldData.containsKey('type')) {
          oldKey = oldData['type'].toString();
        }
      }

      final updates = <String, dynamic>{};

      if (oldKey != null && oldKey != key) {
        updates['reactionCounts.$oldKey'] = FieldValue.increment(-1);
      }

      if (oldKey == key) {
        updates['reactionCounts.$key'] = FieldValue.increment(-1);
        tx.delete(userReactionRef);
      } else {
        updates['reactionCounts.$key'] = FieldValue.increment(1);
        tx.set(userReactionRef, {
          'type': key,
          'userId': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      tx.set(postRef, updates, SetOptions(merge: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: emojis.entries.map((e) {
        final count = reactions[e.key] ?? 0;

        return InkWell(
          onTap: () => react(e.key),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white12),
            ),
            child: Text(
              '${e.value} $count',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        );
      }).toList(),
    );
  }
}
