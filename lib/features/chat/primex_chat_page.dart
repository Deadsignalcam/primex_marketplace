import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/primex_profile_circle.dart';

class PrimeXChatPage extends StatefulWidget {
  final String otherUserId;
  final String otherName;
  final String itemId;
  final String itemTitle;

  const PrimeXChatPage({
    super.key,
    required this.otherUserId,
    this.otherName = 'PrimeX Member',
    this.itemId = '',
    this.itemTitle = '',
  });

  @override
  State<PrimeXChatPage> createState() => _PrimeXChatPageState();
}

class _PrimeXChatPageState extends State<PrimeXChatPage> {
  final text = TextEditingController();
  final scroll = ScrollController();

  String get myUid => FirebaseAuth.instance.currentUser?.uid ?? '';
  String get otherUid => widget.otherUserId.trim();

  String get chatId {
    final ids = [myUid, otherUid]..sort();
    return ids.join('_');
  }

  Future<Map<String, dynamic>> loadMe() async {
    if (myUid.isEmpty) return {};
    final u =
        await FirebaseFirestore.instance.collection('users').doc(myUid).get();
    final p = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(myUid)
        .get();
    return {...(p.data() ?? {}), ...(u.data() ?? {})};
  }

  Future<void> send() async {
    final body = text.text.trim();
    if (body.isEmpty || myUid.isEmpty || otherUid.isEmpty) return;

    final me = await loadMe();
    final senderName = (me['displayName'] ??
            me['name'] ??
            FirebaseAuth.instance.currentUser?.email ??
            'PrimeX Member')
        .toString();
    final senderPhoto =
        (me['photoUrl'] ?? me['profilePhoto'] ?? me['avatarUrl'] ?? '')
            .toString();

    final ref = FirebaseFirestore.instance.collection('chats').doc(chatId);

    await ref.set({
      'participants': [myUid, otherUid],
      'users': [myUid, otherUid],
      'lastMessage': body,
      'lastSenderId': myUid,
      'itemId': widget.itemId,
      'itemTitle': widget.itemTitle,
      'platformOnly': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await ref.collection('messages').add({
      'text': body,
      'senderId': myUid,
      'senderName': senderName,
      'senderPhoto': senderPhoto,
      'receiverId': otherUid,
      'receiverName': widget.otherName,
      'createdAt': FieldValue.serverTimestamp(),
      'platformOnly': true,
    });

    text.clear();

    Future.delayed(const Duration(milliseconds: 250), () {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget bubble(Map<String, dynamic> m) {
    final mine = m['senderId'] == myUid;
    final msg = (m['text'] ?? '').toString();
    final name = mine
        ? 'Me'
        : (m['senderName'] ?? widget.otherName ?? 'PrimeX Member').toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment:
            mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine) ...[
            PrimeXProfileCircle(uid: otherUid, radius: 18),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: mine ? Colors.cyanAccent : Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: const BoxConstraints(maxWidth: 290),
                  decoration: BoxDecoration(
                    color: mine
                        ? const Color(0xFF00E5FF)
                        : const Color(0xFF1F2937),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(mine ? 18 : 4),
                      bottomRight: Radius.circular(mine ? 4 : 18),
                    ),
                  ),
                  child: Text(
                    msg,
                    style: TextStyle(
                      color: mine ? Colors.black : Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.otherName.isEmpty ? 'PrimeX Member' : widget.otherName;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            PrimeXProfileCircle(uid: otherUid, radius: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(name, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
      body: Column(
        children: [
          if (widget.itemTitle.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.black87,
              child: Text(
                'About: ${widget.itemTitle}',
                style: const TextStyle(color: Colors.cyanAccent),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, snap) {
                final docs = snap.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Start the conversation inside PrimeX.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                Future.delayed(const Duration(milliseconds: 150), () {
                  if (scroll.hasClients) {
                    scroll.jumpTo(scroll.position.maxScrollExtent);
                  }
                });

                return ListView.builder(
                  controller: scroll,
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    return bubble(docs[i].data() as Map<String, dynamic>);
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: const Color(0xFF050B14),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: text,
                      minLines: 1,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Message inside PrimeX...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: const Color(0xFF111827),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF00E5FF),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward, color: Colors.black),
                      onPressed: send,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
