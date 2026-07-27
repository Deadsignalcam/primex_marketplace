import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../widgets/primex_small_photo_strip.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/primex_follow_button.dart';
import '../chat/primex_chat_page.dart';

class LiveFeedPage extends StatefulWidget {
  const LiveFeedPage({super.key});

  @override
  State<LiveFeedPage> createState() => _LiveFeedPageState();
}

class _LiveFeedPageState extends State<LiveFeedPage> {
  final textCtrl = TextEditingController();
  final picker = ImagePicker();
  final List<XFile> pickedPhotos = [];
  bool posting = false;

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> pickPhotos() async {
    final files = await picker.pickMultiImage(imageQuality: 75);
    if (files.isEmpty) return;
    setState(() {
      pickedPhotos
        ..clear()
        ..addAll(files.take(25));
    });
  }

  Future<List<String>> uploadPhotos(String postId) async {
    final urls = <String>[];
    for (int i = 0; i < pickedPhotos.length; i++) {
      final bytes = await pickedPhotos[i].readAsBytes();
      final ref =
          FirebaseStorage.instance.ref('live_feed/$postId/photo_$i.jpg');
      await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  Future<void> createPost() async {
    final text = textCtrl.text.trim();
    if (uid.isEmpty || (text.isEmpty && pickedPhotos.isEmpty)) return;

    setState(() => posting = true);
    final doc = FirebaseFirestore.instance.collection('posts').doc();
    final photos = await uploadPhotos(doc.id);

    await doc.set({
      'text': text,
      'userId': uid,
      'ownerId': uid,
      'photos': photos,
      'photoUrls': photos,
      'createdAt': FieldValue.serverTimestamp(),
      'ownerUid': FirebaseAuth.instance.currentUser?.uid ?? '',
      'userId': FirebaseAuth.instance.currentUser?.uid ?? '',
      'sellerUid': FirebaseAuth.instance.currentUser?.uid ?? '',
      'sellerName':
          FirebaseAuth.instance.currentUser?.displayName ?? 'PrimeX Member',
      'boostRank': 0,
      'showOnMap': true,
      'platform': 'PrimeX',
      'type': 'post',
    });

    textCtrl.clear();
    pickedPhotos.clear();
    setState(() => posting = false);
  }

  List<String> list(dynamic v) {
    if (v is List)
      return v.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    if (v is String && v.trim().isNotEmpty) return [v.trim()];
    return [];
  }

  Widget uploadPreview() {
    if (pickedPhotos.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 58,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pickedPhotos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          return FutureBuilder<Uint8List>(
            future: pickedPhotos[i].readAsBytes(),
            builder: (context, snap) {
              return Stack(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: Colors.cyanAccent.withOpacity(.4)),
                    ),
                    child: snap.hasData
                        ? Image.memory(snap.data!, fit: BoxFit.cover)
                        : const Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () => setState(() => pickedPhotos.removeAt(i)),
                      child: const CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.redAccent,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget photoStrip(List<String> photos) {
    return PrimeXSmallPhotoStrip(photos: photos, size: 86);
  }

  Future<void> sharePost(String text) async {
    await Clipboard.setData(ClipboardData(text: 'PrimeX Marketplace: $text'));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied. Ready to share.')),
      );
    }
  }

  void messageOwner(String ownerId, String postId, String text) {
    if (ownerId.isEmpty || ownerId == uid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Open another member post to message.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrimeXChatPage(
          otherUserId: ownerId,
          otherName: 'PrimeX Member',
          itemId: postId,
          itemTitle: text.isEmpty ? 'Live Feed Post' : text,
        ),
      ),
    );
  }

  Widget postCard(String id, Map<String, dynamic> d) {
    final text = (d['text'] ?? d['title'] ?? d['caption'] ?? '').toString();
    final ownerId = (d['userId'] ?? d['ownerId'] ?? d['uid'] ?? '').toString();
    final photos = [
      ...list(d['photos']),
      ...list(d['photoUrls']),
      ...list(d['images'])
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent.withOpacity(.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const CircleAvatar(
              backgroundColor: Colors.cyanAccent,
              child: Icon(Icons.person, color: Colors.black),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text('PrimeX Member',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            PrimeXFollowButton(ownerId: ownerId),
          ]),
          if (text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(color: Colors.white)),
          ],
          if (photos.isNotEmpty) ...[
            const SizedBox(height: 8),
            photoStrip(photos),
          ],
          const SizedBox(height: 6),
          Wrap(spacing: 8, children: [
            TextButton.icon(
              onPressed: () => messageOwner(ownerId, id, text),
              icon: const Icon(Icons.message, size: 15),
              label: const Text('Message'),
            ),
            TextButton.icon(
              onPressed: () => sharePost(text),
              icon: const Icon(Icons.share, size: 15),
              label: const Text('Share'),
            ),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = FirebaseAuth.instance.currentUser != null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black, title: const Text('PrimeX Live Feed')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          if (loggedIn)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyanAccent.withOpacity(.4)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: textCtrl,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Post your day, listing, service, or update...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                  uploadPreview(),
                  const SizedBox(height: 8),
                  Row(children: [
                    OutlinedButton.icon(
                      onPressed: pickPhotos,
                      icon: const Icon(Icons.photo_library),
                      label: Text('Upload Photos ${pickedPhotos.length}/25'),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: posting ? null : createPost,
                      icon: posting
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      label: const Text('Post'),
                    ),
                  ]),
                ],
              ),
            ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('boostRank', descending: true)
                .orderBy('createdAt', descending: true)
                .limit(60)
                .snapshots(),
            builder: (context, snap) {
              final docs = snap.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text('No posts yet.',
                        style: TextStyle(color: Colors.white70)),
                  ),
                );
              }

              return Column(
                children: docs.map((doc) {
                  return postCard(doc.id, doc.data() as Map<String, dynamic>);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
