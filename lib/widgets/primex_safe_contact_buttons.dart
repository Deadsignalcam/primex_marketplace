import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../features/chat/primex_chat_page.dart';
import '../features/chat/primex_call_page.dart';
import '../features/safety/safe_meet_page.dart';

final AudioPlayer _tapRingPlayer = AudioPlayer();

class PrimeXSafeContactButtons extends StatelessWidget {
  final String receiverId;
  final String receiverName;
  final String sourceTitle;
  final String receiverPhoto;
  final String listingId;
  final String zoomUrl;

  const PrimeXSafeContactButtons({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.sourceTitle,
    this.receiverPhoto = '',
    this.listingId = '',
    this.zoomUrl = '',
  });

  String get myUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> playTapRing() async {
    try {
      await _tapRingPlayer.stop();
      await _tapRingPlayer.play(AssetSource('sounds/incoming_call.mp3'));
    } catch (_) {}
  }

  Future<void> follow() async {
    if (myUid.isEmpty || receiverId.isEmpty || myUid == receiverId) return;
    final db = FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(myUid)
        .collection('following')
        .doc(receiverId)
        .set({
      'userId': receiverId,
      'followingId': receiverId,
      'followingName': receiverName,
      'followingPhoto': receiverPhoto,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await db
        .collection('users')
        .doc(receiverId)
        .collection('followers')
        .doc(myUid)
        .set({
      'userId': myUid,
      'followerId': myUid,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> unfollow() async {
    if (myUid.isEmpty || receiverId.isEmpty || myUid == receiverId) return;
    final db = FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(myUid)
        .collection('following')
        .doc(receiverId)
        .delete();
    await db
        .collection('users')
        .doc(receiverId)
        .collection('followers')
        .doc(myUid)
        .delete();
  }

  Future<void> message(BuildContext context) async {
    if (receiverId.isEmpty) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PrimeXChatPage(
                  otherUserId: receiverId,
                  otherName:
                      receiverName.isEmpty ? 'PrimeX Member' : receiverName,
                  itemId: listingId,
                  itemTitle: sourceTitle,
                )));
  }

  Future<void> audio(BuildContext context) async {
    if (receiverId.isEmpty) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PrimeXCallPage(
                  otherUserId: receiverId,
                  otherName:
                      receiverName.isEmpty ? 'PrimeX Member' : receiverName,
                  video: false,
                )));
  }

  Future<void> zoom(BuildContext context) async {
    if (zoomUrl.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No Zoom link added for this verified account.')),
      );
      return;
    }
    await launchUrl(Uri.parse(zoomUrl.trim()),
        mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final canFollow =
        myUid.isNotEmpty && receiverId.isNotEmpty && myUid != receiverId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (canFollow)
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(myUid)
                .collection('following')
                .doc(receiverId)
                .snapshots(),
            builder: (context, snap) {
              final following = snap.data?.exists == true;
              return OutlinedButton.icon(
                onPressed: following ? unfollow : follow,
                icon: Icon(following ? Icons.person_remove : Icons.person_add),
                label: Text(following ? 'Unfollow' : 'Follow'),
              );
            },
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
                onPressed: () => message(context),
                icon: const Icon(Icons.chat),
                label: const Text('Message')),
            ElevatedButton.icon(
                onPressed: () => audio(context),
                icon: const Icon(Icons.wifi_calling_3),
                label: const Text('PrimeX Audio')),
            OutlinedButton.icon(
                onPressed: () => zoom(context),
                icon: const Icon(Icons.video_camera_front),
                label: const Text('Zoom')),
            OutlinedButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SafeMeetPage(
                        listingTitle: sourceTitle.isEmpty
                            ? 'PrimeX Safe Meet'
                            : sourceTitle),
                  )),
              icon: const Icon(Icons.shield),
              label: const Text('Safe Meet'),
            ),
          ],
        ),
      ],
    );
  }
}
