import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LiveFeedPage extends StatefulWidget {
  const LiveFeedPage({super.key});

  @override
  State<LiveFeedPage> createState() => _LiveFeedPageState();
}

class _LiveFeedPageState extends State<LiveFeedPage> {
  final postCtrl = TextEditingController();
  bool posting = false;

  Future<void> addPost() async {
    final text = postCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() => posting = true);

    try {
      await FirebaseFirestore.instance.collection('live_feed').add({
        'description': text,
        'userName': 'PrimeX User',
        'profileImage': '',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      postCtrl.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Posted to Live Feed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('POST ERROR: $e')),
        );
      }
    }

    if (mounted) setState(() => posting = false);
  }

  Future<void> editPost(String id, String oldText) async {
    final editCtrl = TextEditingController(text: oldText);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Live Feed Post'),
        content: TextField(
          controller: editCtrl,
          maxLines: 5,
          decoration: const InputDecoration(labelText: 'Edit post'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('live_feed')
                  .doc(id)
                  .update({
                'description': editCtrl.text.trim(),
                'updatedAt': Timestamp.now(),
              });
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050814),
      appBar:
          AppBar(backgroundColor: Colors.black, title: const Text('LIVE FEED')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1020),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.cyanAccent),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    CircleAvatar(child: Icon(Icons.person)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Post to PrimeX Live Feed',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: postCtrl,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Write your live post',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => postCtrl.text += ' 🔥',
                        icon: const Text('🔥', style: TextStyle(fontSize: 24))),
                    IconButton(
                        onPressed: () => postCtrl.text += ' 💎',
                        icon: const Text('💎', style: TextStyle(fontSize: 24))),
                    IconButton(
                        onPressed: () => postCtrl.text += ' 🚀',
                        icon: const Text('🚀', style: TextStyle(fontSize: 24))),
                    IconButton(
                        onPressed: () => postCtrl.text += ' 🙌',
                        icon: const Text('🙌', style: TextStyle(fontSize: 24))),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: posting ? null : addPost,
                    icon: const Icon(Icons.send),
                    label: Text(posting ? 'POSTING...' : 'POST LIVE'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('live_feed')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snap) {
              if (snap.hasError) {
                return Text('LIVE FEED ERROR: ${snap.error}',
                    style: const TextStyle(color: Colors.redAccent));
              }

              if (!snap.hasData)
                return const Center(child: CircularProgressIndicator());

              final docs = snap.data!.docs;

              if (docs.isEmpty) {
                return const Text(
                  'No posts yet. Post HELLO WORLD to test.',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                );
              }

              return Column(
                children: docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final text = data['description'] ?? '';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1020),
                      borderRadius: BorderRadius.circular(18),
                      border:
                          Border.all(color: Colors.cyanAccent.withOpacity(.35)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(child: Icon(Icons.person)),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text('PrimeX User',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.cyanAccent),
                              tooltip: 'Edit Post',
                              onPressed: () => editPost(doc.id, text),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              tooltip: 'Delete Post',
                              onPressed: () => FirebaseFirestore.instance
                                  .collection('live_feed')
                                  .doc(doc.id)
                                  .delete(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(text,
                            style: const TextStyle(color: Colors.white70)),
                      ],
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
