import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrimeXHomeSocialBar extends StatefulWidget {
  final String postId;
  final String ownerId;

  const PrimeXHomeSocialBar({
    super.key,
    required this.postId,
    required this.ownerId,
  });

  @override
  State<PrimeXHomeSocialBar> createState() => _PrimeXHomeSocialBarState();
}

class _PrimeXHomeSocialBarState extends State<PrimeXHomeSocialBar> {
  final comment = TextEditingController();
  final emojis = ['🔥', '❤️', '🙏', '💎', '👏', '🚀'];

  String get myUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> follow() async {
    if (myUid.isEmpty || widget.ownerId.isEmpty || myUid == widget.ownerId)
      return;

    final db = FirebaseFirestore.instance;

    await db
        .collection('users')
        .doc(myUid)
        .collection('following')
        .doc(widget.ownerId)
        .set({
      'userId': widget.ownerId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await db
        .collection('users')
        .doc(widget.ownerId)
        .collection('followers')
        .doc(myUid)
        .set({
      'userId': myUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unfollow() async {
    if (myUid.isEmpty || widget.ownerId.isEmpty || myUid == widget.ownerId)
      return;

    final db = FirebaseFirestore.instance;

    await db
        .collection('users')
        .doc(myUid)
        .collection('following')
        .doc(widget.ownerId)
        .delete();
    await db
        .collection('users')
        .doc(widget.ownerId)
        .collection('followers')
        .doc(myUid)
        .delete();
  }

  Future<void> addComment(String text) async {
    final body = text.trim();
    if (myUid.isEmpty || body.isEmpty || widget.postId.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('home_comments')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'userId': myUid,
      'text': body,
      'createdAt': FieldValue.serverTimestamp(),
    });

    comment.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (myUid.isEmpty) return const SizedBox.shrink();

    final canFollow = widget.ownerId.isNotEmpty && myUid != widget.ownerId;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.62),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyanAccent.withOpacity(.6)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (canFollow)
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(myUid)
                      .collection('following')
                      .doc(widget.ownerId)
                      .snapshots(),
                  builder: (context, snap) {
                    final isFollowing = snap.data?.exists == true;

                    return OutlinedButton.icon(
                      onPressed: isFollowing ? unfollow : follow,
                      icon: Icon(
                          isFollowing ? Icons.person_remove : Icons.person_add,
                          size: 16),
                      label: Text(isFollowing ? 'Unfollow' : 'Follow'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.cyanAccent),
                        visualDensity: VisualDensity.compact,
                      ),
                    );
                  },
                ),
              const Spacer(),
              const Icon(Icons.comment, color: Colors.cyanAccent, size: 18),
              const SizedBox(width: 6),
              const Text('Comment', style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: emojis.map((e) {
              return InkWell(
                onTap: () => addComment(e),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(e, style: const TextStyle(fontSize: 22)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: comment,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Write something nice...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF111827),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => addComment(comment.text),
                icon: const Icon(Icons.send, color: Colors.cyanAccent),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('home_comments')
                .doc(widget.postId)
                .collection('comments')
                .orderBy('createdAt', descending: true)
                .limit(3)
                .snapshots(),
            builder: (context, snap) {
              final docs = snap.data?.docs ?? [];
              if (docs.isEmpty) return const SizedBox.shrink();

              return Column(
                children: docs.map((d) {
                  final x = d.data() as Map<String, dynamic>;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        (x['text'] ?? '').toString(),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
