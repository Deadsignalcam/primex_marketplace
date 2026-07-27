import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrimeXMessageThreadPage extends StatefulWidget {
  final String otherUserId;
  final String otherName;
  final String listingId;
  final String listingTitle;

  const PrimeXMessageThreadPage({
    super.key,
    required this.otherUserId,
    required this.otherName,
    this.listingId = '',
    this.listingTitle = '',
  });

  @override
  State<PrimeXMessageThreadPage> createState() =>
      _PrimeXMessageThreadPageState();
}

class _PrimeXMessageThreadPageState extends State<PrimeXMessageThreadPage> {
  final msg = TextEditingController();

  String threadId(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join('_');
  }

  Future<void> send() async {
    final me = FirebaseAuth.instance.currentUser;
    if (me == null || msg.text.trim().isEmpty) return;

    final tid = threadId(me.uid, widget.otherUserId);

    await FirebaseFirestore.instance.collection('threads').doc(tid).set({
      'members': [me.uid, widget.otherUserId],
      'lastMessage': msg.text.trim(),
      'listingId': widget.listingId,
      'listingTitle': widget.listingTitle,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('threads')
        .doc(tid)
        .collection('messages')
        .add({
      'fromUid': me.uid,
      'toUid': widget.otherUserId,
      'text': msg.text.trim(),
      'listingId': widget.listingId,
      'listingTitle': widget.listingTitle,
      'createdAt': FieldValue.serverTimestamp(),
    });

    msg.clear();
  }

  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser;
    final tid = me == null ? '' : threadId(me.uid, widget.otherUserId);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Message ${widget.otherName}'),
      ),
      body: Column(
        children: [
          if (widget.listingTitle.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.cyanAccent.withOpacity(.12),
              child: Text(
                'Listing: ${widget.listingTitle}',
                style: const TextStyle(color: Colors.cyanAccent),
              ),
            ),
          Expanded(
            child: me == null
                ? const Center(
                    child: Text('Login first.',
                        style: TextStyle(color: Colors.white)))
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('threads')
                        .doc(tid)
                        .collection('messages')
                        .orderBy('createdAt')
                        .snapshots(),
                    builder: (_, snap) {
                      final docs = snap.data?.docs ?? [];
                      return ListView(
                        padding: const EdgeInsets.all(12),
                        children: docs.map((doc) {
                          final d = doc.data() as Map<String, dynamic>;
                          final mine = d['fromUid'] == me.uid;
                          return Align(
                            alignment: mine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                    mine ? Colors.cyanAccent : Colors.white12,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                (d['text'] ?? '').toString(),
                                style: TextStyle(
                                    color: mine ? Colors.black : Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msg,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Type message...',
                      hintStyle: TextStyle(color: Colors.white54),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: send,
                  icon: const Icon(Icons.send, color: Colors.cyanAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
