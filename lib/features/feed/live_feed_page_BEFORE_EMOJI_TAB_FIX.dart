import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../messages/messages_page.dart';

import '../profile/primex_public_profile_page.dart';

import 'live_feed_detail_page.dart';

class LiveFeedPage extends StatefulWidget {
  const LiveFeedPage({super.key});

  @override
  State<LiveFeedPage> createState() => _LiveFeedPageState();
}

class _LiveFeedPageState extends State<LiveFeedPage> {
  final postText = TextEditingController();

  final postAddress = TextEditingController();

  final List<PlatformFile> pickedPhotos = [];

  PlatformFile? pickedVideo;

  bool posting = false;

  User? get user => FirebaseAuth.instance.currentUser;

  bool isImage(String e) => ['jpg', 'jpeg', 'png', 'webp'].contains(e);

  bool isVideo(String e) => ['mp4', 'mov', 'm4v', 'webm'].contains(e);

  Future<void> pickMedia() async {
    final r = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'webp',
        'mp4',
        'mov',
        'm4v',
        'webm'
      ],
    );

    if (r == null) return;

    for (final f in r.files) {
      final ext = (f.extension ?? '').toLowerCase();

      if (f.bytes == null) continue;

      if (isImage(ext) && pickedPhotos.length < 25) {
        pickedPhotos.add(f);
      } else if (isVideo(ext) && pickedVideo == null) {
        pickedVideo = f;
      }
    }

    setState(() {});
  }

  Future<Map<String, dynamic>> myProfile() async {
    final u = user;

    if (u == null) return {};

    final ud =
        (await FirebaseFirestore.instance.collection('users').doc(u.uid).get())
                .data() ??
            {};

    final ad = (await FirebaseFirestore.instance
                .collection('affiliates')
                .doc(u.uid)
                .get())
            .data() ??
        {};

    return {
      'displayName': ad['displayName'] ??
          ud['displayName'] ??
          u.displayName ??
          u.email ??
          'Syntax Phantom',
      'photoUrl': ad['photoUrl'] ?? ud['photoUrl'] ?? u.photoURL ?? '',
      'founderAffiliate': ad['founderAffiliate'] ?? false,
      'founderMemberNumber': ad['founderMemberNumber'] ?? '',
      'youthLevel': ad['youthLevel'] ?? '',
    };
  }

  Future<String> uploadFile(
      String postId, PlatformFile f, String folder) async {
    final name = f.name.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');

    final ref = FirebaseStorage.instance
        .ref('professional_live_feed/$postId/$folder/$name');

    await ref.putData(f.bytes!);

    return await ref.getDownloadURL();
  }

  Future<void> createPost() async {
    final u = user;

    if (u == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login before posting.')));

      return;
    }

    if (postText.text.trim().isEmpty &&
        pickedPhotos.isEmpty &&
        pickedVideo == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Add text, photos, or video before posting.')));

      return;
    }

    setState(() => posting = true);

    try {
      final ref =
          FirebaseFirestore.instance.collection('professional_live_feed').doc();

      final profile = await myProfile();

      final photoUrls = <String>[];

      for (final f in pickedPhotos) {
        photoUrls.add(await uploadFile(ref.id, f, 'photos'));
      }

      final videoUrls = <String>[];

      if (pickedVideo != null) {
        videoUrls.add(await uploadFile(ref.id, pickedVideo!, 'video'));
      }

      final postData = {
        'uid': u.uid,
        'ownerUid': u.uid,
        'sellerUid': u.uid,
        'ownerUid': u.uid,
        'sellerUid': u.uid,
        'ownerUid': u.uid,
        'sellerUid': u.uid,
        'email': u.email ?? '',
        'displayName': profile['displayName'],
        'photoUrl': profile['photoUrl'],
        'founderAffiliate': profile['founderAffiliate'],
        'founderMemberNumber': profile['founderMemberNumber'],
        'youthLevel': profile['youthLevel'],
        'type': 'professional_post',
        'source': 'professional_live_feed',
        'address': postAddress.text.trim(),
        'text': postText.text.trim(),
        'photoUrls': photoUrls,
        'videoUrls': videoUrls,
        'photoLimit': 25,
        'videoLimit': 1,
        'videoMaxSeconds': 60,
        'reactionCounts': {},
        'mapReady': true,
        'pinType': 'live_feed_post',
        'address': '',
        'lat': null,
        'lng': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await ref.set(postData);

      await FirebaseFirestore.instance
          .collection('live_feed')
          .doc(ref.id)
          .set(postData, SetOptions(merge: true));

      postText.clear();

      postAddress.clear();

      pickedPhotos.clear();

      pickedVideo = null;

      if (mounted) {
        setState(() => posting = false);

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Post uploaded.')));
      }
    } catch (e) {
      if (mounted) {
        setState(() => posting = false);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Post failed: $e')));
      }
    }
  }

  Future<void> editPost(String id, String oldText) async {
    final c = TextEditingController(text: oldText);

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text('Edit Post', style: TextStyle(color: Colors.white)),
        content: TextField(
            controller: c,
            maxLines: 5,
            style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, c.text.trim()),
              child: const Text('Save')),
        ],
      ),
    );

    if (result == null) return;

    await FirebaseFirestore.instance
        .collection('professional_live_feed')
        .doc(id)
        .set({
      'text': result,
      'edited': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deletePost(String id) async {
    await FirebaseFirestore.instance
        .collection('professional_live_feed')
        .doc(id)
        .delete();
  }

  Future<void> react(String id, String emoji) async {
    final u = user;

    if (u == null) return;

    final postRef =
        FirebaseFirestore.instance.collection('professional_live_feed').doc(id);

    final reactionRef = postRef.collection('reactions').doc(u.uid);

    final oldSnap = await reactionRef.get();

    final oldEmoji = (oldSnap.data()?['emoji'] ?? '').toString();

    if (oldEmoji == emoji) {
      await reactionRef.delete();

      final removeData = {
        'reactionCounts.$emoji': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await postRef.set(removeData, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('live_feed')
          .doc(id)
          .set(removeData, SetOptions(merge: true));

      return;
    }

    await reactionRef.set({
      'uid': u.uid,
      'emoji': emoji,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final updates = <String, dynamic>{
      'reactionCounts.$emoji': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (oldEmoji.isNotEmpty) {
      updates['reactionCounts.$oldEmoji'] = FieldValue.increment(-1);
    }

    await postRef.set(updates, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('live_feed')
        .doc(id)
        .set(updates, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('live_feed')
        .doc(id)
        .set(updates, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('professional_live_feed')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('PrimeX Professional Live Feed')),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('assets/images/primex_jobs_bg.png',
                  fit: BoxFit.cover)),
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(.70))),
          ListView(
            padding: const EdgeInsets.all(12),
            children: [
              composer(),
              const SizedBox(height: 12),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: stream,
                builder: (context, snap) {
                  final docs = snap.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text('No professional posts yet.',
                            style: TextStyle(color: Colors.white70)),
                      ),
                    );
                  }

                  return Column(
                    children: docs.map((doc) {
                      final d = doc.data();

                      final mine = d['uid'] == user?.uid;

                      return postCard(doc.id, d, mine);
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget composer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: box(),
      child: Column(
        children: [
          TextField(
            controller: postAddress,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Property/listing address for map pin',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
            ),
          ),
          const Divider(color: Colors.white24),
          TextField(
            controller: postText,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Create a professional PrimeX post...',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
            ),
          ),
          TextField(
            controller: postAddress,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Optional address for map pin only',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: pickMedia,
                  icon: const Icon(Icons.photo_library),
                  label: Text(
                      'Photo/Video ${pickedPhotos.length}/25 photos â¢ ${pickedVideo == null ? 0 : 1}/1 video'),
                ),
              ),
              IconButton(
                onPressed: posting ? null : createPost,
                icon: posting
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.send, color: Colors.cyanAccent),
              ),
            ],
          ),
          if (pickedPhotos.isNotEmpty || pickedVideo != null) previewStrip(),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Max 25 photos + 1 video, 1 minute',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget previewStrip() {
    return SizedBox(
      height: 92,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < pickedPhotos.length; i++)
            Stack(
              children: [
                Container(
                  width: 92,
                  height: 92,
                  margin: const EdgeInsets.only(right: 8),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyanAccent)),
                  child:
                      Image.memory(pickedPhotos[i].bytes!, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 2,
                  right: 10,
                  child: InkWell(
                    onTap: () => setState(() => pickedPhotos.removeAt(i)),
                    child: const CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.redAccent,
                        child:
                            Icon(Icons.close, size: 14, color: Colors.white)),
                  ),
                ),
              ],
            ),
          if (pickedVideo != null)
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 92,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.greenAccent)),
                  child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_circle,
                            color: Colors.greenAccent, size: 34),
                        Text('1 Video', style: TextStyle(color: Colors.white)),
                      ]),
                ),
                Positioned(
                  top: 2,
                  right: 10,
                  child: InkWell(
                    onTap: () => setState(() => pickedVideo = null),
                    child: const CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.redAccent,
                        child:
                            Icon(Icons.close, size: 14, color: Colors.white)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget postCard(String id, Map<String, dynamic> d, bool mine) {
    final name = (d['displayName'] ?? 'Syntax Phantom').toString();

    final avatar = (d['photoUrl'] ?? '').toString();

    final text = (d['text'] ?? '').toString();

    final photos = List<String>.from(d['photoUrls'] ?? []);

    final videos = List<String>.from(d['videoUrls'] ?? []);

    final counts = Map<String, dynamic>.from(d['reactionCounts'] ?? {});

    const emojis = [
      'ð',
      'â¤',
      'ð',
      'ð®',
      'ð¢',
      'ð¡',
      'ð¥',
      'ð¯',
      'â­',
      'ð'
    ];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LiveFeedDetailPage(data: d),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: box(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    final ownerUid =
                        (d['ownerUid'] ?? d['sellerUid'] ?? d['uid'] ?? '')
                            .toString();

                    if (ownerUid.isEmpty) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PrimeXPublicProfilePage(
                          uid: ownerUid,
                          profile: d,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.cyanAccent,
                    backgroundImage:
                        avatar.startsWith('http') ? NetworkImage(avatar) : null,
                    child: avatar.startsWith('http')
                        ? null
                        : const Icon(Icons.person, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900)),
                        if (d['founderAffiliate'] == true)
                          Text(
                              'ð Founding Affiliate â¢ Member #${d['founderMemberNumber'] ?? ''}',
                              style: const TextStyle(
                                  color: Colors.greenAccent, fontSize: 11)),
                        if ((d['youthLevel'] ?? '').toString().isNotEmpty)
                          Text('ð Youth Entrepreneur â¢ ${d['youthLevel']}',
                              style: const TextStyle(
                                  color: Colors.cyanAccent, fontSize: 11)),
                      ]),
                ),
                if (mine)
                  TextButton.icon(
                      onPressed: () => editPost(id, text),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit')),
                if (mine)
                  IconButton(
                      onPressed: () => deletePost(id),
                      icon: const Icon(Icons.delete, color: Colors.redAccent)),
              ],
            ),
            if (text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  if (mine)
                    TextButton.icon(
                      onPressed: () => editPost(id, text),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                  TextButton.icon(
                    onPressed: () {
                      final ownerUid =
                          (d['ownerUid'] ?? d['sellerUid'] ?? d['uid'] ?? '')
                              .toString();

                      if (ownerUid == user?.uid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'This is your post. Buyers will message you here.')),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MessagesPage()),
                      );
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('Message'),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final shareText =
                          (d['text'] ?? d['title'] ?? 'PrimeX post').toString();
                      await Clipboard.setData(
                        ClipboardData(
                            text:
                                'Check this on PrimeX Marketplace: $shareText'),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Post copied to clipboard for sharing.')),
                        );
                      }
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ],
              ),
              Text(text, style: const TextStyle(color: Colors.white)),
            ],
            if (photos.isNotEmpty) photoStrip(photos),
            if (videos.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(children: [
                  Icon(Icons.play_circle, color: Colors.greenAccent),
                  SizedBox(width: 8),
                  Text('1 video attached',
                      style: TextStyle(color: Colors.white)),
                ]),
              ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: emojis.map((e) {
                final count = counts[e] ?? 0;

                return InkWell(
                  onTap: () => react(id, e),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(.55),
                        border: Border.all(color: Colors.cyanAccent)),
                    child: Text(count == 0 ? e : '$e $count',
                        style: const TextStyle(fontSize: 18)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message),
                    label: const Text('Message')),
                TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share),
                    label: const Text('Share')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget photoStrip(List<String> photos) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 95,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: photos.map((u) {
            return Container(
              width: 95,
              margin: const EdgeInsets.only(right: 8),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.cyanAccent)),
              child: Image.network(u, fit: BoxFit.cover),
            );
          }).toList(),
        ),
      ),
    );
  }

  BoxDecoration box() {
    return BoxDecoration(
      color: Colors.black.withOpacity(.76),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.cyanAccent),
    );
  }
}
