import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrimeXLiveFeedReactions extends StatefulWidget {
  final String postId;

  const PrimeXLiveFeedReactions({
    super.key,
    required this.postId,
  });

  @override
  State<PrimeXLiveFeedReactions> createState() =>
      _PrimeXLiveFeedReactionsState();
}

class _PrimeXLiveFeedReactionsState extends State<PrimeXLiveFeedReactions> {
  final comment = TextEditingController();
  final emojis = ['🔥', '❤️', '🙏', '💎', '👏', '🚀'];

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> react(String emoji) async {
    if (uid.isEmpty || widget.postId.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('live_feed_reactions')
        .doc(widget.postId)
        .collection('items')
        .add({
      'userId': uid,
      'emoji': emoji,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendComment() async {
    final body = comment.text.trim();
    if (uid.isEmpty || body.isEmpty || widget.postId.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('live_feed_comments')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'userId': uid,
      'text': body,
      'createdAt': FieldValue.serverTimestamp(),
    });

    comment.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (uid.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyanAccent.withOpacity(.55)),
      ),
      child: Column(
        children: [
          Row(
            children: emojis.map((e) {
              return InkWell(
                onTap: () => react(e),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(e, style: const TextStyle(fontSize: 24)),
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
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: sendComment,
                icon: const Icon(Icons.send, color: Colors.cyanAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
